import 'dart:math' as math;

import 'matrix.dart';
import 'vec.dart';

/// The result of an eigenvalue decomposition.
///
/// Holds the real eigenvalues and the corresponding eigenvectors of a real
/// matrix. The eigenvalues are stored in [eigenvalues] and the matching
/// eigenvectors are the *columns* of [eigenvectors].
///
/// `eigenvectors.col(i)` is the normalised eigenvector corresponding to
/// `eigenvalues[i]`.
class EigenResult {
  /// The eigenvalues, ordered from largest to smallest absolute value.
  final List<double> eigenvalues;

  /// The eigenvectors as columns. `eigenvectors.col(i)` corresponds to
  /// `eigenvalues[i]`.
  final Mat eigenvectors;

  /// Creates an [EigenResult] from a list of eigenvalues and an eigenvector
  /// matrix.
  const EigenResult({required this.eigenvalues, required this.eigenvectors});

  @override
  String toString() => 'EigenResult(λ=$eigenvalues)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Power Iteration
// ─────────────────────────────────────────────────────────────────────────────

/// Finds the *dominant* eigenvalue and corresponding eigenvector of [a] using
/// the power iteration method.
///
/// Convergence is guaranteed when the dominant eigenvalue has a strictly
/// larger absolute value than all others. The algorithm terminates when the
/// change in the estimated eigenvalue drops below [tol] or after [maxIter]
/// iterations.
///
/// Returns a record `(eigenvalue, eigenvector)`.
///
/// Parameters:
/// - [a] — square real matrix.
/// - [maxIter] — maximum number of iterations (default 1000).
/// - [tol] — convergence tolerance (default `1e-10`).
///
/// Throws [ArgumentError] if [a] is not square.
///
/// Complexity: $O(k \cdot n^2)$ where $k$ is the number of iterations.
///
/// Mirrors the concept behind `std::linalg` power-method utilities.
(double, Vec) powerIteration(Mat a, {int maxIter = 1000, double tol = 1e-10}) {
  if (!a.isSquare) throw ArgumentError('powerIteration: matrix must be square');
  final n = a.rows;

  // Start with a non-zero vector (use the first standard basis vector)
  var b = Vec(List<double>.generate(n, (i) => i == 0 ? 1.0 : 0.0));
  var eigenvalue = 0.0;

  for (var iter = 0; iter < maxIter; iter++) {
    // Multiply: Ab
    final ab = _matVecMul(a, b);
    // Estimate eigenvalue (Rayleigh quotient)
    final newEigenvalue = b.dot(ab);
    // Normalise
    final normAb = ab.norm();
    if (normAb < 1e-14) break; // zero result, already converged or degenerate
    final newB = ab / normAb;
    if ((newEigenvalue - eigenvalue).abs() < tol) {
      eigenvalue = newEigenvalue;
      b = newB;
      break;
    }
    eigenvalue = newEigenvalue;
    b = newB;
  }
  return (eigenvalue, b);
}

// ─────────────────────────────────────────────────────────────────────────────
// Jacobi Method for Symmetric Matrices
// ─────────────────────────────────────────────────────────────────────────────

/// Computes *all* eigenvalues and eigenvectors of a real *symmetric* matrix
/// using the classical Jacobi method (cyclic Jacobi sweeps).
///
/// The algorithm iteratively annihilates off-diagonal elements via Givens
/// rotations until convergence. For symmetric matrices this is guaranteed to
/// converge.
///
/// Returns an [EigenResult] with eigenvalues sorted in descending order of
/// magnitude.
///
/// Parameters:
/// - [a] — real symmetric square matrix.
/// - [maxIter] — maximum number of Jacobi sweeps (default 1000).
/// - [tol] — off-diagonal convergence tolerance (default `1e-10`).
///
/// Throws [ArgumentError] if [a] is not square or not symmetric (within
/// tolerance $10^{-9}$).
///
/// Complexity: $O(k \cdot n^2)$ per sweep.
///
/// Mirrors the intent of `std::linalg::symmetric_eigensystem` (C++26).
EigenResult symmetricEigen(Mat a, {int maxIter = 1000, double tol = 1e-10}) {
  if (!a.isSquare) throw ArgumentError('symmetricEigen: matrix must be square');
  const symTol = 1e-9;
  for (var i = 0; i < a.rows; i++) {
    for (var j = i + 1; j < a.cols; j++) {
      if ((a.at(i, j) - a.at(j, i)).abs() > symTol) {
        throw ArgumentError('symmetricEigen: matrix must be symmetric');
      }
    }
  }

  final n = a.rows;
  // Working copy of the matrix
  final d = a.toList();
  // Accumulate eigenvectors (start as identity)
  final v = List.generate(
    n,
    (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0),
  );

  for (var iter = 0; iter < maxIter; iter++) {
    // Find the largest off-diagonal element
    var maxOff = 0.0;
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        if (d[i][j].abs() > maxOff) maxOff = d[i][j].abs();
      }
    }
    if (maxOff < tol) break;

