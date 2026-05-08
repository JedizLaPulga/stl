/// C++ inspired time and clock utilities.
///
/// Provides [SystemClock] and [SteadyClock] for precise, portable time tracking
/// across Native and Web platforms, along with [TimePoint] and extensions for
/// expressive duration creation (e.g. `10.milliseconds`).
///
/// Additional clocks, calendar types, time intervals, lap stopwatch, and
/// timer utilities are exposed via the sub-libraries re-exported from
/// `package:stl/stl.dart`:
///   - `chrono/calendar.dart`  — [ChronoDate], [ChronoTime], [ChronoDateTime],
///                               [Month], [Weekday]
///   - `chrono/clocks.dart`    — [MockClock], [HiResClock], [UtcClock],
///                               [TaiClock], [GpsClock]
///   - `chrono/time_interval.dart` — [TimeInterval]
///   - `chrono/lap_stopwatch.dart` — [LapStopwatch], [LapRecord]
///   - `chrono/timer.dart`     — [CountdownTimer], [Ticker]
library;

/// Represents a monotonic clock that never jumps backward.
///
/// Analogous to `std::chrono::steady_clock` in C++.
/// This is specifically designed for measuring time intervals precisely.
class SteadyClock {
  SteadyClock._();

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
  SystemClock._();

  /// Returns a [TimePoint] representing the current system time since Unix Epoch.
  static TimePoint now() {
    return TimePoint(
      Duration(microseconds: DateTime.now().microsecondsSinceEpoch),
    );
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

  /// The Unix epoch (1970-01-01 00:00:00 UTC) as a [TimePoint].
  static const TimePoint epoch = TimePoint(Duration.zero);

  /// Creates a [TimePoint] from a Dart [DateTime].
  ///
  /// The [TimePoint.timeSinceEpoch] will equal the number of microseconds
  /// since the Unix epoch (1970-01-01T00:00:00Z), matching the semantics of
  /// [SystemClock] and [UtcClock].
  factory TimePoint.fromDateTime(DateTime dt) =>
      TimePoint(Duration(microseconds: dt.microsecondsSinceEpoch));

  // ---- Arithmetic ----------------------------------------------------------

  /// Returns the [Duration] elapsed from [other] to this time point.
  ///
  /// The result is negative when this point is earlier than [other].
  Duration operator -(TimePoint other) => timeSinceEpoch - other.timeSinceEpoch;

  /// Returns a new [TimePoint] displaced forward by [duration].
  TimePoint operator +(Duration duration) =>
      TimePoint(timeSinceEpoch + duration);

  // ---- Conversions ---------------------------------------------------------

  /// Converts this time point to a Dart [DateTime] in UTC.
  ///
  /// Interprets [timeSinceEpoch] as microseconds since the Unix epoch.
  /// The result is in UTC regardless of the local time zone.
  DateTime toDateTime() => DateTime.fromMicrosecondsSinceEpoch(
    timeSinceEpoch.inMicroseconds,
    isUtc: true,
  );

  /// Formats this time point as an ISO 8601 string in UTC.
  ///
  /// Example: `"2024-06-15T12:30:00.000000Z"`.
  String toIso8601String() => toDateTime().toIso8601String();

  // ---- Comparison ----------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimePoint && timeSinceEpoch == other.timeSinceEpoch;
  }

  @override
  int get hashCode => timeSinceEpoch.hashCode;

  /// Returns true if this time point is strictly before [other].
  bool operator <(TimePoint other) => timeSinceEpoch < other.timeSinceEpoch;

  /// Returns true if this time point is strictly after [other].
  bool operator >(TimePoint other) => timeSinceEpoch > other.timeSinceEpoch;

  /// Returns true if this time point is before or equal to [other].
  bool operator <=(TimePoint other) => timeSinceEpoch <= other.timeSinceEpoch;

  /// Returns true if this time point is after or equal to [other].
  bool operator >=(TimePoint other) => timeSinceEpoch >= other.timeSinceEpoch;

  @override
  int compareTo(TimePoint other) =>
      timeSinceEpoch.compareTo(other.timeSinceEpoch);

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

  /// Creates a [Duration] in days.
  Duration get days => Duration(days: this);

  /// Creates a [Duration] in weeks (7 days each).
  Duration get weeks => Duration(days: this * 7);
}

// ---------------------------------------------------------------------------
// DurationExtension
// ---------------------------------------------------------------------------

/// Extensions on Dart's built-in [Duration] for formatting and rounding.
extension DurationExtension on Duration {
  /// Returns `true` if this duration is strictly positive.
  bool get isPositive => inMicroseconds > 0;

