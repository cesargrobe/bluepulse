enum SessionClockStatus { idle, running, paused, completed }

class SessionClock {
  SessionClock({required this.totalSeconds})
    : assert(totalSeconds > 0),
      remainingSeconds = totalSeconds;

  final int totalSeconds;
  int remainingSeconds;
  SessionClockStatus status = SessionClockStatus.idle;

  int get elapsedSeconds => totalSeconds - remainingSeconds;
  double get progress => elapsedSeconds / totalSeconds;

  void start() {
    remainingSeconds = totalSeconds;
    status = SessionClockStatus.running;
  }

  void tick() {
    if (status != SessionClockStatus.running) return;
    if (remainingSeconds > 0) remainingSeconds -= 1;
    if (remainingSeconds == 0) status = SessionClockStatus.completed;
  }

  void pause() {
    if (status == SessionClockStatus.running) {
      status = SessionClockStatus.paused;
    }
  }

  void resume() {
    if (status == SessionClockStatus.paused) {
      status = SessionClockStatus.running;
    }
  }

  void reset() {
    remainingSeconds = totalSeconds;
    status = SessionClockStatus.idle;
  }
}

enum BreathingPhase { inhale, exhale }

BreathingPhase breathingPhaseAt(int elapsedSeconds) =>
    elapsedSeconds % 10 < 4 ? BreathingPhase.inhale : BreathingPhase.exhale;
