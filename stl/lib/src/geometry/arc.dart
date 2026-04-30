library;

import 'dart:math' as math;
import 'point.dart';

/// A circular arc defined by a [center], [radius], [startAngle], and [endAngle].
///
/// All angles are in radians, measured counter-clockwise from the positive
/// x-axis (standard mathematical convention).
class Arc {
  /// The center of the circle on which this arc lies.
  final Point<double> center;

  /// The radius of the arc.
  final double radius;

  /// The starting angle in radians.
  final double startAngle;

  /// The ending angle in radians.
  final double endAngle;

  /// Creates an [Arc] with the given parameters.
  ///
  /// Throws [ArgumentError] if [radius] is negative.
  Arc({
    required Point<num> center,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
  }) : center = Point(x: center.x.toDouble(), y: center.y.toDouble()) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative.');
  }

  /// The angular span of the arc in radians.
  ///
  /// Always positive; wraps around if [endAngle] < [startAngle].
  double get spanAngle {
    final span = endAngle - startAngle;
    return span < 0 ? span + 2 * math.pi : span;
  }

  /// The arc length: $r \cdot \theta$ where $\theta$ is [spanAngle].
  double get arcLength => radius * spanAngle;

  /// The chord length — the straight-line distance between the two endpoints:
  /// $2r \sin(\theta / 2)$.
  double get chordLength => 2 * radius * math.sin(spanAngle / 2);

  /// The point on the arc at [startAngle].
  Point<double> get startPoint => Point(
    x: center.x + radius * math.cos(startAngle),
    y: center.y + radius * math.sin(startAngle),
  );

  /// The point on the arc at [endAngle].
  Point<double> get endPoint => Point(
    x: center.x + radius * math.cos(endAngle),
    y: center.y + radius * math.sin(endAngle),
  );

  /// Returns the point on the arc at the given [angle] in radians.
  Point<double> pointAt(double angle) => Point(
    x: center.x + radius * math.cos(angle),
    y: center.y + radius * math.sin(angle),
  );

  /// Whether the given [angle] (in radians) falls within the arc span.
  bool containsAngle(double angle) {
    final start = startAngle % (2 * math.pi);
    final end = endAngle % (2 * math.pi);
    final a = angle % (2 * math.pi);
    if (start <= end) return a >= start && a <= end;
    return a >= start || a <= end;
  }

  @override
  String toString() =>
      'Arc(center: $center, radius: $radius, start: $startAngle, end: $endAngle)';
}
