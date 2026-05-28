import 'matrix.dart';
import 'vec.dart';

/// BLAS-level linear algebra kernels (Level 1, 2, and 3).
///
/// These are stateless free functions mirroring the BLAS (Basic Linear Algebra
/// Subprograms) interface and the C++26 `std::linalg` (P1673) free-function
/// design. They operate on [Vec] and [Mat] values without allocating any
/// hidden mutable state.
///
/// ### Level 1 — vector/vector
/// - [dot], [nrm2], [asum], [iamax], [axpy], [scal]
///
/// ### Level 2 — matrix/vector
/// - [gemv], [ger]
///
/// ### Level 3 — matrix/matrix
/// - [gemm], [trmm]
///
/// All dimension mismatches throw [ArgumentError] with a descriptive message.

// ─────────────────────────────────────────────────────────────────────────────
// Level 1 — vector / vector
// ─────────────────────────────────────────────────────────────────────────────

/// Computes the inner (dot) product $\mathbf{x} \cdot \mathbf{y}$.
///
/// Equivalent to `sum_i x[i] * y[i]`.
///
/// Throws [ArgumentError] if the dimensions of [x] and [y] differ.
///
/// Mirrors BLAS `ddot` and `std::linalg::dot`.
double dot(Vec x, Vec y) {
  if (x.length != y.length) {
    throw ArgumentError('dot: dimension mismatch ${x.length} vs ${y.length}');
  }
  var result = 0.0;
  for (var i = 0; i < x.length; i++) {
    result += x[i] * y[i];
  }
  return result;
}

/// Computes the Euclidean ($L^2$) norm $\|\mathbf{x}\|_2$.
///
/// Mirrors BLAS `dnrm2` and `std::linalg::vector_two_norm`.
double nrm2(Vec x) => x.norm(2);

/// Computes the sum of absolute values $\|\mathbf{x}\|_1 = \sum_i |x_i|$.
///
/// Mirrors BLAS `dasum` and `std::linalg::vector_abs_sum`.
double asum(Vec x) => x.norm(1);

/// Returns the index of the element with the largest absolute value,
/// $\arg\max_i |x_i|$.
///
/// Mirrors BLAS `idamax` and `std::linalg::idx_abs_max`.
///
/// Throws [ArgumentError] if [x] is empty.
int iamax(Vec x) {
  var maxIdx = 0;
  var maxVal = x[0].abs();
  for (var i = 1; i < x.length; i++) {
    final a = x[i].abs();
    if (a > maxVal) {
      maxVal = a;
      maxIdx = i;
    }
  }
  return maxIdx;
}

/// Computes $\mathbf{y} + \alpha \mathbf{x}$ (constant times a vector plus a
/// vector).
///
/// Returns a new [Vec] = [y] + [alpha] * [x]. Neither operand is mutated.
///
/// Mirrors BLAS `daxpy` and `std::linalg::add`.
///
/// Throws [ArgumentError] if the dimensions of [x] and [y] differ.
Vec axpy(double alpha, Vec x, Vec y) {
  if (x.length != y.length) {
    throw ArgumentError('axpy: dimension mismatch ${x.length} vs ${y.length}');
  }
  return Vec(List<double>.generate(x.length, (i) => y[i] + alpha * x[i]));
}

/// Scales a vector: returns $\alpha \mathbf{x}$.
///
/// Mirrors BLAS `dscal` and `std::linalg::scale`.
Vec scal(double alpha, Vec x) => x * alpha;

// ─────────────────────────────────────────────────────────────────────────────
// Level 2 — matrix / vector
// ─────────────────────────────────────────────────────────────────────────────

