import 'deque.dart';

/// An adapter class that provides a Last-In, First-Out (LIFO) data structure.
///
/// In the C++ STL, `std::stack` wraps an underlying container (by default a deque)
/// and restricts the interface to LIFO operations.
class Stack<T> {
  final Deque<T> _container;

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

  /// Removes the top element from the stack.
  /// Throws a [StateError] if the stack is empty.
  void pop() {
    if (empty) {
      throw StateError('Cannot pop from an empty Stack');
    }
    _container.deleteLast();
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
  bool get isNotEmpty => _container.isNotEmpty;

  /// Returns the number of elements in the stack.
  int get size => _container.length;

  /// Clears the stack.
  void clear() {
    _container.clear();
  }
}
