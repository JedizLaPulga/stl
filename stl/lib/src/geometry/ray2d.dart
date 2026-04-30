library;

import 'dart:math' as math;
import 'point.dart';
import 'line_segment.dart';
import 'circle.dart';

/// A semi-infinite ray in 2D space defined by an [origin] and a [direction].
///
/// The direction vector does not need to be normalised — it is normalised
/// automatically upon construction.
class Ray2D {
  /// The starting point of the ray.
  final Point<double> origin;

  /// The unit direction vector of the ray.
  final Point<double> direction;

  /// Creates a [Ray2D] from the given [origin] and [direction].
  ///
  /// Throws [ArgumentError] if [direction] is the zero vector.
  Ray2D({required Point<num> origin, required Point<num> direction})
    : origin = Point(x: origin.x.toDouble(), y: origin.y.toDouble()),
      direction = _normalise(direction);

  static Point<double> _normalise(Point<num> d) {
    final m = d.magnitude;
    if (m == 0) {
      throw ArgumentError('Ray direction must not be the zero vector.');
    }
    return Point(x: d.x / m, y: d.y / m);
  }

  /// Returns the point along the ray at parameter [t]: $\text{origin} + t \cdot \text{direction}$.
  ///
  /// Negative [t] travels behind the ray's origin.
  Point<double> at(double t) =>
      Point(x: origin.x + direction.x * t, y: origin.y + direction.y * t);

  /// Intersects this ray with a [LineSegment].
  ///
  /// Returns the parameter [t] ≥ 0 at which the intersection occurs, or
  /// `null` if the ray and segment are parallel or do not intersect within
  /// the segment's extent.
  double? intersectSegment(LineSegment segment) {
    final dx = direction.x;
    final dy = direction.y;
    final ex = segment.p2.x - segment.p1.x;
    final ey = segment.p2.y - segment.p1.y;

    final denom = dx * ey - dy * ex;
    if (denom.abs() < 1e-12) return null; // Parallel.

    final fx = segment.p1.x - origin.x;
    final fy = segment.p1.y - origin.y;

    final t = (fx * ey - fy * ex) / denom;
    final u = (fx * dy - fy * dx) / denom;

    if (t >= 0 && u >= 0 && u <= 1) return t;
    return null;
  }

  /// Intersects this ray with a [Circle].
  ///
  /// Returns the smallest non-negative parameter [t] at which the ray enters
  /// the circle, or `null` if there is no intersection.
  double? intersectCircle(Circle circle) {
    final ocx = origin.x - circle.center.x.toDouble();
    final ocy = origin.y - circle.center.y.toDouble();

    final a = direction.x * direction.x + direction.y * direction.y;
    final b = 2 * (ocx * direction.x + ocy * direction.y);
    final c = ocx * ocx + ocy * ocy - circle.radius * circle.radius;

    final discriminant = b * b - 4 * a * c;
    if (discriminant < 0) return null;

    final s = math.sqrt(discriminant);
    final t0 = (-b - s) / (2 * a);
    final t1 = (-b + s) / (2 * a);

    if (t0 >= 0) return t0;
    if (t1 >= 0) return t1;
    return null;
  }

  @override
  String toString() => 'Ray2D(origin: $origin, direction: $direction)';
}
