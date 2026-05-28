import 'dart:math' as math;

import 'package:stl/stl.dart';
import 'package:test/test.dart';

const _eps = 1e-6;

void main() {
  // ── EigenResult ──────────────────────────────────────────────────────────────
  group('EigenResult', () {
    test('stores eigenvalues and eigenvectors', () {
      final ev = Vec([1.0, 0.0, 0.0]);
      final evecs = Mat.identity(3);
      final result = EigenResult(
        eigenvalues: [3.0, 2.0, 1.0],
        eigenvectors: evecs,
      );
      expect(result.eigenvalues, [3.0, 2.0, 1.0]);
      expect(result.eigenvectors, evecs);
    });

    test('toString contains EigenResult', () {
      final result = EigenResult(
        eigenvalues: [1.0],
        eigenvectors: Mat.identity(1),
      );
      expect(result.toString(), contains('EigenResult'));
    });
  });

  // ── Power Iteration ──────────────────────────────────────────────────────────
  group('powerIteration', () {
    test('throws for non-square matrix', () {
      expect(() => powerIteration(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('diagonal matrix: dominant eigenvalue', () {
      // Diagonal [5, 3, 1] — dominant eigenvalue is 5
      final A = Mat.diagonal([5.0, 3.0, 1.0]);
      final (lambda, v) = powerIteration(A);
      expect(lambda, closeTo(5.0, _eps));
      // Eigenvector should be close to e_0 = [1, 0, 0]
      expect(v[0].abs(), closeTo(1.0, _eps));
    });

    test('symmetric 2×2 dominant eigenvalue', () {
      // A = [[3, 1], [1, 3]] → eigenvalues 4 and 2
      final A = Mat([
        [3.0, 1.0],
        [1.0, 3.0],
      ]);
      final (lambda, _) = powerIteration(A);
      expect(lambda, closeTo(4.0, _eps));
    });

    test('eigenvector satisfies Av = λv', () {
      final A = Mat.diagonal([7.0, 2.0, 1.0]);
      final (lambda, v) = powerIteration(A);
      // Av should equal lambda * v
      final Av = Vec(
        List.generate(3, (i) {
          var s = 0.0;
          for (var j = 0; j < 3; j++) s += A.at(i, j) * v[j];
          return s;
        }),
      );
      final lambdaV = v * lambda;
      for (var i = 0; i < 3; i++) {
        expect(Av[i], closeTo(lambdaV[i], _eps));
      }
    });

    test('eigenvector is normalised (unit length)', () {
      final A = Mat([
        [4.0, 1.0],
        [1.0, 2.0],
      ]);
      final (_, v) = powerIteration(A);
      expect(v.norm(), closeTo(1.0, _eps));
    });

    test('identity matrix: dominant eigenvalue is 1', () {
      final (lambda, _) = powerIteration(Mat.identity(4));
      expect(lambda, closeTo(1.0, _eps));
    });

    test('negative dominant eigenvalue', () {
      final A = Mat.diagonal([-6.0, 3.0, 1.0]);
      final (lambda, _) = powerIteration(A);
      expect(lambda.abs(), closeTo(6.0, _eps));
    });
  });

  // ── Symmetric Eigen ──────────────────────────────────────────────────────────
  group('symmetricEigen', () {
    test('throws for non-square matrix', () {
      expect(() => symmetricEigen(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('throws for non-symmetric matrix', () {
      expect(
        () => symmetricEigen(
          Mat([
            [1.0, 2.0],
            [3.0, 4.0],
          ]),
        ),
        throwsArgumentError,
      );
    });

    test('diagonal matrix: eigenvalues are diagonal entries', () {
      final A = Mat.diagonal([3.0, 1.0, 2.0]);
      final result = symmetricEigen(A);
      final sorted = [...result.eigenvalues]..sort((a, b) => b.compareTo(a));
      expect(sorted[0], closeTo(3.0, _eps));
      expect(sorted[1], closeTo(2.0, _eps));
      expect(sorted[2], closeTo(1.0, _eps));
    });

    test('2×2 symmetric: eigenvalues [4, 2] for [[3,1],[1,3]]', () {
      final A = Mat([
        [3.0, 1.0],
        [1.0, 3.0],
      ]);
      final result = symmetricEigen(A);
      final ev = [...result.eigenvalues]..sort((a, b) => b.compareTo(a));
      expect(ev[0], closeTo(4.0, _eps));
      expect(ev[1], closeTo(2.0, _eps));
    });

    test('eigenvectors are orthonormal', () {
      final A = Mat([
        [3.0, 1.0],
        [1.0, 3.0],
      ]);
      final result = symmetricEigen(A);
      final V = result.eigenvectors;
      // V^T * V should be identity
      final VtV = V.transpose() * V;
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
          expect(
            VtV.at(i, j),
            closeTo(i == j ? 1.0 : 0.0, 1e-8),
            reason: '[$i][$j]',
          );
        }
      }
    });

    test('each Av_i = λ_i * v_i', () {
      final A = Mat([
        [3.0, 1.0],
        [1.0, 3.0],
      ]);
      final result = symmetricEigen(A);
      for (var k = 0; k < 2; k++) {
        final v = result.eigenvectors.col(k);
        final lambda = result.eigenvalues[k];
        final Av = Vec(
          List.generate(2, (i) {
            var s = 0.0;
            for (var j = 0; j < 2; j++) s += A.at(i, j) * v[j];
            return s;
          }),
        );
        for (var i = 0; i < 2; i++) {
          expect(Av[i], closeTo(lambda * v[i], 1e-7));
        }
      }
    });

    test('3×3 symmetric tridiagonal', () {
      // A = [[2,-1,0],[-1,2,-1],[0,-1,2]]
      // Eigenvalues: 2 - 2*cos(k*pi/4) for k=1,2,3
      final A = Mat([
        [2.0, -1.0, 0.0],
        [-1.0, 2.0, -1.0],
        [0.0, -1.0, 2.0],
      ]);
      final result = symmetricEigen(A);
      final ev = [...result.eigenvalues]..sort();
      // known eigenvalues
      final expected = [2.0 - math.sqrt(2.0), 2.0, 2.0 + math.sqrt(2.0)];
      for (var i = 0; i < 3; i++) {
        expect(ev[i], closeTo(expected[i], _eps));
      }
    });

    test('eigenvalues sorted by descending absolute value', () {
      final A = Mat.diagonal([1.0, 3.0, 2.0]);
      final result = symmetricEigen(A);
      // Should be [3, 2, 1]
      expect(
        result.eigenvalues[0].abs(),
        greaterThanOrEqualTo(result.eigenvalues[1].abs()),
      );
      expect(
        result.eigenvalues[1].abs(),
        greaterThanOrEqualTo(result.eigenvalues[2].abs()),
      );
    });

    test('identity: all eigenvalues are 1', () {
      final result = symmetricEigen(Mat.identity(3));
      for (final ev in result.eigenvalues) {
        expect(ev, closeTo(1.0, _eps));
      }
    });
  });

  // ── QR Eigen ─────────────────────────────────────────────────────────────────
  group('qrEigen', () {
    test('throws for non-square matrix', () {
      expect(() => qrEigen(Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('diagonal matrix: eigenvalues are diagonal entries', () {
      final A = Mat.diagonal([5.0, 3.0, 1.0]);
      final result = qrEigen(A);
      final sorted = [...result.eigenvalues]
        ..sort((a, b) => b.abs().compareTo(a.abs()));
      expect(sorted[0], closeTo(5.0, _eps));
      expect(sorted[1], closeTo(3.0, _eps));
      expect(sorted[2], closeTo(1.0, _eps));
    });

    test('symmetric 2×2 [[3,1],[1,3]] → eigenvalues 4 and 2', () {
      final A = Mat([
        [3.0, 1.0],
        [1.0, 3.0],
      ]);
      final result = qrEigen(A);
      final ev = [...result.eigenvalues]..sort((a, b) => b.compareTo(a));
      expect(ev[0], closeTo(4.0, _eps));
      expect(ev[1], closeTo(2.0, _eps));
    });

    test('identity: all eigenvalues 1', () {
      final result = qrEigen(Mat.identity(3));
      for (final ev in result.eigenvalues) {
        expect(ev, closeTo(1.0, _eps));
      }
    });

    test('upper triangular: eigenvalues are diagonal', () {
      final A = Mat([
        [3.0, 5.0, 7.0],
        [0.0, 2.0, 4.0],
        [0.0, 0.0, 1.0],
      ]);
      final result = qrEigen(A);
      final ev = [...result.eigenvalues]
        ..sort((a, b) => b.abs().compareTo(a.abs()));
      expect(ev[0], closeTo(3.0, _eps));
      expect(ev[1], closeTo(2.0, _eps));
      expect(ev[2], closeTo(1.0, _eps));
    });

    test('eigenvalues sorted by descending absolute value', () {
      final A = Mat.diagonal([4.0, -8.0, 2.0]);
      final result = qrEigen(A);
      expect(
        result.eigenvalues[0].abs(),
        greaterThanOrEqualTo(result.eigenvalues[1].abs()),
      );
      expect(
        result.eigenvalues[1].abs(),
        greaterThanOrEqualTo(result.eigenvalues[2].abs()),
      );
    });

    test('eigenvectors matrix has correct dimensions', () {
      final A = Mat.identity(3);
      final result = qrEigen(A);
      expect(result.eigenvectors.rows, 3);
      expect(result.eigenvectors.cols, 3);
    });
  });
}
