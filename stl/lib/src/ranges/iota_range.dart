import 'dart:collection';

/// A lazy view that yields a consecutive integer sequence `[start, end)`.
/// Mimics C++ `std::views::iota` (C++23).
///
/// When [end] is omitted the sequence is infinite. Use [Iterable.take] to
/// limit the number of elements consumed from an infinite [IotaRange].
///
/// Example:
/// ```dart
/// IotaRange(0, 5).toList(); // [0, 1, 2, 3, 4]
/// IotaRange(3).take(4).toList(); // [3, 4, 5, 6]
/// ```
class IotaRange extends IterableBase<int> {
  final int _start;
  final int? _end;

  /// Creates an [IotaRange] yielding integers from [_start] (inclusive) up to
  /// [_end] (exclusive).
  ///
  /// Omit [_end] to create an infinite range. Use [Iterable.take] to consume
  /// a bounded prefix of an infinite [IotaRange].
  ///
  /// Throws an [ArgumentError] if [_end] is not `null` and [_end] is less
  /// than [_start].
  IotaRange(this._start, [this._end]) {
    if (_end != null && _end < _start) {
      throw ArgumentError('end must be >= start, got start=$_start end=$_end.');
    }
  }

  /// Returns an iterator that yields each integer in `[start, end)` in
  /// ascending order.
  @override
  Iterator<int> get iterator => _IotaRangeIterator(_start, _end);
}

class _IotaRangeIterator implements Iterator<int> {
  final int _start;
  final int? _end;
  late int _current;
  bool _initialized = false;
  bool _exhausted = false;

  _IotaRangeIterator(this._start, this._end);

  /// The current integer value in the sequence.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the
  /// iterator is exhausted.
  @override
  int get current {
    if (!_initialized || _exhausted) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current;
  }

  /// Advances to the next integer and returns `true`, or returns `false` when
  /// the bounded [end] has been reached.
  ///
  /// For an infinite [IotaRange] this always returns `true`; pair with
  /// [Iterable.take] to prevent unbounded iteration.
  @override
  bool moveNext() {
    if (_exhausted) return false;
    if (!_initialized) {
      _initialized = true;
      _current = _start;
    } else {
      _current++;
    }
    if (_end != null && _current >= _end) {
      _exhausted = true;
      return false;
    }
    return true;
  }
}
