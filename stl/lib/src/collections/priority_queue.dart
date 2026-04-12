/// An adapter class that provides a Priority Queue (Heap) data structure.
///
/// In the C++ STL, `std::priority_queue` is a container adapter that provides
/// constant time lookup of the largest (by default) element, at the expense
/// of logarithmic insertion and extraction.
///
/// By default, this implementation acts as a Max-Heap when types are `Comparable`.
class PriorityQueue<T> {
  final List<T> _heap = [];
  final int Function(T, T) _compare;

  /// Creates an empty PriorityQueue.
  ///
  /// By default, it expects [T] to be [Comparable] to create a max-heap.
  /// You can provide a custom [compare] function to define priority.
  PriorityQueue([int Function(T, T)? compare])
    : _compare = compare ?? _defaultCompare;

  /// Creates a PriorityQueue containing the elements of the given iterable.
  ///
  /// The elements are built into a heap queue.
  PriorityQueue.from(Iterable<T> elements, [int Function(T, T)? compare])
    : _compare = compare ?? _defaultCompare {
    for (final element in elements) {
      push(element);
    }
  }

  static int _defaultCompare<T>(T a, T b) {
    if (a is Comparable && b is Comparable) {
      return a.compareTo(b);
    }
    throw ArgumentError(
      'Elements must be Comparable if no compare function is provided.',
    );
  }

  /// Pushes an element into the priority queue. Time complexity: O(log N).
  void push(T value) {
    _heap.add(value);
    _siftUp(_heap.length - 1);
  }

  /// Removes and returns the top priority element from the queue. Time complexity: O(log N).
  /// Throws a [StateError] if the queue is empty.
  T pop() {
    if (empty) {
      throw StateError('Cannot pop from an empty PriorityQueue');
    }
    if (_heap.length == 1) {
      return _heap.removeLast();
    }
    final result = _heap[0];
    _heap[0] = _heap.removeLast();
    _siftDown(0);
    return result;
  }

  /// Returns the top priority element without removing it. Time complexity: O(1).
  /// Throws a [StateError] if the queue is empty.
  T get top {
    if (empty) {
      throw StateError('Cannot access top of an empty PriorityQueue');
    }
    return _heap[0];
  }

  /// Returns `true` if the priority queue is empty.
  bool get empty => _heap.isEmpty;

  /// Returns `true` if the priority queue is not empty.
  bool get isNotEmpty => _heap.isNotEmpty;

  /// Returns the number of elements in the priority queue.
  int get size => _heap.length;

  /// Alias for generic Dart collection length.
  int get length => _heap.length;

  /// Clears the priority queue.
  void clear() {
    _heap.clear();
  }

  /// Exchanges the contents of this priority queue with those of [other].
  void swap(PriorityQueue<T> other) {
    final tempHeap = _heap.toList();
    _heap.clear();
    _heap.addAll(other._heap);
    other._heap.clear();
    other._heap.addAll(tempHeap);
  }

  void _siftUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) >>> 1;
      // Max-heap by default: if parent is less than child, swap them.
      if (_compare(_heap[parentIndex], _heap[index]) < 0) {
        final temp = _heap[index];
        _heap[index] = _heap[parentIndex];
        _heap[parentIndex] = temp;
        index = parentIndex;
      } else {
        break;
      }
    }
  }

  void _siftDown(int index) {
    final length = _heap.length;
    while (true) {
      int largest = index;
      final leftChild = (index << 1) + 1;
      final rightChild = leftChild + 1;

      if (leftChild < length &&
          _compare(_heap[largest], _heap[leftChild]) < 0) {
        largest = leftChild;
      }
      if (rightChild < length &&
          _compare(_heap[largest], _heap[rightChild]) < 0) {
        largest = rightChild;
      }

      if (largest != index) {
        final temp = _heap[index];
        _heap[index] = _heap[largest];
        _heap[largest] = temp;
        index = largest;
      } else {
        break;
      }
    }
  }

  @override
  String toString() {
    return 'PriorityQueue(${_heap.toList()})';
  }

  @override
  int get hashCode => Object.hashAll(_heap);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PriorityQueue<T>) return false;
    if (size != other.size) return false;

    // For PriorityQueue, perfect structural equality means the underlying heaps are identical.
    for (int i = 0; i < size; i++) {
      if (_heap[i] != other._heap[i]) return false;
    }
    return true;
  }
}
