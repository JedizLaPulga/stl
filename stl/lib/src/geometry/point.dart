library;

import 'dart:math' as math;
import '../math/cmath.dart';

/// Represents a 2D coordinate in Euclidean space.
class Point<T extends num> {
  /// The x-coordinate.
  final T x;

  /// The y-coordinate.
  final T y;

  /// Creates a [Point] at the given [x] and [y] coordinates.
  const Point({required this.x, required this.y});

  /// Computes the exact Euclidean distance to another [Point].
  double distanceTo(Point<num> other) {
    return hypot(x - other.x, y - other.y);
  }

  /// The magnitude (length) of the vector from the origin (0,0).
  double get magnitude => hypot(x, y);

  /// Returns a unit vector (magnitude = 1) in the same direction.
  ///
  /// Throws [StateError] if the vector has zero magnitude.
  Point<double> normalize() {
    final m = magnitude;
    if (m == 0) throw StateError('Cannot normalize a zero-length vector.');
    return Point(x: x / m, y: y / m);
  }

  /// Computes the 2D scalar cross product with [other]: $x_1 y_2 - y_1 x_2$.
  ///
  /// Positive values indicate [other] is counter-clockwise from this vector.
  double cross(Point<num> other) => (x * other.y - y * other.x).toDouble();

  /// Returns the angle (in radians) from this point to [other], measured
  /// counter-clockwise from the positive x-axis.
  double angleTo(Point<num> other) =>
      math.atan2((other.y - y).toDouble(), (other.x - x).toDouble());

  /// Returns the midpoint between this point and [other].
  Point<double> midpointTo(Point<num> other) =>
      Point(x: (x + other.x) / 2.0, y: (y + other.y) / 2.0);

  /// Linearly interpolates between this point and [other] by [t] ∈ [0, 1].
  ///
  /// At `t = 0` returns this point; at `t = 1` returns [other].
  Point<double> lerp(Point<num> other, double t) =>
      Point(x: x + (other.x - x) * t, y: y + (other.y - y) * t);

  /// Adds another point (vector addition).
  Point<num> operator +(Point<num> other) =>
      Point(x: x + other.x, y: y + other.y);

  /// Subtracts another point (vector subtraction).
  Point<num> operator -(Point<num> other) =>
      Point(x: x - other.x, y: y - other.y);

  /// Multiplies the point by a scalar value.
  Point<num> operator *(num scalar) => Point(x: x * scalar, y: y * scalar);

  /// Divides the point by a scalar value.
  ///
  /// Throws [ArgumentError] if [scalar] is zero.
  Point<double> operator /(num scalar) {
    if (scalar == 0) throw ArgumentError('Cannot divide by zero.');
    return Point(x: x / scalar, y: y / scalar);
  }

  /// Computes the dot product with another point.
  num dotProduct(Point<num> other) => (x * other.x) + (y * other.y);

  @override
  String toString() => 'Point($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