    // Cyclic sweep: annihilate each off-diagonal pair (p, q)
    for (var p = 0; p < n - 1; p++) {
      for (var q = p + 1; q < n; q++) {
        if (d[p][q].abs() < tol * 1e-2) continue;
        // Compute rotation angle
        final theta = 0.5 * (d[q][q] - d[p][p]) / d[p][q];
        final t =
            (theta >= 0 ? 1.0 : -1.0) /
            (theta.abs() + math.sqrt(1.0 + theta * theta));
        final c = 1.0 / math.sqrt(1.0 + t * t);
        final s = t * c;

        // Apply Jacobi rotation: D = J^T D J
        final dpp = d[p][p];
        final dqq = d[q][q];
        final dpq = d[p][q];
        d[p][p] = dpp - t * dpq;
        d[q][q] = dqq + t * dpq;
        d[p][q] = 0.0;
        d[q][p] = 0.0;
        for (var r = 0; r < n; r++) {
          if (r == p || r == q) continue;
          final drp = d[r][p];
          final drq = d[r][q];
          d[r][p] = c * drp - s * drq;
          d[p][r] = d[r][p];
          d[r][q] = s * drp + c * drq;
          d[q][r] = d[r][q];
        }

        // Update eigenvector matrix V = V * J
        for (var r = 0; r < n; r++) {
          final vrp = v[r][p];
          final vrq = v[r][q];
          v[r][p] = c * vrp - s * vrq;
          v[r][q] = s * vrp + c * vrq;
        }
      }
    }
  }

  // Extract eigenvalues from diagonal and sort by descending absolute value
  final indexed = List.generate(n, (i) => (d[i][i], i));
  indexed.sort((a, b) => b.$1.abs().compareTo(a.$1.abs()));

  final eigenvalues = indexed.map((e) => e.$1).toList();
  final eigenvectors = Mat.fromColumns(
    indexed.map((e) => Vec(List.generate(n, (i) => v[i][e.$2]))).toList(),
  );
  return EigenResult(eigenvalues: eigenvalues, eigenvectors: eigenvectors);
}

// ─────────────────────────────────────────────────────────────────────────────
// QR Algorithm for General Real Matrices
// ─────────────────────────────────────────────────────────────────────────────

