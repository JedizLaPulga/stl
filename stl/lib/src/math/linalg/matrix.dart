import 'dart:math' as math;

import 'vec.dart';

/// An immutable, general-purpose M×N real matrix stored in row-major order.
///
/// [Mat] supports arbitrary dimensions and provides the standard matrix-space
/// operations: arithmetic, transposition, block extraction, norms, determinant,
/// and inverse. Decompositions (LU, QR, Cholesky) are provided as separate
/// classes in `decomposition.dart` for composability.
///
/// All operations return new [Mat] instances; the original is never mutated.
///
/// ### Example
/// ```dart
/// final A = Mat.identity(3);
/// final B = Mat([
///   [1.0, 2.0, 0.0],
///   [0.0, 3.0, 4.0],
///   [0.0, 0.0, 5.0],
/// ]);
/// print(B.determinant()); // 15.0
/// print(B.transpose());
/// ```
///
/// Mirrors the general dense matrix concept underlying C++26 `std::linalg`.
class Mat {
  /// Internal storage: `_data[i][j]` is row *i*, column *j*.
  final List<List<double>> _data;

  /// The number of rows.
  final int rows;

  /// The number of columns.
  final int cols;

  /// Creates a [Mat] from a row-major list-of-lists.
  ///
  /// The data is copied defensively. Every inner list must have the same
  /// length.
  ///
  /// Throws [ArgumentError] if [data] is empty, any row is empty, or row
  /// lengths are inconsistent.
  Mat(List<List<double>> data)
    : rows = data.length,
      cols = data.isEmpty ? 0 : data.first.length,
      _data = _copyData(data) {
    if (data.isEmpty) throw ArgumentError('data must not be empty');
    final c = data.first.length;
    if (c == 0) throw ArgumentError('rows must not be empty');
    for (var i = 1; i < data.length; i++) {
      if (data[i].length != c) {
        throw ArgumentError(
          'all rows must have the same length; row 0 has $c, row $i has ${data[i].length}',
        );
      }
    }
  }

  /// Creates an M×N zero matrix.
  ///
  /// Throws [ArgumentError] if [r] or [c] is less than 1.
  factory Mat.zeros(int r, int c) {
    _checkDims(r, c);
    return Mat(List.generate(r, (_) => List<double>.filled(c, 0.0)));
  }

  /// Creates the $n \times n$ identity matrix $I_n$.
  ///
  /// Throws [ArgumentError] if [n] is less than 1.
  factory Mat.identity(int n) {
    if (n < 1) throw ArgumentError.value(n, 'n', 'must be >= 1');
    return Mat(
      List.generate(n, (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0)),
    );
  }

  /// Creates an M×N matrix where every element equals [v].
  ///
  /// Throws [ArgumentError] if [r] or [c] is less than 1.
  factory Mat.filled(int r, int c, double v) {
    _checkDims(r, c);
    return Mat(List.generate(r, (_) => List<double>.filled(c, v)));
  }

  /// Creates a square diagonal matrix from [diag].
  ///
  /// Off-diagonal elements are zero. The matrix dimension equals
  /// `diag.length`.
  ///
  /// Throws [ArgumentError] if [diag] is empty.
  factory Mat.diagonal(List<double> diag) {
    if (diag.isEmpty) throw ArgumentError('diag must not be empty');
    final n = diag.length;
    return Mat(
      List.generate(n, (i) => List.generate(n, (j) => i == j ? diag[i] : 0.0)),
    );
  }

  /// Creates a matrix whose *columns* are the given [vectors].
  ///
  /// All vectors must have the same length (dimension). The resulting matrix
  /// has `vectors.first.length` rows and `vectors.length` columns.
  ///
  /// Throws [ArgumentError] if [vectors] is empty or vector lengths differ.
  factory Mat.fromColumns(List<Vec> vectors) {
    if (vectors.isEmpty) throw ArgumentError('vectors must not be empty');
    final r = vectors.first.length;
    for (var i = 1; i < vectors.length; i++) {
      if (vectors[i].length != r) {
        throw ArgumentError('all vectors must have the same length');
      }
    }
    return Mat(
      List.generate(
        r,
        (i) => List.generate(vectors.length, (j) => vectors[j][i]),
      ),
    );
  }

  /// Creates a matrix whose *rows* are the given [vectors].
  ///
  /// All vectors must have the same length (dimension). The resulting matrix
  /// has `vectors.length` rows and `vectors.first.length` columns.
  ///
  /// Throws [ArgumentError] if [vectors] is empty or vector lengths differ.
  factory Mat.fromRows(List<Vec> vectors) {
    if (vectors.isEmpty) throw ArgumentError('vectors must not be empty');
    final c = vectors.first.length;
    for (var i = 1; i < vectors.length; i++) {
      if (vectors[i].length != c) {
        throw ArgumentError('all vectors must have the same length');
      }
    }
    return Mat(List.generate(vectors.length, (i) => vectors[i].toList()));
  }

  // ── Properties ───────────────────────────────────────────────────────────────

