import 'dart:math' as math;

import 'matrix.dart';

/// An immutable, general-purpose $n$-dimensional real vector.
///
/// [Vec] represents a mathematical column vector of arbitrary length. It is
/// intentionally distinct from the collection [Vector]\<T\> — it exists
/// entirely within the linear-algebra domain and supports the full suite of
/// vector-space operations: norms, inner products, cross products, outer
/// products, and element-wise arithmetic.
///
/// All arithmetic operations return new [Vec] instances; the original is never
/// mutated.
///
/// ### Example
/// ```dart
/// final a = Vec([1.0, 2.0, 3.0]);
/// final b = Vec([4.0, 5.0, 6.0]);
/// print(a.dot(b));       // 32.0
/// print(a.norm());       // sqrt(14) ≈ 3.742
/// print(a.normalize());  // Vec([0.267, 0.535, 0.802])
/// ```
///
/// Mirrors the mathematical vector type underlying C++26 `std::linalg`.
class Vec {
  /// The underlying element storage (unmodifiable).
  final List<double> _data;

  /// Creates a [Vec] from [data].
  ///
  /// The list is copied defensively so external mutations do not affect this
  /// vector.
  ///
  /// Throws [ArgumentError] if [data] is empty.
  Vec(List<double> data) : _data = List<double>.unmodifiable(data) {
    if (data.isEmpty) {
      throw ArgumentError.value(data, 'data', 'must not be empty');
    }
  }

  /// Creates a zero vector of dimension [n].
  ///
  /// Every element is `0.0`.
  ///
  /// Throws [ArgumentError] if [n] is less than 1.
  factory Vec.zeros(int n) {
    if (n < 1) throw ArgumentError.value(n, 'n', 'must be >= 1');
    return Vec(List<double>.filled(n, 0.0));
  }

  /// Creates a ones vector of dimension [n].
  ///
  /// Every element is `1.0`.
  ///
  /// Throws [ArgumentError] if [n] is less than 1.
  factory Vec.ones(int n) {
    if (n < 1) throw ArgumentError.value(n, 'n', 'must be >= 1');
    return Vec(List<double>.filled(n, 1.0));
  }

  /// Creates a constant vector of dimension [n] where every element equals [v].
  ///
  /// Throws [ArgumentError] if [n] is less than 1.
  factory Vec.filled(int n, double v) {
    if (n < 1) throw ArgumentError.value(n, 'n', 'must be >= 1');
    return Vec(List<double>.filled(n, v));
  }

  /// Creates the $i$-th standard basis vector $e_i$ of dimension [n].
  ///
  /// The element at index [i] is `1.0`; all others are `0.0`.
  ///
  /// Throws [ArgumentError] if [n] is less than 1 or if [i] is out of
  /// `[0, n)`.
  factory Vec.basis(int n, int i) {
    if (n < 1) throw ArgumentError.value(n, 'n', 'must be >= 1');
    if (i < 0 || i >= n) {
      throw ArgumentError.value(i, 'i', 'must be in [0, $n)');
    }
    final data = List<double>.filled(n, 0.0);
    data[i] = 1.0;
    return Vec(data);
  }

  /// The dimension (number of elements) of this vector.
  int get length => _data.length;

  /// Whether this vector has zero elements (always `false` — construction
  /// guards against empty vectors).
  bool get isEmpty => _data.isEmpty;

  /// Returns the element at [index].
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  double operator [](int index) => _data[index];

  // ── Arithmetic ───────────────────────────────────────────────────────────────

  /// Returns the element-wise sum of this vector and [other].
  ///
  /// Throws [ArgumentError] if the dimensions differ.
  Vec operator +(Vec other) {
    _checkSameDimension(other);
    return Vec(List<double>.generate(length, (i) => _data[i] + other._data[i]));
  }

  /// Returns the element-wise difference of this vector and [other].
  ///
  /// Throws [ArgumentError] if the dimensions differ.
  Vec operator -(Vec other) {
    _checkSameDimension(other);
    return Vec(List<double>.generate(length, (i) => _data[i] - other._data[i]));
  }

  /// Returns the additive inverse of this vector.
  Vec operator -() => Vec(List<double>.generate(length, (i) => -_data[i]));

