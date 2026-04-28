import 'dart:collection';

/// A view that yields the elements of an iterable in reverse order.
/// Mimics C++ `std::views::reverse` (C++20).
///
/// The source iterable is buffered once on first iteration, then traversed
/// from back to front. Subsequent iterations reuse the same buffer.
///
/// Example:
/// ```dart
/// ReverseRange([1, 2, 3, 4, 5]).toList(); // [5, 4, 3, 2, 1]
/// ```
class ReverseRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  List<T>? _buffer;

  /// Creates a [ReverseRange] that yields the elements of [_iterable] in
  /// reverse order.
  ReverseRange(this._iterable);

  List<T> get _reversed {
    _buffer ??= _iterable.toList();
    return _buffer!;
  }

  @override
  Iterator<T> get iterator => _ReverseRangeIterator<T>(_reversed);
}

class _ReverseRangeIterator<T> implements Iterator<T> {
  final List<T> _list;
  int _index;
  T? _current;
  bool _initialized = false;

  _ReverseRangeIterator(this._list) : _index = _list.length - 1;

  @override
  T get current {
    if (!_initialized) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    _initialized = true;
    if (_index >= 0) {
      _current = _list[_index--];
      return true;
    }
    _current = null;
    return false;
  }
}
