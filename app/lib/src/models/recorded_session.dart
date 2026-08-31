import 'dart:convert';

import '../simulation/deterministic_simulator.dart';
import 'session_draft.dart';

class RecordedSample {
  const RecordedSample({
    required this.sequence,
    required this.elapsedMilliseconds,
    required this.simulatedTimestampUtc,
    required this.scenario,
    required this.infrared,
    required this.contactDetected,
    required this.movementIndex,
    required this.quality,
  });

  factory RecordedSample.fromSensorSample(SensorSample sample) {
    return RecordedSample(
      sequence: sample.index,
      elapsedMilliseconds: sample.index * 1000,
      simulatedTimestampUtc: sample.timestamp.toUtc(),
      scenario: sample.scenario,
      infrared: sample.infrared,
      contactDetected: sample.contactDetected,
      movementIndex: sample.movementIndex,
      quality: sample.quality,
    );
  }

  factory RecordedSample.fromJson(Map<String, Object?> json) {
    return RecordedSample(
      sequence: json['sequence']! as int,
      elapsedMilliseconds: json['elapsed_ms']! as int,
      simulatedTimestampUtc: DateTime.parse(
        json['simulated_timestamp_utc']! as String,
      ).toUtc(),
      scenario: SimulatedScenario.values.byName(json['scenario']! as String),
      infrared: json['infrared'] as int?,
      contactDetected: json['contact_detected']! as bool,
      movementIndex: (json['movement_index'] as num?)?.toDouble(),
      quality: SampleQuality.values.byName(json['quality']! as String),
    );
  }

  final int sequence;
  final int elapsedMilliseconds;
  final DateTime simulatedTimestampUtc;
  final SimulatedScenario scenario;
  final int? infrared;
  final bool contactDetected;
  final double? movementIndex;
  final SampleQuality quality;

  Map<String, Object?> toJson() => {
    'sequence': sequence,
    'elapsed_ms': elapsedMilliseconds,
    'simulated_timestamp_utc': simulatedTimestampUtc.toIso8601String(),
    'scenario': scenario.name,
    'infrared': infrared,
    'contact_detected': contactDetected,
    'movement_index': movementIndex,
    'quality': quality.name,
    'bpm': null,
    'spo2': null,
    'gsr': null,
  };
}

class RecordedSession {
  const RecordedSession({
    required this.sessionCode,
    required this.startedAtUtc,
    required this.endedAtUtc,
    required this.initialSelfReport,
    required this.samples,
  });

  factory RecordedSession.fromSimulation({
    required SessionDraft draft,
    required DateTime startedAtUtc,
    required DateTime endedAtUtc,
    required Iterable<SensorSample> samples,
  }) {
    return RecordedSession(
      sessionCode: draft.sessionCode,
      startedAtUtc: startedAtUtc.toUtc(),
      endedAtUtc: endedAtUtc.toUtc(),
      initialSelfReport: draft.initialSelfReport,
      samples: samples
          .map(RecordedSample.fromSensorSample)
          .toList(growable: false),
    );
  }

  factory RecordedSession.fromJson(Map<String, Object?> json) {
    final report = json['initial_self_report']! as Map<String, Object?>;
    final samples = json['samples']! as List<Object?>;
    return RecordedSession(
      sessionCode: json['session_code']! as String,
      startedAtUtc: DateTime.parse(json['started_at_utc']! as String).toUtc(),
      endedAtUtc: DateTime.parse(json['ended_at_utc']! as String).toUtc(),
      initialSelfReport: InitialSelfReport(
        tension: report['tension']! as int,
        tranquility: report['tranquility']! as int,
        comfort: report['comfort']! as int,
      ),
      samples: samples
          .cast<Map<String, Object?>>()
          .map(RecordedSample.fromJson)
          .toList(growable: false),
    );
  }

  static const int schemaVersion = 1;
  static const String appVersion = '1.0.0+1';
  static const String simulatorVersion = 'deterministic-v1';
  static const int provisionalInfraredThreshold = 5000;
  static const double provisionalMovementThreshold = 0.08;

  final String sessionCode;
  final DateTime startedAtUtc;
  final DateTime endedAtUtc;
  final InitialSelfReport initialSelfReport;
  final List<RecordedSample> samples;

  String get storageKey {
    final timestamp = startedAtUtc.toIso8601String().replaceAll(':', '-');
    final safeCode = sessionCode.replaceAll(RegExp('[^A-Za-z0-9-]'), '_');
    return '${safeCode}_$timestamp';
  }

  Map<String, Object?> toJson() => {
    'schema_version': schemaVersion,
    'project': 'BluePulse',
    'app_version': appVersion,
    'data_origin': 'simulated',
    'simulator_version': simulatorVersion,
    'session_code': sessionCode,
    'started_at_utc': startedAtUtc.toIso8601String(),
    'ended_at_utc': endedAtUtc.toIso8601String(),
    'sample_interval_ms': 1000,
    'thresholds_provisional': {
      'infrared_contact_greater_than': provisionalInfraredThreshold,
      'movement_affected_greater_than_or_equal_to':
          provisionalMovementThreshold,
    },
    'clinical_status': {
      'diagnosis': false,
      'bpm_available': false,
      'spo2_available': false,
      'gsr_available': false,
      'stress_inference_available': false,
      'anxiety_inference_available': false,
    },
    'initial_self_report': {
      'tension': initialSelfReport.tension,
      'tranquility': initialSelfReport.tranquility,
      'comfort': initialSelfReport.comfort,
      'interpretation': null,
    },
    'samples': samples.map((sample) => sample.toJson()).toList(growable: false),
  };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  String toCsv() {
    final rows = <List<Object?>>[
      [
        'schema_version',
        'session_code',
        'data_origin',
        'sequence',
        'elapsed_ms',
        'simulated_timestamp_utc',
        'scenario',
        'infrared',
        'contact_detected',
        'movement_index',
        'quality',
        'bpm',
        'spo2',
        'gsr',
      ],
      ...samples.map(
        (sample) => <Object?>[
          schemaVersion,
          sessionCode,
          'simulated',
          sample.sequence,
          sample.elapsedMilliseconds,
          sample.simulatedTimestampUtc.toIso8601String(),
          sample.scenario.name,
          sample.infrared,
          sample.contactDetected,
          sample.movementIndex,
          sample.quality.name,
          null,
          null,
          null,
        ],
      ),
    ];
    return '${rows.map(_encodeCsvRow).join('\n')}\n';
  }
}

String _encodeCsvRow(List<Object?> cells) {
  return cells
      .map((cell) {
        final value = cell?.toString() ?? '';
        if (!value.contains(RegExp('[,"\n\r]'))) return value;
        return '"${value.replaceAll('"', '""')}"';
      })
      .join(',');
}
