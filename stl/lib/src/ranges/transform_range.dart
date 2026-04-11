import 'dart:collection';

/// A view that transforms elements from one type to another using a mapping function.
/// Mimics C++ `std::views::transform`.
class TransformRange<T, U> extends IterableBase<U> {
  final Iterable<T> _iterable;
  final U Function(T) _transform;

  TransformRange(this._iterable, this._transform);

  @override
  Iterator<U> get iterator => _TransformRangeIterator<T, U>(_iterable.iterator, _transform);
}

class _TransformRangeIterator<T, U> implements Iterator<U> {
  final Iterator<T> _iterator;
  final U Function(T) _transform;
  U? _current;
  bool _isInitialized = false;

  _TransformRangeIterator(this._iterator, this._transform);

  @override
  U get current {
    if (!_isInitialized) {
      throw StateError('Iterator not initialized.');
    }
    return _current as U;
  }

  @override
  bool moveNext() {
    _isInitialized = true;
    if (_iterator.moveNext()) {
      _current = _transform(_iterator.current);
      return true;
    }
    _current = null;
    return false;
  }
}
