import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;

/// An unordered collection that contains no duplicate elements.
///
/// In the C++ STL, this matches `std::unordered_set`.
/// It utilizes a fast hash table under the hood and makes no guarantees
/// about the iteration order of the elements.
/// For an insertion-ordered set, use the generic [Set].
/// For a strictly sorted set, use [SortedSet].
class HashSet<T> with IterableMixin<T> {
  final collection.HashSet<T> _container;

  @override
  Iterator<T> get iterator => _container.iterator;

  /// Creates an empty HashSet.
  HashSet() : _container = collection.HashSet<T>();

  /// Creates a HashSet containing the elements of the given iterable.
  HashSet.from(Iterable<T> elements)
    : _container = collection.HashSet<T>.from(elements);

  /// Inserts a new [element] into the set.
  ///
  /// Returns `true` if the element was added, or `false` if it was already present.
  bool insert(T element) {
    return _container.add(element);
  }

  /// Removes [element] from the set (C++ STL style).
  ///
  /// Returns `true` if the element was removed, or `false` if it was not found.
  bool erase(T element) {
    return _container.remove(element);
  }

  /// Returns `true` if the set contains the exact [element].
  @override
  bool contains(covariant T element) {
    return _container.contains(element);
  }

  /// Removes all elements from the set.
  void clear() {
    _container.clear();
  }

  /// Returns the number of elements in the set.
  int get size => _container.length;

  /// Returns `true` if the set is empty.
  bool get empty => _container.isEmpty;

  /// Returns `true` if the set is not empty.
  @override
  bool get isNotEmpty => _container.isNotEmpty;

  /// Exchanges the contents of this set with those of [other].
  void swap(HashSet<T> other) {
    final temp = _container.toSet();
    _container.clear();
    _container.addAll(other._container);
    other._container.clear();
    other._container.addAll(temp);
  }

  /// Returns a new set with the elements of this that are not in [other].
  HashSet<T> difference(HashSet<T> other) {
    return HashSet<T>.from(_container.difference(other._container));
  }

  /// Returns a new set which contains all the elements of this set and [other].
  HashSet<T> union(HashSet<T> other) {
    return HashSet<T>.from(_container.union(other._container));
  }

  /// Returns a new set which is the intersection between this set and [other].
  HashSet<T> intersection(HashSet<T> other) {
    return HashSet<T>.from(_container.intersection(other._container));
  }

  /// Whether this set contains all the elements of [other].
  bool containsAll(Iterable<T> other) {
    return _container.containsAll(other);
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HashSet<T>) return false;
    if (size != other.size) return false;
    return containsAll(other);
  }
}
