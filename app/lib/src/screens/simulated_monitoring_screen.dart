import 'package:flutter/material.dart';

import '../models/session_draft.dart';
import '../simulation/deterministic_simulator.dart';

class SimulatedMonitoringScreen extends StatefulWidget {
  const SimulatedMonitoringScreen({required this.sessionDraft, super.key});

  final SessionDraft sessionDraft;

  @override
  State<SimulatedMonitoringScreen> createState() =>
      _SimulatedMonitoringScreenState();
}

class _SimulatedMonitoringScreenState extends State<SimulatedMonitoringScreen> {
  late final DeterministicSimulator _simulator;
  int _sampleIndex = 0;

  SensorSample get _sample => _simulator.sampleAt(_sampleIndex);

  @override
  void initState() {
    super.initState();
    _simulator = DeterministicSimulator(
      seed: stableSeedFromCode(widget.sessionDraft.sessionCode),
    );
  }

  void _nextSample() {
    setState(() => _sampleIndex += 1);
  }

  void _restart() {
    setState(() => _sampleIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final sample = _sample;
    final presentation = _presentationFor(sample.scenario);

    return Scaffold(
      appBar: AppBar(title: const Text('Monitoramento simulado')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          'Sessão ${widget.sessionDraft.sessionCode}',
                        ),
                      ),
                      const Chip(
                        avatar: Icon(Icons.science_outlined, size: 18),
                        label: Text('DADOS SIMULADOS'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: presentation.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            presentation.icon,
                            size: 48,
                            color: presentation.foregroundColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  presentation.title,
                                  key: const Key('scenario-title'),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(presentation.description),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth >= 560
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _MetricCard(
                            width: cardWidth,
                            label: 'Intensidade infravermelha',
                            value:
                                sample.infrared?.toString() ?? 'Indisponível',
                            icon: Icons.sensors_rounded,
                          ),
                          _MetricCard(
                            width: cardWidth,
                            label: 'Contato detectado',
                            value: sample.contactDetected ? 'Sim' : 'Não',
                            icon: Icons.touch_app_outlined,
                          ),
                          _MetricCard(
                            width: cardWidth,
                            label: 'Índice de movimento',
                            value:
                                sample.movementIndex?.toStringAsFixed(2) ??
                                'Indisponível',
                            icon: Icons.vibration_rounded,
                          ),
                          _MetricCard(
                            width: cardWidth,
                            label: 'Qualidade da amostra',
                            value: _qualityLabel(sample.quality),
                            icon: Icons.fact_check_outlined,
                          ),
                          _MetricCard(
                            width: cardWidth,
                            label: 'BPM / SpO₂ / GSR',
                            value: 'Não disponíveis',
                            icon: Icons.favorite_border_rounded,
                          ),
                          _MetricCard(
                            width: cardWidth,
                            label: 'Cenário',
                            value: '${sample.index % 4 + 1} de 4',
                            icon: Icons.repeat_rounded,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: const Color(0xFFFFFBEB),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Os critérios IR > 5000 para contato e movimento >= 0.08 '
                        'são provisórios de bancada. Os números desta tela são '
                        'artificiais e não representam uma pessoa.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const Key('next-simulated-sample'),
                    onPressed: _nextSample,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: const Text('Avançar simulação'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _restart,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Reiniciar sequência'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Encerrar teste simulado'),
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

String _qualityLabel(SampleQuality quality) {
  return switch (quality) {
    SampleQuality.unavailable => 'Indisponível',
    SampleQuality.good => 'Adequada para o ensaio',
    SampleQuality.affected => 'Afetada por movimento',
  };
}

_ScenarioPresentation _presentationFor(SimulatedScenario scenario) {
  return switch (scenario) {
    SimulatedScenario.noContact => const _ScenarioPresentation(
      title: 'Sem contato',
      description: 'A simulação representa o sensor sem contato com a pele.',
      icon: Icons.pan_tool_alt_outlined,
      backgroundColor: Color(0xFFE0F2FE),
      foregroundColor: Color(0xFF0369A1),
    ),
    SimulatedScenario.stableContact => const _ScenarioPresentation(
      title: 'Sinal adequado',
      description: 'Contato simulado com baixo índice de movimento.',
      icon: Icons.check_circle_outline_rounded,
      backgroundColor: Color(0xFFDCFCE7),
      foregroundColor: Color(0xFF15803D),
    ),
    SimulatedScenario.movement => const _ScenarioPresentation(
      title: 'Movimento detectado',
      description: 'A amostra simulada foi marcada como afetada por movimento.',
      icon: Icons.directions_run_rounded,
      backgroundColor: Color(0xFFFEF3C7),
      foregroundColor: Color(0xFFA16207),
    ),
    SimulatedScenario.transientFailure => const _ScenarioPresentation(
      title: 'Falha simulada',
      description: 'A leitura está indisponível neste passo da sequência.',
      icon: Icons.warning_amber_rounded,
      backgroundColor: Color(0xFFFEE2E2),
      foregroundColor: Color(0xFFB91C1C),
    ),
  };
}

class _ScenarioPresentation {
  const _ScenarioPresentation({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.label,
    required this.value,
    required this.icon,
  });

  final double width;
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF0284C7)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
