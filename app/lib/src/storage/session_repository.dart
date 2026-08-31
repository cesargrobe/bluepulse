import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/recorded_session.dart';

typedef DirectoryProvider = Future<Directory> Function();

class SessionExport {
  const SessionExport({required this.jsonFile, required this.csvFile});

  final File jsonFile;
  final File csvFile;
}

abstract interface class SessionStore {
  Future<File> save(RecordedSession session);
  Future<List<RecordedSession>> list();
  Future<SessionExport> createExport(RecordedSession session);
  Future<void> delete(RecordedSession session);
}

class SessionRepository implements SessionStore {
  factory SessionRepository({
    required DirectoryProvider documentsDirectory,
    required DirectoryProvider temporaryDirectory,
  }) => SessionRepository._(documentsDirectory, temporaryDirectory);

  SessionRepository._(this._documentsDirectory, this._temporaryDirectory);

  factory SessionRepository.platform() {
    return SessionRepository(
      documentsDirectory: getApplicationDocumentsDirectory,
      temporaryDirectory: getTemporaryDirectory,
    );
  }

  final DirectoryProvider _documentsDirectory;
  final DirectoryProvider _temporaryDirectory;

  @override
  Future<File> save(RecordedSession session) async {
    final directory = await _sessionsDirectory();
    final file = File('${directory.path}/${session.storageKey}.json');
    return file.writeAsString(
      '${session.toPrettyJson()}\n',
      encoding: utf8,
      flush: true,
    );
  }

  @override
  Future<List<RecordedSession>> list() async {
    final directory = await _sessionsDirectory();
    final files = await directory
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path));

    final sessions = <RecordedSession>[];
    for (final file in files) {
      final decoded = jsonDecode(await file.readAsString());
      sessions.add(
        RecordedSession.fromJson((decoded as Map).cast<String, Object?>()),
      );
    }
    return sessions;
  }

  @override
  Future<SessionExport> createExport(RecordedSession session) async {
    final root = await _temporaryDirectory();
    final directory = Directory('${root.path}/bluepulse_exports');
    await directory.create(recursive: true);

    final jsonFile = File('${directory.path}/${session.storageKey}.json');
    final csvFile = File('${directory.path}/${session.storageKey}.csv');
    await Future.wait([
      jsonFile.writeAsString(
        '${session.toPrettyJson()}\n',
        encoding: utf8,
        flush: true,
      ),
      csvFile.writeAsString(session.toCsv(), encoding: utf8, flush: true),
    ]);
    return SessionExport(jsonFile: jsonFile, csvFile: csvFile);
  }

  @override
  Future<void> delete(RecordedSession session) async {
    final directory = await _sessionsDirectory();
    final persisted = File('${directory.path}/${session.storageKey}.json');
    if (await persisted.exists()) await persisted.delete();

    final temporary = await _temporaryDirectory();
    for (final extension in const ['json', 'csv']) {
      final exported = File(
        '${temporary.path}/bluepulse_exports/${session.storageKey}.$extension',
      );
      if (await exported.exists()) await exported.delete();
    }
  }

  Future<Directory> _sessionsDirectory() async {
    final root = await _documentsDirectory();
    final directory = Directory('${root.path}/bluepulse_sessions');
    await directory.create(recursive: true);
    return directory;
  }
}
