import 'dart:collection';
import '../utilities/pair.dart';

/// A view that yields consecutive adjacent pairs of elements.
/// Mimics C++ `std::views::pairwise` / `std::views::adjacent<2>` (C++23).
///
/// Each element is paired with the element immediately following it, yielded
/// as a [Pair<T, T>]. If the source iterable has fewer than two elements, no
/// pairs are yielded. This is the typed, [Pair]-based specialisation of
/// [SlideRange] for a window size of 2.
///
/// Example:
/// ```dart
/// PairwiseRange([1, 2, 3, 4]).toList();
/// // [Pair(1,2), Pair(2,3), Pair(3,4)]
/// ```
class PairwiseRange<T> extends IterableBase<Pair<T, T>> {
  final Iterable<T> _iterable;

  /// Creates a [PairwiseRange] that yields consecutive adjacent pairs from
  /// [_iterable].
  PairwiseRange(this._iterable);

  @override
  Iterator<Pair<T, T>> get iterator =>
      _PairwiseRangeIterator<T>(_iterable.iterator);
}

class _PairwiseRangeIterator<T> implements Iterator<Pair<T, T>> {
  final Iterator<T> _iterator;
  Pair<T, T>? _current;
  T? _prev;
  bool _initialized = false;

  _PairwiseRangeIterator(this._iterator);

  @override
  Pair<T, T> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (!_initialized) {
      _initialized = true;
      if (!_iterator.moveNext()) return false;
      _prev = _iterator.current;
    }
    if (_iterator.moveNext()) {
      final next = _iterator.current;
      _current = Pair<T, T>(_prev as T, next);
      _prev = next;
      return true;
    }
    _current = null;
    return false;
  }
}
