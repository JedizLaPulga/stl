import 'dart:collection';

/// A view that groups consecutive elements into `List<T>` chunks while a
/// binary predicate `pred(prev, curr)` returns `true`.
/// Mimics C++ `std::views::chunk_by` (C++23).
///
/// A new chunk begins every time the predicate returns `false` for a
/// consecutive pair `(prev, curr)`. An empty source yields no chunks.
///
/// Example:
/// ```dart
/// ChunkByRange([1, 1, 2, 2, 2, 3], (a, b) => a == b).toList();
/// // [[1, 1], [2, 2, 2], [3]]
///
/// ChunkByRange([1, 2, 3, 1, 2], (a, b) => b >= a).toList();
/// // [[1, 2, 3], [1, 2]]
/// ```
class ChunkByRange<T> extends IterableBase<List<T>> {
  final Iterable<T> _iterable;
  final bool Function(T prev, T curr) _predicate;

  /// Creates a [ChunkByRange] that groups elements from [_iterable] into
  /// consecutive chunks while [_predicate] returns `true` for each adjacent
  /// pair `(prev, curr)`.
  ChunkByRange(this._iterable, this._predicate);

  /// Returns an iterator over the `List<T>` chunks produced by [_predicate].
  @override
  Iterator<List<T>> get iterator =>
      _ChunkByRangeIterator<T>(_iterable.iterator, _predicate);
}

class _ChunkByRangeIterator<T> implements Iterator<List<T>> {
  final Iterator<T> _inner;
  final bool Function(T, T) _predicate;
  List<T>? _current;
  bool _done = false;
  bool _initialized = false;
  T? _pending;
  bool _hasPending = false;

  _ChunkByRangeIterator(this._inner, this._predicate);

  /// The current chunk as a `List<T>`.
  ///
  /// Throws a [StateError] if [moveNext] has not been called yet or the
  /// iterator is exhausted.
  @override
  List<T> get current {
    if (_current == null) {
      throw StateError('Iterator not initialized or already exhausted.');
    }
    return _current!;
  }

  /// Advances to the next chunk and returns `true`, or returns `false` when
  /// the source is exhausted.
  ///
  /// The first element of a new chunk is either the very first element of the
  /// source (on the initial call) or the element that caused the predicate to
  /// return `false` in the previous call.
  @override
  bool moveNext() {
    if (_done) return false;

    // Determine the first element of the upcoming chunk.
    T first;
    if (!_initialized) {
      _initialized = true;
      if (!_inner.moveNext()) {
        _done = true;
        return false;
      }
      first = _inner.current;
    } else if (_hasPending) {
      first = _pending as T;
      _hasPending = false;
    } else {
      _done = true;
      return false;
    }

    final chunk = <T>[first];
    T prev = first;

    while (_inner.moveNext()) {
      final curr = _inner.current;
      if (_predicate(prev, curr)) {
        chunk.add(curr);
        prev = curr;
      } else {
        // curr starts the next chunk; stash it for the following moveNext call.
        _pending = curr;
        _hasPending = true;
        break;
      }
    }

    _current = chunk;
    return true;
  }
}
