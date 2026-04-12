import 'dart:collection';

/// A view that repeats a single value either limits-free (infinitely) or a specific amount of times.
/// Mimics C++ `std::views::repeat`.
class RepeatRange<T> extends IterableBase<T> {
  final T _value;
  final int? _bound;

  RepeatRange(this._value, [this._bound]) {
    if (_bound != null && _bound < 0) {
      throw ArgumentError('Bound cannot be negative.');
    }
  }

  @override
  Iterator<T> get iterator => _RepeatRangeIterator<T>(_value, _bound);
}

class _RepeatRangeIterator<T> implements Iterator<T> {
  final T _value;
  final int? _bound;
  int _count = 0;
  bool _active = false;

  _RepeatRangeIterator(this._value, this._bound);

  @override
  T get current {
    if (!_active)
      throw StateError('Iterator not initialized or already exhausted.');
    return _value;
  }

  @override
  bool moveNext() {
    if (_bound != null && _count >= _bound) {
      _active = false;
      return false;
    }
    _count++;
    _active = true;
    return true;
  }
}
