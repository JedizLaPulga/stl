/// Extended clock types: MockClock, HiResClock, UtcClock, TaiClock, GpsClock.
///
/// Provides additional clocks beyond [SystemClock] and [SteadyClock]:
///
/// * [Clock] — abstract interface that all clocks satisfy.
/// * [MockClock] — manually-controllable clock for deterministic testing.
/// * [HiResClock] — highest-resolution monotonic clock available.
/// * [UtcClock] — UTC wall-clock (time zone–neutral variant of [SystemClock]).
/// * [TaiClock] — International Atomic Time (TAI), ahead of UTC by a fixed
///   leap-second offset.
/// * [GpsClock] — GPS time, measured from the GPS epoch (1980-01-06 UTC).
///
/// Analogous to the additional clocks introduced in C++20 `<chrono>`:
/// `std::chrono::utc_clock`, `std::chrono::tai_clock`,
/// `std::chrono::gps_clock`, and `std::chrono::high_resolution_clock`.
library;

import 'package:stl/src/chrono/chrono.dart';

// ---------------------------------------------------------------------------
// Clock interface
// ---------------------------------------------------------------------------

/// Abstract interface satisfied by every clock in this library.
///
/// Enables dependency injection: accept a [Clock] parameter in code that
/// needs time, and swap in a [MockClock] in tests.
abstract interface class Clock {
  /// Returns the current time as a [TimePoint].
  TimePoint now();
}

// ---------------------------------------------------------------------------
// MockClock
// ---------------------------------------------------------------------------

/// A clock whose time is fully controlled by the caller.
///
/// Time does **not** advance automatically — it advances only when you call
/// [advance], [set], or [reset]. Use [MockClock] in unit tests to eliminate
/// timing flakiness.
///
/// ```dart
/// final clock = MockClock();
/// clock.advance(5.seconds);
/// expect(clock.now().timeSinceEpoch.inSeconds, equals(5));
/// ```
class MockClock implements Clock {
  Duration _current;

  /// Creates a [MockClock] starting at [initial] (default: [Duration.zero]).
  MockClock([Duration initial = Duration.zero]) : _current = initial;

  @override
  TimePoint now() => TimePoint(_current);

  /// Advances the clock forward by [delta].
  ///
  /// Throws [ArgumentError] if [delta] is negative (time must not go
  /// backwards; use [set] for absolute repositioning).
  void advance(Duration delta) {
    if (delta.isNegative) {
      throw ArgumentError.value(
        delta,
        'delta',
        'must be non-negative; use set() for absolute time repositioning',
      );
    }
    _current += delta;
  }

  /// Sets the clock to an absolute elapsed [time] from its epoch.
  void set(Duration time) {
    _current = time;
  }

  /// Resets the clock to [Duration.zero].
  void reset() => _current = Duration.zero;
}

// ---------------------------------------------------------------------------
// HiResClock
// ---------------------------------------------------------------------------

/// The highest-resolution monotonic clock available on the platform.
///
/// On native Dart this provides microsecond-level elapsed time via an
/// internal [Stopwatch]. On Web platforms, precision may be limited by the
/// browser's timer resolution.
///
/// Analogous to `std::chrono::high_resolution_clock` in C++.
///
/// Like [SteadyClock], the epoch is the program start time, not the Unix
/// epoch. Do **not** use this to compare with wall-clock times.
class HiResClock {
  HiResClock._();

  static final Stopwatch _sw = Stopwatch()..start();

  /// Returns a [TimePoint] representing the current high-resolution elapsed
  /// time since program start.
  static TimePoint now() => TimePoint(_sw.elapsed);
}

// ---------------------------------------------------------------------------
// UtcClock
// ---------------------------------------------------------------------------

/// The system wall-clock expressed in UTC.
///
/// Identical to [SystemClock] except the returned [TimePoint] is always
/// anchored to UTC microseconds since the Unix epoch, with no local-timezone
/// influence.
///
/// Analogous to `std::chrono::utc_clock` in C++20.
class UtcClock implements Clock {
  /// Creates a const [UtcClock] instance.
  ///
  /// The clock carries no mutable state, so a single `const UtcClock()` can
  /// be shared freely across the entire program.
  const UtcClock();

  /// Returns a [TimePoint] whose [TimePoint.timeSinceEpoch] is the number of
  /// microseconds elapsed since the Unix epoch (1970-01-01T00:00:00Z) in UTC.
  ///
  /// The result is unaffected by the local time zone of the host machine.
  @override
  TimePoint now() => TimePoint(
    Duration(microseconds: DateTime.now().toUtc().microsecondsSinceEpoch),
  );
}

// ---------------------------------------------------------------------------
// TaiClock
// ---------------------------------------------------------------------------

/// International Atomic Time (TAI) clock.
///
/// TAI is a continuous atomic time scale that does **not** insert leap seconds.
/// As of the 2017 IERS bulletin, TAI is exactly **37 seconds ahead of UTC**.
/// This constant offset is baked in; update [taiUtcOffsetSeconds] if a new
/// leap second is announced.
///
/// Analogous to `std::chrono::tai_clock` in C++20.
class TaiClock {
  TaiClock._();

  /// Current TAI–UTC offset in whole seconds (37 as of January 2017).
  ///
  /// This value must be updated manually whenever the IERS announces a new
  /// leap second insertion.
  static const int taiUtcOffsetSeconds = 37;

  /// Returns a [TimePoint] representing the current TAI time.
  static TimePoint now() {
    final utcMicros = DateTime.now().toUtc().microsecondsSinceEpoch;
    return TimePoint(
      Duration(microseconds: utcMicros + taiUtcOffsetSeconds * 1000000),
    );
  }
}

// ---------------------------------------------------------------------------
// GpsClock
// ---------------------------------------------------------------------------

/// GPS time clock, measured from the GPS epoch (1980-01-06 00:00:00 UTC).
///
/// GPS time is a continuous atomic time scale aligned with TAI but offset by
/// a fixed 19 seconds (GPS = TAI − 19 s). Because GPS does not insert leap
/// seconds, it diverges from UTC by the cumulative leap-second count.
///
/// Analogous to `std::chrono::gps_clock` in C++20.
class GpsClock {
  GpsClock._();

  /// The GPS epoch in UTC: midnight on 6 January 1980.
  static final DateTime _gpsEpochUtc = DateTime.utc(1980, 1, 6);

  /// Fixed GPS–TAI offset in seconds (GPS = TAI − 19 s).
  static const int gpsTaiOffsetSeconds = 19;

  /// Returns a [TimePoint] whose [TimePoint.timeSinceEpoch] is the number of
  /// (non-leap) seconds elapsed since the GPS epoch.
  static TimePoint now() {
    final utcMicros = DateTime.now().toUtc().microsecondsSinceEpoch;
    // GPS ahead of UTC by (TAI offset − GPS–TAI gap) = 37 − 19 = 18 s.
    final gpsMicros =
        utcMicros -
        _gpsEpochUtc.microsecondsSinceEpoch +
        (TaiClock.taiUtcOffsetSeconds - gpsTaiOffsetSeconds) * 1000000;
    return TimePoint(Duration(microseconds: gpsMicros));
  }
}
