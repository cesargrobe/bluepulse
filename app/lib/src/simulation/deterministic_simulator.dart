enum SimulatedScenario { noContact, stableContact, movement, transientFailure }

enum SampleQuality { unavailable, good, affected }

class SensorSample {
  const SensorSample({
    required this.index,
    required this.timestamp,
    required this.scenario,
    required this.infrared,
    required this.contactDetected,
    required this.movementIndex,
    required this.quality,
    this.bpm,
    this.spo2,
    this.gsr,
  });

  final int index;
  final DateTime timestamp;
  final SimulatedScenario scenario;
  final int? infrared;
  final bool contactDetected;
  final double? movementIndex;
  final SampleQuality quality;
  final double? bpm;
  final double? spo2;
  final double? gsr;
}

class DeterministicSimulator {
  const DeterministicSimulator({required this.seed});

  final int seed;

  SensorSample sampleAt(int index) {
    if (index < 0) {
      throw ArgumentError.value(index, 'index', 'Deve ser maior ou igual a 0.');
    }

    final scenario = SimulatedScenario.values[index % 4];
    final variation = _variation(index);
    final timestamp = DateTime.utc(
      2026,
      8,
      30,
      12,
    ).add(Duration(seconds: index));

    return switch (scenario) {
      SimulatedScenario.noContact => SensorSample(
        index: index,
        timestamp: timestamp,
        scenario: scenario,
        infrared: 1400 + variation,
        contactDetected: false,
        movementIndex: 0.02,
        quality: SampleQuality.unavailable,
      ),
      SimulatedScenario.stableContact => SensorSample(
        index: index,
        timestamp: timestamp,
        scenario: scenario,
        infrared: 8300 + variation,
        contactDetected: true,
        movementIndex: 0.03,
        quality: SampleQuality.good,
      ),
      SimulatedScenario.movement => SensorSample(
        index: index,
        timestamp: timestamp,
        scenario: scenario,
        infrared: 9100 + variation,
        contactDetected: true,
        movementIndex: 0.14,
        quality: SampleQuality.affected,
      ),
      SimulatedScenario.transientFailure => SensorSample(
        index: index,
        timestamp: timestamp,
        scenario: scenario,
        infrared: null,
        contactDetected: false,
        movementIndex: null,
        quality: SampleQuality.unavailable,
      ),
    };
  }

  int _variation(int index) {
    final value = (seed * 1103515245 + (index + 1) * 12345) & 0x7fffffff;
    return value % 201 - 100;
  }
}

int stableSeedFromCode(String code) {
  return code.codeUnits.fold<int>(17, (value, unit) {
    return (value * 31 + unit) & 0x7fffffff;
  });
}
