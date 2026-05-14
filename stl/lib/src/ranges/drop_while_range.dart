import 'dart:collection';

/// A view that skips elements from the front of an iterable while [predicate]
/// returns `true`, then yields all remaining elements unchanged.
///
/// Mirrors C++20 `std::views::drop_while`.
///
/// The skip phase runs exactly once per iterator instance. Once the predicate
/// first fails, every subsequent element is emitted — including elements that
/// would again satisfy the predicate. This is the key distinction from
/// [FilterRange], which continues testing every element throughout iteration.
///
/// Example:
/// ```dart
/// final data = [2, 4, 6, 7, 8, 10];
/// final fromOdd = DropWhileRange(data, (n) => n.isEven);
/// print(fromOdd.toList()); // [7, 8, 10]
/// ```
class DropWhileRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final bool Function(T) _predicate;

  /// Creates a [DropWhileRange] that skips leading elements of [_iterable]
  /// while [_predicate] returns `true`, then yields all remaining elements.
  DropWhileRange(this._iterable, this._predicate);

  @override
  Iterator<T> get iterator =>
      _DropWhileRangeIterator<T>(_iterable.iterator, _predicate);
}

class _DropWhileRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final bool Function(T) _predicate;
  bool _skipping = true;

  _DropWhileRangeIterator(this._iterator, this._predicate);

  @override
  T get current => _iterator.current;

  @override
  bool moveNext() {
    if (_skipping) {
      while (_iterator.moveNext()) {
        if (!_predicate(_iterator.current)) {
          _skipping = false;
          return true;
        }
      }
      _skipping = false;
      return false;
    }
    return _iterator.moveNext();
  }
}
