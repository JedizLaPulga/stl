import 'dart:collection';

class _ForwardListNode<T> {
  T value;
  _ForwardListNode<T>? next;

  _ForwardListNode(this.value, [this.next]);
}

class _ForwardListIterator<T> implements Iterator<T> {
  _ForwardListNode<T>? _current;
  _ForwardListNode<T>? _head;
  bool _started = false;

  _ForwardListIterator(this._head);

  @override
  T get current {
    if (!_started || _current == null) {
      throw StateError('Iterator is not valid');
    }
    return _current!.value;
  }

  @override
  bool moveNext() {
    if (!_started) {
      _current = _head;
      _started = true;
    } else if (_current != null) {
      _current = _current!.next;
    }
    return _current != null;
  }
}

/// A singly-linked list.
///
/// In the C++ STL, `std::forward_list` is a singly-linked list. It provides
/// fast insertion and removal of elements from the front of the list.
/// Unlike standard Dart `List`, a forward list does not provide fast random access.
class ForwardList<T> with IterableMixin<T> {
  _ForwardListNode<T>? _head;
  int _length = 0;

  /// Creates an empty forward list.
  ForwardList();

  /// Creates a forward list from an iterable.
  /// Elements are added in the order they appear, so the first element
  /// of the iterable will be at the front of the forward list.
  ForwardList.from(Iterable<T> elements) {
    if (elements.isEmpty) return;
    
    var iter = elements.iterator;
    iter.moveNext();
    
    _head = _ForwardListNode<T>(iter.current);
    _length = 1;
    
    var current = _head;
    while (iter.moveNext()) {
      current!.next = _ForwardListNode<T>(iter.current);
      current = current.next;
      _length++;
    }
  }

  @override
  Iterator<T> get iterator => _ForwardListIterator<T>(_head);

  @override
  int get length => _length;

  /// Returns `true` if the list is empty.
  bool empty() => _length == 0;

  /// Retrieves the first element of the list.
  /// Throws a [StateError] if the list is empty.
  T front() {
    if (_head == null) {
      throw StateError('Cannot get front of an empty ForwardList');
    }
    return _head!.value;
  }

  /// Adds an element to the front of the list.
  void push_front(T value) {
    _head = _ForwardListNode<T>(value, _head);
    _length++;
  }

  /// Removes the first element from the list.
  /// Throws a [StateError] if the list is empty.
  void pop_front() {
    if (_head == null) {
      throw StateError('Cannot pop from an empty ForwardList');
    }
    _head = _head!.next;
    _length--;
  }

  /// Clears the list.
  void clear() {
    _head = null;
    _length = 0;
  }

  /// Reverses the list in place (O(N) time complexity).
  /// This is highly efficient as it just redirects the underlying node pointers.
  void reverse() {
    _ForwardListNode<T>? prev = null;
    _ForwardListNode<T>? current = _head;
    _ForwardListNode<T>? next;

    while (current != null) {
      next = current.next;
      current.next = prev;
      prev = current;
      current = next;
    }
    
    _head = prev;
  }
}
