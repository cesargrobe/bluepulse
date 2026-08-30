import 'package:bluepulse_app/src/simulation/deterministic_simulator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a mesma semente produz a mesma sequência', () {
    const first = DeterministicSimulator(seed: 42);
    const second = DeterministicSimulator(seed: 42);

    for (var index = 0; index < 12; index += 1) {
      final a = first.sampleAt(index);
      final b = second.sampleAt(index);

      expect(a.timestamp, b.timestamp);
      expect(a.scenario, b.scenario);
      expect(a.infrared, b.infrared);
      expect(a.contactDetected, b.contactDetected);
      expect(a.movementIndex, b.movementIndex);
      expect(a.quality, b.quality);
    }
  });

  test('percorre os quatro cenários e não inventa medidas validadas', () {
    const simulator = DeterministicSimulator(seed: 7);
    final samples = List.generate(4, simulator.sampleAt);

    expect(samples.map((sample) => sample.scenario), [
      SimulatedScenario.noContact,
      SimulatedScenario.stableContact,
      SimulatedScenario.movement,
      SimulatedScenario.transientFailure,
    ]);
    for (final sample in samples) {
      expect(sample.bpm, isNull);
      expect(sample.spo2, isNull);
      expect(sample.gsr, isNull);
    }
  });

  test('rejeita índice negativo', () {
    const simulator = DeterministicSimulator(seed: 1);

    expect(() => simulator.sampleAt(-1), throwsArgumentError);
  });
}
