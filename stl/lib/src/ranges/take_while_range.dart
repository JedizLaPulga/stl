import 'dart:collection';

/// A view that yields elements from the front of an iterable as long as
/// [predicate] returns `true`, halting permanently at the first failing element.
///
/// Mirrors C++20 `std::views::take_while`.
///
/// Unlike [FilterRange], which skips non-matching elements and continues
/// scanning, [TakeWhileRange] stops entirely at the first element that fails
/// the predicate — subsequent elements are never examined.
///
/// Safe to use on infinite sources such as [IotaRange] or [CycleRange].
///
/// Example:
/// ```dart
/// final data = [2, 4, 6, 7, 8, 10];
/// final evens = TakeWhileRange(data, (n) => n.isEven);
/// print(evens.toList()); // [2, 4, 6]
/// ```
class TakeWhileRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final bool Function(T) _predicate;

  /// Creates a [TakeWhileRange] that yields elements of [_iterable] while
  /// [_predicate] returns `true`.
  TakeWhileRange(this._iterable, this._predicate);

  @override
  Iterator<T> get iterator =>
      _TakeWhileRangeIterator<T>(_iterable.iterator, _predicate);
}

class _TakeWhileRangeIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;
  final bool Function(T) _predicate;
  T? _current;
  bool _done = false;

  _TakeWhileRangeIterator(this._iterator, this._predicate);

  @override
  T get current {
    if (_done || _current == null) {
      throw StateError(
        'No current element: iterator not started or exhausted.',
      );
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    if (_done) return false;
    if (_iterator.moveNext()) {
      final element = _iterator.current;
      if (_predicate(element)) {
        _current = element;
        return true;
      }
    }
    _done = true;
    _current = null;
    return false;
  }
}
