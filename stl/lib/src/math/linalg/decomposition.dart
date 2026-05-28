import 'dart:math' as math;

import 'matrix.dart';
import 'vec.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LU Decomposition
// ─────────────────────────────────────────────────────────────────────────────

/// LU decomposition with partial pivoting: $A = P \cdot L \cdot U$.
///
/// Decomposes a square matrix into:
/// - $P$ — permutation matrix encoding row swaps,
/// - $L$ — unit lower triangular matrix (diagonal entries all 1),
/// - $U$ — upper triangular matrix.
///
/// Applications:
/// - Solving linear systems $Ax = b$ in $O(n^2)$ after $O(n^3)$ factorisation.
/// - Computing $\det(A) = \text{sign}(P) \cdot \prod_i u_{ii}$.
/// - Computing $A^{-1}$ by solving $AX = I$ column by column.
///
/// ### Example
/// ```dart
/// final A = Mat([
///   [2.0, 1.0, -1.0],
///   [-3.0, -1.0, 2.0],
///   [-2.0, 1.0, 2.0],
/// ]);
/// final lu = LUDecomposition(A);
/// final x  = lu.solve(Vec([8.0, -11.0, -3.0]));
/// print(x); // Vec([2.0, 3.0, -1.0])
/// ```
///
/// Mirrors the solve behaviour of `std::linalg::lu_solve` (C++26).
class LUDecomposition {
  final int _n;
  final List<List<double>> _lu;

  /// The pivot index array. `_piv[i]` is the original row index that was
  /// swapped into row *i*.
  final List<int> _piv;

  int _pivSign = 1;

  /// Constructs the LU decomposition of [a].
  ///
  /// Throws [ArgumentError] if [a] is not square.
  LUDecomposition(Mat a)
    : _n = a.rows,
      _lu = a.toList(),
      _piv = List<int>.generate(a.rows, (i) => i) {
    if (!a.isSquare) {
      throw ArgumentError('LUDecomposition requires a square matrix');
    }
    _factor();
  }

  void _factor() {
    for (var k = 0; k < _n; k++) {
      // Partial pivot: find row with maximum absolute value in column k
      var maxVal = _lu[k][k].abs();
      var maxRow = k;
      for (var i = k + 1; i < _n; i++) {
        if (_lu[i][k].abs() > maxVal) {
          maxVal = _lu[i][k].abs();
          maxRow = i;
        }
      }
      if (maxRow != k) {
        final tmp = _lu[k];
        _lu[k] = _lu[maxRow];
        _lu[maxRow] = tmp;
        final tp = _piv[k];
        _piv[k] = _piv[maxRow];
        _piv[maxRow] = tp;
        _pivSign = -_pivSign;
      }
      if (_lu[k][k] == 0.0) continue; // singular column, skip
      for (var i = k + 1; i < _n; i++) {
        _lu[i][k] /= _lu[k][k];
        for (var j = k + 1; j < _n; j++) {
          _lu[i][j] -= _lu[i][k] * _lu[k][j];
        }
      }
    }
  }

  // ── Getters ──────────────────────────────────────────────────────────────────

  /// The unit lower triangular factor $L$ (diagonal entries are all 1).
  Mat get l {
    return Mat(
      List.generate(
        _n,
        (i) => List.generate(_n, (j) {
          if (j < i) return _lu[i][j]; // subdiagonal: multipliers
          if (j == i) return 1.0; // unit diagonal
          return 0.0;
        }),
      ),
    );
  }

  /// The upper triangular factor $U$.
  Mat get u {
    return Mat(
      List.generate(
        _n,
        (i) => List.generate(_n, (j) {
          if (j >= i) return _lu[i][j];
          return 0.0;
        }),
      ),
    );
  }

  /// The permutation matrix $P$ such that $A = P \cdot L \cdot U$.
  ///
  /// This is the *inverse* (transpose) of the row-selection permutation used
  /// internally during factorisation, i.e. `P[i][j] = 1` iff `pivots[j] == i`.
  Mat get p {
    return Mat(
      List.generate(
        _n,
        (i) => List.generate(_n, (j) => _piv[j] == i ? 1.0 : 0.0),
      ),
    );
  }

  /// The raw pivot indices: `pivots[i]` is the original row index at position
  /// *i* after all swaps.
  List<int> get pivots => List<int>.unmodifiable(_piv);

  // ── Solve / derive ───────────────────────────────────────────────────────────

  /// Solves the linear system $Ax = b$ via forward and back substitution.
  ///
  /// Requires `b.length == n`.
  ///
  /// Throws [ArgumentError] if the dimension of [b] does not match.
  /// Throws [StateError] if the matrix is singular (a diagonal of $U$ is zero
  /// within tolerance $10^{-12}$).
  Vec solve(Vec b) {
    if (b.length != _n) {
      throw ArgumentError(
        'b.length (${b.length}) must equal matrix order ($_n)',
      );
    }
    // Apply row permutation
    final x = List<double>.generate(_n, (i) => b[_piv[i]]);
    // Forward substitution through L (unit diagonal → no division needed)
    for (var k = 0; k < _n; k++) {
      for (var i = k + 1; i < _n; i++) {
        x[i] -= _lu[i][k] * x[k];
      }
    }
    // Back substitution through U
    for (var k = _n - 1; k >= 0; k--) {
      if (_lu[k][k].abs() < 1e-12) {
        throw StateError('matrix is singular — cannot solve');
      }
      x[k] /= _lu[k][k];
      for (var i = 0; i < k; i++) {
        x[i] -= _lu[i][k] * x[k];
      }
    }
    return Vec(x);
  }

