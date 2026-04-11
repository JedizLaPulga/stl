import 'dart:collection';

/// A view that drops the first [count] elements of an iterable.
/// Mimics C++ `std::views::drop`.
class DropRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final int _count;

  /// Creates a [DropRange] that skips the first [_count] elements of [_iterable].
  DropRange(this._iterable, this._count) {
    if (_count < 0) {
      throw ArgumentError.value(_count, 'count', 'Must be greater than or equal to zero');
    }
  }

  @override
  Iterator<T> get iterator => _DropRangeIterator<T>(_iterable.iterator, _count);
}

class _DropRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final int _count;
  bool _skipped = false;

  _DropRangeIterator(this._iterator, this._count);

  @override
  T get current => _iterator.current;

  @override
  bool moveNext() {
    if (!_skipped) {
      _skipped = true;
      for (var i = 0; i < _count; i++) {
        if (!_iterator.moveNext()) {
          return false;
        }
      }
    }
    return _iterator.moveNext();
  }
}
