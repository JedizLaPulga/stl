import 'dart:collection';
import '../utilities/pair.dart';

/// A view that extracts the key from each [Pair]`<K, V>` in an iterable.
/// Mimics C++ `std::views::keys` (C++23).
///
/// Composes seamlessly with any collection that yields [Pair]`<K, V>` on
/// iteration, such as `HashMap`, `SortedMap`, and `MultiMap`.
/// The dual complement is [ValuesRange].
///
/// Example:
/// ```dart
/// final pairs = [Pair('a', 1), Pair('b', 2), Pair('c', 3)];
/// KeysRange(pairs).toList(); // ['a', 'b', 'c']
/// ```
class KeysRange<K, V> extends IterableBase<K> {
  final Iterable<Pair<K, V>> _iterable;

  /// Creates a [KeysRange] that extracts [Pair.first] from each element of
  /// [_iterable].
  KeysRange(this._iterable);

  /// Returns an iterator that yields each key in source order.
  @override
  Iterator<K> get iterator => _KeysRangeIterator<K, V>(_iterable.iterator);
}

class _KeysRangeIterator<K, V> implements Iterator<K> {
  final Iterator<Pair<K, V>> _inner;
  K? _current;
  bool _initialized = false;

  _KeysRangeIterator(this._inner);

  /// The current key value.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the
  /// iterator is exhausted.
  @override
  K get current {
    if (!_initialized) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as K;
  }

  /// Advances to the next key and returns `true`, or returns `false` when the
  /// source is exhausted.
  @override
  bool moveNext() {
    if (_inner.moveNext()) {
      _initialized = true;
      _current = _inner.current.first;
      return true;
    }
    _current = null;
    return false;
  }
}
