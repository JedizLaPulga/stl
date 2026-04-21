import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;
import '../utility/pair.dart';

/// A collection that stores elements as key-value pairs, maintaining them in strictly sorted order by key.
///
/// In the C++ STL, this matches exactly the behavior, complexity, and contract of `std::map`.
/// It utilizes a balanced tree structure (Splay tree) under the hood.
/// Iteration yields elements in strictly mathematical or custom-comparator order of keys.
class SortedMap<K, V> with IterableMixin<Pair<K, V>> {
  final collection.SplayTreeMap<K, V> _container;
  final int Function(K, K)? _compare;

  @override
  Iterator<Pair<K, V>> get iterator =>
      _container.entries.map((e) => Pair<K, V>.fromMapEntry(e)).iterator;

  /// Creates an empty SortedMap.
  ///
  /// Optionally inject a [compare] function. If null, it assumes keys are `Comparable`.
  SortedMap([this._compare]) : _container = collection.SplayTreeMap<K, V>(_compare);

  /// Creates a SortedMap from an existing Dart [Map].
  SortedMap.from(Map<K, V> other, [this._compare])
      : _container = collection.SplayTreeMap<K, V>.from(other, _compare);

  /// Inserts a key-value pair.
  /// If the key already exists, its value is updated. Time complexity: O(log N).
  void insert(K key, V value) {
    _container[key] = value;
  }

  /// Removes the element with the specified [key]. Time complexity: O(log N).
  ///
  /// Returns `true` if the key was found and removed, `false` otherwise.
  bool erase(K key) {
    if (_container.containsKey(key)) {
      _container.remove(key);
      return true;
    }
    return false;
  }

  /// Returns `true` if the map contains the specified [key]. Time complexity: O(log N).
  bool containsKey(K key) {
    return _container.containsKey(key);
  }

  /// Returns the value associated with the [key], or null if it doesn't exist. Time complexity: O(log N).
  V? operator [](K key) => _container[key];

  /// Associates the [value] with the [key]. Time complexity: O(log N).
  void operator []=(K key, V value) {
    _container[key] = value;
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
    final temp = Map<K, V>.of(_container);
    _container.clear();
    _container.addAll(other._container);
    other._container.clear();
    other._container.addAll(temp);
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var entry in _container.entries) {
      hash ^= Object.hash(entry.key, entry.value);
    }
    return hash;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SortedMap<K, V>) return false;
    if (size != other.size) return false;

    for (var key in _container.keys) {
      if (!other.containsKey(key) || other[key] != _container[key]) {
        return false;
      }
    }
    return true;
  }
}
