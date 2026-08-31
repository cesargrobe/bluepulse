import 'dart:convert';
import 'dart:io';

import 'package:bluepulse_app/src/models/recorded_session.dart';
import 'package:bluepulse_app/src/models/session_draft.dart';
import 'package:bluepulse_app/src/simulation/deterministic_simulator.dart';
import 'package:bluepulse_app/src/storage/session_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory root;
  late Directory documents;
  late Directory temporary;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('bluepulse-recording-test-');
    documents = Directory('${root.path}/documents');
    temporary = Directory('${root.path}/temporary');
    await documents.create();
    await temporary.create();
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('serializa coleta simulada com metadados e métricas indisponíveis', () {
    final session = _session();
    final decoded = jsonDecode(session.toPrettyJson()) as Map<String, dynamic>;

    expect(decoded['schema_version'], 1);
    expect(decoded['data_origin'], 'simulated');
    expect(decoded['session_code'], 'BP-TESTE');
    expect(
      decoded['thresholds_provisional']['infrared_contact_greater_than'],
      5000,
    );
    expect(decoded['clinical_status']['diagnosis'], isFalse);
    expect(decoded['clinical_status']['bpm_available'], isFalse);
    expect(decoded['samples'], hasLength(30));
    expect(decoded['samples'][0]['bpm'], isNull);
    expect(decoded['samples'][0]['spo2'], isNull);
    expect(decoded['samples'][0]['gsr'], isNull);

    final restored = RecordedSession.fromJson(decoded.cast<String, Object?>());
    expect(restored.sessionCode, session.sessionCode);
    expect(restored.samples.length, 30);
    expect(restored.samples[2].scenario, SimulatedScenario.movement);
  });

  test('exporta CSV com cabeçalho e trinta amostras', () {
    final lines = _session().toCsv().trim().split('\n');

    expect(lines, hasLength(31));
    expect(lines.first, contains('data_origin'));
    expect(lines.first, contains('bpm,spo2,gsr'));
    expect(lines[1], contains('BP-TESTE,simulated,0'));
  });

  test('salva, lista, exporta e exclui a sessão', () async {
    final repository = SessionRepository(
      documentsDirectory: () async => documents,
      temporaryDirectory: () async => temporary,
    );
    final session = _session();

    final persisted = await repository.save(session);
    expect(await persisted.exists(), isTrue);
    expect((await repository.list()).single.samples, hasLength(30));

    final exported = await repository.createExport(session);
    expect(await exported.jsonFile.exists(), isTrue);
    expect(await exported.csvFile.exists(), isTrue);

    await repository.delete(session);
    expect(await persisted.exists(), isFalse);
    expect(await exported.jsonFile.exists(), isFalse);
    expect(await exported.csvFile.exists(), isFalse);
  });
}

RecordedSession _session() {
  const draft = SessionDraft(
    sessionCode: 'BP-TESTE',
    initialSelfReport: InitialSelfReport(
      tension: 3,
      tranquility: 4,
      comfort: 5,
    ),
    dataOrigin: DataOrigin.simulated,
  );
  const simulator = DeterministicSimulator(seed: 123);
  return RecordedSession.fromSimulation(
    draft: draft,
    startedAtUtc: DateTime.utc(2026, 8, 30, 21, 0),
    endedAtUtc: DateTime.utc(2026, 8, 30, 21, 0, 30),
    samples: List.generate(30, simulator.sampleAt),
  );
}
