import 'dart:collection' show IterableMixin;
import 'red_black_tree.dart';

/// A collection that contains no duplicate elements, ensuring strict sorting order.
///
/// In the C++ STL, this matches exactly the behavior, complexity, and contract of `std::set`.
/// It utilizes a balanced tree structure (Red-Black tree) under the hood.
/// Iteration yields elements in strictly mathematical or custom-comparator order.
class SortedSet<T> with IterableMixin<T> {
  final RedBlackTree<T, bool> _container;
  final int Function(T, T)? _compare;

  @override
  Iterator<T> get iterator => _container.nodes.map((node) => node.key).iterator;

  /// Creates an empty SortedSet.
  ///
  /// Optionally inject a [compare] function. If null, it assumes elements are `Comparable`.
  SortedSet([this._compare]) : _container = RedBlackTree<T, bool>(_compare);

  /// Creates a SortedSet containing the elements of the given iterable.
  SortedSet.from(Iterable<T> elements, [this._compare])
      : _container = RedBlackTree<T, bool>(_compare) {
    for (var element in elements) {
      _container.insert(element, true);
    }
  }

  /// Inserts a new [element] into the set. Time complexity: O(log N).
  ///
  /// Returns `true` if the element was added, or `false` if it was already present.
  bool insert(T element) {
    return _container.insert(element, true);
  }

  /// Removes [element] from the set. Time complexity: O(log N).
  ///
  /// Returns `true` if the element was removed, or `false` if it was not found.
  bool erase(T element) {
    return _container.erase(element);
  }

  /// Returns `true` if the set contains the exact [element]. Time complexity: O(log N).
  @override
  bool contains(covariant T element) {
    return _container.findNode(element) != null;
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
    _container.swap(other._container);
  }

  /// Returns a new SortedSet with the elements of this that are not in [other].
  SortedSet<T> difference(SortedSet<T> other) {
    final result = SortedSet<T>(_compare);
    for (var element in this) {
      if (!other.contains(element)) {
        result.insert(element);
      }
    }
    return result;
  }

  /// Returns a new SortedSet which contains all the elements of this set and [other].
  SortedSet<T> union(SortedSet<T> other) {
    final result = SortedSet<T>(_compare);
    for (var element in this) {
      result.insert(element);
    }
    for (var element in other) {
      result.insert(element);
    }
    return result;
  }

  /// Returns a new SortedSet which is the intersection between this set and [other].
  SortedSet<T> intersection(SortedSet<T> other) {
    final result = SortedSet<T>(_compare);
    for (var element in this) {
      if (other.contains(element)) {
        result.insert(element);
      }
    }
    return result;
  }

  /// Whether this set contains all the elements of [other].
  bool containsAll(Iterable<T> other) {
    for (var element in other) {
      if (!contains(element)) return false;
    }
    return true;
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
