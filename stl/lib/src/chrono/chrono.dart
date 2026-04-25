/// C++ inspired time and clock utilities.
///
/// Provides [SystemClock] and [SteadyClock] for precise, portable time tracking
/// across Native and Web platforms, along with [TimePoint] and extensions for
/// expressive duration creation (e.g. `10.milliseconds`).
library;

/// Represents a monotonic clock that never jumps backward.
///
/// Analogous to `std::chrono::steady_clock` in C++.
/// This is specifically designed for measuring time intervals precisely.
class SteadyClock {
  // A globally running stopwatch to simulate monotonic time since program start.
  static final Stopwatch _stopwatch = Stopwatch()..start();

  /// Returns a [TimePoint] representing the current steady time.
  static TimePoint now() {
    return TimePoint(_stopwatch.elapsed);
  }
}

/// Represents the system-wide real time wall clock.
///
/// Analogous to `std::chrono::system_clock` in C++.
/// This clock tracks the current date and time and can be affected by system clock changes.
class SystemClock {
  /// Returns a [TimePoint] representing the current system time since Unix Epoch.
  static TimePoint now() {
    return TimePoint(Duration(microseconds: DateTime.now().microsecondsSinceEpoch));
  }
}

/// Represents a specific point in time measured by a clock.
///
/// Analogous to `std::chrono::time_point` in C++.
class TimePoint implements Comparable<TimePoint> {
  /// The duration representing the time elapsed since the clock's epoch.
  final Duration timeSinceEpoch;

  /// Creates a [TimePoint] with the given [timeSinceEpoch].
  const TimePoint(this.timeSinceEpoch);

  /// Computes the [Duration] between this time point and [other].
  Duration operator -(TimePoint other) => timeSinceEpoch - other.timeSinceEpoch;

  /// Returns a new [TimePoint] by adding [duration] to this time point.
  TimePoint operator +(Duration duration) => TimePoint(timeSinceEpoch + duration);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimePoint && timeSinceEpoch == other.timeSinceEpoch;
  }

  @override
  int get hashCode => timeSinceEpoch.hashCode;

  /// Returns true if this time point is strictly before [other].
  bool operator <(TimePoint other) => timeSinceEpoch < other.timeSinceEpoch;

  /// Returns true if this time point is after [other].
  bool operator >(TimePoint other) => timeSinceEpoch > other.timeSinceEpoch;

  /// Returns true if this time point is before or equal to [other].
  bool operator <=(TimePoint other) => timeSinceEpoch <= other.timeSinceEpoch;

  /// Returns true if this time point is after or equal to [other].
  bool operator >=(TimePoint other) => timeSinceEpoch >= other.timeSinceEpoch;

  @override
  int compareTo(TimePoint other) => timeSinceEpoch.compareTo(other.timeSinceEpoch);

  @override
  String toString() => 'TimePoint($timeSinceEpoch)';
}

/// Extensions on [int] to provide C++ `<chrono>` style literals for durations.
extension ChronoIntExtension on int {
  /// Creates a [Duration] in microseconds (Dart does not support nanosecond precision natively).
  Duration get nanoseconds => Duration(microseconds: this ~/ 1000);
  /// Creates a [Duration] in microseconds.
  Duration get microseconds => Duration(microseconds: this);
  /// Creates a [Duration] in milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);
  /// Creates a [Duration] in seconds.
  Duration get seconds => Duration(seconds: this);
  /// Creates a [Duration] in minutes.
  Duration get minutes => Duration(minutes: this);
  /// Creates a [Duration] in hours.
  Duration get hours => Duration(hours: this);
}
