import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;

/// A collection that contains no duplicate elements, ensuring strict sorting order.
///
/// In the C++ STL, this matches exactly the behavior, complexity, and contract of `std::set`.
/// It utilizes a balanced tree structure (Splay tree) under the hood.
/// Iteration yields elements in strictly mathematical or custom-comparator order.
class SortedSet<T> with IterableMixin<T> {
  final collection.SplayTreeSet<T> _container;
  final int Function(T, T)? _compare;

  @override
  Iterator<T> get iterator => _container.iterator;

  /// Creates an empty SortedSet.
  ///
  /// Optionally inject a [compare] function. If null, it assumes elements are `Comparable`.
  SortedSet([this._compare])
    : _container = collection.SplayTreeSet<T>(_compare);

  /// Creates a SortedSet containing the elements of the given iterable.
  SortedSet.from(Iterable<T> elements, [this._compare])
    : _container = collection.SplayTreeSet<T>.from(elements, _compare);

  /// Inserts a new [element] into the set. Time complexity: O(log N).
  ///
  /// Returns `true` if the element was added, or `false` if it was already present.
  bool insert(T element) {
    return _container.add(element);
  }

  /// Removes [element] from the set. Time complexity: O(log N).
  ///
  /// Returns `true` if the element was removed, or `false` if it was not found.
  bool erase(T element) {
    return _container.remove(element);
  }

  /// Returns `true` if the set contains the exact [element]. Time complexity: O(log N).
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
  void swap(SortedSet<T> other) {
    final temp = _container.toSet();
    _container.clear();
    _container.addAll(other._container);
    other._container.clear();
    other._container.addAll(temp);
  }

  /// Returns a new SortedSet with the elements of this that are not in [other].
  SortedSet<T> difference(SortedSet<T> other) {
    return SortedSet<T>.from(_container.difference(other._container), _compare);
  }

  /// Returns a new SortedSet which contains all the elements of this set and [other].
  SortedSet<T> union(SortedSet<T> other) {
    return SortedSet<T>.from(_container.union(other._container), _compare);
  }

  /// Returns a new SortedSet which is the intersection between this set and [other].
  SortedSet<T> intersection(SortedSet<T> other) {
    return SortedSet<T>.from(
      _container.intersection(other._container),
      _compare,
    );
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
    if (other is! SortedSet<T>) return false;
    if (size != other.size) return false;
    return containsAll(other);
  }
}
