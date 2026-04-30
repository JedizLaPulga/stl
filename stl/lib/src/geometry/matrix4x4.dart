library;

import 'dart:math' as math;
import 'point3d.dart';

/// A 4×4 homogeneous transformation matrix stored in row-major order.
///
/// The matrix is laid out as:
///
/// | m00 m01 m02 m03 |
/// | m10 m11 m12 m13 |
/// | m20 m21 m22 m23 |
/// | m30 m31 m32 m33 |
class Matrix4x4 {
  // Row 0
  /// Entry at (0, 0).
  final double m00;

  /// Entry at (0, 1).
  final double m01;

  /// Entry at (0, 2).
  final double m02;

  /// Entry at (0, 3).
  final double m03;
  // Row 1
  /// Entry at (1, 0).
  final double m10;

  /// Entry at (1, 1).
  final double m11;

  /// Entry at (1, 2).
  final double m12;

  /// Entry at (1, 3).
  final double m13;
  // Row 2
  /// Entry at (2, 0).
  final double m20;

  /// Entry at (2, 1).
  final double m21;

  /// Entry at (2, 2).
  final double m22;

  /// Entry at (2, 3).
  final double m23;
  // Row 3
  /// Entry at (3, 0).
  final double m30;

  /// Entry at (3, 1).
  final double m31;

  /// Entry at (3, 2).
  final double m32;

  /// Entry at (3, 3).
  final double m33;

  /// Creates a [Matrix4x4] with the given row-major entries.
  const Matrix4x4({
    required this.m00,
    required this.m01,
    required this.m02,
    required this.m03,
    required this.m10,
    required this.m11,
    required this.m12,
    required this.m13,
    required this.m20,
    required this.m21,
    required this.m22,
    required this.m23,
    required this.m30,
    required this.m31,
    required this.m32,
    required this.m33,
  });

  /// The 4×4 identity matrix.
  factory Matrix4x4.identity() => const Matrix4x4(
    m00: 1,
    m01: 0,
    m02: 0,
    m03: 0,
    m10: 0,
    m11: 1,
    m12: 0,
    m13: 0,
    m20: 0,
    m21: 0,
    m22: 1,
    m23: 0,
    m30: 0,
    m31: 0,
    m32: 0,
    m33: 1,
  );

  /// A translation matrix that moves by ([tx], [ty], [tz]).
  factory Matrix4x4.translation(double tx, double ty, double tz) => Matrix4x4(
    m00: 1,
    m01: 0,
    m02: 0,
    m03: tx,
    m10: 0,
    m11: 1,
    m12: 0,
    m13: ty,
    m20: 0,
    m21: 0,
    m22: 1,
    m23: tz,
    m30: 0,
    m31: 0,
    m32: 0,
    m33: 1,
  );

  /// A non-uniform scaling matrix by ([sx], [sy], [sz]).
  factory Matrix4x4.scaling(double sx, double sy, double sz) => Matrix4x4(
    m00: sx,
    m01: 0,
    m02: 0,
    m03: 0,
    m10: 0,
    m11: sy,
    m12: 0,
    m13: 0,
    m20: 0,
    m21: 0,
    m22: sz,
    m23: 0,
    m30: 0,
    m31: 0,
    m32: 0,
    m33: 1,
  );

  /// Counter-clockwise rotation around the X-axis by [angle] radians.
  factory Matrix4x4.rotationX(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix4x4(
      m00: 1,
      m01: 0,
      m02: 0,
      m03: 0,
      m10: 0,
      m11: c,
      m12: -s,
      m13: 0,
      m20: 0,
      m21: s,
      m22: c,
      m23: 0,
      m30: 0,
      m31: 0,
      m32: 0,
      m33: 1,
    );
  }

  /// Counter-clockwise rotation around the Y-axis by [angle] radians.
  factory Matrix4x4.rotationY(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix4x4(
      m00: c,
      m01: 0,
      m02: s,
      m03: 0,
      m10: 0,
      m11: 1,
      m12: 0,
      m13: 0,
      m20: -s,
      m21: 0,
      m22: c,
      m23: 0,
      m30: 0,
      m31: 0,
      m32: 0,
      m33: 1,
    );
  }

