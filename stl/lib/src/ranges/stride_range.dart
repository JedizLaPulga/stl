import 'dart:collection';

/// A view that yields every Nth element of an iterable.
/// Mimics C++ `std::views::stride` (C++23).
///
/// The first element is always included (index 0), then every [stride]th
/// element thereafter (indices `stride`, `2*stride`, …).
///
/// Example:
/// ```dart
/// StrideRange([1, 2, 3, 4, 5, 6], 2).toList(); // [1, 3, 5]
/// StrideRange([1, 2, 3, 4, 5, 6], 3).toList(); // [1, 4]
/// ```
class StrideRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final int _stride;

  /// Creates a [StrideRange] that yields every [stride]th element of [_iterable].
  ///
  /// Throws an [ArgumentError] if [stride] is less than or equal to 0.
  StrideRange(this._iterable, this._stride) {
    if (_stride <= 0) {
      throw ArgumentError('Stride must be strictly positive.');
    }
  }

  @override
  Iterator<T> get iterator =>
      _StrideRangeIterator<T>(_iterable.iterator, _stride);
}

class _StrideRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final int _stride;
  T? _current;
  bool _initialized = false;

  _StrideRangeIterator(this._iterator, this._stride);

  @override
  T get current {
    if (!_initialized) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    if (!_initialized) {
      // First call: advance once to land on index 0.
      _initialized = true;
      if (_iterator.moveNext()) {
        _current = _iterator.current;
        return true;
      }
      return false;
    }
    // Subsequent calls: skip (_stride - 1) elements, then take one.
    for (int i = 0; i < _stride; i++) {
      if (!_iterator.moveNext()) {
        _current = null;
        return false;
      }
    }
    _current = _iterator.current;
    return true;
  }
}
