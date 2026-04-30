library;

import 'dart:math' as math;

/// A point (or vector) in 3D Euclidean space.
class Point3D {
  /// The x-coordinate.
  final double x;

  /// The y-coordinate.
  final double y;

  /// The z-coordinate.
  final double z;

  /// Creates a [Point3D] at the given coordinates.
  Point3D({required num x, required num y, required num z})
    : x = x.toDouble(),
      y = y.toDouble(),
      z = z.toDouble();

  /// Creates a [Point3D] at the given coordinates, accepting any [num].
  factory Point3D.of(num x, num y, num z) =>
      Point3D(x: x.toDouble(), y: y.toDouble(), z: z.toDouble());

  /// The Euclidean length (magnitude) of this vector.
  double get magnitude => math.sqrt(x * x + y * y + z * z);

  /// Returns a unit vector in the same direction.
  ///
  /// Throws [StateError] if this is the zero vector.
  Point3D normalize() {
    final m = magnitude;
    if (m == 0) throw StateError('Cannot normalize a zero-length vector.');
    return Point3D(x: x / m, y: y / m, z: z / m);
  }

  /// The Euclidean distance to [other].
  double distanceTo(Point3D other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  /// The dot product with [other]: $x_1 x_2 + y_1 y_2 + z_1 z_2$.
  double dot(Point3D other) => x * other.x + y * other.y + z * other.z;

  /// The cross product with [other], producing a vector perpendicular to both.
  ///
  /// $\vec{a} \times \vec{b} = (a_y b_z - a_z b_y,\; a_z b_x - a_x b_z,\; a_x b_y - a_y b_x)$
  Point3D cross(Point3D other) => Point3D(
    x: y * other.z - z * other.y,
    y: z * other.x - x * other.z,
    z: x * other.y - y * other.x,
  );

  /// Linearly interpolates towards [other] by [t] ∈ [0, 1].
  Point3D lerp(Point3D other, double t) => Point3D(
    x: x + (other.x - x) * t,
    y: y + (other.y - y) * t,
    z: z + (other.z - z) * t,
  );

  /// Returns the midpoint between this point and [other].
  Point3D midpointTo(Point3D other) =>
      Point3D(x: (x + other.x) / 2, y: (y + other.y) / 2, z: (z + other.z) / 2);

  /// The angle in radians between this vector and [other].
  double angleTo(Point3D other) {
    final denom = magnitude * other.magnitude;
    if (denom == 0) return 0;
    return math.acos((dot(other) / denom).clamp(-1.0, 1.0));
  }

  /// Vector addition.
  Point3D operator +(Point3D other) =>
      Point3D(x: x + other.x, y: y + other.y, z: z + other.z);

  /// Vector subtraction.
  Point3D operator -(Point3D other) =>
      Point3D(x: x - other.x, y: y - other.y, z: z - other.z);

  /// Scalar multiplication.
  Point3D operator *(double scalar) =>
      Point3D(x: x * scalar, y: y * scalar, z: z * scalar);

  /// Scalar division.
  ///
  /// Throws [ArgumentError] if [scalar] is zero.
  Point3D operator /(double scalar) {
    if (scalar == 0) throw ArgumentError('Cannot divide by zero.');
    return Point3D(x: x / scalar, y: y / scalar, z: z / scalar);
  }

  /// Negation.
  Point3D operator -() => Point3D(x: -x, y: -y, z: -z);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point3D &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;

  @override
  String toString() => 'Point3D($x, $y, $z)';
}
