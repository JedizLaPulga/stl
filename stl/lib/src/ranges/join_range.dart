import 'dart:collection';

/// A view that flattens an iterable of iterables into a single contiguous iterable.
/// Mimics C++ `std::views::join`.
class JoinRange<T> extends IterableBase<T> {
  final Iterable<Iterable<T>> _iterable;

  /// Creates a [JoinRange] flattening the [_iterable] of iterables.
  JoinRange(this._iterable);

  @override
  Iterator<T> get iterator => _JoinRangeIterator<T>(_iterable.iterator);
}

class _JoinRangeIterator<T> implements Iterator<T> {
  final Iterator<Iterable<T>> _outerIterator;
  Iterator<T>? _innerIterator;
  T? _current;
  bool _isInitialized = false;

  _JoinRangeIterator(this._outerIterator);

  @override
  T get current {
    if (!_isInitialized) {
      throw StateError('Iterator not initialized.');
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    _isInitialized = true;
    while (true) {
      if (_innerIterator != null && _innerIterator!.moveNext()) {
        _current = _innerIterator!.current;
        return true;
      }
      
      if (_outerIterator.moveNext()) {
        _innerIterator = _outerIterator.current.iterator;
      } else {
        _current = null;
        return false;
      }
    }
  }
}
