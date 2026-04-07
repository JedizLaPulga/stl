import 'dart:collection';

/// A double-ended queue (deque) that allows for insertion and deletion of elements
/// at both the front and the rear.
///
/// This implementation uses [ListQueue] from `dart:collection` under the hood,
/// which is designed to handle double-ended operations with very little friction.
class Deque<T> with IterableMixin<T> {
  final ListQueue<T> _queue;

  @override
  Iterator<T> get iterator => _queue.iterator;

  /// Creates an empty deque.
  Deque() : _queue = ListQueue<T>();

  /// Creates a deque containing the elements of the given iterable.
  Deque.from(Iterable<T> elements) : _queue = ListQueue<T>.from(elements);

  /// Inserts an [element] at the front of the deque.
  void insertFront(T element) {
    _queue.addFirst(element);
  }

  /// Inserts an [element] at the last (rear) of the deque.
  void insertLast(T element) {
    _queue.addLast(element);
  }

  /// Removes and returns the element at the front of the deque.
  /// Throws a [StateError] if the deque is empty.
  T deleteFront() {
    if (isEmpty) {
      throw StateError('Cannot delete from an empty Deque');
    }
    return _queue.removeFirst();
  }

  /// Removes and returns the element at the last (rear) of the deque.
  /// Throws a [StateError] if the deque is empty.
  T deleteLast() {
    if (isEmpty) {
      throw StateError('Cannot delete from an empty Deque');
    }
    return _queue.removeLast();
  }

  /// Returns the element at the front of the deque without removing it.
  /// Throws a [StateError] if the deque is empty.
  T getFront() {
    if (isEmpty) {
      throw StateError('Cannot get front element from an empty Deque');
    }
    return _queue.first;
  }

  /// Returns the element at the rear (last) of the deque without removing it.
  /// Throws a [StateError] if the deque is empty.
  T getRear() {
    if (isEmpty) {
      throw StateError('Cannot get rear element from an empty Deque');
    }
    return _queue.last;
  }

  /// Returns the number of elements in the deque.
  @override
  int get length => _queue.length;

  /// Returns `true` if the deque is empty.
  @override
  bool get isEmpty => _queue.isEmpty;

  /// Returns `true` if the deque has at least one element.
  @override
  bool get isNotEmpty => _queue.isNotEmpty;

  /// Removes all elements from the deque.
  void clear() {
    _queue.clear();
  }

  /// Adds an element to the front (C++ STL naming).
  void pushFront(T element) => insertFront(element);

  /// Adds an element to the back (C++ STL naming).
  void pushBack(T element) => insertLast(element);

  /// Removes and returns the front element (C++ STL naming).
  T popFront() => deleteFront();

  /// Removes and returns the back element (C++ STL naming).
  T popBack() => deleteLast();

  /// Returns the front element without removing it (C++ STL naming).
  T front() => getFront();

  /// Returns the back element without removing it (C++ STL naming).
  T back() => getRear();

  /// Random access: retrieves the element at [index].
  /// Note: O(N) complexity due to underlying ListQueue implementation.
  T at(int index) {
    if (index < 0 || index >= _queue.length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    return _queue.elementAt(index);
  }

  /// Operator overload for random access.
  T operator [](int index) => at(index);

  /// Operator overload for setting an element at [index].
  /// Note: O(N) complexity as it requires rebuilding parts of the queue.
  void operator []=(int index, T value) {
    if (index < 0 || index >= _queue.length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    final list = _queue.toList();
    list[index] = value;
    _queue.clear();
    _queue.addAll(list);
  }

  /// Exchanges the contents of this deque with those of [other].
  void swap(Deque<T> other) {
    final temp = _queue.toList();
    _queue.clear();
    _queue.addAll(other._queue);
    other._queue.clear();
    other._queue.addAll(temp);
  }
}
