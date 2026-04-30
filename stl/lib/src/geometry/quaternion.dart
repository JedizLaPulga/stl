library;

import 'dart:math' as math;
import 'point3d.dart';
import 'matrix3x3.dart';

/// A unit quaternion for representing 3D rotations.
///
/// Stored as $(w, x, y, z)$ where $w$ is the scalar part and $(x, y, z)$
/// is the vector part.
class Quaternion {
  /// The scalar (real) component.
  final double w;

  /// The x-component of the vector part.
  final double x;

  /// The y-component of the vector part.
  final double y;

  /// The z-component of the vector part.
  final double z;

  /// Creates a [Quaternion] with components $(w, x, y, z)$.
  Quaternion({required num w, required num x, required num y, required num z})
    : w = w.toDouble(),
      x = x.toDouble(),
      y = y.toDouble(),
      z = z.toDouble();

  /// The identity quaternion (no rotation): $(1, 0, 0, 0)$.
  factory Quaternion.identity() => Quaternion(w: 1, x: 0, y: 0, z: 0);

  /// Creates a unit quaternion representing a rotation of [angle] radians
  /// around the unit [axis] vector.
  ///
  /// The [axis] is automatically normalised.
  factory Quaternion.fromAxisAngle(Point3D axis, double angle) {
    final unitAxis = axis.normalize();
    final half = angle / 2.0;
    final s = math.sin(half);
    return Quaternion(
      w: math.cos(half),
      x: unitAxis.x * s,
      y: unitAxis.y * s,
      z: unitAxis.z * s,
    ).normalize();
  }

  /// The Euclidean norm (magnitude) of this quaternion.
  double get magnitude => math.sqrt(w * w + x * x + y * y + z * z);

  /// Returns the unit quaternion in the same direction.
  ///
  /// Throws [StateError] if the quaternion is zero.
  Quaternion normalize() {
    final m = magnitude;
    if (m == 0) throw StateError('Cannot normalize a zero quaternion.');
    return Quaternion(w: w / m, x: x / m, y: y / m, z: z / m);
  }

  /// The conjugate: $q^* = (w, -x, -y, -z)$.
  Quaternion get conjugate => Quaternion(w: w, x: -x, y: -y, z: -z);

  /// The inverse: $q^{-1} = q^* / |q|^2$.
  ///
  /// For unit quaternions this equals [conjugate].
  Quaternion get inverse {
    final n2 = w * w + x * x + y * y + z * z;
    if (n2 < 1e-24) throw StateError('Cannot invert a zero quaternion.');
    return Quaternion(w: w / n2, x: -x / n2, y: -y / n2, z: -z / n2);
  }

  /// The dot product with [other]: $w_1 w_2 + x_1 x_2 + y_1 y_2 + z_1 z_2$.
  double dot(Quaternion other) =>
      w * other.w + x * other.x + y * other.y + z * other.z;

  /// Hamilton (quaternion) multiplication.
  Quaternion operator *(Quaternion other) => Quaternion(
    w: w * other.w - x * other.x - y * other.y - z * other.z,
    x: w * other.x + x * other.w + y * other.z - z * other.y,
    y: w * other.y - x * other.z + y * other.w + z * other.x,
    z: w * other.z + x * other.y - y * other.x + z * other.w,
  );

  /// Rotates [point] by this (unit) quaternion using the sandwich product
  /// $q \, p \, q^*$ where $p = (0, x, y, z)$.
  Point3D rotate(Point3D point) {
    final q = normalize();
    final p = Quaternion(w: 0, x: point.x, y: point.y, z: point.z);
    final result = q * p * q.conjugate;
    return Point3D(x: result.x, y: result.y, z: result.z);
  }

  /// Spherical linear interpolation (SLERP) from this quaternion to [other]
  /// by factor [t] ∈ [0, 1].
  Quaternion slerp(Quaternion other, double t) {
    var cosHalf = dot(other);

    // Ensure shortest-path interpolation.
    Quaternion end = other;
    if (cosHalf < 0) {
      cosHalf = -cosHalf;
      end = Quaternion(w: -other.w, x: -other.x, y: -other.y, z: -other.z);
    }

    if (cosHalf > 0.9995) {
      // Fallback to linear interpolation for nearly identical quaternions.
      return Quaternion(
        w: w + t * (end.w - w),
        x: x + t * (end.x - x),
        y: y + t * (end.y - y),
        z: z + t * (end.z - z),
      ).normalize();
    }

    final halfAngle = math.acos(cosHalf);
    final sinHalf = math.sin(halfAngle);
    final wa = math.sin((1 - t) * halfAngle) / sinHalf;
    final wb = math.sin(t * halfAngle) / sinHalf;

    return Quaternion(
      w: wa * w + wb * end.w,
      x: wa * x + wb * end.x,
      y: wa * y + wb * end.y,
      z: wa * z + wb * end.z,
    );
  }

  /// Converts this unit quaternion to a 3×3 rotation matrix.
  Matrix3x3 toMatrix3x3() {
    final q = normalize();
    final qw = q.w, qx = q.x, qy = q.y, qz = q.z;
    return Matrix3x3(
      m00: 1 - 2 * (qy * qy + qz * qz),
      m01: 2 * (qx * qy - qz * qw),
      m02: 2 * (qx * qz + qy * qw),
      m10: 2 * (qx * qy + qz * qw),
      m11: 1 - 2 * (qx * qx + qz * qz),
      m12: 2 * (qy * qz - qx * qw),
      m20: 2 * (qx * qz - qy * qw),
      m21: 2 * (qy * qz + qx * qw),
      m22: 1 - 2 * (qx * qx + qy * qy),
    );
  }

  /// Converts this unit quaternion to Euler angles (roll, pitch, yaw) in radians.
  ///
  /// Returns a [Point3D] where `x` = roll, `y` = pitch, `z` = yaw.
  Point3D toEulerAngles() {
    final q = normalize();
    // Roll (x-axis rotation)
    final sinrCosp = 2 * (q.w * q.x + q.y * q.z);
    final cosrCosp = 1 - 2 * (q.x * q.x + q.y * q.y);
    final roll = math.atan2(sinrCosp, cosrCosp);

    // Pitch (y-axis rotation)
    final sinp = 2 * (q.w * q.y - q.z * q.x);
    final pitch = sinp.abs() >= 1 ? (sinp.sign * math.pi / 2) : math.asin(sinp);

    // Yaw (z-axis rotation)
    final sinyCosp = 2 * (q.w * q.z + q.x * q.y);
    final cosyCosp = 1 - 2 * (q.y * q.y + q.z * q.z);
    final yaw = math.atan2(sinyCosp, cosyCosp);

    return Point3D(x: roll, y: pitch, z: yaw);
  }

  @override
  String toString() => 'Quaternion(w: $w, x: $x, y: $y, z: $z)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quaternion &&
          w == other.w &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => Object.hash(w, x, y, z);
}
