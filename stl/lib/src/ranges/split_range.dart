import 'dart:collection';

/// A view that splits an iterable on a delimiter element, yielding each
/// segment as a `List<T>`.
/// Mimics C++ `std::views::split` (C++23).
///
/// Equality is determined via `==`. Consecutive delimiters produce empty
/// list segments. A trailing delimiter produces a final empty list. An empty
/// source yields one empty list — the same behaviour as C++ `std::views::split`.
///
/// Example:
/// ```dart
/// SplitRange([1, 0, 2, 3, 0, 4], 0).toList();
/// // [[1], [2, 3], [4]]
///
/// SplitRange([0, 1, 0], 0).toList();
/// // [[], [1], []]
/// ```
class SplitRange<T> extends IterableBase<List<T>> {
  final Iterable<T> _iterable;
  final T _delimiter;

  /// Creates a [SplitRange] that partitions [_iterable] whenever [_delimiter]
  /// is encountered, using `==` for equality comparisons.
  SplitRange(this._iterable, this._delimiter);

  /// Returns an iterator over the `List<T>` segments between each occurrence
  /// of [_delimiter].
  @override
  Iterator<List<T>> get iterator =>
      _SplitRangeIterator<T>(_iterable.iterator, _delimiter);
}

class _SplitRangeIterator<T> implements Iterator<List<T>> {
  final Iterator<T> _inner;
  final T _delimiter;
  List<T>? _current;
  bool _done = false;

  _SplitRangeIterator(this._inner, this._delimiter);

  /// The current segment as an unmodifiable `List<T>`.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the
  /// iterator is exhausted.
  @override
  List<T> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  /// Collects elements into the next segment up to the next [_delimiter] and
  /// returns `true`, or returns `false` when the source is exhausted.
  ///
  /// Always yields at least one segment (even for an empty source), matching
  /// the C++ `std::views::split` contract.
  @override
  bool moveNext() {
    if (_done) return false;
    final segment = <T>[];
    while (_inner.moveNext()) {
      final el = _inner.current;
      if (el == _delimiter) {
        _current = segment;
        return true;
      }
      segment.add(el);
    }
    // Source exhausted — emit the trailing segment (may be empty) and stop.
    _done = true;
    _current = segment;
    return true;
  }
}
