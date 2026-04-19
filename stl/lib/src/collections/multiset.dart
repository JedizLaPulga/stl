import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;

class _MultiSetIterator<T> implements Iterator<T> {
  final Iterator<MapEntry<T, int>> _entryIterator;
  int _currentCount = 0;
  int _index = 0;
  T? _current;

  _MultiSetIterator(Map<T, int> map) : _entryIterator = map.entries.iterator;

  @override
  T get current => _current as T;

  @override
  bool moveNext() {
    if (_index < _currentCount) {
      _index++;
      return true;
    }
    if (_entryIterator.moveNext()) {
      _current = _entryIterator.current.key;
      _currentCount = _entryIterator.current.value;
      _index = 1;
      return true;
    }
    return false;
  }
}

/// A collection that contains elements in sorted order, allowing duplicates.
///
/// In the C++ STL, this matches exactly the behavior and contract of `std::multiset`.
/// It utilizes a balanced tree structure under the hood to keep elements ordered.
class MultiSet<T> with IterableMixin<T> {
  final collection.SplayTreeMap<T, int> _container;
  int _size = 0;

  @override
  Iterator<T> get iterator => _MultiSetIterator<T>(_container);

  /// Creates an empty MultiSet.
  ///
  /// Optionally inject a [compare] function. If null, it assumes elements are `Comparable`.
  MultiSet([int Function(T, T)? compare])
      : _container = collection.SplayTreeMap<T, int>(compare);

  /// Creates a MultiSet containing the elements of the given iterable.
  MultiSet.from(Iterable<T> elements, [int Function(T, T)? compare])
      : _container = collection.SplayTreeMap<T, int>(compare) {
    for (var element in elements) {
      insert(element);
    }
  }

  /// Inserts a new [element] into the set. Time complexity: O(log N).
  void insert(T element) {
    _container[element] = (_container[element] ?? 0) + 1;
    _size++;
  }

  /// Removes all instances of [element] from the set. Time complexity: O(log N).
  ///
  /// Returns the number of elements removed.
  int erase(T element) {
    final count = _container.remove(element);
    if (count != null) {
      _size -= count;
      return count;
    }
    return 0;
  }

  /// Removes a single instance of [element] from the set. Time complexity: O(log N).
  ///
  /// Returns `true` if an element was removed, `false` otherwise.
  bool eraseOne(T element) {
    final currentCount = _container[element];
    if (currentCount == null) return false;

    if (currentCount > 1) {
      _container[element] = currentCount - 1;
    } else {
      _container.remove(element);
    }
    _size--;
    return true;
  }

  /// Returns the number of occurrences of [element] in the set. Time complexity: O(log N).
  int count(T element) {
    return _container[element] ?? 0;
  }

  /// Returns `true` if the set contains the exact [element]. Time complexity: O(log N).
  @override
  bool contains(covariant T element) {
    return _container.containsKey(element);
  }

  /// Removes all elements from the set.
  void clear() {
    _container.clear();
    _size = 0;
  }

  /// Returns the total number of elements in the set, including duplicates.
  int get size => _size;

  /// Returns the number of unique elements in the set.
  int get uniqueSize => _container.length;

  /// Returns `true` if the set is empty.
  bool get empty => _size == 0;

  /// Returns `true` if the set is not empty.
  @override
  bool get isNotEmpty => _size > 0;

  /// Exchanges the contents of this set with those of [other].
  void swap(MultiSet<T> other) {
    final temp = Map<T, int>.of(_container);
    final tempSize = _size;

    _container.clear();
    _container.addAll(other._container);
    _size = other._size;

    other._container.clear();
    other._container.addAll(temp);
    other._size = tempSize;
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MultiSet<T>) return false;
    if (size != other.size) return false;

    for (var entry in _container.entries) {
      if (other.count(entry.key) != entry.value) {
        return false;
      }
    }
    return true;
  }
}
