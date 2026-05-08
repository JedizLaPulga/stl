/// Timer utilities: CountdownTimer and Ticker.
///
/// * [CountdownTimer] — synchronous countdown tracker (no async required).
/// * [Ticker] — [Stream]-based periodic tick source.
library;

// ---------------------------------------------------------------------------
// CountdownTimer
// ---------------------------------------------------------------------------

/// A synchronous countdown timer that tracks how much time remains.
///
/// [CountdownTimer] does **not** fire callbacks or use async machinery. It
/// simply records when it was started and computes remaining/elapsed time on
/// demand by comparing against [DateTime.now]. This makes it suitable for
/// both sync and async contexts.
///
/// ```dart
/// final timer = CountdownTimer(const Duration(seconds: 10));
/// timer.start();
/// // … later …
/// print(timer.remaining); // Duration(seconds: ~7)
/// print(timer.progress);  // 0.3
/// ```
class CountdownTimer {
  final Duration _total;
  DateTime? _startTime;

  /// Creates a [CountdownTimer] that will count down [total].
  ///
  /// Throws [ArgumentError] if [total] is negative or zero.
  CountdownTimer(Duration total) : _total = total {
    if (total <= Duration.zero) {
      throw ArgumentError.value(total, 'total', 'must be a positive duration');
    }
  }

  // ---- Control -------------------------------------------------------------

  /// Starts (or restarts) the countdown from the full [total] duration.
  void start() => _startTime = DateTime.now();

  /// Resets the timer to its initial state without starting it.
  void reset() => _startTime = null;

  // ---- Properties ----------------------------------------------------------

  /// The total duration this timer counts down from.
  Duration get total => _total;

  /// Returns `true` if [start] has been called at least once after the last
  /// [reset].
  bool get isStarted => _startTime != null;

  /// Returns `true` if the countdown has reached zero.
  ///
  /// Always `false` if the timer has not been started.
  bool get isExpired {
    if (_startTime == null) return false;
    return DateTime.now().difference(_startTime!) >= _total;
  }

  /// Time remaining until the countdown expires.
  ///
  /// Returns [total] if not yet started; [Duration.zero] once expired.
  Duration get remaining {
    if (_startTime == null) return _total;
    final elapsed = DateTime.now().difference(_startTime!);
    final rem = _total - elapsed;
    return rem.isNegative ? Duration.zero : rem;
  }

  /// Time elapsed since [start] was called.
  ///
  /// Capped at [total] — does not grow beyond the countdown period.
  Duration get elapsed {
    if (_startTime == null) return Duration.zero;
    final e = DateTime.now().difference(_startTime!);
    return e > _total ? _total : e;
  }

  /// Completion fraction in the range `[0.0, 1.0]`.
  ///
  /// Returns `0.0` if not started; `1.0` when expired.
  double get progress {
    if (_startTime == null) return 0.0;
    return (elapsed.inMicroseconds / _total.inMicroseconds).clamp(0.0, 1.0);
  }

  @override
  String toString() =>
      'CountdownTimer(total: $_total, remaining: $remaining, '
      'progress: ${(progress * 100).toStringAsFixed(1)}%)';
}

// ---------------------------------------------------------------------------
// Ticker
// ---------------------------------------------------------------------------

/// A framework-independent periodic tick source backed by [Stream.periodic].
///
/// Each tick carries the cumulative elapsed time since the ticker started
/// (i.e. `interval * tickNumber`). Cancel the subscription to stop ticking.
///
/// ```dart
/// final ticker = Ticker(const Duration(milliseconds: 16));
/// final sub = ticker.tick().listen((elapsed) {
///   print('elapsed: $elapsed');
/// });
/// // …
/// await sub.cancel();
/// ```
class Ticker {
  /// The interval between successive ticks.
  final Duration interval;

  Stream<Duration>? _stream;

  /// Creates a [Ticker] that fires once every [interval].
  ///
  /// Throws [ArgumentError] if [interval] is not positive.
  Ticker(this.interval) {
    if (interval <= Duration.zero) {
      throw ArgumentError.value(
        interval,
        'interval',
        'must be a positive duration',
      );
    }
  }

  /// Returns the [Stream<Duration>] of periodic ticks.
  ///
  /// Each emitted value is the cumulative elapsed time since the first tick:
  /// `interval`, `2 * interval`, `3 * interval`, …
  ///
  /// The stream is created lazily on the first call and reused on subsequent
  /// calls. To obtain a fresh stream, create a new [Ticker].
  Stream<Duration> tick() {
    _stream ??= Stream.periodic(interval, (i) => interval * (i + 1));
    return _stream!;
  }
}
