import 'dart:collection';
import 'deque.dart';

/// An adapter class that provides a Last-In, First-Out (LIFO) data structure.
///
/// In the C++ STL, `std::stack` wraps an underlying container (by default a deque)
/// and restricts the interface to LIFO operations.
class Stack<T> with IterableMixin<T> {
  final Deque<T> _container;

  /// Returns an iterator that iterates from the top of the stack to the bottom (LIFO order).
  @override
  Iterator<T> get iterator => _container.toList().reversed.iterator;

  /// Creates an empty stack using a [Deque] as the default underlying container.
  Stack() : _container = Deque<T>();

  /// Creates a stack containing the elements of the given iterable.
  /// Elements are pushed in the order they appear, so the last element
  /// of the iterable will be at the top of the stack.
  Stack.from(Iterable<T> elements) : _container = Deque<T>.from(elements);

  /// Pushes an element onto the top of the stack.
  void push(T value) {
    _container.insertLast(value);
  }

  /// Removes and returns the top element from the stack.
  /// Throws a [StateError] if the stack is empty.
  T pop() {
    if (empty) {
      throw StateError('Cannot pop from an empty Stack');
    }
    return _container.deleteLast();
  }

  /// Returns the top element of the stack without removing it.
  /// Throws a [StateError] if the stack is empty.
  T get top {
    if (empty) {
      throw StateError('Cannot access top of an empty Stack');
    }
    return _container.getRear();
  }

  /// Returns `true` if the stack is empty.
  bool get empty => _container.isEmpty;

  /// Returns `true` if the stack has at least one element.
  @override
  bool get isNotEmpty => _container.isNotEmpty;

  /// Returns the number of elements in the stack.
  int get size => _container.length;

  /// Clears the stack.
  void clear() {
    _container.clear();
  }

  /// Exchanges the contents of this stack with those of [other].
  void swap(Stack<T> other) {
    _container.swap(other._container);
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Stack<T>) return false;
    if (size != other.size) return false;

    final it1 = iterator;
    final it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current != it2.current) return false;
    }
    return true;
  }
}