  /// Returns $\det(A) = \text{sign}(P) \cdot \prod_i u_{ii}$.
  double determinant() {
    var d = _pivSign.toDouble();
    for (var k = 0; k < _n; k++) {
      d *= _lu[k][k];
    }
    return d;
  }

  /// Returns $A^{-1}$ by solving $AX = I$ column by column.
  ///
  /// Throws [StateError] if the matrix is singular.
  Mat inverse() {
    final cols = <Vec>[];
    for (var j = 0; j < _n; j++) {
      final e = Vec(List.generate(_n, (i) => i == j ? 1.0 : 0.0));
      cols.add(solve(e));
    }
    return Mat.fromColumns(cols);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QR Decomposition
// ─────────────────────────────────────────────────────────────────────────────

/// QR decomposition via Householder reflections: $A = Q \cdot R$.
///
/// Decomposes an M×N real matrix ($M \geq N$) into:
/// - $Q$ — M×M orthogonal matrix ($Q^\top Q = I$),
/// - $R$ — M×N upper trapezoidal matrix.
///
/// Primarily used for:
/// - Solving least-squares problems $\min \|Ax - b\|_2$ via
///   $Rx = Q^\top b$ (for full-rank, square systems this yields the exact
///   solution).
/// - Computing QR factorisations for iterative eigenvalue algorithms.
///
/// ### Example
/// ```dart
/// final A = Mat([
///   [12.0, -51.0, 4.0],
///   [6.0,  167.0, -68.0],
///   [-4.0,  24.0, -41.0],
/// ]);
/// final qr = QRDecomposition(A);
/// // Q * R ≈ A
/// ```
///
/// Mirrors `std::linalg::householder_qr` (C++26 P1673).
class QRDecomposition {
  final int _m;
  final int _n;
  late final Mat _q;
  late final Mat _r;

  /// Constructs the QR decomposition of [a] using Householder reflections.
  ///
  /// Throws [ArgumentError] if `a.rows < a.cols`.
  QRDecomposition(Mat a) : _m = a.rows, _n = a.cols {
    if (a.rows < a.cols) {
      throw ArgumentError(
        'QRDecomposition requires rows >= cols (got ${a.rows}×${a.cols})',
      );
    }
    _compute(a);
  }

  void _compute(Mat a) {
    // Work on mutable copies
    final r = a.toList(); // will become R
    // Q starts as identity (M×M)
    final qData = List.generate(
      _m,
      (i) => List.generate(_m, (j) => i == j ? 1.0 : 0.0),
    );

    for (var k = 0; k < _n; k++) {
      // Extract column sub-vector x = r[k..m-1, k]
      final xLen = _m - k;
      final x = List<double>.generate(xLen, (i) => r[k + i][k]);

      // Householder vector v = x + sign(x[0]) * ||x|| * e_1
      final normX = math.sqrt(x.fold(0.0, (s, xi) => s + xi * xi));
      if (normX == 0.0) continue;
      x[0] += (x[0] >= 0 ? 1.0 : -1.0) * normX;
      final normV2 = x.fold(0.0, (s, vi) => s + vi * vi);
      if (normV2 == 0.0) {
        continue;
      }

      // Apply H = I - 2 v v^T / ||v||^2 to R (columns k..n-1) and Q (all cols)
      // Update R: for each column j >= k, R[k:,j] -= (2/||v||^2) * v * (v^T R[k:,j])
      for (var j = k; j < _n; j++) {
        var dot = 0.0;
        for (var i = 0; i < xLen; i++) {
          dot += x[i] * r[k + i][j];
        }
        dot *= 2.0 / normV2;
        for (var i = 0; i < xLen; i++) {
          r[k + i][j] -= dot * x[i];
        }
      }
      // Update Q: Q = Q * H^T  (H is symmetric so H^T = H)
      // For each row i of Q, Q[i, k:] -= (2/||v||^2) * (Q[i,k:] . v) * v
      for (var i = 0; i < _m; i++) {
        var dot = 0.0;
        for (var j = 0; j < xLen; j++) {
          dot += qData[i][k + j] * x[j];
        }
        dot *= 2.0 / normV2;
        for (var j = 0; j < xLen; j++) {
          qData[i][k + j] -= dot * x[j];
        }
      }
    }

    _q = Mat(qData);
    _r = Mat(r);
  }

  /// The orthogonal factor $Q$ ($M \times M$, $Q^\top Q = I$).
  Mat get q => _q;

  /// The upper trapezoidal factor $R$ ($M \times N$).
  Mat get r => _r;

  /// Solves the linear system (or least-squares problem) $Ax = b$.
  ///
  /// Computes $x = R^{-1} Q^\top b$ via back substitution.
  ///
  /// Requires `b.length == a.rows`. For square full-rank systems the exact
  /// solution is returned; for overdetermined systems this gives the
  /// least-squares solution.
  ///
  /// Throws [ArgumentError] if the dimension of [b] does not match.
  Vec solve(Vec b) {
    if (b.length != _m) {
      throw ArgumentError(
        'b.length (${b.length}) must equal matrix rows ($_m)',
      );
    }
    // Compute y = Q^T * b
    final qt = _q.transpose();
    final y = List<double>.generate(_m, (i) {
      var s = 0.0;
      for (var j = 0; j < _m; j++) {
        s += qt[i][j] * b[j];
      }
      return s;
    });

    // Back substitution on the top n×n block of R
    final rData = _r.toList();
    final x = List<double>.filled(_n, 0.0);
    for (var i = _n - 1; i >= 0; i--) {
      var s = y[i];
      for (var j = i + 1; j < _n; j++) {
        s -= rData[i][j] * x[j];
      }
      if (rData[i][i].abs() < 1e-12) {
        throw StateError('matrix is rank-deficient — cannot solve');
      }
      x[i] = s / rData[i][i];
    }
    return Vec(x);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cholesky Decomposition
// ─────────────────────────────────────────────────────────────────────────────

/// Cholesky decomposition for symmetric positive-definite (SPD) matrices:
/// $A = L \cdot L^\top$.
///
/// - $L$ is a lower triangular matrix with strictly positive diagonal entries.
///
/// Faster than LU for SPD matrices ($\approx$ half the operations) and
/// numerically stable without pivoting.
///
/// ### Example
/// ```dart
/// final A = Mat([
///   [4.0,  12.0, -16.0],
///   [12.0, 37.0, -43.0],
///   [-16.0, -43.0, 98.0],
/// ]);
/// final ch = CholeskyDecomposition(A);
/// final x  = ch.solve(Vec([1.0, 0.0, 0.0]));
/// ```
///
/// Mirrors `std::linalg::cholesky_factorize` (C++26 P1673).
class CholeskyDecomposition {
  final int _n;
  late final Mat _l;

  /// Constructs the Cholesky decomposition of the SPD matrix [a].
  ///
  /// Throws [ArgumentError] if [a] is not square or is not symmetric within
  /// tolerance $10^{-9}$.
  /// Throws [StateError] if [a] is not positive-definite (a diagonal entry
  /// becomes non-positive during factorisation).
  CholeskyDecomposition(Mat a) : _n = a.rows {
    if (!a.isSquare) {
      throw ArgumentError('CholeskyDecomposition requires a square matrix');
    }
    // Symmetry check (within tolerance)
    const tol = 1e-9;
    for (var i = 0; i < _n; i++) {
      for (var j = i + 1; j < _n; j++) {
        if ((a.at(i, j) - a.at(j, i)).abs() > tol) {
          throw ArgumentError(
            'CholeskyDecomposition requires a symmetric matrix '
            '(a[$i][$j]=${a.at(i, j)}, a[$j][$i]=${a.at(j, i)})',
          );
        }
      }
    }
    _compute(a);
  }

  void _compute(Mat a) {
    final l = List.generate(_n, (_) => List<double>.filled(_n, 0.0));
    for (var i = 0; i < _n; i++) {
      for (var j = 0; j <= i; j++) {
        var sum = a.at(i, j);
        for (var k = 0; k < j; k++) {
          sum -= l[i][k] * l[j][k];
        }
        if (i == j) {
          if (sum <= 0.0) {
            throw StateError(
              'matrix is not positive-definite '
              '(non-positive pivot at diagonal index $i: $sum)',
            );
          }
          l[i][j] = math.sqrt(sum);
        } else {
          l[i][j] = sum / l[j][j];
        }
      }
    }
    _l = Mat(l);
  }

  /// The lower triangular Cholesky factor $L$ such that $A = L L^\top$.
  Mat get l => _l;

  /// Solves the linear system $Ax = b$ via forward and back substitution
  /// through $L$ and $L^\top$.
  ///
  /// Requires `b.length == n`.
  ///
  /// Throws [ArgumentError] if the dimension of [b] does not match.
  Vec solve(Vec b) {
    if (b.length != _n) {
      throw ArgumentError(
        'b.length (${b.length}) must equal matrix order ($_n)',
      );
    }
    final lData = _l.toList();

    // Forward substitution: L y = b
    final y = List<double>.of(b.toList());
    for (var i = 0; i < _n; i++) {
      for (var j = 0; j < i; j++) {
        y[i] -= lData[i][j] * y[j];
      }
      y[i] /= lData[i][i];
    }

    // Back substitution: L^T x = y
    final x = List<double>.of(y);
    for (var i = _n - 1; i >= 0; i--) {
      for (var j = i + 1; j < _n; j++) {
        x[i] -= lData[j][i] * x[j];
      }
      x[i] /= lData[i][i];
    }
    return Vec(x);
  }
}
