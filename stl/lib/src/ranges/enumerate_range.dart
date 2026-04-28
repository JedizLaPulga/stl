import 'dart:collection';
import '../utilities/pair.dart';

/// A view that pairs each element of an iterable with its 0-based index.
/// Mimics C++ `std::views::enumerate` (C++23).
///
/// Yields [Pair<int, T>] where [Pair.first] is the index and [Pair.second]
/// is the element. Equivalent to Python's `enumerate()`.
///
/// Example:
/// ```dart
/// for (final p in EnumerateRange(['a', 'b', 'c'])) {
///   print('${p.first}: ${p.second}'); // 0: a, 1: b, 2: c
/// }
/// ```
class EnumerateRange<T> extends IterableBase<Pair<int, T>> {
  final Iterable<T> _iterable;

  /// Creates an [EnumerateRange] that yields index–element pairs for each
  /// element in [_iterable], starting at index 0.
  EnumerateRange(this._iterable);

  @override
  Iterator<Pair<int, T>> get iterator =>
      _EnumerateRangeIterator<T>(_iterable.iterator);
}

class _EnumerateRangeIterator<T> implements Iterator<Pair<int, T>> {
  final Iterator<T> _iterator;
  int _index = 0;
  Pair<int, T>? _current;

  _EnumerateRangeIterator(this._iterator);

  @override
  Pair<int, T> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (_iterator.moveNext()) {
      _current = Pair<int, T>(_index++, _iterator.current);
      return true;
    }
    _current = null;
    return false;
  }
}
