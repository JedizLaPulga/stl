import 'dart:collection';

/// A view that repeats an iterable indefinitely or for a fixed number of
/// full cycles. Mimics `std::views::cycle` from range-v3 / C++23 proposals.
///
/// Each full pass over the source iterable counts as one cycle. If [bound]
/// is provided, iteration stops after [bound] complete cycles. If [bound]
/// is omitted, the range is infinite — take care to pair it with [TakeRange]
/// or similar to avoid infinite loops.
///
/// Throws an [ArgumentError] if the source iterable is empty (an empty cycle
/// would be an infinite loop producing nothing).
///
/// Example:
/// ```dart
/// // Finite: 2 full cycles
/// CycleRange([1, 2, 3], 2).toList(); // [1, 2, 3, 1, 2, 3]
///
/// // Infinite: take first 7 elements
/// TakeRange(CycleRange([1, 2, 3]), 7).toList(); // [1, 2, 3, 1, 2, 3, 1]
/// ```
class CycleRange<T> extends IterableBase<T> {
  final Iterable<T> _iterable;
  final int? _bound;

  /// Creates a [CycleRange] that cycles through [_iterable] repeatedly.
  ///
  /// If [bound] is provided, at most [bound] full cycles are produced.
  /// Throws an [ArgumentError] if [_iterable] is empty.
  CycleRange(this._iterable, [this._bound]) {
    if (_iterable.isEmpty) {
      throw ArgumentError('CycleRange source iterable must not be empty.');
    }
    if (_bound != null && _bound < 0) {
      throw ArgumentError('Bound cannot be negative.');
    }
  }

  @override
  Iterator<T> get iterator => _CycleRangeIterator<T>(_iterable, _bound);
}

class _CycleRangeIterator<T> implements Iterator<T> {
  final Iterable<T> _iterable;
  final int? _bound;
  Iterator<T> _iterator;
  int _cycleCount = 0;
  T? _current;
  bool _done = false;

  _CycleRangeIterator(this._iterable, this._bound)
    : _iterator = _iterable.iterator,
      _done = _bound != null && _bound == 0;
  @override
  T get current {
    if (_done) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current as T;
  }

  @override
  bool moveNext() {
    if (_done) return false;

    if (_iterator.moveNext()) {
      _current = _iterator.current;
      return true;
    }

    // End of current cycle — start next one if within bound.
    _cycleCount++;
    if (_bound != null && _cycleCount >= _bound) {
      _done = true;
      _current = null;
      return false;
    }

    _iterator = _iterable.iterator;
    if (_iterator.moveNext()) {
      _current = _iterator.current;
      return true;
    }

    _done = true;
    return false;
  }
}
