import 'package:stl/stl.dart';
import 'package:test/test.dart';

const _eps = 1e-9;

void expectVecClose(Vec actual, Vec expected, {double eps = _eps}) {
  expect(actual.length, expected.length, reason: 'length mismatch');
  for (var i = 0; i < expected.length; i++) {
    expect(actual[i], closeTo(expected[i], eps), reason: 'index $i');
  }
}

void expectMatClose(Mat actual, Mat expected, {double eps = _eps}) {
  expect(actual.rows, expected.rows);
  expect(actual.cols, expected.cols);
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

void main() {
  // ── Level 1: dot ─────────────────────────────────────────────────────────────
  group('dot', () {
    test('basic inner product', () {
      expect(
        dot(Vec([1.0, 2.0, 3.0]), Vec([4.0, 5.0, 6.0])),
        closeTo(32.0, _eps),
      );
    });

    test('dot of zero vectors is zero', () {
      expect(dot(Vec.zeros(4), Vec.zeros(4)), closeTo(0.0, _eps));
    });

    test('dot of orthogonal vectors is zero', () {
      expect(
        dot(Vec([1.0, 0.0, 0.0]), Vec([0.0, 1.0, 0.0])),
        closeTo(0.0, _eps),
      );
    });

    test('commutativity', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([7.0, 8.0, 9.0]);
      expect(dot(a, b), closeTo(dot(b, a), _eps));
    });

    test('dimension mismatch throws', () {
      expect(() => dot(Vec([1.0]), Vec([1.0, 2.0])), throwsArgumentError);
    });
  });

  // ── Level 1: nrm2 ────────────────────────────────────────────────────────────
  group('nrm2', () {
    test('3-4-5 triangle', () {
      expect(nrm2(Vec([3.0, 4.0])), closeTo(5.0, _eps));
    });

    test('zero vector', () {
      expect(nrm2(Vec.zeros(5)), closeTo(0.0, _eps));
    });

    test('unit vectors', () {
      expect(nrm2(Vec.basis(4, 2)), closeTo(1.0, _eps));
    });
  });

  // ── Level 1: asum ────────────────────────────────────────────────────────────
  group('asum', () {
    test('sum of absolute values', () {
      expect(asum(Vec([1.0, -2.0, 3.0, -4.0])), closeTo(10.0, _eps));
    });

    test('all zeros', () {
      expect(asum(Vec.zeros(3)), closeTo(0.0, _eps));
    });
  });

  // ── Level 1: iamax ───────────────────────────────────────────────────────────
  group('iamax', () {
    test('returns index of max absolute value', () {
      expect(iamax(Vec([1.0, -5.0, 3.0])), 1); // |-5| is largest
    });

    test('all equal returns first', () {
      expect(iamax(Vec([2.0, 2.0, 2.0])), 0);
    });

    test('large negative dominates', () {
      expect(iamax(Vec([1.0, 2.0, -10.0])), 2);
    });

    test('single element', () {
      expect(iamax(Vec([42.0])), 0);
    });
  });

  // ── Level 1: axpy ────────────────────────────────────────────────────────────
  group('axpy', () {
    test('y + alpha * x', () {
      final x = Vec([1.0, 2.0, 3.0]);
      final y = Vec([4.0, 5.0, 6.0]);
      final result = axpy(2.0, x, y);
      expectVecClose(result, Vec([6.0, 9.0, 12.0]));
    });

    test('alpha = 0 returns y', () {
      final x = Vec([1.0, 2.0, 3.0]);
      final y = Vec([4.0, 5.0, 6.0]);
      expectVecClose(axpy(0.0, x, y), y);
    });

    test('alpha = 1 is addition', () {
      final x = Vec([1.0, 2.0]);
      final y = Vec([3.0, 4.0]);
      expectVecClose(axpy(1.0, x, y), x + y);
    });

    test('alpha = -1 is subtraction', () {
      final x = Vec([1.0, 2.0]);
      final y = Vec([3.0, 4.0]);
      expectVecClose(axpy(-1.0, x, y), y - x);
    });

    test('dimension mismatch throws', () {
      expect(() => axpy(1.0, Vec([1.0]), Vec([1.0, 2.0])), throwsArgumentError);
    });
  });

  // ── Level 1: scal ────────────────────────────────────────────────────────────
  group('scal', () {
    test('scales vector', () {
      expectVecClose(scal(3.0, Vec([1.0, 2.0, 3.0])), Vec([3.0, 6.0, 9.0]));
    });

    test('scal by 0 gives zero vector', () {
      expectVecClose(scal(0.0, Vec([1.0, 2.0, 3.0])), Vec.zeros(3));
    });

    test('scal by 1 returns same values', () {
      final v = Vec([7.0, 8.0, 9.0]);
      expectVecClose(scal(1.0, v), v);
    });
  });

  // ── Level 2: gemv ────────────────────────────────────────────────────────────
  group('gemv', () {
    final A = Mat([
      [1.0, 2.0],
      [3.0, 4.0],
    ]);
    final x = Vec([1.0, 1.0]);

    test('basic A * x (alpha=1, beta=0)', () {
      final result = gemv(A, x);
      expectVecClose(result, Vec([3.0, 7.0]));
    });

    test('alpha=2, beta=0', () {
      final result = gemv(A, x, alpha: 2.0);
      expectVecClose(result, Vec([6.0, 14.0]));
    });

    test('alpha=1, beta=1, y provided', () {
      final y = Vec([1.0, 0.0]);
      final result = gemv(A, x, beta: 1.0, y: y);
      expectVecClose(result, Vec([4.0, 7.0]));
    });

    test('identity * x = x', () {
      final v = Vec([3.0, 5.0]);
      expectVecClose(gemv(Mat.identity(2), v), v);
    });

    test('x dimension mismatch throws', () {
      expect(() => gemv(A, Vec([1.0])), throwsArgumentError);
    });

    test('y dimension mismatch throws', () {
      expect(() => gemv(A, x, beta: 1.0, y: Vec([1.0])), throwsArgumentError);
    });
  });

  // ── Level 2: ger ─────────────────────────────────────────────────────────────
  group('ger', () {
    test('outer product dimensions', () {
      final m = ger(Vec([1.0, 2.0, 3.0]), Vec([4.0, 5.0]));
      expect(m.rows, 3);
      expect(m.cols, 2);
    });

    test('outer product values', () {
      final m = ger(Vec([1.0, 2.0]), Vec([3.0, 4.0]));
      expect(m.at(0, 0), closeTo(3.0, _eps));
      expect(m.at(0, 1), closeTo(4.0, _eps));
      expect(m.at(1, 0), closeTo(6.0, _eps));
      expect(m.at(1, 1), closeTo(8.0, _eps));
    });

    test('ger with alpha=2', () {
      final m = ger(Vec([1.0, 1.0]), Vec([1.0, 1.0]), alpha: 2.0);
      expect(m.at(0, 0), closeTo(2.0, _eps));
    });

    test('ger matches Vec.outer()', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([4.0, 5.0]);
      final m1 = ger(a, b);
      final m2 = a.outer(b);
      expectMatClose(m1, m2);
    });
  });

  // ── Level 3: gemm ────────────────────────────────────────────────────────────
  group('gemm', () {
    test('basic matrix multiply', () {
      final A = Mat([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);
      final B = Mat([
        [5.0, 6.0],
        [7.0, 8.0],
      ]);
      final C = gemm(A, B);
      expectMatClose(C, A * B);
    });

    test('alpha scaling', () {
      final A = Mat([
        [1.0, 0.0],
        [0.0, 1.0],
      ]);
      final B = Mat([
        [2.0, 0.0],
        [0.0, 2.0],
      ]);
      final C = gemm(A, B, alpha: 3.0);
      expectMatClose(
        C,
        Mat([
          [6.0, 0.0],
          [0.0, 6.0],
        ]),
      );
    });

    test('beta accumulation', () {
      final A = Mat.identity(2);
      final B = Mat.identity(2);
      final existing = Mat([
        [1.0, 0.0],
        [0.0, 1.0],
      ]);
      // C = 1*I*I + 2*I = 3*I
      final C = gemm(A, B, beta: 2.0, c: existing);
      expectMatClose(C, Mat.identity(2).scaled(3.0));
    });

    test('gemm matches Mat multiplication', () {
      final A = Mat([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final B = Mat([
        [7.0, 8.0],
        [9.0, 10.0],
        [11.0, 12.0],
      ]);
      expectMatClose(gemm(A, B), A * B);
    });

    test('dimension mismatch throws', () {
      expect(() => gemm(Mat.zeros(2, 3), Mat.zeros(2, 3)), throwsArgumentError);
    });

    test('c dimension mismatch throws', () {
      expect(
        () => gemm(
          Mat.identity(2),
          Mat.identity(2),
          beta: 1.0,
          c: Mat.zeros(2, 3),
        ),
        throwsArgumentError,
      );
    });
  });

  // ── Level 3: trmm ────────────────────────────────────────────────────────────
  group('trmm', () {
    test('upper triangular multiply', () {
      final A = Mat([
        [2.0, 3.0],
        [0.0, 4.0],
      ]);
      final B = Mat([
        [1.0],
        [1.0],
      ]);
      final C = trmm(A, B, upper: true);
      // Row 0: 2*1 + 3*1 = 5
      // Row 1: 0 + 4*1 = 4
      expect(C.at(0, 0), closeTo(5.0, _eps));
      expect(C.at(1, 0), closeTo(4.0, _eps));
    });

    test('lower triangular multiply', () {
      final A = Mat([
        [2.0, 0.0],
        [3.0, 4.0],
      ]);
      final B = Mat([
        [1.0],
        [1.0],
      ]);
      final C = trmm(A, B, upper: false);
      expect(C.at(0, 0), closeTo(2.0, _eps));
      expect(C.at(1, 0), closeTo(7.0, _eps));
    });

    test('trmm with alpha', () {
      final A = Mat([
        [1.0, 0.0],
        [0.0, 1.0],
      ]);
      final B = Mat([
        [3.0],
        [4.0],
      ]);
      final C = trmm(A, B, alpha: 2.0);
      expect(C.at(0, 0), closeTo(6.0, _eps));
      expect(C.at(1, 0), closeTo(8.0, _eps));
    });

    test('non-square A throws', () {
      expect(() => trmm(Mat.zeros(2, 3), Mat.zeros(3, 1)), throwsArgumentError);
    });

    test('dimension mismatch throws', () {
      expect(() => trmm(Mat.identity(2), Mat.zeros(3, 1)), throwsArgumentError);
    });
  });
}
