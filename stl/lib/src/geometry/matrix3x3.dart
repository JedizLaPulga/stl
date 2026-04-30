library;

import 'dart:math' as math;

/// A 3×3 matrix with entries stored in row-major order.
///
/// Row indices 0–2, column indices 0–2.
class Matrix3x3 {
  // Row 0
  /// Entry at (0, 0).
  final double m00;

  /// Entry at (0, 1).
  final double m01;

  /// Entry at (0, 2).
  final double m02;
  // Row 1
  /// Entry at (1, 0).
  final double m10;

  /// Entry at (1, 1).
  final double m11;

  /// Entry at (1, 2).
  final double m12;
  // Row 2
  /// Entry at (2, 0).
  final double m20;

  /// Entry at (2, 1).
  final double m21;

  /// Entry at (2, 2).
  final double m22;

  /// Creates a [Matrix3x3] with the given row-major entries.
  const Matrix3x3({
    required this.m00,
    required this.m01,
    required this.m02,
    required this.m10,
    required this.m11,
    required this.m12,
    required this.m20,
    required this.m21,
    required this.m22,
  });

  /// The 3×3 identity matrix.
  factory Matrix3x3.identity() => const Matrix3x3(
    m00: 1,
    m01: 0,
    m02: 0,
    m10: 0,
    m11: 1,
    m12: 0,
    m20: 0,
    m21: 0,
    m22: 1,
  );

  /// Counter-clockwise rotation around the X-axis by [angle] radians.
  factory Matrix3x3.rotationX(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix3x3(
      m00: 1,
      m01: 0,
      m02: 0,
      m10: 0,
      m11: c,
      m12: -s,
      m20: 0,
      m21: s,
      m22: c,
    );
  }

  /// Counter-clockwise rotation around the Y-axis by [angle] radians.
  factory Matrix3x3.rotationY(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix3x3(
      m00: c,
      m01: 0,
      m02: s,
      m10: 0,
      m11: 1,
      m12: 0,
      m20: -s,
      m21: 0,
      m22: c,
    );
  }

  /// Counter-clockwise rotation around the Z-axis by [angle] radians.
  factory Matrix3x3.rotationZ(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Matrix3x3(
      m00: c,
      m01: -s,
      m02: 0,
      m10: s,
      m11: c,
      m12: 0,
      m20: 0,
      m21: 0,
      m22: 1,
    );
  }

  /// The determinant via cofactor expansion along the first row.
  double get determinant =>
      m00 * (m11 * m22 - m12 * m21) -
      m01 * (m10 * m22 - m12 * m20) +
      m02 * (m10 * m21 - m11 * m20);

  /// The transpose of this matrix.
  Matrix3x3 get transpose => Matrix3x3(
    m00: m00,
    m01: m10,
    m02: m20,
    m10: m01,
    m11: m11,
    m12: m21,
    m20: m02,
    m21: m12,
    m22: m22,
  );

  /// The inverse of this matrix.
  ///
  /// Throws [StateError] if the matrix is singular.
  Matrix3x3 get inverse {
    final det = determinant;
    if (det.abs() < 1e-12) {
      throw StateError('Matrix3x3 is singular (determinant ≈ 0).');
    }
    final inv = 1.0 / det;
    return Matrix3x3(
      m00: (m11 * m22 - m12 * m21) * inv,
      m01: (m02 * m21 - m01 * m22) * inv,
      m02: (m01 * m12 - m02 * m11) * inv,
      m10: (m12 * m20 - m10 * m22) * inv,
      m11: (m00 * m22 - m02 * m20) * inv,
      m12: (m02 * m10 - m00 * m12) * inv,
      m20: (m10 * m21 - m11 * m20) * inv,
      m21: (m01 * m20 - m00 * m21) * inv,
      m22: (m00 * m11 - m01 * m10) * inv,
    );
  }

  /// Matrix–matrix multiplication.
  Matrix3x3 operator *(Matrix3x3 o) => Matrix3x3(
    m00: m00 * o.m00 + m01 * o.m10 + m02 * o.m20,
    m01: m00 * o.m01 + m01 * o.m11 + m02 * o.m21,
    m02: m00 * o.m02 + m01 * o.m12 + m02 * o.m22,
    m10: m10 * o.m00 + m11 * o.m10 + m12 * o.m20,
    m11: m10 * o.m01 + m11 * o.m11 + m12 * o.m21,
    m12: m10 * o.m02 + m11 * o.m12 + m12 * o.m22,
    m20: m20 * o.m00 + m21 * o.m10 + m22 * o.m20,
    m21: m20 * o.m01 + m21 * o.m11 + m22 * o.m21,
    m22: m20 * o.m02 + m21 * o.m12 + m22 * o.m22,
  );

  /// Matrix addition.
  Matrix3x3 operator +(Matrix3x3 o) => Matrix3x3(
    m00: m00 + o.m00,
    m01: m01 + o.m01,
    m02: m02 + o.m02,
    m10: m10 + o.m10,
    m11: m11 + o.m11,
    m12: m12 + o.m12,
    m20: m20 + o.m20,
    m21: m21 + o.m21,
    m22: m22 + o.m22,
  );

  /// Scalar multiplication (all entries multiplied by [scalar]).
  Matrix3x3 scaled(double scalar) => Matrix3x3(
    m00: m00 * scalar,
    m01: m01 * scalar,
    m02: m02 * scalar,
    m10: m10 * scalar,
    m11: m11 * scalar,
    m12: m12 * scalar,
    m20: m20 * scalar,
    m21: m21 * scalar,
    m22: m22 * scalar,
  );

  @override
  String toString() =>
      'Matrix3x3([[$m00, $m01, $m02], [$m10, $m11, $m12], [$m20, $m21, $m22]])';
}
