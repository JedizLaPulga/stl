import 'dart:collection';

/// A view that filters elements based on a predicate.
/// Mimics C++ `std::views::filter`.
class FilterRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final bool Function(T) _predicate;

  /// Creates a [FilterRange] that conditionally yields elements of [_iterable] matching [_predicate].
  FilterRange(this._iterable, this._predicate);

  @override
  Iterator<T> get iterator => _FilterRangeIterator<T>(_iterable.iterator, _predicate);
}

class _FilterRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final bool Function(T) _predicate;
  T? _current;
  bool _isInitialized = false;

  _FilterRangeIterator(this._iterator, this._predicate);

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
    while (_iterator.moveNext()) {
      if (_predicate(_iterator.current)) {
        _current = _iterator.current;
        return true;
      }
    }
    _current = null;
    return false;
  }
}
