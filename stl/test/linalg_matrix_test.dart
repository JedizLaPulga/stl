// ignore_for_file: non_constant_identifier_names

import 'dart:math' as math;

import 'package:stl/stl.dart';
import 'package:test/test.dart';

// Tolerance for floating-point comparisons.
const _eps = 1e-9;

Matcher closeToMat(Mat expected, {double eps = _eps}) =>
    predicate<Mat>((actual) {
      if (actual.rows != expected.rows || actual.cols != expected.cols) {
        return false;
      }
      for (var i = 0; i < expected.rows; i++) {
        for (var j = 0; j < expected.cols; j++) {
          if ((actual.at(i, j) - expected.at(i, j)).abs() > eps) return false;
        }
      }
      return true;
    }, 'matrix close to expected within $eps');

void main() {
  // ── Constructors ─────────────────────────────────────────────────────────────
  group('Mat constructors', () {
    test('Mat(data) stores elements correctly', () {
      final m = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      expect(m.at(0, 0), 1.0);
      expect(m.at(0, 1), 2.0);
      expect(m.at(1, 0), 3.0);
      expect(m.at(1, 1), 4.0);
    });

    test('Mat(empty) throws', () {
      expect(() => Mat([]), throwsArgumentError);
    });

    test('Mat(inconsistent row lengths) throws', () {
      expect(
        () => Mat([
          [1.0, 2.0],
          [3.0],
        ]),
        throwsArgumentError,
      );
    });

    test('Mat.zeros creates zero matrix', () {
      final m = Mat.zeros(2, 3);
      expect(m.rows, 2);
      expect(m.cols, 3);
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 3; j++) {
          expect(m.at(i, j), 0.0);
        }
      }
    });

    test('Mat.identity creates identity matrix', () {
      final I = Mat.identity(3);
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(I.at(i, j), i == j ? 1.0 : 0.0);
        }
      }
    });

    test('Mat.filled creates constant matrix', () {
      final m = Mat.filled(3, 3, 7.0);
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(m.at(i, j), 7.0);
        }
      }
    });

    test('Mat.diagonal creates diagonal matrix', () {
      final m = Mat.diagonal([1.0, 2.0, 3.0]);
      expect(m.at(0, 0), 1.0);
      expect(m.at(1, 1), 2.0);
      expect(m.at(2, 2), 3.0);
      expect(m.at(0, 1), 0.0);
      expect(m.at(1, 0), 0.0);
    });

    test('Mat.fromColumns assembles correctly', () {
      final c0 = Vec([1.0, 2.0, 3.0]);
      final c1 = Vec([4.0, 5.0, 6.0]);
      final m = Mat.fromColumns([c0, c1]);
      expect(m.rows, 3);
      expect(m.cols, 2);
      expect(m.at(0, 0), 1.0);
      expect(m.at(0, 1), 4.0);
      expect(m.at(2, 1), 6.0);
    });

    test('Mat.fromRows assembles correctly', () {
      final r0 = Vec([1.0, 2.0, 3.0]);
      final r1 = Vec([4.0, 5.0, 6.0]);
      final m = Mat.fromRows([r0, r1]);
      expect(m.rows, 2);
      expect(m.cols, 3);
      expect(m.at(0, 0), 1.0);
      expect(m.at(1, 2), 6.0);
    });

    test('Mat.fromColumns inconsistent lengths throw', () {
      expect(
        () => Mat.fromColumns([
          Vec([1.0, 2.0]),
          Vec([1.0]),
        ]),
        throwsArgumentError,
      );
    });
  });

  // ── Properties ───────────────────────────────────────────────────────────────
  group('Mat properties', () {
    test('isSquare', () {
      expect(Mat.identity(3).isSquare, isTrue);
      expect(Mat.zeros(2, 3).isSquare, isFalse);
    });

    test('isSymmetric on symmetric matrix', () {
      final m = Mat([
        [1.0, 2.0],
        [2.0, 3.0],
      ]);
      expect(m.isSymmetric, isTrue);
    });

    test('isSymmetric false on asymmetric matrix', () {
      final m = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      expect(m.isSymmetric, isFalse);
    });

    test('isSymmetric false for non-square', () {
      expect(Mat.zeros(2, 3).isSymmetric, isFalse);
    });

    test('isDiagonal on diagonal matrix', () {
      expect(Mat.diagonal([1.0, 2.0, 3.0]).isDiagonal, isTrue);
    });

    test('isDiagonal false on non-diagonal', () {
      final m = Mat([
        [1.0, 1.0],
        [0.0, 2.0],
      ]);
      expect(m.isDiagonal, isFalse);
    });
  });

  // ── Access ────────────────────────────────────────────────────────────────────
  group('Mat access', () {
    final m = Mat([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ]);

    test('row(i) returns Vec', () {
      final r = m.row(0);
      expect(r[0], 1.0);
      expect(r[1], 2.0);
      expect(r[2], 3.0);
    });

    test('col(j) returns Vec', () {
      final c = m.col(1);
      expect(c[0], 2.0);
      expect(c[1], 5.0);
    });

    test('[] operator returns row', () {
      expect(m[1][0], 4.0);
    });
  });

  // ── Arithmetic ───────────────────────────────────────────────────────────────
  group('Mat arithmetic', () {
    final a = Mat([
      [1.0, 2.0],
      [3.0, 4.0],
    ]);
    final b = Mat([
      [5.0, 6.0],
      [7.0, 8.0],
    ]);

    test('addition', () {
      final c = a + b;
      expect(c.at(0, 0), 6.0);
      expect(c.at(1, 1), 12.0);
    });

    test('subtraction', () {
      final c = b - a;
      expect(c.at(0, 0), 4.0);
      expect(c.at(1, 0), 4.0);
    });

    test('unary negation', () {
      final c = -a;
      expect(c.at(0, 0), -1.0);
      expect(c.at(1, 1), -4.0);
    });

    test('matrix multiplication', () {
      // [1,2] * [5,6] = [1*5+2*7, 1*6+2*8] = [19, 22]
      // [3,4]   [7,8]   [3*5+4*7, 3*6+4*8]   [43, 50]
      final c = a * b;
      expect(c.at(0, 0), 19.0);
      expect(c.at(0, 1), 22.0);
      expect(c.at(1, 0), 43.0);
      expect(c.at(1, 1), 50.0);
    });

    test('identity multiplication is identity', () {
      final I = Mat.identity(2);
      expect(a * I, closeToMat(a));
      expect(I * a, closeToMat(a));
    });

    test('multiplication dimension mismatch throws', () {
      expect(() => Mat.zeros(2, 3) * Mat.zeros(2, 3), throwsArgumentError);
    });

    test('scaled', () {
      final c = a.scaled(2.0);
      expect(c.at(0, 0), 2.0);
      expect(c.at(1, 1), 8.0);
    });

    test('divided', () {
      final c = a.divided(2.0);
      expect(c.at(0, 0), 0.5);
      expect(c.at(1, 1), 2.0);
    });

    test('divided by zero throws', () {
      expect(() => a.divided(0.0), throwsArgumentError);
    });

    test('addition dimension mismatch throws', () {
      expect(() => Mat.zeros(2, 2) + Mat.zeros(2, 3), throwsArgumentError);
    });
  });

  // ── Transformations ───────────────────────────────────────────────────────────
  group('Mat transformations', () {
    test('transpose 2×2', () {
      final m = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      final t = m.transpose();
      expect(t.at(0, 0), 1.0);
      expect(t.at(0, 1), 3.0);
      expect(t.at(1, 0), 2.0);
    });

    test('transpose of identity is identity', () {
      final I = Mat.identity(4);
      expect(I.transpose(), closeToMat(I));
    });

    test('(A^T)^T = A', () {
      final m = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      expect(m.transpose().transpose(), closeToMat(m));
    });

    test('submatrix extracts block correctly', () {
      final m = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
        [7.0, 8.0, 9.0],
      ]);
      final sub = m.submatrix(1, 1, 2, 2);
      expect(sub.rows, 2);
      expect(sub.cols, 2);
      expect(sub.at(0, 0), 5.0);
      expect(sub.at(1, 1), 9.0);
    });

    test('submatrix out of bounds throws RangeError', () {
      expect(() => Mat.identity(3).submatrix(0, 0, 4, 4), throwsRangeError);
    });
  });

  // ── Reductions ────────────────────────────────────────────────────────────────
  group('Mat reductions', () {
    test('trace of identity(n) is n', () {
      for (var n = 1; n <= 5; n++) {
        expect(Mat.identity(n).trace(), closeTo(n.toDouble(), _eps));
      }
    });

    test('trace on non-square throws', () {
      expect(() => Mat.zeros(2, 3).trace(), throwsStateError);
    });

    test('frobenius norm of identity(3) is sqrt(3)', () {
      expect(Mat.identity(3).frobenius(), closeTo(math.sqrt(3), _eps));
    });

    test('frobenius of zero matrix is 0', () {
      expect(Mat.zeros(4, 4).frobenius(), closeTo(0.0, _eps));
    });
  });

  // ── Determinant & Inverse ─────────────────────────────────────────────────────
  group('Mat determinant and inverse', () {
    test('determinant of identity is 1', () {
      for (var n = 1; n <= 5; n++) {
        expect(Mat.identity(n).determinant(), closeTo(1.0, _eps));
      }
    });

    test('determinant of 2×2', () {
      final m = Mat([
        [3.0, 7.0],
        [1.0, -4.0],
      ]);
      expect(m.determinant(), closeTo(-19.0, _eps));
    });

    test('determinant of 3×3', () {
      final m = Mat([
        [6.0, 1.0, 1.0],
        [4.0, -2.0, 5.0],
        [2.0, 8.0, 7.0],
      ]);
      expect(m.determinant(), closeTo(-306.0, _eps));
    });

    test('determinant of singular matrix is 0', () {
      final m = Mat([
        [1.0, 2.0],
        [2.0, 4.0],
      ]);
      expect(m.determinant().abs(), lessThan(1e-9));
    });

    test('determinant on non-square throws', () {
      expect(() => Mat.zeros(2, 3).determinant(), throwsStateError);
    });

    test('inverse of identity is identity', () {
      expect(Mat.identity(3).inverse(), closeToMat(Mat.identity(3)));
    });

    test('A * A^-1 = I', () {
      final A = Mat([
        [2.0, 1.0],
        [5.0, 3.0],
      ]);
      final Ainv = A.inverse();
      expect(A * Ainv, closeToMat(Mat.identity(2), eps: 1e-9));
    });

    test('inverse of 3×3', () {
      final A = Mat([
        [1.0, 2.0, 0.0],
        [0.0, 1.0, 3.0],
        [0.0, 0.0, 1.0],
      ]);
      final Ainv = A.inverse();
      expect(A * Ainv, closeToMat(Mat.identity(3), eps: 1e-9));
    });

    test('inverse on non-square throws', () {
      expect(() => Mat.zeros(2, 3).inverse(), throwsStateError);
    });
  });

  // ── Equality & utilities ─────────────────────────────────────────────────────
  group('Mat equality and utilities', () {
    test('equal matrices', () {
      final a = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      final b = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      expect(a == b, isTrue);
    });

    test('different values are not equal', () {
      final a = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      final b = Mat([
        [1.0, 2.0],
        [3.0, 5.0],
      ]);
      expect(a == b, isFalse);
    });

    test('hashCode consistent with equality', () {
      final a = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      final b = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      expect(a.hashCode, b.hashCode);
    });

    test('toList returns deep copy', () {
      final m = Mat([
        [1.0, 2.0],
      ]);
      final list = m.toList();
      list[0][0] = 99.0;
      expect(m.at(0, 0), 1.0);
    });

    test('toString contains Mat label', () {
      expect(Mat.identity(2).toString(), contains('Mat'));
    });
  });

  // ── Non-square operations ────────────────────────────────────────────────────
  group('Mat non-square', () {
    test('2×3 * 3×2 gives 2×2', () {
      final a = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final b = Mat([
        [7.0, 8.0],
        [9.0, 10.0],
        [11.0, 12.0],
      ]);
      final c = a * b;
      expect(c.rows, 2);
      expect(c.cols, 2);
      expect(c.at(0, 0), closeTo(58.0, _eps));
      expect(c.at(0, 1), closeTo(64.0, _eps));
    });

    test('transpose of non-square', () {
      final m = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final t = m.transpose();
      expect(t.rows, 3);
      expect(t.cols, 2);
      expect(t.at(2, 0), 3.0);
    });
  });
}