/// Computes the eigenvalues of a general real matrix [a] using the QR
/// algorithm with Wilkinson shifts.
///
/// Iteratively decomposes the matrix via QR and accumulates the product
/// $A \leftarrow R \cdot Q$ until the matrix converges to quasi-upper
/// triangular (Schur) form. The eigenvalues appear on the diagonal.
///
/// Returns an [EigenResult]. For non-symmetric matrices the eigenvectors are
/// an approximation computed from the Schur form; for symmetric inputs
/// prefer [symmetricEigen] which is faster and more accurate.
///
/// Parameters:
/// - [a] — real square matrix.
/// - [maxIter] — maximum number of QR iterations (default 1000).
/// - [tol] — sub-diagonal convergence tolerance (default `1e-10`).
///
/// Throws [ArgumentError] if [a] is not square.
///
/// Complexity: $O(k \cdot n^3)$ per iteration.
EigenResult qrEigen(Mat a, {int maxIter = 1000, double tol = 1e-10}) {
  if (!a.isSquare) throw ArgumentError('qrEigen: matrix must be square');
  final n = a.rows;

  // Working copy; V accumulates the transformation (starts as identity)
  var current = a.toList();
  var vData = List.generate(
    n,
    (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0),
  );

  for (var iter = 0; iter < maxIter; iter++) {
    // Wilkinson shift: use eigenvalue of the bottom-right 2×2 submatrix
    // closest to current[n-1][n-1].
    double shift = 0.0;
    if (n >= 2) {
      final a11 = current[n - 2][n - 2];
      final a12 = current[n - 2][n - 1];
      final a21 = current[n - 1][n - 2];
      final a22 = current[n - 1][n - 1];
      final prod = a12 * a21;
      if (prod.abs() < 1e-14) {
        // No off-diagonal coupling — trivial shift.
        shift = a22;
      } else {
        final delta = (a11 - a22) / 2.0;
        final sign = delta >= 0 ? 1.0 : -1.0;
        shift =
            a22 - sign * prod / (delta.abs() + math.sqrt(delta * delta + prod));
      }
    }

    // Shift: A - shift*I
    final shifted = List.generate(
      n,
      (i) => List.generate(n, (j) {
        return current[i][j] - (i == j ? shift : 0.0);
      }),
    );

    // QR decomposition of shifted matrix (using Givens rotations for efficiency)
    final (q, r) = _qrGivens(shifted, n);

    // Update: A = R * Q + shift * I
    final rq = _matMul(r, q, n, n, n);
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        current[i][j] = rq[i][j] + (i == j ? shift : 0.0);
      }
    }

    // Accumulate eigenvectors: V = V * Q
    vData = _matMul(vData, q, n, n, n);

    // Check convergence: all sub-diagonal elements small
    var converged = true;
    for (var i = 1; i < n; i++) {
      if (current[i][i - 1].abs() > tol) {
        converged = false;
        break;
      }
    }
    if (converged) break;
  }

  // Eigenvalues are on the diagonal
  final eigenvalues = List.generate(n, (i) => current[i][i]);
  // Sort by descending absolute value
  final indexed = List.generate(n, (i) => (eigenvalues[i], i));
  indexed.sort((a, b) => b.$1.abs().compareTo(a.$1.abs()));

  final sortedEigenvalues = indexed.map((e) => e.$1).toList();
  final eigenvectors = Mat.fromColumns(
    indexed.map((e) => Vec(List.generate(n, (i) => vData[i][e.$2]))).toList(),
  );
  return EigenResult(
    eigenvalues: sortedEigenvalues,
    eigenvectors: eigenvectors,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Matrix-vector multiply (for internal use, avoids constructing Mat/Vec).
Vec _matVecMul(Mat a, Vec x) {
  return Vec(
    List<double>.generate(a.rows, (i) {
      var s = 0.0;
      for (var j = 0; j < a.cols; j++) {
        s += a.at(i, j) * x[j];
      }
      return s;
    }),
  );
}

/// Dense matrix multiply on raw lists.
List<List<double>> _matMul(
  List<List<double>> a,
  List<List<double>> b,
  int m,
  int k,
  int n2,
) {
  final c = List.generate(m, (_) => List<double>.filled(n2, 0.0));
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n2; j++) {
      for (var l = 0; l < k; l++) {
        c[i][j] += a[i][l] * b[l][j];
      }
    }
  }
  return c;
}

/// QR decomposition via Givens rotations (returns raw list-of-lists).
(List<List<double>>, List<List<double>>) _qrGivens(
  List<List<double>> a,
  int n,
) {
  // Q starts as identity
  final q = List.generate(
    n,
    (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0),
  );
  // R starts as copy of a
  final r = List.generate(n, (i) => List<double>.of(a[i]));

  for (var j = 0; j < n; j++) {
    for (var i = n - 1; i > j; i--) {
      final a0 = r[i - 1][j];
      final b0 = r[i][j];
      final norm = math.sqrt(a0 * a0 + b0 * b0);
      if (norm < 1e-14) continue;
      final c = a0 / norm;
      final s = -b0 / norm;
      // Apply Givens to R (rows i-1 and i)
      for (var k = 0; k < n; k++) {
        final rk1 = r[i - 1][k];
        final rk2 = r[i][k];
        r[i - 1][k] = c * rk1 - s * rk2;
        r[i][k] = s * rk1 + c * rk2;
      }
      // Apply Givens to Q (columns i-1 and i)
      for (var k = 0; k < n; k++) {
        final qk1 = q[k][i - 1];
        final qk2 = q[k][i];
        q[k][i - 1] = c * qk1 - s * qk2;
        q[k][i] = s * qk1 + c * qk2;
      }
    }
  }
  return (q, r);
}
