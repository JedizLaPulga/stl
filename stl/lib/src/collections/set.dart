import 'dart:collection';
import 'dart:core' as core;

/// A collection that contains no duplicate elements.
///
/// In the C++ STL, `std::set` is generally a balanced binary tree. 
/// However, this generic `Set` utilities Dart's default linked hash table for 
/// optimized insertion-ordered uniqueness. For a pure Tree-based C++ `std::set` equivalent, 
/// utilize [SortedSet]. For an purely unordered, fast C++ hash set, utilize [HashSet].
class Set<T> with IterableMixin<T> {
  final core.Set<T> _container;

  @override
  Iterator<T> get iterator => _container.iterator;

  /// Creates an empty Set.
  Set() : _container = <T>{};

  /// Creates a Set containing the elements of the given iterable.
  Set.from(Iterable<T> elements) : _container = core.Set<T>.from(elements);

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
  void swap(Set<T> other) {
    final temp = _container.toSet();
    _container.clear();
    _container.addAll(other._container);
    other._container.clear();
    other._container.addAll(temp);
  }

  /// Returns a new set with the elements of this that are not in [other].
  Set<T> difference(Set<T> other) {
    return Set<T>.from(_container.difference(other._container));
  }

  /// Returns a new set which contains all the elements of this set and [other].
  Set<T> union(Set<T> other) {
    return Set<T>.from(_container.union(other._container));
  }

  /// Returns a new set which is the intersection between this set and [other].
  Set<T> intersection(Set<T> other) {
    return Set<T>.from(_container.intersection(other._container));
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
    if (other is! Set<T>) return false;
    if (size != other.size) return false;
    return containsAll(other);
  }
}
