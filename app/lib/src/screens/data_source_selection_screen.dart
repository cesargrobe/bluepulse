import 'package:flutter/material.dart';

import '../models/session_draft.dart';
import 'simulated_monitoring_screen.dart';

class DataSourceSelectionScreen extends StatelessWidget {
  const DataSourceSelectionScreen({required this.sessionDraft, super.key});

  final SessionDraft sessionDraft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fonte dos dados')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sessão ${sessionDraft.sessionCode}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: const Color(0xFF0369A1)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha a origem das amostras',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nesta etapa, somente o modo simulado está disponível. '
                    'Ele permite validar o aplicativo sem usar o sensor.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _SourceCard(
                    icon: Icons.science_outlined,
                    title: 'Modo simulado',
                    description:
                        'Sequência artificial e reproduzível com sem contato, '
                        'sinal adequado, movimento e falha transitória.',
                    badge: 'DISPONÍVEL',
                    action: FilledButton.icon(
                      key: const Key('select-simulated-source'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SimulatedMonitoringScreen(
                              sessionDraft: sessionDraft.copyWith(
                                dataOrigin: DataOrigin.simulated,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Usar dados simulados'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SourceCard(
                    icon: Icons.bluetooth_disabled_rounded,
                    title: 'Dispositivo BLE',
                    description:
                        'Será habilitado somente após definição e teste do '
                        'protocolo de comunicação com o ESP32.',
                    badge: 'INDISPONÍVEL',
                    muted: true,
                    action: FilledButton.icon(
                      key: const Key('select-ble-source'),
                      onPressed: null,
                      icon: const Icon(Icons.bluetooth_rounded),
                      label: const Text('BLE ainda não disponível'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: const Color(0xFFE0F2FE),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'A escolha da fonte informa apenas a origem técnica '
                        'das amostras. Nenhuma opção realiza diagnóstico clínico.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Cancelar sessão'),
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

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.action,
    this.muted = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final Widget action;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? Colors.blueGrey : const Color(0xFF0284C7);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(label: Text(badge)),
              ],
            ),
            const SizedBox(height: 12),
            Text(description),
            const SizedBox(height: 20),
            action,
          ],
        ),
      ),
    );
  }
}