  /// Returns this vector scaled by the scalar [s].
  Vec operator *(double s) =>
      Vec(List<double>.generate(length, (i) => _data[i] * s));

  /// Returns this vector divided by the scalar [s].
  ///
  /// Throws [ArgumentError] if [s] is zero.
  Vec operator /(double s) {
    if (s == 0.0) throw ArgumentError.value(s, 's', 'divisor must not be zero');
    return Vec(List<double>.generate(length, (i) => _data[i] / s));
  }

  // ── Products ─────────────────────────────────────────────────────────────────

  /// Computes the inner (dot) product $\mathbf{this} \cdot \mathbf{other}$.
  ///
  /// Equivalent to `sum_i (this[i] * other[i])`.
  ///
  /// Throws [ArgumentError] if the dimensions differ.
  double dot(Vec other) {
    _checkSameDimension(other);
    var result = 0.0;
    for (var i = 0; i < length; i++) {
      result += _data[i] * other._data[i];
    }
    return result;
  }

  /// Computes the cross product $\mathbf{this} \times \mathbf{other}$ in
  /// $\mathbb{R}^3$.
  ///
  /// Returns a new [Vec] orthogonal to both operands following the right-hand
  /// rule.
  ///
  /// Throws [ArgumentError] if either vector is not 3-dimensional.
  Vec cross(Vec other) {
    if (length != 3 || other.length != 3) {
      throw ArgumentError('cross product is only defined for 3D vectors');
    }
    return Vec([
      _data[1] * other._data[2] - _data[2] * other._data[1],
      _data[2] * other._data[0] - _data[0] * other._data[2],
      _data[0] * other._data[1] - _data[1] * other._data[0],
    ]);
  }

  /// Computes the outer (tensor) product $\mathbf{this} \, \mathbf{other}^\top$.
  ///
  /// Returns a `(this.length × other.length)` [Mat].
  Mat outer(Vec other) {
    final rows = List<List<double>>.generate(
      length,
      (i) =>
          List<double>.generate(other.length, (j) => _data[i] * other._data[j]),
    );
    return Mat(rows);
  }

  // ── Norms ────────────────────────────────────────────────────────────────────

  /// Computes the $L^p$ norm of this vector.
  ///
  /// - `p == 1` → $\|\mathbf{x}\|_1 = \sum_i |x_i|$
  /// - `p == 2` (default) → $\|\mathbf{x}\|_2 = \sqrt{\sum_i x_i^2}$
  /// - `p == 0` treated as $L^\infty$ → $\max_i |x_i|$
  ///
  /// Throws [ArgumentError] if [p] is negative.
  double norm([int p = 2]) {
    if (p < 0) throw ArgumentError.value(p, 'p', 'must be >= 0');
    if (p == 0) {
      // L-infinity norm
      return _data.fold(0.0, (acc, x) => math.max(acc, x.abs()));
    }
    if (p == 1) {
      return _data.fold(0.0, (acc, x) => acc + x.abs());
    }
    if (p == 2) {
      return math.sqrt(_data.fold(0.0, (acc, x) => acc + x * x));
    }
    final dp = p.toDouble();
    return math.pow(
          _data.fold(0.0, (acc, x) => acc + math.pow(x.abs(), dp)),
          1.0 / dp,
        )
        as double;
  }

  /// Returns the unit vector in the same direction as this vector.
  ///
  /// Throws [StateError] if this is a zero vector (norm is zero).
  Vec normalize() {
    final n = norm();
    if (n == 0.0) throw StateError('cannot normalize a zero vector');
    return this / n;
  }

  // ── Utilities ────────────────────────────────────────────────────────────────

  /// Returns a modifiable copy of the underlying data as a [List<double>].
  List<double> toList() => List<double>.of(_data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vec) return false;
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (_data[i] != other._data[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_data);

  @override
  String toString() {
    final elems = _data.map((e) => e.toStringAsFixed(4)).join(', ');
    return 'Vec([$elems])';
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  void _checkSameDimension(Vec other) {
    if (length != other.length) {
      throw ArgumentError('dimension mismatch: $length vs ${other.length}');
    }
  }
}
