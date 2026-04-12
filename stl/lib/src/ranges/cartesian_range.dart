import 'dart:collection';
import '../utility/pair.dart';

/// A view that generates the Cartesian product of two iterables.
/// Mimics C++ `std::views::cartesian_product`.
///
/// The second iterable must be re-iterable (e.g. `List`, `Vector`, `Set`, `NumberLine`),
/// as it will be iterated multiple times to form all combinations with the first iterable.
class CartesianRange<T1, T2> extends IterableBase<Pair<T1, T2>> {
  final Iterable<T1> _first;
  final Iterable<T2> _second;

  /// Creates a [CartesianRange] combining the elements of the first and second iterable.
  CartesianRange(this._first, this._second);

  @override
  Iterator<Pair<T1, T2>> get iterator {
    return _CartesianRangeIterator<T1, T2>(_first, _second);
  }
}

class _CartesianRangeIterator<T1, T2> implements Iterator<Pair<T1, T2>> {
  final Iterable<T1> _first;
  final Iterable<T2> _second;

  Iterator<T1>? _firstIterator;
  Iterator<T2>? _secondIterator;

  Pair<T1, T2>? _current;

  _CartesianRangeIterator(this._first, this._second);

  @override
  Pair<T1, T2> get current {
    if (_current == null)
      throw StateError('Iterator not initialized or already exhausted.');
    return _current!;
  }

  @override
  bool moveNext() {
    if (_firstIterator == null) {
      _firstIterator = _first.iterator;
      if (!_firstIterator!.moveNext()) return false;

      _secondIterator = _second.iterator;
      if (!_secondIterator!.moveNext()) return false;

      _current = Pair<T1, T2>(
        _firstIterator!.current,
        _secondIterator!.current,
      );
      return true;
    }

    if (_secondIterator!.moveNext()) {
      _current = Pair<T1, T2>(
        _firstIterator!.current,
        _secondIterator!.current,
      );
      return true;
    }

    // Second iterator exhausted, move first iterator and reset second
    if (_firstIterator!.moveNext()) {
      _secondIterator = _second.iterator;
      if (_secondIterator!.moveNext()) {
        _current = Pair<T1, T2>(
          _firstIterator!.current,
          _secondIterator!.current,
        );
        return true;
      }
    }

    _current = null;
    return false;
  }
}
