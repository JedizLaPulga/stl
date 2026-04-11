import 'dart:collection';

/// A view that yields up to the first [count] elements of an iterable.
/// Mimics C++ `std::views::take`.
class TakeRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final int _count;

  TakeRange(this._iterable, this._count) {
    if (_count < 0) {
      throw ArgumentError.value(_count, 'count', 'Must be greater than or equal to zero');
    }
  }

  @override
  Iterator<T> get iterator => _TakeRangeIterator<T>(_iterable.iterator, _count);
}

class _TakeRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final int _count;
  int _currentCount = 0;
  T? _current;

  _TakeRangeIterator(this._iterator, this._count);

  @override
  T get current {
    if (_currentCount == 0 || _currentCount > _count) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    if (_currentCount < _count && _iterator.moveNext()) {
      _current = _iterator.current;
      _currentCount++;
      return true;
    }
    _current = null;
    return false;
  }
}
