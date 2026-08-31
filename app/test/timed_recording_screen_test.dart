import 'dart:io';

import 'package:bluepulse_app/src/models/recorded_session.dart';
import 'package:bluepulse_app/src/models/session_draft.dart';
import 'package:bluepulse_app/src/screens/timed_monitoring_screen.dart';
import 'package:bluepulse_app/src/storage/session_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('salva e exclui coleta simulada após trinta segundos', (
    tester,
  ) async {
    final repository = _MemorySessionStore();
    const draft = SessionDraft(
      sessionCode: 'BP-TESTE',
      initialSelfReport: InitialSelfReport(
        tension: 3,
        tranquility: 4,
        comfort: 5,
      ),
      dataOrigin: DataOrigin.simulated,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimedMonitoringScreen(
          sessionDraft: draft,
          repository: repository,
          now: () => DateTime.utc(2026, 8, 30, 21),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('start-timed-monitoring')));
    await tester.pump(const Duration(seconds: 30));
    expect(find.text('Monitoramento concluído'), findsOneWidget);
    expect(find.text('30 amostras artificiais'), findsOneWidget);

    final saveButton = find.byKey(const Key('save-simulated-recording'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.textContaining('salva na área privada'), findsOneWidget);
    expect(find.byKey(const Key('export-simulated-recording')), findsOneWidget);
    expect(find.byKey(const Key('delete-simulated-recording')), findsOneWidget);
    expect(repository.session?.samples, hasLength(30));

    final deleteButton = find.byKey(const Key('delete-simulated-recording'));
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete-recording')));
    await tester.pumpAndSettle();
    expect(find.textContaining('excluída do dispositivo'), findsOneWidget);
    expect(find.byKey(const Key('save-simulated-recording')), findsOneWidget);
    expect(repository.session, isNull);
  });
}

class _MemorySessionStore implements SessionStore {
  RecordedSession? session;

  @override
  Future<void> delete(RecordedSession session) async {
    this.session = null;
  }

  @override
  Future<SessionExport> createExport(RecordedSession session) {
    throw UnimplementedError();
  }

  @override
  Future<List<RecordedSession>> list() async => [?session];

  @override
  Future<File> save(RecordedSession session) async {
    this.session = session;
    return File('unused-in-memory-test.json');
  }
}
