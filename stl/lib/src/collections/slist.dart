import 'dart:collection';

class _DoubleListNode<T> {
  T value;
  _DoubleListNode<T>? prev;
  _DoubleListNode<T>? next;

  _DoubleListNode(this.value, [this.prev, this.next]);
}

class _SListIterator<T> implements Iterator<T> {
  _DoubleListNode<T>? _current;
  final _DoubleListNode<T>? _head;
  bool _started = false;

  _SListIterator(this._head);

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

/// A doubly-linked list.
///
/// In the C++ STL, this matches exactly the behavior of `std::list`.
/// It allows constant time O(1) insertion and deletion at both the front and back,
/// as well as any point in the sequence if the logical node position is known.
/// Does not provide fast random access (no `operator[]`).
class SList<T> with IterableMixin<T> {
  _DoubleListNode<T>? _head;
  _DoubleListNode<T>? _tail;
  int _length = 0;

  /// Creates an empty doubly-linked list.
  SList();

  /// Creates a doubly-linked list from an iterable.
  SList.from(Iterable<T> elements) {
    for (var element in elements) {
      pushBack(element);
    }
  }

  @override
  Iterator<T> get iterator => _SListIterator<T>(_head);

  @override
  int get length => _length;

  /// Returns `true` if the list is empty.
  bool empty() => _length == 0;

  /// Retrieves the first element of the list.
  /// Throws a [StateError] if the list is empty.
  T front() {
    if (_head == null) {
      throw StateError('Cannot get front of an empty SList');
    }
    return _head!.value;
  }

  /// Retrieves the last element of the list.
  /// Throws a [StateError] if the list is empty.
  T back() {
    if (_tail == null) {
      throw StateError('Cannot get back of an empty SList');
    }
    return _tail!.value;
  }

  /// Adds an element to the front of the list. O(1).
  void pushFront(T value) {
    final newNode = _DoubleListNode<T>(value, null, _head);
    if (_head != null) {
      _head!.prev = newNode;
    }
    _head = newNode;
    if (_tail == null) {
      _tail = newNode;
    }
    _length++;
  }

  /// Adds an element to the back of the list. O(1).
  void pushBack(T value) {
    final newNode = _DoubleListNode<T>(value, _tail, null);
    if (_tail != null) {
      _tail!.next = newNode;
    }
    _tail = newNode;
    if (_head == null) {
      _head = newNode;
    }
    _length++;
  }

  /// Removes the first element from the list. O(1).
  /// Throws a [StateError] if the list is empty.
  void popFront() {
    if (_head == null) {
      throw StateError('Cannot pop from an empty SList');
    }
    _head = _head!.next;
    if (_head != null) {
      _head!.prev = null;
    } else {
      _tail = null;
    }
    _length--;
  }

  /// Removes the last element from the list. O(1).
  /// Throws a [StateError] if the list is empty.
  void popBack() {
    if (_tail == null) {
      throw StateError('Cannot pop from an empty SList');
    }
    _tail = _tail!.prev;
    if (_tail != null) {
      _tail!.next = null;
    } else {
      _head = null;
    }
    _length--;
  }

  /// Clears the list.
  void clear() {
    _head = null;
    _tail = null;
    _length = 0;
  }

  /// Reverses the list in place (O(N) time complexity).
  void reverse() {
    _DoubleListNode<T>? current = _head;
    _DoubleListNode<T>? temp;
    while (current != null) {
      temp = current.prev;
      current.prev = current.next;
      current.next = temp;
      current = current.prev; // Since we just swapped them
    }
    if (temp != null) {
      _tail = _head;
      _head = temp.prev;
    }
  }

  /// Removes all elements equal to [value].
  void remove(T value) {
    _DoubleListNode<T>? current = _head;
    while (current != null) {
      _DoubleListNode<T>? nextNode = current.next;
      if (current.value == value) {
        _unlink(current);
      }
      current = nextNode;
    }
  }

  /// Removes all elements for which [test] returns true.
  void removeIf(bool Function(T) test) {
    _DoubleListNode<T>? current = _head;
    while (current != null) {
      _DoubleListNode<T>? nextNode = current.next;
      if (test(current.value)) {
        _unlink(current);
      }
      current = nextNode;
    }
  }

  void _unlink(_DoubleListNode<T> node) {
    if (node.prev != null) {
      node.prev!.next = node.next;
    } else {
      _head = node.next;
    }
    if (node.next != null) {
      node.next!.prev = node.prev;
    } else {
      _tail = node.prev;
    }
    _length--;
  }

  /// Removes consecutive duplicate elements.
  void unique() {
    if (_head == null) return;
    _DoubleListNode<T>? current = _head;
    while (current != null && current.next != null) {
      if (current.value == current.next!.value) {
        _unlink(current.next!);
      } else {
        current = current.next;
      }
    }
  }

  /// Exchanges the contents of this list with those of [other].
  void swap(SList<T> other) {
    final tempHead = _head;
    final tempTail = _tail;
    final tempLength = _length;

    _head = other._head;
    _tail = other._tail;
    _length = other._length;

    other._head = tempHead;
    other._tail = tempTail;
    other._length = tempLength;
  }

  @override
  String toString() {
    return 'SList(${toList()})';
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SList<T>) return false;
    if (length != other.length) return false;

    var it1 = iterator;
    var it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current != it2.current) return false;
    }
    return true;
  }
}
