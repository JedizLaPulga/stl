import 'dart:collection';
import '../utilities/pair.dart';

/// A view that extracts the value from each [Pair]`<K, V>` in an iterable.
/// Mimics C++ `std::views::values` (C++23).
///
/// The dual complement of [KeysRange]. Composes seamlessly with any collection
/// that yields [Pair]`<K, V>` on iteration, such as `HashMap`, `SortedMap`,
/// and `MultiMap`.
///
/// Example:
/// ```dart
/// final pairs = [Pair('a', 1), Pair('b', 2), Pair('c', 3)];
/// ValuesRange(pairs).toList(); // [1, 2, 3]
/// ```
class ValuesRange<K, V> extends IterableBase<V> {
  final Iterable<Pair<K, V>> _iterable;

  /// Creates a [ValuesRange] that extracts [Pair.second] from each element of
  /// [_iterable].
  ValuesRange(this._iterable);

  /// Returns an iterator that yields each value in source order.
  @override
  Iterator<V> get iterator => _ValuesRangeIterator<K, V>(_iterable.iterator);
}

class _ValuesRangeIterator<K, V> implements Iterator<V> {
  final Iterator<Pair<K, V>> _inner;
  V? _current;
  bool _initialized = false;

  _ValuesRangeIterator(this._inner);

  /// The current value.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the
  /// iterator is exhausted.
  @override
  V get current {
    if (!_initialized) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as V;
  }

  /// Advances to the next value and returns `true`, or returns `false` when
  /// the source is exhausted.
  @override
  bool moveNext() {
    if (_inner.moveNext()) {
      _initialized = true;
      _current = _inner.current.second;
      return true;
    }
    _current = null;
    return false;
  }
}
