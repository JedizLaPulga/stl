import 'dart:collection';

/// A view that wraps exactly one value as a single-element range.
/// Mimics C++ `std::views::single` (C++23).
///
/// Useful for composing a lone value with other range adapters without
/// allocating a temporary `List`.
///
/// Example:
/// ```dart
/// SingleRange(42).toList(); // [42]
/// SingleRange('hello').first; // 'hello'
/// ```
class SingleRange<T> extends IterableBase<T> {
  final T _value;

  /// Creates a [SingleRange] that yields [_value] exactly once.
  SingleRange(this._value);

  /// Returns an iterator that yields [_value] once then signals exhaustion.
  @override
  Iterator<T> get iterator => _SingleRangeIterator<T>(_value);
}

class _SingleRangeIterator<T> implements Iterator<T> {
  final T _value;
  bool _initialized = false;
  bool _consumed = false;

  _SingleRangeIterator(this._value);

  /// The single value held by this range.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the value
  /// has already been consumed.
  @override
  T get current {
    if (!_initialized || _consumed) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _value;
  }

  /// Returns `true` on the first call and advances to [_value].
  /// Returns `false` on every subsequent call.
  @override
  bool moveNext() {
    if (_consumed) return false;
    if (!_initialized) {
      _initialized = true;
      return true;
    }
    _consumed = true;
    return false;
  }
}
