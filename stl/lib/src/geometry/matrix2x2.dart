library;

import 'dart:math' as math;

/// A 2×2 matrix with entries stored in row-major order.
///
/// | [a] [b] |
/// | [c] [d] |
class Matrix2x2 {
  /// Entry at row 0, column 0.
  final double a;

  /// Entry at row 0, column 1.
  final double b;

  /// Entry at row 1, column 0.
  final double c;

  /// Entry at row 1, column 1.
  final double d;

  /// Creates a [Matrix2x2] with the given entries.
  const Matrix2x2({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  /// The 2×2 identity matrix.
  factory Matrix2x2.identity() => const Matrix2x2(a: 1, b: 0, c: 0, d: 1);

  /// A counter-clockwise rotation matrix by [angle] radians.
  factory Matrix2x2.rotation(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Matrix2x2(a: cos, b: -sin, c: sin, d: cos);
  }

  /// The determinant: $ad - bc$.
  double get determinant => a * d - b * c;

  /// The transpose of this matrix (rows and columns swapped).
  Matrix2x2 get transpose => Matrix2x2(a: a, b: c, c: b, d: d);

  /// The inverse of this matrix.
  ///
  /// Throws [StateError] if the matrix is singular (determinant ≈ 0).
  Matrix2x2 get inverse {
    final det = determinant;
    if (det.abs() < 1e-12) {
      throw StateError('Matrix2x2 is singular (determinant ≈ 0).');
    }

    final inv = 1.0 / det;
    return Matrix2x2(a: d * inv, b: -b * inv, c: -c * inv, d: a * inv);
  }

  /// Matrix addition.
  Matrix2x2 operator +(Matrix2x2 other) =>
      Matrix2x2(a: a + other.a, b: b + other.b, c: c + other.c, d: d + other.d);

  /// Matrix subtraction.
  Matrix2x2 operator -(Matrix2x2 other) =>
      Matrix2x2(a: a - other.a, b: b - other.b, c: c - other.c, d: d - other.d);

  /// Matrix–matrix multiplication.
  Matrix2x2 operator *(Matrix2x2 other) => Matrix2x2(
    a: a * other.a + b * other.c,
    b: a * other.b + b * other.d,
    c: c * other.a + d * other.c,
    d: c * other.b + d * other.d,
  );

  /// Scalar multiplication.
  Matrix2x2 scale(double scalar) =>
      Matrix2x2(a: a * scalar, b: b * scalar, c: c * scalar, d: d * scalar);

  @override
  String toString() => 'Matrix2x2([[$a, $b], [$c, $d]])';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Matrix2x2 &&
          a == other.a &&
          b == other.b &&
          c == other.c &&
          d == other.d;

  @override
  int get hashCode => Object.hash(a, b, c, d);
}
