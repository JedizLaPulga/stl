import 'dart:collection';

/// A view that yields overlapping sliding windows of size N over an iterable.
/// Mimics C++ `std::views::slide` (C++23).
///
/// Each yielded value is a [List<T>] of exactly [windowSize] consecutive
/// elements. The window advances by one element at a time. If the source
/// iterable has fewer elements than [windowSize], no windows are yielded.
///
/// Example:
/// ```dart
/// SlideRange([1, 2, 3, 4, 5], 3).toList();
/// // [[1,2,3], [2,3,4], [3,4,5]]
/// ```
class SlideRange<T> extends IterableBase<List<T>> {
  final Iterable<T> _iterable;
  final int _windowSize;

  /// Creates a [SlideRange] that yields overlapping windows of [windowSize]
  /// consecutive elements from [_iterable].
  ///
  /// Throws an [ArgumentError] if [windowSize] is less than or equal to 0.
  SlideRange(this._iterable, this._windowSize) {
    if (_windowSize <= 0) {
      throw ArgumentError('Window size must be strictly positive.');
    }
  }

  @override
  Iterator<List<T>> get iterator =>
      _SlideRangeIterator<T>(_iterable.iterator, _windowSize);
}

class _SlideRangeIterator<T> implements Iterator<List<T>> {
  final Iterator<T> _iterator;
  final int _windowSize;
  final List<T> _window = [];
  List<T>? _current;
  bool _initialized = false;

  _SlideRangeIterator(this._iterator, this._windowSize);

  @override
  List<T> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (!_initialized) {
      _initialized = true;
      // Fill initial window.
      for (int i = 0; i < _windowSize; i++) {
        if (!_iterator.moveNext()) {
          _current = null;
          return false;
        }
        _window.add(_iterator.current);
      }
      _current = List<T>.from(_window);
      return true;
    }
    // Slide: drop the oldest element, append the next.
    if (_iterator.moveNext()) {
      _window.removeAt(0);
      _window.add(_iterator.current);
      _current = List<T>.from(_window);
      return true;
    }
    _current = null;
    return false;
  }
}
