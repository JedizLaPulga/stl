/// C++ inspired iterator adapters.
///
/// Provides iterables and sinks to seamlessly reverse iteration and insert
/// elements into collections, bridging C++ `<iterator>` patterns.
library;

/// An `Iterable` wrapper that lazily iterates over a `List` backwards.
///
/// Analogous to `std::reverse_iterator` in C++.
class ReverseIterator<T> extends Iterable<T> {
  final List<T> _source;

  /// Creates a [ReverseIterator] that iterates [source] from the end to the beginning.
  const ReverseIterator(List<T> source) : _source = source;

  @override
  Iterator<T> get iterator => _ReverseIteratorImpl<T>(_source);
}

class _ReverseIteratorImpl<T> implements Iterator<T> {
  final List<T> _source;
  int _index;
  T? _current;

  _ReverseIteratorImpl(this._source) : _index = _source.length;

  @override
  T get current => _current as T;

  @override
  bool moveNext() {
    if (_index > 0) {
      _index--;
      _current = _source[_index];
      return true;
    }
    return false;
  }
}

/// An output iterator that pushes elements to the back of a collection.
///
/// Analogous to `std::back_insert_iterator` in C++.
/// Automatically detects `pushBack()` or defaults to standard `add()`.
class BackInsertIterator<T> implements Sink<T> {
  final dynamic _container;

  /// Creates a [BackInsertIterator] linked to the specified [container].
  BackInsertIterator(dynamic container) : _container = container;

  /// Pushes the [value] to the back of the underlying container.
  @override
  void add(T value) {
    try {
      // ignore: avoid_dynamic_calls
      _container.pushBack(value);
    } on NoSuchMethodError {
      // ignore: avoid_dynamic_calls
      _container.add(value);
    }
  }

  @override
  void close() {}
}

/// An output iterator that pushes elements to the front of a collection.
///
/// Analogous to `std::front_insert_iterator` in C++.
/// Automatically detects `pushFront()` or defaults to standard `insert(0, value)`.
class FrontInsertIterator<T> implements Sink<T> {
  final dynamic _container;

  /// Creates a [FrontInsertIterator] linked to the specified [container].
  FrontInsertIterator(dynamic container) : _container = container;

  /// Pushes the [value] to the front of the underlying container.
  @override
  void add(T value) {
    try {
      // ignore: avoid_dynamic_calls
      _container.pushFront(value);
    } on NoSuchMethodError {
      // ignore: avoid_dynamic_calls
      _container.insert(0, value);
    }
  }

  @override
  void close() {}
}

/// An output iterator that inserts elements into a collection at a specified position.
///
/// Analogous to `std::insert_iterator` in C++.
/// Automatically increments the insertion index with each element added.
class InsertIterator<T> implements Sink<T> {
  final dynamic _container;
  int _index;

  /// Creates an [InsertIterator] linked to the specified [container] starting at [index].
  InsertIterator(dynamic container, int index)
      : _container = container,
        _index = index;

  /// Inserts the [value] at the current iterator position and advances the position.
  @override
  void add(T value) {
    // ignore: avoid_dynamic_calls
    _container.insert(_index++, value);
  }

  @override
  void close() {}
}
