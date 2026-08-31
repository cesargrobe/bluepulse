import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/recorded_session.dart';
import '../models/session_draft.dart';
import '../session/session_clock.dart';
import '../simulation/deterministic_simulator.dart';
import '../storage/session_repository.dart';
import 'blue_space_intervention_screen.dart';

class TimedMonitoringScreen extends StatefulWidget {
  const TimedMonitoringScreen({
    required this.sessionDraft,
    this.repository,
    this.now,
    super.key,
  });

  final SessionDraft sessionDraft;
  final SessionStore? repository;
  final DateTime Function()? now;

  @override
  State<TimedMonitoringScreen> createState() => _TimedMonitoringScreenState();
}

class _TimedMonitoringScreenState extends State<TimedMonitoringScreen> {
  final SessionClock _clock = SessionClock(totalSeconds: 30);
  late final DeterministicSimulator _simulator;
  late final SessionStore _repository;
  final List<SensorSample> _capturedSamples = [];
  Timer? _timer;
  DateTime? _startedAtUtc;
  RecordedSession? _recordedSession;
  bool _storageBusy = false;
  String? _storageMessage;

  SensorSample get _sample => _simulator.sampleAt(_clock.elapsedSeconds);
  DateTime _now() => (widget.now?.call() ?? DateTime.now()).toUtc();

  @override
  void initState() {
    super.initState();
    _simulator = DeterministicSimulator(
      seed: stableSeedFromCode(widget.sessionDraft.sessionCode),
    );
    _repository = widget.repository ?? SessionRepository.platform();
  }

