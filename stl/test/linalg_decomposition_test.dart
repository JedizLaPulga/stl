// ignore_for_file: non_constant_identifier_names

import 'package:stl/stl.dart';
import 'package:test/test.dart';

const _eps = 1e-8;

/// Checks that two matrices are element-wise close.
void expectMatClose(Mat actual, Mat expected, {double eps = _eps}) {
  expect(actual.rows, expected.rows, reason: 'rows mismatch');
  expect(actual.cols, expected.cols, reason: 'cols mismatch');
  for (var i = 0; i < expected.rows; i++) {
    for (var j = 0; j < expected.cols; j++) {
      expect(
        actual.at(i, j),
        closeTo(expected.at(i, j), eps),
        reason: 'at($i,$j)',
      );
    }
  }
}

/// Checks that two vectors are element-wise close.
void expectVecClose(Vec actual, Vec expected, {double eps = _eps}) {
  expect(actual.length, expected.length, reason: 'length mismatch');
  for (var i = 0; i < expected.length; i++) {
    expect(actual[i], closeTo(expected[i], eps), reason: 'index $i');
  }
}

void main() {
  // ── LU Decomposition ─────────────────────────────────────────────────────────
  group('LUDecomposition', () {
    test('throws for non-square input', () {
      expect(() => LUDecomposition(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('L is unit lower triangular', () {
      final A = Mat([
        [2.0, 1.0],
        [4.0, 3.0],
      ]);
      final lu = LUDecomposition(A);
      final L = lu.l;
      expect(L.at(0, 0), closeTo(1.0, _eps));
      expect(L.at(1, 1), closeTo(1.0, _eps));
      expect(L.at(0, 1), closeTo(0.0, _eps)); // upper triangle is zero
    });

    test('U is upper triangular', () {
      final A = Mat([
        [2.0, 1.0],
        [4.0, 3.0],
      ]);
      final lu = LUDecomposition(A);
      final U = lu.u;
      expect(U.at(1, 0), closeTo(0.0, _eps)); // lower triangle is zero
    });

    test('P * L * U = A (2×2)', () {
      final A = Mat([
        [2.0, 1.0],
        [4.0, 3.0],
      ]);
      final lu = LUDecomposition(A);
      final recon = lu.p * lu.l * lu.u;
      expectMatClose(recon, A);
    });

    test('P * L * U = A (3×3)', () {
      final A = Mat([
        [2.0, 1.0, -1.0],
        [-3.0, -1.0, 2.0],
        [-2.0, 1.0, 2.0],
      ]);
      final lu = LUDecomposition(A);
      expectMatClose(lu.p * lu.l * lu.u, A);
    });

    test('solve Ax = b (2×2)', () {
      final A = Mat([
        [2.0, 1.0],
        [5.0, 3.0],
      ]);
      final b = Vec([1.0, 2.0]);
      final x = LUDecomposition(A).solve(b);
      // Verify: Ax = b
      final Ax = Vec([
        A.at(0, 0) * x[0] + A.at(0, 1) * x[1],
        A.at(1, 0) * x[0] + A.at(1, 1) * x[1],
      ]);
      expectVecClose(Ax, b);
    });

    test('solve Ax = b (3×3) classic example', () {
      // x=2, y=3, z=-1  is the solution
      final A = Mat([
        [2.0, 1.0, -1.0],
        [-3.0, -1.0, 2.0],
        [-2.0, 1.0, 2.0],
      ]);
      final b = Vec([8.0, -11.0, -3.0]);
      final x = LUDecomposition(A).solve(b);
      expectVecClose(x, Vec([2.0, 3.0, -1.0]));
    });

    test('solve with identity coefficient gives b back', () {
      final b = Vec([3.0, 1.0, 4.0]);
      final x = LUDecomposition(Mat.identity(3)).solve(b);
      expectVecClose(x, b);
    });

    test('solve dimension mismatch throws', () {
      expect(
        () => LUDecomposition(Mat.identity(3)).solve(Vec([1.0, 2.0])),
        throwsArgumentError,
      );
    });

    test('determinant of identity is 1', () {
      for (var n = 1; n <= 5; n++) {
        expect(
          LUDecomposition(Mat.identity(n)).determinant(),
          closeTo(1.0, _eps),
        );
      }
    });

    test('determinant of 3×3', () {
      final A = Mat([
        [6.0, 1.0, 1.0],
        [4.0, -2.0, 5.0],
        [2.0, 8.0, 7.0],
      ]);
      expect(LUDecomposition(A).determinant(), closeTo(-306.0, _eps));
    });

    test('determinant of singular matrix is near 0', () {
      final A = Mat([
        [1.0, 2.0],
        [2.0, 4.0],
      ]);
      expect(LUDecomposition(A).determinant().abs(), lessThan(1e-9));
    });

    test('inverse: A * A^-1 = I', () {
      final A = Mat([
        [2.0, 1.0],
        [5.0, 3.0],
      ]);
      final Ainv = LUDecomposition(A).inverse();
      expectMatClose(A * Ainv, Mat.identity(2));
    });

    test('inverse of identity is identity', () {
      expectMatClose(
        LUDecomposition(Mat.identity(4)).inverse(),
        Mat.identity(4),
      );
    });
  });

  // ── QR Decomposition ─────────────────────────────────────────────────────────
  group('QRDecomposition', () {
    test('throws when rows < cols', () {
      expect(() => QRDecomposition(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('Q is orthogonal: Q^T * Q = I (square)', () {
      final A = Mat([
        [12.0, -51.0, 4.0],
        [6.0, 167.0, -68.0],
        [-4.0, 24.0, -41.0],
      ]);
      final qr = QRDecomposition(A);
      expectMatClose(qr.q.transpose() * qr.q, Mat.identity(3));
    });

    test('Q * R = A (square)', () {
      final A = Mat([
        [12.0, -51.0, 4.0],
        [6.0, 167.0, -68.0],
        [-4.0, 24.0, -41.0],
      ]);
      final qr = QRDecomposition(A);
      expectMatClose(qr.q * qr.r, A, eps: 1e-7);
    });

    test('R is upper triangular (square)', () {
      final A = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
        [7.0, 8.0, 10.0],
      ]);
      final R = QRDecomposition(A).r;
      for (var i = 1; i < 3; i++) {
        for (var j = 0; j < i; j++) {
          expect(
            R.at(i, j),
            closeTo(0.0, 1e-9),
            reason: 'R[$i][$j] should be 0',
          );
        }
      }
    });

    test('solve square system gives exact solution', () {
      final A = Mat([
        [2.0, 1.0],
        [1.0, 3.0],
      ]);
      final b = Vec([5.0, 10.0]);
      final x = QRDecomposition(A).solve(b);
      // Ax = b → x = A^-1 b
      final Ax = Vec([
        A.at(0, 0) * x[0] + A.at(0, 1) * x[1],
        A.at(1, 0) * x[0] + A.at(1, 1) * x[1],
      ]);
      expectVecClose(Ax, b);
    });

    test('solve 4×4 system', () {
      final A = Mat([
        [1.0, 2.0, 0.0, 0.0],
        [0.0, 1.0, 3.0, 0.0],
        [0.0, 0.0, 1.0, 4.0],
        [0.0, 0.0, 0.0, 1.0],
      ]);
      final b = Vec([1.0, 2.0, 3.0, 4.0]);
      final x = QRDecomposition(A).solve(b);
      // verify residual is near zero
      final rows = A.rows;
      for (var i = 0; i < rows; i++) {
        var rowSum = 0.0;
        for (var j = 0; j < A.cols; j++) {
          rowSum += A.at(i, j) * x[j];
        }
        expect(rowSum, closeTo(b[i], _eps));
      }
    });

    test('Q * R = A (tall 4×2 matrix)', () {
      final A = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
        [5.0, 6.0],
        [7.0, 8.0],
      ]);
      final qr = QRDecomposition(A);
      expectMatClose(qr.q * qr.r, A, eps: 1e-7);
    });

    test('solve dimension mismatch throws', () {
      expect(
        () => QRDecomposition(Mat.identity(3)).solve(Vec([1.0, 2.0])),
        throwsArgumentError,
      );
    });
  });

  // ── Cholesky Decomposition ────────────────────────────────────────────────────
  group('CholeskyDecomposition', () {
    test('throws for non-square matrix', () {
      expect(() => CholeskyDecomposition(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('throws for non-symmetric matrix', () {
      expect(
        () => CholeskyDecomposition(
          Mat([
            [1.0, 2.0],
            [3.0, 4.0],
          ]),
        ),
        throwsArgumentError,
      );
    });

    test('throws for non-positive-definite matrix', () {
      // Negative definite (well-known failure case)
      expect(
        () => CholeskyDecomposition(
          Mat([
            [-1.0, 0.0],
            [0.0, -1.0],
          ]),
        ),
        throwsStateError,
      );
    });

    test('L is lower triangular', () {
      final A = Mat([
        [4.0, 2.0],
        [2.0, 3.0],
      ]);
      final L = CholeskyDecomposition(A).l;
      expect(L.at(0, 1), closeTo(0.0, _eps)); // upper triangle is 0
    });

    test('L * L^T = A (2×2)', () {
      final A = Mat([
        [4.0, 2.0],
        [2.0, 3.0],
      ]);
      final L = CholeskyDecomposition(A).l;
      expectMatClose(L * L.transpose(), A);
    });

    test('L * L^T = A (3×3 standard SPD)', () {
      // This is 2*I + ones-matrix => SPD
      final A = Mat([
        [4.0, 12.0, -16.0],
        [12.0, 37.0, -43.0],
        [-16.0, -43.0, 98.0],
      ]);
      final L = CholeskyDecomposition(A).l;
      expectMatClose(L * L.transpose(), A);
    });

    test('L diagonal entries are positive', () {
      final A = Mat([
        [4.0, 2.0],
        [2.0, 3.0],
      ]);
      final L = CholeskyDecomposition(A).l;
      for (var i = 0; i < 2; i++) {
        expect(L.at(i, i), greaterThan(0.0));
      }
    });

    test('solve Ax = b', () {
      final A = Mat([
        [4.0, 2.0],
        [2.0, 3.0],
      ]);
      final b = Vec([2.0, 1.0]);
      final x = CholeskyDecomposition(A).solve(b);
      // Verify Ax = b
      final Ax = Vec([
        A.at(0, 0) * x[0] + A.at(0, 1) * x[1],
        A.at(1, 0) * x[0] + A.at(1, 1) * x[1],
      ]);
      expectVecClose(Ax, b);
    });

    test('solve 3×3 system', () {
      final A = Mat([
        [4.0, 12.0, -16.0],
        [12.0, 37.0, -43.0],
        [-16.0, -43.0, 98.0],
      ]);
      final b = Vec([1.0, 0.0, 0.0]);
      final x = CholeskyDecomposition(A).solve(b);
      // Verify residual
      for (var i = 0; i < 3; i++) {
        var s = 0.0;
        for (var j = 0; j < 3; j++) {
          s += A.at(i, j) * x[j];
        }
        expect(s, closeTo(b[i], _eps));
      }
    });

    test('solve identity system gives b back', () {
      final b = Vec([3.0, 1.0, 4.0]);
      final x = CholeskyDecomposition(Mat.identity(3)).solve(b);
      expectVecClose(x, b);
    });

    test('solve dimension mismatch throws', () {
      expect(
        () => CholeskyDecomposition(Mat.identity(3)).solve(Vec([1.0, 2.0])),
        throwsArgumentError,
      );
    });
  });
}
