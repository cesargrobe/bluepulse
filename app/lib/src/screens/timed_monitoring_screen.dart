import 'dart:async';

import 'package:flutter/material.dart';

import '../models/session_draft.dart';
import '../session/session_clock.dart';
import '../simulation/deterministic_simulator.dart';
import 'blue_space_intervention_screen.dart';

class TimedMonitoringScreen extends StatefulWidget {
  const TimedMonitoringScreen({required this.sessionDraft, super.key});

  final SessionDraft sessionDraft;

  @override
  State<TimedMonitoringScreen> createState() => _TimedMonitoringScreenState();
}

class _TimedMonitoringScreenState extends State<TimedMonitoringScreen> {
  final SessionClock _clock = SessionClock(totalSeconds: 30);
  late final DeterministicSimulator _simulator;
  Timer? _timer;

  SensorSample get _sample => _simulator.sampleAt(_clock.elapsedSeconds);

  @override
  void initState() {
    super.initState();
    _simulator = DeterministicSimulator(
      seed: stableSeedFromCode(widget.sessionDraft.sessionCode),
    );
  }

  void _start() {
    setState(_clock.start);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_clock.tick);
      if (_clock.status == SessionClockStatus.completed) _timer?.cancel();
    });
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
                        ? 'A sequência simulada terminou. Nenhum dado foi salvo.'
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
