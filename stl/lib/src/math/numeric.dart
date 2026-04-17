/// Dart implementations of C++ `<numeric>` algorithms.
///
/// Provides two extensions:
/// - [NumericIterableExtension] — adds [accumulate], [innerProduct],
///   [adjacentDifference], [partialSum], and [cppReduce] to any [Iterable].
/// - [NumericListExtension] — adds [iota] to any [List].
library math_numeric;

extension NumericIterableExtension<T> on Iterable<T> {
  /// Sums up or folds the elements in the range, starting with [init].
  ///
  /// Similar to `std::accumulate`. The default operation is addition,
  /// but a custom [op] can be provided. Note that if no custom [op] is provided,
  /// `T` must support the `+` operator.
  T accumulate(T init, [T Function(T, T)? op]) {
    op ??= (T a, T b) => ((a as dynamic) + (b as dynamic)) as T;
    return fold(init, op);
  }

  /// Computes the inner product (dot product) of two ranges.
  ///
  /// Similar to `std::inner_product`. The default sums the products of corresponding elements.
  /// [op1] accumulates the results (default `+`), and [op2] computes the product (default `*`).
  T innerProduct(
    Iterable<T> other,
    T init, {
    T Function(T, T)? op1,
    T Function(T, T)? op2,
  }) {
    op1 ??= (T a, T b) => ((a as dynamic) + (b as dynamic)) as T;
    op2 ??= (T a, T b) => ((a as dynamic) * (b as dynamic)) as T;

    var it1 = iterator;
    var it2 = other.iterator;
    T result = init;
    while (it1.moveNext() && it2.moveNext()) {
      result = op1(result, op2(it1.current, it2.current));
    }
    return result;
  }

  /// Computes the differences between adjacent elements.
  ///
  /// Similar to `std::adjacent_difference`. The first element is copied as-is,
  /// then each subsequent element is `op(current, previous)`. Default [op] is `-`.
  List<T> adjacentDifference([T Function(T, T)? op]) {
    op ??= (T a, T b) => ((a as dynamic) - (b as dynamic)) as T;
    var result = <T>[];
    var it = iterator;
    if (!it.moveNext()) return result;

    result.add(it.current);
    var prev = it.current;
    while (it.moveNext()) {
      var val = it.current;
      result.add(op(val, prev));
      prev = val;
    }
    return result;
  }

  /// Computes the prefix sums (partial sums).
  ///
  /// Similar to `std::partial_sum`. The first element is copied as-is.
  /// Each subsequent element is `op(sum, current)`. Default [op] is `+`.
  List<T> partialSum([T Function(T, T)? op]) {
    op ??= (T a, T b) => ((a as dynamic) + (b as dynamic)) as T;
    var result = <T>[];
    var it = iterator;
    if (!it.moveNext()) return result;

    var sum = it.current;
    result.add(sum);
    while (it.moveNext()) {
      sum = op(sum, it.current);
      result.add(sum);
    }
    return result;
  }

  /// Computes a result using an operation over the elements.
  ///
  /// Similar to `std::reduce`. The difference in C++ is that `std::reduce` can be executed out of order,
  /// but here it operates sequentially unless parallelized. It differs from Dart's `reduce` only
  /// by defaulting the [op] to addition if not provided.
  ///
  /// Throws a [StateError] if the iterable is empty.
  T cppReduce([T Function(T, T)? op]) {
    op ??= (T a, T b) => ((a as dynamic) + (b as dynamic)) as T;
    return reduce(op);
  }
}

/// Extension providing numeric operations on Lists.
extension NumericListExtension<T> on List<T> {
  /// Fills the list with successively increasing values, starting with [value].
  ///
  /// Similar to `std::iota`. Each element is produced by calling [step] on the
  /// previous value. If [step] is not provided, it defaults to incrementing by `1`.
  /// Example: given a list of length 3 and `value = 5`, produces `[5, 6, 7]`.
  void iota(T value, [T Function(T)? step]) {
    step ??= (T val) => ((val as dynamic) + 1) as T;
    var current = value;
    for (int i = 0; i < length; i++) {
      this[i] = current;
      current = step(current);
    }
  }
}
