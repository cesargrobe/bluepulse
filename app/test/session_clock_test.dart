import 'package:bluepulse_app/src/session/session_clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('relógio inicia, pausa, continua e conclui', () {
    final clock = SessionClock(totalSeconds: 3);
    expect(clock.status, SessionClockStatus.idle);
    clock.start();
    clock.tick();
    expect(clock.remainingSeconds, 2);
    expect(clock.progress, closeTo(1 / 3, 0.001));
    clock.pause();
    clock.tick();
    expect(clock.remainingSeconds, 2);
    clock.resume();
    clock.tick();
    clock.tick();
    expect(clock.status, SessionClockStatus.completed);
    expect(clock.remainingSeconds, 0);
  });

  test('ciclo respiratório usa quatro segundos para inspirar', () {
    expect(breathingPhaseAt(0), BreathingPhase.inhale);
    expect(breathingPhaseAt(3), BreathingPhase.inhale);
    expect(breathingPhaseAt(4), BreathingPhase.exhale);
    expect(breathingPhaseAt(9), BreathingPhase.exhale);
    expect(breathingPhaseAt(10), BreathingPhase.inhale);
  });
}