  /// Formats this duration as a human-readable string.
  ///
  /// Components are omitted when zero. Fractional seconds are shown at
  /// millisecond granularity when the duration has a sub-second component.
  ///
  /// Examples:
  /// * `Duration(hours: 2, minutes: 30, seconds: 5)` → `"2h 30m 5s"`
  /// * `Duration(milliseconds: 750)` → `"750ms"`
  /// * `Duration.zero` → `"0s"`
  String humanReadable() {
    if (this == Duration.zero) return '0s';
    final negative = isNegative;
    var rem = negative ? -this : this;
    final parts = <String>[];

    final d = rem.inDays;
    if (d > 0) {
      parts.add('${d}d');
      rem -= Duration(days: d);
    }
    final h = rem.inHours;
    if (h > 0) {
      parts.add('${h}h');
      rem -= Duration(hours: h);
    }
    final m = rem.inMinutes;
    if (m > 0) {
      parts.add('${m}m');
      rem -= Duration(minutes: m);
    }
    final s = rem.inSeconds;
    if (s > 0) {
      parts.add('${s}s');
      rem -= Duration(seconds: s);
    }
    final ms = rem.inMilliseconds;
    if (ms > 0) {
      parts.add('${ms}ms');
    }

    return (negative ? '-' : '') + parts.join(' ');
  }

  /// Formats this duration as an ISO 8601 duration string.
  ///
  /// Examples:
  /// * `Duration(hours: 2, minutes: 30, seconds: 5)` → `"PT2H30M5S"`
  /// * `Duration(days: 3)` → `"P3D"`
  /// * `Duration.zero` → `"PT0S"`
  /// * `Duration(seconds: -5)` → `"-PT5S"`
  String toIso8601() {
    if (this == Duration.zero) return 'PT0S';
    final negative = isNegative;
    var rem = negative ? -this : this;
    final buf = StringBuffer(negative ? '-P' : 'P');

    final d = rem.inDays;
    if (d > 0) {
      buf.write('${d}D');
      rem -= Duration(days: d);
    }

    if (rem > Duration.zero) {
      buf.write('T');
      final h = rem.inHours;
      if (h > 0) {
        buf.write('${h}H');
        rem -= Duration(hours: h);
      }
      final min = rem.inMinutes;
      if (min > 0) {
        buf.write('${min}M');
        rem -= Duration(minutes: min);
      }
      final micros = rem.inMicroseconds;
      if (micros > 0) {
        final secs = micros ~/ 1000000;
        final frac = micros % 1000000;
        if (frac == 0) {
          buf.write('${secs}S');
        } else {
          final fracStr = frac
              .toString()
              .padLeft(6, '0')
              .replaceAll(RegExp(r'0+$'), '');
          buf.write('$secs.${fracStr}S');
        }
      }
    }

    return buf.toString();
  }

  /// Returns this duration truncated (floored) toward negative infinity to the
  /// nearest multiple of [period].
  ///
  /// Analogous to `std::chrono::floor` in C++17.
  ///
  /// Examples:
  /// * `Duration(seconds: 7).floor(Duration(seconds: 5))` → `Duration(seconds: 5)`
  /// * `Duration(seconds: -7).floor(Duration(seconds: 5))` → `Duration(seconds: -10)`
  ///
  /// Throws [ArgumentError] if [period] is zero.
  Duration floor(Duration period) {
    if (period == Duration.zero) {
      throw ArgumentError.value(period, 'period', 'must be non-zero');
    }
    final us = inMicroseconds;
    final p = period.inMicroseconds;
    final q = us ~/ p;
    // Adjust toward negative infinity if the remainder is non-zero and the
    // signs of us and p differ (Dart ~/ truncates toward zero).
    final floored = ((us ^ p) < 0 && q * p != us) ? q - 1 : q;
    return Duration(microseconds: floored * p);
  }

  /// Returns this duration rounded up (ceiling) toward positive infinity to
  /// the nearest multiple of [period].
  ///
  /// Analogous to `std::chrono::ceil` in C++17.
  ///
  /// Examples:
  /// * `Duration(seconds: 7).ceil(Duration(seconds: 5))` → `Duration(seconds: 10)`
  /// * `Duration(seconds: -7).ceil(Duration(seconds: 5))` → `Duration(seconds: -5)`
  ///
  /// Throws [ArgumentError] if [period] is zero.
  Duration ceil(Duration period) {
    if (period == Duration.zero) {
      throw ArgumentError.value(period, 'period', 'must be non-zero');
    }
    final us = inMicroseconds;
    final p = period.inMicroseconds;
    // ceil = -floor(-us, p) when using true floor division.
    final negUs = -us;
    final q = negUs ~/ p;
    final floored = ((negUs ^ p) < 0 && q * p != negUs) ? q - 1 : q;
    return Duration(microseconds: -floored * p);
  }

  /// Returns this duration rounded to the nearest multiple of [period].
  ///
  /// Ties (exactly halfway) round toward positive infinity (away from zero on
  /// the positive side), matching `std::chrono::round` in C++17.
  ///
  /// Example:
  /// * `Duration(seconds: 7).round(Duration(seconds: 5))` → `Duration(seconds: 5)`
  /// * `Duration(seconds: 8).round(Duration(seconds: 5))` → `Duration(seconds: 10)`
  ///
  /// Throws [ArgumentError] if [period] is zero.
  Duration round(Duration period) {
    if (period == Duration.zero) {
      throw ArgumentError.value(period, 'period', 'must be non-zero');
    }
    final f = floor(period);
    final c = ceil(period);
    final distToFloor = (this - f).abs();
    final distToCeil = (c - this).abs();
    return distToFloor <= distToCeil ? f : c;
  }
}
