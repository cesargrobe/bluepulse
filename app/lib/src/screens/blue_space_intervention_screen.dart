import 'dart:async';

import 'package:flutter/material.dart';

import '../models/session_draft.dart';
import '../session/session_clock.dart';

class BlueSpaceInterventionScreen extends StatefulWidget {
  const BlueSpaceInterventionScreen({required this.sessionDraft, super.key});

  final SessionDraft sessionDraft;

  @override
  State<BlueSpaceInterventionScreen> createState() =>
      _BlueSpaceInterventionScreenState();
}

class _BlueSpaceInterventionScreenState
    extends State<BlueSpaceInterventionScreen> {
  final SessionClock _clock = SessionClock(totalSeconds: 30);
  Timer? _timer;

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
    final inhale =
        breathingPhaseAt(_clock.elapsedSeconds) == BreathingPhase.inhale;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F2FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Pausa oceânica'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    completed
                        ? 'Pausa oceânica concluída'
                        : 'Respiração visual opcional',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF075985),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    completed
                        ? 'Obrigado por participar deste ensaio do protótipo.'
                        : 'Respire naturalmente e interrompa se sentir qualquer desconforto.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      width: started && !completed ? (inhale ? 220 : 145) : 170,
                      height: started && !completed
                          ? (inhale ? 220 : 145)
                          : 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF7DD3FC), Color(0xFF0284C7)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7)
                                .withValues(alpha: 0.25),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        completed ? Icons.check_rounded : Icons.water_rounded,
                        color: Colors.white,
                        size: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    completed
                        ? 'Concluído'
                        : started
                        ? (inhale ? 'Inspire suavemente' : 'Expire suavemente')
                        : '30 segundos',
                    key: const Key('breathing-instruction'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(_clock.remainingSeconds),
                    key: const Key('blue-space-remaining'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.volume_off_outlined),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Áudio não incluído nesta versão. Um som oceânico só será adicionado com autoria e licença registradas.',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Este recurso experimental promove uma pausa guiada; não é tratamento e não realiza diagnóstico clínico.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!started)
                    FilledButton.icon(
                      key: const Key('start-blue-space'),
                      onPressed: _start,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Iniciar pausa visual'),
                    )
                  else if (!completed)
                    FilledButton.icon(
                      key: const Key('toggle-blue-space'),
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
                      onPressed: () =>
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Encerrar protótipo'),
                    ),
                  const SizedBox(height: 8),
                  if (!completed)
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Agora não'),
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
