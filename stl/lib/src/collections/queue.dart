import 'dart:collection';
import 'deque.dart';

/// An adapter class that provides a First-In, First-Out (FIFO) data structure.
///
/// In the C++ STL, `std::queue` wraps an underlying container (by default a deque)
/// and restricts the interface to FIFO operations.
class Queue<T> with IterableMixin<T> {
  final Deque<T> _container;

  /// Returns an iterator that iterates from the front of the queue to the back (FIFO order).
  @override
  Iterator<T> get iterator => _container.iterator;

  /// Creates an empty queue using a [Deque] as the default underlying container.
  Queue() : _container = Deque<T>();

  /// Creates a queue containing the elements of the given iterable.
  /// Elements are pushed in the order they appear, so the first element
  /// of the iterable will be at the front of the queue.
  Queue.from(Iterable<T> elements) : _container = Deque<T>.from(elements);

  /// Pushes an element onto the back of the queue.
  void push(T value) {
    _container.insertLast(value);
  }

  /// Removes and returns the front element from the queue.
  /// Throws a [StateError] if the queue is empty.
  T pop() {
    if (empty) {
      throw StateError('Cannot pop from an empty Queue');
    }
    return _container.deleteFirst();
  }

  /// Returns the front element of the queue without removing it.
  /// Throws a [StateError] if the queue is empty.
  T get front {
    if (empty) {
      throw StateError('Cannot access front of an empty Queue');
    }
    return _container.getFront();
  }

  /// Returns the back element of the queue without removing it.
  /// Throws a [StateError] if the queue is empty.
  T get back {
    if (empty) {
      throw StateError('Cannot access back of an empty Queue');
    }
    return _container.getRear();
  }

  /// Returns `true` if the queue is empty.
  bool get empty => _container.isEmpty;

  /// Returns `true` if the queue has at least one element.
  @override
  bool get isNotEmpty => _container.isNotEmpty;

  /// Returns the number of elements in the queue.
  int get size => _container.length;

  /// Clears the queue.
  void clear() {
    _container.clear();
  }

  /// Exchanges the contents of this queue with those of [other].
  void swap(Queue<T> other) {
    _container.swap(other._container);
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Queue<T>) return false;
    if (size != other.size) return false;

    final it1 = iterator;
    final it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current != it2.current) return false;
    }
    return true;
  }
}