/// General matrix-vector multiply:
/// $\mathbf{y} \leftarrow \alpha A \mathbf{x} + \beta \mathbf{y}$.
///
/// Parameters:
/// - [a] — M×N matrix.
/// - [x] — vector of length N.
/// - [alpha] — scalar multiplier for $A\mathbf{x}$ (default 1.0).
/// - [beta]  — scalar multiplier for [y] (default 0.0).
/// - [y]     — optional addend of length M. Treated as zero vector when `null`.
///
/// Returns a new [Vec] of length M.
///
/// Mirrors BLAS `dgemv` and `std::linalg::matrix_vector_product`.
///
/// Throws [ArgumentError] on dimension mismatch.
Vec gemv(Mat a, Vec x, {double alpha = 1.0, double beta = 0.0, Vec? y}) {
  if (x.length != a.cols) {
    throw ArgumentError(
      'gemv: x.length (${x.length}) must equal a.cols (${a.cols})',
    );
  }
  if (y != null && y.length != a.rows) {
    throw ArgumentError(
      'gemv: y.length (${y.length}) must equal a.rows (${a.rows})',
    );
  }
  return Vec(
    List<double>.generate(a.rows, (i) {
      var s = 0.0;
      for (var j = 0; j < a.cols; j++) {
        s += a.at(i, j) * x[j];
      }
      s *= alpha;
      if (beta != 0.0 && y != null) s += beta * y[i];
      return s;
    }),
  );
}

/// Rank-1 update (outer product): returns $\alpha \mathbf{x} \mathbf{y}^\top$.
///
/// The result is an M×N [Mat] where M = `x.length` and N = `y.length`.
///
/// Mirrors BLAS `dger` and `std::linalg::matrix_rank_1_update`.
Mat ger(Vec x, Vec y, {double alpha = 1.0}) {
  return Mat(
    List.generate(
      x.length,
      (i) => List.generate(y.length, (j) => alpha * x[i] * y[j]),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Level 3 — matrix / matrix
// ─────────────────────────────────────────────────────────────────────────────

/// General matrix-matrix multiply:
/// $C \leftarrow \alpha A B + \beta C$.
///
/// Parameters:
/// - [a] — M×K matrix.
/// - [b] — K×N matrix.
/// - [alpha] — scalar multiplier for $AB$ (default 1.0).
/// - [beta]  — scalar multiplier for [c] (default 0.0).
/// - [c]     — optional M×N addend. Treated as zero matrix when `null`.
///
/// Returns a new M×N [Mat].
///
/// Mirrors BLAS `dgemm` and `std::linalg::matrix_product`.
///
/// Throws [ArgumentError] on dimension mismatch.
Mat gemm(Mat a, Mat b, {double alpha = 1.0, double beta = 0.0, Mat? c}) {
  if (a.cols != b.rows) {
    throw ArgumentError(
      'gemm: a.cols (${a.cols}) must equal b.rows (${b.rows})',
    );
  }
  if (c != null && (c.rows != a.rows || c.cols != b.cols)) {
    throw ArgumentError(
      'gemm: c dimensions (${c.rows}×${c.cols}) must equal result dimensions (${a.rows}×${b.cols})',
    );
  }
  return Mat(
    List.generate(
      a.rows,
      (i) => List.generate(b.cols, (j) {
        var s = 0.0;
        for (var k = 0; k < a.cols; k++) {
          s += a.at(i, k) * b.at(k, j);
        }
        s *= alpha;
        if (beta != 0.0 && c != null) s += beta * c.at(i, j);
        return s;
      }),
    ),
  );
}

/// Triangular matrix-matrix multiply: $C \leftarrow \alpha \cdot \text{tri}(A) \cdot B$.
///
/// - [a] must be square (N×N). Only the upper triangle is read when
///   [upper] is `true`; only the lower when `false`.
/// - [b] must be N×M.
/// - Returns a new N×M [Mat].
///
/// Mirrors BLAS `dtrmm`.
///
/// Throws [ArgumentError] if [a] is not square or dimensions mismatch.
Mat trmm(Mat a, Mat b, {bool upper = true, double alpha = 1.0}) {
  if (!a.isSquare) {
    throw ArgumentError('trmm: a must be square');
  }
  if (a.cols != b.rows) {
    throw ArgumentError(
      'trmm: a.cols (${a.cols}) must equal b.rows (${b.rows})',
    );
  }
  final n = a.rows;
  final m = b.cols;
  return Mat(
    List.generate(
      n,
      (i) => List.generate(m, (j) {
        var s = 0.0;
        for (var k = 0; k < n; k++) {
          final aik = upper
              ? (k >= i ? a.at(i, k) : 0.0)
              : (k <= i ? a.at(i, k) : 0.0);
          s += aik * b.at(k, j);
        }
        return alpha * s;
      }),
    ),
  );
}