  /// Counter-clockwise rotation around the Z-axis by [angle] radians.
  factory Matrix4x4.rotationZ(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix4x4(
      m00: c,
      m01: -s,
      m02: 0,
      m03: 0,
      m10: s,
      m11: c,
      m12: 0,
      m13: 0,
      m20: 0,
      m21: 0,
      m22: 1,
      m23: 0,
      m30: 0,
      m31: 0,
      m32: 0,
      m33: 1,
    );
  }

  /// A perspective projection matrix.
  ///
  /// [fovY] is the vertical field of view in radians, [aspect] is width/height,
  /// [near] and [far] are the near and far clipping plane distances.
  factory Matrix4x4.perspective(
    double fovY,
    double aspect,
    double near,
    double far,
  ) {
    final f = 1.0 / math.tan(fovY / 2.0);
    final nf = 1.0 / (near - far);
    return Matrix4x4(
      m00: f / aspect,
      m01: 0,
      m02: 0,
      m03: 0,
      m10: 0,
      m11: f,
      m12: 0,
      m13: 0,
      m20: 0,
      m21: 0,
      m22: (far + near) * nf,
      m23: 2 * far * near * nf,
      m30: 0,
      m31: 0,
      m32: -1,
      m33: 0,
    );
  }

  /// Matrix–matrix multiplication.
  Matrix4x4 operator *(Matrix4x4 o) => Matrix4x4(
    m00: m00 * o.m00 + m01 * o.m10 + m02 * o.m20 + m03 * o.m30,
    m01: m00 * o.m01 + m01 * o.m11 + m02 * o.m21 + m03 * o.m31,
    m02: m00 * o.m02 + m01 * o.m12 + m02 * o.m22 + m03 * o.m32,
    m03: m00 * o.m03 + m01 * o.m13 + m02 * o.m23 + m03 * o.m33,

    m10: m10 * o.m00 + m11 * o.m10 + m12 * o.m20 + m13 * o.m30,
    m11: m10 * o.m01 + m11 * o.m11 + m12 * o.m21 + m13 * o.m31,
    m12: m10 * o.m02 + m11 * o.m12 + m12 * o.m22 + m13 * o.m32,
    m13: m10 * o.m03 + m11 * o.m13 + m12 * o.m23 + m13 * o.m33,

    m20: m20 * o.m00 + m21 * o.m10 + m22 * o.m20 + m23 * o.m30,
    m21: m20 * o.m01 + m21 * o.m11 + m22 * o.m21 + m23 * o.m31,
    m22: m20 * o.m02 + m21 * o.m12 + m22 * o.m22 + m23 * o.m32,
    m23: m20 * o.m03 + m21 * o.m13 + m22 * o.m23 + m23 * o.m33,

    m30: m30 * o.m00 + m31 * o.m10 + m32 * o.m20 + m33 * o.m30,
    m31: m30 * o.m01 + m31 * o.m11 + m32 * o.m21 + m33 * o.m31,
    m32: m30 * o.m02 + m31 * o.m12 + m32 * o.m22 + m33 * o.m32,
    m33: m30 * o.m03 + m31 * o.m13 + m32 * o.m23 + m33 * o.m33,
  );

  /// Transforms [point] by this matrix, treating the point as a homogeneous
  /// vector $(x, y, z, 1)$ and performing perspective division.
  ///
  /// Returns the resulting [Point3D] after the transform.
  Point3D transform(Point3D point) {
    final x = m00 * point.x + m01 * point.y + m02 * point.z + m03;
    final y = m10 * point.x + m11 * point.y + m12 * point.z + m13;
    final z = m20 * point.x + m21 * point.y + m22 * point.z + m23;
    final w = m30 * point.x + m31 * point.y + m32 * point.z + m33;
    if (w == 0) {
      throw StateError(
        'Homogeneous w component is zero; cannot perform perspective division.',
      );
    }
    return Point3D(x: x / w, y: y / w, z: z / w);
  }

  /// The transpose of this matrix.
  Matrix4x4 get transpose => Matrix4x4(
    m00: m00,
    m01: m10,
    m02: m20,
    m03: m30,
    m10: m01,
    m11: m11,
    m12: m21,
    m13: m31,
    m20: m02,
    m21: m12,
    m22: m22,
    m23: m32,
    m30: m03,
    m31: m13,
    m32: m23,
    m33: m33,
  );

  @override
  String toString() =>
      'Matrix4x4('
      '[[$m00, $m01, $m02, $m03], '
      '[$m10, $m11, $m12, $m13], '
      '[$m20, $m21, $m22, $m23], '
      '[$m30, $m31, $m32, $m33]])';
}
