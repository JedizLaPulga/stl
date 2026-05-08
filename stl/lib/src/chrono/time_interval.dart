/// TimeInterval — a half-open range [start, end) of [TimePoint]s.
///
/// Useful for scheduling, event windowing, overlap detection, and any scenario
/// that requires reasoning about spans of time rather than individual instants.
///
/// Analogous to common interval types used alongside C++ `<chrono>`.
library;

import 'package:stl/src/chrono/chrono.dart';

/// A contiguous range of time represented as a half-open interval [start, end).
///
/// The interval includes [start] but excludes [end], matching the same
/// convention used by C++ ranges, Python `range`, and ISO 8601 duration spans.
///
/// An interval where `start == end` is considered **empty**.
class TimeInterval {
  /// The inclusive start of the interval.
  final TimePoint start;

  /// The exclusive end of the interval.
  final TimePoint end;

  /// Creates a [TimeInterval] from [start] to [end].
  ///
  /// Throws [ArgumentError] if [end] is before [start].
  TimeInterval(this.start, this.end) {
    if (end < start) {
      throw ArgumentError('end must be >= start, got $start .. $end');
    }
  }

  /// Creates a [TimeInterval] starting at [start] with the given [duration].
  ///
  /// Equivalent to `TimeInterval(start, start + duration)`.
  factory TimeInterval.fromDuration(TimePoint start, Duration duration) =>
      TimeInterval(start, start + duration);

  // ---- Properties ----------------------------------------------------------

  /// The length of the interval.
  Duration get duration => end - start;

  /// Returns `true` if [start] == [end] (zero-length interval).
  bool get isEmpty => start == end;

  /// Returns `true` if the interval has non-zero length.
  bool get isNotEmpty => !isEmpty;

  // ---- Membership ----------------------------------------------------------

  /// Returns `true` if [t] is inside the half-open interval [start, end).
  ///
  /// The start point is included; the end point is excluded.
  bool contains(TimePoint t) => t >= start && t < end;

  /// Returns `true` if [t] is inside the closed interval [start, end].
  ///
  /// Both endpoints are included.
  bool containsClosed(TimePoint t) => t >= start && t <= end;

  // ---- Set operations ------------------------------------------------------

  /// Returns `true` if this interval shares any time with [other].
  ///
  /// Two half-open intervals overlap when neither ends before the other starts.
  bool overlaps(TimeInterval other) => start < other.end && other.start < end;

  /// Returns the intersection of this interval and [other], or `null` if they
  /// do not overlap.
  TimeInterval? intersection(TimeInterval other) {
    if (!overlaps(other)) return null;
    final s = start > other.start ? start : other.start;
    final e = end < other.end ? end : other.end;
    return TimeInterval(s, e);
  }

  /// Returns the smallest interval that covers both this interval and [other]
  /// (the convex hull).
  TimeInterval hull(TimeInterval other) {
    final s = start < other.start ? start : other.start;
    final e = end > other.end ? end : other.end;
    return TimeInterval(s, e);
  }

  /// Returns the gap between this interval and [other], or `null` if they
  /// touch or overlap.
  ///
  /// The gap is itself a [TimeInterval] spanning the space between the two
  /// non-overlapping intervals.
  TimeInterval? gap(TimeInterval other) {
    // Determine which interval comes first.
    final (first, second) = end <= other.start ? (this, other) : (other, this);
    if (first.end >= second.start) return null; // touching or overlapping
    return TimeInterval(first.end, second.start);
  }

  // ---- Comparison ----------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      other is TimeInterval && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'TimeInterval[$start, $end)';
}
