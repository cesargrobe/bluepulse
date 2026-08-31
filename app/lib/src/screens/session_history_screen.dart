import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/recorded_session.dart';
import '../storage/session_repository.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({this.repository, super.key});

  final SessionStore? repository;

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  late final SessionStore _repository;
  List<RecordedSession> _sessions = const [];
  bool _loading = true;
  String? _error;
  String? _busySessionKey;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? SessionRepository.platform();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final sessions = await _repository.list();
      if (!mounted) return;
      setState(() => _sessions = sessions);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'Não foi possível ler o histórico: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _export(RecordedSession session) async {
    if (_busySessionKey != null) return;
    setState(() => _busySessionKey = session.storageKey);
    try {
      final exported = await _repository.createExport(session);
      await SharePlus.instance.share(
        ShareParams(
          title: 'Exportar coleta simulada BluePulse',
          subject: 'Coleta simulada ${session.sessionCode}',
          text:
              'Arquivos experimentais com dados simulados. Não contêm '
              'diagnóstico clínico nem BPM, SpO₂ ou GSR.',
          files: [XFile(exported.csvFile.path), XFile(exported.jsonFile.path)],
        ),
      );
    } catch (error) {
      if (mounted) _showMessage('Não foi possível exportar: $error');
    } finally {
      if (mounted) setState(() => _busySessionKey = null);
    }
  }

  Future<void> _delete(RecordedSession session) async {
    if (_busySessionKey != null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir coleta simulada?'),
        content: Text(
          'A coleta ${session.sessionCode} e suas cópias temporárias serão '
          'removidas deste dispositivo. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Manter'),
          ),
          FilledButton(
            key: const Key('confirm-history-delete'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busySessionKey = session.storageKey);
    try {
      await _repository.delete(session);
      if (!mounted) return;
      setState(() {
        _sessions = _sessions
            .where((item) => item.storageKey != session.storageKey)
            .toList(growable: false);
      });
      _showMessage('Coleta ${session.sessionCode} excluída do dispositivo.');
    } catch (error) {
      if (mounted) _showMessage('Não foi possível excluir: $error');
    } finally {
      if (mounted) setState(() => _busySessionKey = null);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de coletas'),
        actions: [
          IconButton(
            key: const Key('refresh-session-history'),
            onPressed: _loading ? null : _load,
            tooltip: 'Atualizar histórico',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _MessageState(
        icon: Icons.error_outline_rounded,
        title: 'Falha ao abrir o histórico',
        message: _error!,
        action: FilledButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tentar novamente'),
        ),
      );
    }
    if (_sessions.isEmpty) {
      return const _MessageState(
        key: Key('empty-session-history'),
        icon: Icons.inventory_2_outlined,
        title: 'Nenhuma coleta simulada salva',
        message:
            'As sessões aparecem aqui somente após a ação explícita de salvar.',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        key: const Key('session-history-list'),
        padding: const EdgeInsets.all(20),
        children: [
          const Chip(
            avatar: Icon(Icons.science_outlined, size: 18),
            label: Text('DADOS SIMULADOS SALVOS LOCALMENTE'),
          ),
          const SizedBox(height: 12),
          const Card(
            color: Color(0xFFFFFBEB),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Este histórico não contém diagnóstico clínico. BPM, SpO₂ e '
                'GSR permanecem indisponíveis, e nenhuma amostra BLE real é '
                'armazenada nesta versão.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._sessions.map(_sessionCard),
        ],
      ),
    );
  }

  Widget _sessionCard(RecordedSession session) {
    final busy = _busySessionKey == session.storageKey;
    final duration =
        session.endedAtUtc.difference(session.startedAtUtc).inMicroseconds /
        Duration.microsecondsPerSecond;
    return Card(
      key: Key('history-session-${session.sessionCode}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.sessionCode,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Início: ${_formatUtc(session.startedAtUtc)}'),
            Text('Duração registrada: ${duration.toStringAsFixed(3)} s'),
            Text('${session.samples.length} amostras simuladas'),
            const Text('BPM / SpO₂ / GSR: indisponíveis'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  key: Key('history-export-${session.sessionCode}'),
                  onPressed: busy ? null : () => _export(session),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Exportar'),
                ),
                OutlinedButton.icon(
                  key: Key('history-delete-${session.sessionCode}'),
                  onPressed: busy ? null : () => _delete(session),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(icon, size: 64, color: const Color(0xFF0369A1)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

String _formatUtc(DateTime value) {
  final utc = value.toUtc();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(utc.day)}/${two(utc.month)}/${utc.year} '
      '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)} UTC';
}
