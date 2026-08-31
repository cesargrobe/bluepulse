import 'dart:io';

import 'package:bluepulse_app/src/models/recorded_session.dart';
import 'package:bluepulse_app/src/models/session_draft.dart';
import 'package:bluepulse_app/src/screens/session_history_screen.dart';
import 'package:bluepulse_app/src/simulation/deterministic_simulator.dart';
import 'package:bluepulse_app/src/storage/session_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('recupera coleta salva quando a tela é recriada', (tester) async {
    final repository = _MemoryHistoryStore([_session('BP-002')]);

    await tester.pumpWidget(
      MaterialApp(home: SessionHistoryScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('BP-002'), findsOneWidget);
    expect(find.text('30 amostras simuladas'), findsOneWidget);
    expect(find.text('Duração registrada: 30.003 s'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(home: SessionHistoryScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('BP-002'), findsOneWidget);
    expect(repository.listCalls, 2);
  });

  testWidgets('exclui coleta do histórico após confirmação', (tester) async {
    final repository = _MemoryHistoryStore([_session('BP-EXCLUIR')]);

    await tester.pumpWidget(
      MaterialApp(home: SessionHistoryScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    final deleteButton = find.byKey(const Key('history-delete-BP-EXCLUIR'));
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-history-delete')));
    await tester.pumpAndSettle();

    expect(find.text('BP-EXCLUIR'), findsNothing);
    expect(find.byKey(const Key('empty-session-history')), findsOneWidget);
    expect(repository.sessions, isEmpty);
  });

  testWidgets('informa quando ainda não há coleta salva', (tester) async {
    final repository = _MemoryHistoryStore();

    await tester.pumpWidget(
      MaterialApp(home: SessionHistoryScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nenhuma coleta simulada salva'), findsOneWidget);
    expect(
      find.textContaining('somente após a ação explícita de salvar'),
      findsOneWidget,
    );
  });
}

class _MemoryHistoryStore implements SessionStore {
  _MemoryHistoryStore([Iterable<RecordedSession> initial = const []])
    : sessions = initial.toList();

  final List<RecordedSession> sessions;
  int listCalls = 0;

  @override
  Future<File> save(RecordedSession session) async {
    sessions.add(session);
    return File('unused-in-memory-history.json');
  }

  @override
  Future<List<RecordedSession>> list() async {
    listCalls += 1;
    return List.unmodifiable(sessions);
  }

  @override
  Future<SessionExport> createExport(RecordedSession session) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(RecordedSession session) async {
    sessions.removeWhere((item) => item.storageKey == session.storageKey);
  }
}

RecordedSession _session(String code) {
  final draft = SessionDraft(
    sessionCode: code,
    initialSelfReport: const InitialSelfReport(
      tension: 2,
      tranquility: 3,
      comfort: 2,
    ),
    dataOrigin: DataOrigin.simulated,
  );
  const simulator = DeterministicSimulator(seed: 123);
  return RecordedSession.fromSimulation(
    draft: draft,
    startedAtUtc: DateTime.utc(2026, 8, 31, 2, 0, 37, 608, 605),
    endedAtUtc: DateTime.utc(2026, 8, 31, 2, 1, 7, 611, 105),
    samples: List.generate(30, simulator.sampleAt),
  );
}
