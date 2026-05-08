/// LapStopwatch — an enhanced stopwatch with lap/split recording.
///
/// Unlike Dart's built-in [Stopwatch], [LapStopwatch] records individual lap
/// durations and provides statistics (fastest, slowest, average).
library;

/// A single recorded lap entry produced by [LapStopwatch.lap].
class LapRecord {
  /// 1-based lap number.
  final int number;

  /// Total elapsed time at the moment the lap was recorded.
  final Duration elapsed;

  /// Duration of this lap alone (time since the previous lap, or since start
  /// for the first lap).
  final Duration lapTime;

  /// Creates a [LapRecord].
  const LapRecord({
    required this.number,
    required this.elapsed,
    required this.lapTime,
  });

  @override
  String toString() => 'Lap $number: $lapTime (total: $elapsed)';
}

/// A stopwatch that records individual lap times.
///
/// Wraps Dart's [Stopwatch] and adds a [lap] method that captures the current
/// split time. All recorded laps are accessible via [laps]; aggregate
/// statistics are available through [fastestLap], [slowestLap], and
/// [averageLap].
///
/// ```dart
/// final sw = LapStopwatch()..start();
/// // … do work …
/// sw.lap(); // records Lap 1
/// // … do more work …
/// sw.lap(); // records Lap 2
/// sw.stop();
/// print(sw.fastestLap);
/// ```
class LapStopwatch {
  final Stopwatch _sw = Stopwatch();
  final List<LapRecord> _laps = [];
  Duration _lastLapElapsed = Duration.zero;

  // ---- Control -------------------------------------------------------------

  /// Starts (or resumes) timing.
  void start() => _sw.start();

  /// Stops timing.
  void stop() => _sw.stop();

  /// Resets all state: clears lap records and resets elapsed time to zero.
  void reset() {
    _sw.reset();
    _laps.clear();
    _lastLapElapsed = Duration.zero;
  }

  // ---- Properties ----------------------------------------------------------

  /// Whether the stopwatch is currently running.
  bool get isRunning => _sw.isRunning;

  /// Total elapsed time since the last [reset] (or construction).
  Duration get elapsed => _sw.elapsed;

  /// Elapsed time of the current (not-yet-recorded) lap.
  Duration get currentLapElapsed => elapsed - _lastLapElapsed;

  /// All recorded [LapRecord]s in recording order.
  List<LapRecord> get laps => List.unmodifiable(_laps);

  // ---- Lap recording -------------------------------------------------------

  /// Records a lap and returns its [LapRecord].
  ///
  /// Captures the time since the last recorded lap (or since [start] for the
  /// first lap). The stopwatch continues running.
  LapRecord lap() {
    final now = _sw.elapsed;
    final lapTime = now - _lastLapElapsed;
    _lastLapElapsed = now;
    final record = LapRecord(
      number: _laps.length + 1,
      elapsed: now,
      lapTime: lapTime,
    );
    _laps.add(record);
    return record;
  }

  // ---- Statistics ----------------------------------------------------------

  /// The shortest individual lap duration, or `null` if no laps have been
  /// recorded.
  Duration? get fastestLap => _laps.isEmpty
      ? null
      : _laps.map((l) => l.lapTime).reduce((a, b) => a < b ? a : b);

  /// The longest individual lap duration, or `null` if no laps have been
  /// recorded.
  Duration? get slowestLap => _laps.isEmpty
      ? null
      : _laps.map((l) => l.lapTime).reduce((a, b) => a > b ? a : b);

  /// The mean lap duration, or `null` if no laps have been recorded.
  Duration? get averageLap {
    if (_laps.isEmpty) return null;
    final total = _laps.fold(Duration.zero, (acc, rec) => acc + rec.lapTime);
    return Duration(microseconds: total.inMicroseconds ~/ _laps.length);
  }

  @override
  String toString() =>
      'LapStopwatch(elapsed: $elapsed, laps: ${_laps.length}, '
      'running: $isRunning)';
}
