import 'dart:collection';

/// A view that splits an iterable into chunks of a specific size.
/// Mimics C++ `std::views::chunk`.
/// The last chunk may be smaller than the requested size if the total number
/// of elements is not perfectly divisible by the chunk size.
class ChunkRange<T> extends IterableBase<List<T>> {
  final Iterable<T> _iterable;
  final int _chunkSize;

  /// Creates a [ChunkRange] that splits the given iterable into chunks of a specific size.
  /// 
  /// Throws an [ArgumentError] if the chunk size is less than or equal to 0.
  ChunkRange(this._iterable, this._chunkSize) {
    if (_chunkSize <= 0) {
      throw ArgumentError('Chunk size must be strictly positive.');
    }
  }

  @override
  Iterator<List<T>> get iterator => _ChunkRangeIterator<T>(_iterable.iterator, _chunkSize);
}

class _ChunkRangeIterator<T> implements Iterator<List<T>> {
  final Iterator<T> _iterator;
  final int _chunkSize;
  List<T>? _current;

  _ChunkRangeIterator(this._iterator, this._chunkSize);

  @override
  List<T> get current {
    if (_current == null) throw StateError('Iterator not initialized or already exhausted.');
    return _current!;
  }

  @override
  bool moveNext() {
    List<T> chunk = [];
    for (int i = 0; i < _chunkSize; i++) {
      if (_iterator.moveNext()) {
        chunk.add(_iterator.current);
      } else {
        break;
      }
    }

    if (chunk.isNotEmpty) {
      _current = chunk;
      return true;
    }

    _current = null;
    return false;
  }
}