  /// Whether this matrix is square ($rows == cols$).
  bool get isSquare => rows == cols;

  /// Whether this matrix is symmetric ($A = A^\top$).
  ///
  /// Always `false` for non-square matrices. Uses exact floating-point
  /// equality; for numerical purposes consider checking with a tolerance.
  bool get isSymmetric {
    if (!isSquare) return false;
    for (var i = 0; i < rows; i++) {
      for (var j = i + 1; j < cols; j++) {
        if (_data[i][j] != _data[j][i]) return false;
      }
    }
    return true;
  }

  /// Whether this matrix is diagonal (all off-diagonal elements are zero).
  ///
  /// Always `false` for non-square matrices.
  bool get isDiagonal {
    if (!isSquare) return false;
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (i != j && _data[i][j] != 0.0) return false;
      }
    }
    return true;
  }

  // ── Element access ───────────────────────────────────────────────────────────

  /// Returns the [i]-th row as an unmodifiable `List<double>`.
  ///
  /// Throws [RangeError] if [i] is out of bounds.
  List<double> operator [](int i) => _data[i];

  /// Returns the element at row [r], column [c].
  ///
  /// Throws [RangeError] if either index is out of bounds.
  double at(int r, int c) => _data[r][c];

  /// Returns the [i]-th row as a [Vec].
  ///
  /// Throws [RangeError] if [i] is out of bounds.
  Vec row(int i) {
    RangeError.checkValidIndex(i, _data, 'i', rows);
    return Vec(_data[i]);
  }

  /// Returns the [j]-th column as a [Vec].
  ///
  /// Throws [RangeError] if [j] is out of bounds.
  Vec col(int j) {
    RangeError.checkValidIndex(j, _data.first, 'j', cols);
    return Vec(List.generate(rows, (i) => _data[i][j]));
  }

  // ── Arithmetic ───────────────────────────────────────────────────────────────

  /// Returns the element-wise sum of this matrix and [other].
  ///
  /// Throws [ArgumentError] if dimensions differ.
  Mat operator +(Mat other) {
    _checkSameDims(other);
    return Mat(
      List.generate(
        rows,
        (i) => List.generate(cols, (j) => _data[i][j] + other._data[i][j]),
      ),
    );
  }

  /// Returns the element-wise difference of this matrix and [other].
  ///
  /// Throws [ArgumentError] if dimensions differ.
  Mat operator -(Mat other) {
    _checkSameDims(other);
    return Mat(
      List.generate(
        rows,
        (i) => List.generate(cols, (j) => _data[i][j] - other._data[i][j]),
      ),
    );
  }

  /// Returns the additive inverse of this matrix.
  Mat operator -() =>
      Mat(List.generate(rows, (i) => List.generate(cols, (j) => -_data[i][j])));

  /// Returns the matrix product $\mathbf{this} \cdot \mathbf{other}$.
  ///
  /// Requires `this.cols == other.rows`.
  ///
  /// Throws [ArgumentError] if the inner dimensions do not match.
  Mat operator *(Mat other) {
    if (cols != other.rows) {
      throw ArgumentError(
        'inner dimensions must match for multiplication: ($rows×$cols) * (${other.rows}×${other.cols})',
      );
    }
    final result = List.generate(
      rows,
      (i) => List.generate(other.cols, (j) {
        var sum = 0.0;
        for (var k = 0; k < cols; k++) {
          sum += _data[i][k] * other._data[k][j];
        }
        return sum;
      }),
    );
    return Mat(result);
  }

  /// Returns this matrix scaled by the scalar [s].
  Mat scaled(double s) => Mat(
    List.generate(rows, (i) => List.generate(cols, (j) => _data[i][j] * s)),
  );

  /// Returns this matrix divided by the scalar [s].
  ///
  /// Throws [ArgumentError] if [s] is zero.
  Mat divided(double s) {
    if (s == 0.0) throw ArgumentError.value(s, 's', 'divisor must not be zero');
    return Mat(
      List.generate(rows, (i) => List.generate(cols, (j) => _data[i][j] / s)),
    );
  }

  // ── Transformations ──────────────────────────────────────────────────────────

  /// Returns the transpose $A^\top$.
  Mat transpose() =>
      Mat(List.generate(cols, (i) => List.generate(rows, (j) => _data[j][i])));

  /// Extracts a submatrix starting at row [startRow], column [startCol] with
  /// [numRows] rows and [numCols] columns.
  ///
  /// Throws [RangeError] if the block exceeds the matrix bounds.
  Mat submatrix(int startRow, int startCol, int numRows, int numCols) {
    if (startRow < 0 || startRow + numRows > rows) {
      throw RangeError(
        'row range [$startRow, ${startRow + numRows}) is out of bounds for $rows rows',
      );
    }
    if (startCol < 0 || startCol + numCols > cols) {
      throw RangeError(
        'col range [$startCol, ${startCol + numCols}) is out of bounds for $cols cols',
      );
    }
    return Mat(
      List.generate(
        numRows,
        (i) => List.generate(numCols, (j) => _data[startRow + i][startCol + j]),
      ),
    );
  }

  // ── Reductions ───────────────────────────────────────────────────────────────

  /// Returns the trace $\text{tr}(A) = \sum_i a_{ii}$.
  ///
  /// Throws [StateError] if the matrix is not square.
  double trace() {
    if (!isSquare) {
      throw StateError('trace is only defined for square matrices');
    }
    var t = 0.0;
    for (var i = 0; i < rows; i++) {
      t += _data[i][i];
    }
    return t;
  }

  /// Returns the Frobenius norm $\|A\|_F = \sqrt{\sum_{i,j} a_{ij}^2}$.
  double frobenius() {
    var sum = 0.0;
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        sum += _data[i][j] * _data[i][j];
      }
    }
    return math.sqrt(sum);
  }

  // ── Derived quantities ────────────────────────────────────────────────────────

  /// Returns $\det(A)$ computed via LU factorisation.
  ///
  /// Throws [StateError] if the matrix is not square.
  double determinant() {
    if (!isSquare) {
      throw StateError('determinant is only defined for square matrices');
    }
    return _LUHelper(this).determinant();
  }

  /// Returns $A^{-1}$ computed via LU factorisation.
  ///
  /// Throws [StateError] if the matrix is not square or is singular.
  Mat inverse() {
    if (!isSquare) {
      throw StateError('inverse is only defined for square matrices');
    }
    return _LUHelper(this).inverse();
  }

  // ── Utilities ────────────────────────────────────────────────────────────────

  /// Returns a deep copy of the underlying data as a `List<List<double>>`.
  List<List<double>> toList() =>
      List.generate(rows, (i) => List<double>.of(_data[i]));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Mat) return false;
    if (rows != other.rows || cols != other.cols) return false;
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (_data[i][j] != other._data[i][j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    var h = Object.hash(rows, cols);
    for (final row in _data) {
      h = Object.hashAll([h, ...row]);
    }
    return h;
  }

  @override
  String toString() {
    final sb = StringBuffer('Mat([\n');
    for (final r in _data) {
      sb.write('  [${r.map((e) => e.toStringAsFixed(4)).join(', ')}],\n');
    }
    sb.write('])');
    return sb.toString();
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  void _checkSameDims(Mat other) {
    if (rows != other.rows || cols != other.cols) {
      throw ArgumentError(
        'dimension mismatch: ($rows×$cols) vs (${other.rows}×${other.cols})',
      );
    }
  }

  static void _checkDims(int r, int c) {
    if (r < 1) throw ArgumentError.value(r, 'r', 'must be >= 1');
    if (c < 1) throw ArgumentError.value(c, 'c', 'must be >= 1');
  }

  static List<List<double>> _copyData(List<List<double>> data) =>
      List<List<double>>.unmodifiable(
        data.map((row) => List<double>.unmodifiable(row)),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal LU helper (used only by Mat.determinant and Mat.inverse to avoid
// a circular import with decomposition.dart).
// ─────────────────────────────────────────────────────────────────────────────

class _LUHelper {
  final int _n;
  final List<List<double>> _lu;
  final List<int> _piv;
  int _pivSign = 1;

  _LUHelper(Mat a)
    : _n = a.rows,
      _lu = a.toList(),
      _piv = List<int>.generate(a.rows, (i) => i) {
    // Crout's algorithm with partial pivoting
    for (var k = 0; k < _n; k++) {
      // Find pivot
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
      if (_lu[k][k] == 0.0) continue;
      for (var i = k + 1; i < _n; i++) {
        _lu[i][k] /= _lu[k][k];
        for (var j = k + 1; j < _n; j++) {
          _lu[i][j] -= _lu[i][k] * _lu[k][j];
        }
      }
    }
  }

  double determinant() {
    var d = _pivSign.toDouble();
    for (var k = 0; k < _n; k++) {
      d *= _lu[k][k];
    }
    return d;
  }

  Vec _solve(Vec b) {
    // Apply permutation
    final x = List<double>.generate(_n, (i) => b[_piv[i]]);
    // Forward substitution (L)
    for (var k = 0; k < _n; k++) {
      for (var i = k + 1; i < _n; i++) {
        x[i] -= _lu[i][k] * x[k];
      }
    }
    // Back substitution (U)
    for (var k = _n - 1; k >= 0; k--) {
      if (_lu[k][k].abs() < 1e-12) {
        throw StateError('matrix is singular');
      }
      x[k] /= _lu[k][k];
      for (var i = 0; i < k; i++) {
        x[i] -= _lu[i][k] * x[k];
      }
    }
    return Vec(x);
  }

  Mat inverse() {
    final cols = <Vec>[];
    for (var j = 0; j < _n; j++) {
      final e = Vec(List.generate(_n, (i) => i == j ? 1.0 : 0.0));
      cols.add(_solve(e));
    }
    return Mat.fromColumns(cols);
  }
}