  void _start() {
    _capturedSamples
      ..clear()
      ..add(_simulator.sampleAt(0));
    _startedAtUtc = _now();
    _recordedSession = null;
    _storageMessage = null;
    setState(_clock.start);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final previousElapsed = _clock.elapsedSeconds;
        _clock.tick();
        final elapsed = _clock.elapsedSeconds;
        if (elapsed > previousElapsed && elapsed < _clock.totalSeconds) {
          _capturedSamples.add(_simulator.sampleAt(elapsed));
        }
      });
      if (_clock.status == SessionClockStatus.completed) _timer?.cancel();
    });
  }

  Future<void> _saveCollection() async {
    final startedAt = _startedAtUtc;
    if (startedAt == null || _capturedSamples.isEmpty || _storageBusy) return;

    setState(() {
      _storageBusy = true;
      _storageMessage = null;
    });
    try {
      final session = RecordedSession.fromSimulation(
        draft: widget.sessionDraft,
        startedAtUtc: startedAt,
        endedAtUtc: _now(),
        samples: _capturedSamples,
      );
      await _repository.save(session);
      if (!mounted) return;
      setState(() {
        _recordedSession = session;
        _storageMessage =
            'Coleta simulada salva na área privada do aplicativo.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _storageMessage = 'Não foi possível salvar: $error');
    } finally {
      if (mounted) setState(() => _storageBusy = false);
    }
  }

  Future<void> _exportCollection() async {
    final session = _recordedSession;
    if (session == null || _storageBusy) return;

    setState(() {
      _storageBusy = true;
      _storageMessage = null;
    });
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
      if (!mounted) return;
      setState(() => _storageMessage = 'Arquivos CSV e JSON preparados.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _storageMessage = 'Não foi possível exportar: $error');
    } finally {
      if (mounted) setState(() => _storageBusy = false);
    }
  }

  Future<void> _deleteCollection() async {
    final session = _recordedSession;
    if (session == null || _storageBusy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir coleta simulada?'),
        content: const Text(
          'O arquivo local e as cópias temporárias de exportação serão '
          'removidos. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Manter'),
          ),
          FilledButton(
            key: const Key('confirm-delete-recording'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _storageBusy = true);
    try {
      await _repository.delete(session);
      if (!mounted) return;
      setState(() {
        _recordedSession = null;
        _storageMessage = 'Coleta simulada excluída do dispositivo.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _storageMessage = 'Não foi possível excluir: $error');
    } finally {
      if (mounted) setState(() => _storageBusy = false);
    }
  }

  void _togglePause() {
    if (_clock.status == SessionClockStatus.running) {
      _timer?.cancel();
      setState(_clock.pause);
    } else if (_clock.status == SessionClockStatus.paused) {
      setState(_clock.resume);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final started = _clock.status != SessionClockStatus.idle;
    final completed = _clock.status == SessionClockStatus.completed;
    final sample = _sample;

    return Scaffold(
      appBar: AppBar(title: const Text('Sessão temporizada')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Chip(
                    avatar: Icon(Icons.science_outlined, size: 18),
                    label: Text('DADOS SIMULADOS'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    completed
                        ? 'Monitoramento concluído'
                        : started
                        ? 'Monitoramento em andamento'
                        : 'Ensaio automático de 30 segundos',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    completed
                        ? _recordedSession == null
                              ? 'A sequência simulada terminou. Revise e salve a coleta se desejar preservá-la.'
                              : 'A coleta foi salva localmente e pode ser exportada ou excluída.'
                        : 'A sequência percorre automaticamente os quatro estados já validados. Você pode pausar ou cancelar a qualquer momento.',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _formatTime(_clock.remainingSeconds),
                    key: const Key('timed-remaining'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: const Color(0xFF0369A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: _clock.progress),
                  const SizedBox(height: 24),
                  if (started && !completed)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              _scenarioLabel(sample.scenario),
                              key: const Key('timed-scenario'),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'IR: ${sample.infrared ?? 'indisponível'}  •  '
                              'Movimento: ${sample.movementIndex?.toStringAsFixed(2) ?? 'indisponível'}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Card(
                    color: Color(0xFFFFFBEB),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'IR > 5000 e movimento >= 0.08 são limiares provisórios de bancada. Esta simulação não realiza diagnóstico clínico.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (completed) ...[
                    Card(
                      key: const Key('recording-summary'),
                      color: const Color(0xFFE0F2FE),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coleta simulada',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_capturedSamples.length} amostras artificiais',
                            ),
                            const Text('Intervalo nominal: 1 segundo'),
                            const Text('BPM, SpO₂ e GSR: não disponíveis'),
                            if (_storageMessage != null) ...[
                              const SizedBox(height: 8),
                              Text(_storageMessage!),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_recordedSession == null)
                      FilledButton.icon(
                        key: const Key('save-simulated-recording'),
                        onPressed: _storageBusy ? null : _saveCollection,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Salvar coleta simulada'),
                      )
                    else ...[
                      FilledButton.icon(
                        key: const Key('export-simulated-recording'),
                        onPressed: _storageBusy ? null : _exportCollection,
                        icon: const Icon(Icons.ios_share_rounded),
                        label: const Text('Exportar CSV e JSON'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        key: const Key('delete-simulated-recording'),
                        onPressed: _storageBusy ? null : _deleteCollection,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Excluir coleta local'),
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                  if (!started)
                    FilledButton.icon(
                      key: const Key('start-timed-monitoring'),
                      onPressed: _start,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Iniciar 30 segundos'),
                    )
                  else if (!completed)
                    FilledButton.icon(
                      key: const Key('toggle-timed-monitoring'),
                      onPressed: _togglePause,
                      icon: Icon(
                        _clock.status == SessionClockStatus.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                      ),
                      label: Text(
                        _clock.status == SessionClockStatus.paused
                            ? 'Continuar'
                            : 'Pausar',
                      ),
                    )
                  else
                    FilledButton.icon(
                      key: const Key('continue-to-blue-space'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlueSpaceInterventionScreen(
                            sessionDraft: widget.sessionDraft,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.water_rounded),
                      label: const Text('Conhecer a pausa oceânica'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      started && !completed ? 'Cancelar sessão' : 'Voltar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
}

String _scenarioLabel(SimulatedScenario scenario) => switch (scenario) {
  SimulatedScenario.noContact => 'Sem contato',
  SimulatedScenario.stableContact => 'Sinal adequado',
  SimulatedScenario.movement => 'Movimento detectado',
  SimulatedScenario.transientFailure => 'Falha simulada',
};
