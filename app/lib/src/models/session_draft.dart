enum DataOrigin { simulated, ble }

class InitialSelfReport {
  const InitialSelfReport({
    required this.tension,
    required this.tranquility,
    required this.comfort,
  });

  final int tension;
  final int tranquility;
  final int comfort;
}

class SessionDraft {
  const SessionDraft({
    required this.sessionCode,
    required this.initialSelfReport,
    this.dataOrigin,
  });

  final String sessionCode;
  final InitialSelfReport initialSelfReport;
  final DataOrigin? dataOrigin;

  SessionDraft copyWith({DataOrigin? dataOrigin}) {
    return SessionDraft(
      sessionCode: sessionCode,
      initialSelfReport: initialSelfReport,
      dataOrigin: dataOrigin ?? this.dataOrigin,
    );
  }
}
