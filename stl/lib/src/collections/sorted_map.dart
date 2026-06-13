import 'dart:collection' show IterableMixin;
import '../utilities/pair.dart';
import 'red_black_tree.dart';

/// A collection that stores elements as key-value pairs, maintaining them in strictly sorted order by key.
///
/// In the C++ STL, this matches exactly the behavior, complexity, and contract of `std::map`.
/// It utilizes a balanced tree structure (Red-Black tree) under the hood.
/// Iteration yields elements in strictly mathematical or custom-comparator order of keys.
class SortedMap<K, V> with IterableMixin<Pair<K, V>> {
  final RedBlackTree<K, V> _container;

  @override
  Iterator<Pair<K, V>> get iterator =>
      _container.nodes.map((node) => Pair<K, V>(node.key, node.value)).iterator;

  /// Creates an empty SortedMap.
  ///
  /// Optionally inject a [compare] function. If null, it assumes keys are `Comparable`.
  SortedMap([int Function(K, K)? compare]) : _container = RedBlackTree<K, V>(compare);

  /// Creates a SortedMap from an existing Dart [Map].
  SortedMap.from(Map<K, V> other, [int Function(K, K)? compare])
      : _container = RedBlackTree<K, V>(compare) {
    for (var entry in other.entries) {
      _container.insert(entry.key, entry.value);
    }
  }

  /// Inserts a key-value pair.
  /// If the key already exists, its value is updated. Time complexity: O(log N).
  void insert(K key, V value) {
    _container.insert(key, value);
  }

  /// Removes the element with the specified [key]. Time complexity: O(log N).
  ///
  /// Returns `true` if the key was found and removed, `false` otherwise.
  bool erase(K key) {
    return _container.erase(key);
  }

  /// Returns `true` if the map contains the specified [key]. Time complexity: O(log N).
  bool containsKey(K key) {
    return _container.findNode(key) != null;
  }

  /// Returns the value associated with the [key], or null if it doesn't exist. Time complexity: O(log N).
  V? operator [](K key) => _container.findNode(key)?.value;

  /// Associates the [value] with the [key]. Time complexity: O(log N).
  void operator []=(K key, V value) {
    _container.insert(key, value);
  }

  /// Removes all elements from the map.
  void clear() {
    _container.clear();
  }

  /// Returns the number of elements in the map.
  int get size => _container.length;

  /// Returns `true` if the map is empty.
  bool get empty => _container.isEmpty;

  /// Returns `true` if the map is not empty.
  @override
  bool get isNotEmpty => _container.isNotEmpty;

  /// Exchanges the contents of this map with those of [other].
  void swap(SortedMap<K, V> other) {
    _container.swap(other._container);
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var node in _container.nodes) {
      hash ^= Object.hash(node.key, node.value);
    }
    return hash;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SortedMap<K, V>) return false;
    if (size != other.size) return false;

    for (var node in _container.nodes) {
      if (!other.containsKey(node.key) || other[node.key] != node.value) {
        return false;
      }
    }
    return true;
  }
}
