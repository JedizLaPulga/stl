library;

import 'dart:math' as math;
import 'point.dart';
import 'shape.dart';
import 'rectangle.dart';

/// Defines a mathematical circle strictly via a radius.
class Circle implements Shape<Circle> {
  /// The radius of the circle.
  final double radius;
  final Point<num> _center;

  /// Creates a [Circle] with the given [radius] and [center].
  Circle({required this.radius, Point<num>? center})
    : _center = center ?? const Point(x: 0, y: 0) {
    if (radius < 0) {
      throw ArgumentError('Radius cannot be negative');
    }
  }

  /// The center point of the circle in 2D space.
  Point<num> get center => _center;

  @override
  double get area => math.pi * radius * radius;

  @override
  double get perimeter => 2 * math.pi * radius; // Circumference

  @override
  Rectangle get boundingBox =>
      Rectangle(width: radius * 2, height: radius * 2, center: _center);

  @override
  Point<double> get centroid =>
      Point(x: _center.x.toDouble(), y: _center.y.toDouble());

  @override
  Circle translate(Point<num> offset) =>
      Circle(radius: radius, center: _center + offset);

  @override
  Circle scale(num factor) =>
      Circle(radius: radius * factor.abs(), center: _center);

  @override
  Circle rotate(double angle, [Point<num>? origin]) {
    final rotOrigin = origin ?? centroid;
    final ox = rotOrigin.x.toDouble();
    final oy = rotOrigin.y.toDouble();
    final cx = _center.x.toDouble();
    final cy = _center.y.toDouble();

    final cosA = math.cos(angle);
    final sinA = math.sin(angle);

    final nx = cosA * (cx - ox) - sinA * (cy - oy) + ox;
    final ny = sinA * (cx - ox) + cosA * (cy - oy) + oy;

    return Circle(
      radius: radius,
      center: Point(x: nx, y: ny),
    );
  }

  /// Whether the given [point] lies strictly inside or on the boundary of this circle.
  bool containsPoint(Point<num> point) => _center.distanceTo(point) <= radius;

  /// Whether this circle overlaps with [other] (their boundaries or interiors intersect).
  bool intersectsCircle(Circle other) =>
      _center.distanceTo(other._center) <= radius + other.radius;

  /// The length of a tangent line drawn from an external [point] to the circle.
  ///
  /// Returns 0 if the point is inside the circle.
  /// Computed as $\sqrt{d^2 - r^2}$ where $d$ is the distance from [point] to the center.
  double tangentLength(Point<num> point) {
    final d = _center.distanceTo(point);
    if (d <= radius) return 0.0;
    return math.sqrt(d * d - radius * radius);
  }

  /// The circumference of the circle. Alias for [perimeter].
  double get circumference => perimeter;

  @override
  String toString() => 'Circle(radius: $radius, center: $_center)';
}
