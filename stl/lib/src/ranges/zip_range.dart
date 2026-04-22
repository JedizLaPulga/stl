import 'dart:collection';
import '../utilities/pair.dart';

/// A view that iterates over two iterables in parallel, yielding [Pair]s.
/// Mimics C++ `std::views::zip`.
/// The iteration stops when the shortest iterable is exhausted.
class ZipRange<T1, T2> extends IterableBase<Pair<T1, T2>> {
  final Iterable<T1> _first;
  final Iterable<T2> _second;

  /// Creates a view over two iterables.
  ZipRange(this._first, this._second);

  @override
  Iterator<Pair<T1, T2>> get iterator =>
      _ZipRangeIterator<T1, T2>(_first.iterator, _second.iterator);
}

class _ZipRangeIterator<T1, T2> implements Iterator<Pair<T1, T2>> {
  final Iterator<T1> _firstIterator;
  final Iterator<T2> _secondIterator;
  Pair<T1, T2>? _current;

  _ZipRangeIterator(this._firstIterator, this._secondIterator);

  @override
  Pair<T1, T2> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (_firstIterator.moveNext() && _secondIterator.moveNext()) {
      _current = Pair<T1, T2>(_firstIterator.current, _secondIterator.current);
      return true;
    }
    _current = null;
    return false;
  }
}
