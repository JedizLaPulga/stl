import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;
import '../utility/pair.dart';

/// An unordered collection of key-value pairs.
///
/// In the C++ STL, this matches `std::unordered_map`.
/// It utilizes a fast hash table under the hood and makes no guarantees
/// about the iteration order of the elements.
class HashMap<K, V> with IterableMixin<Pair<K, V>> {
  final collection.HashMap<K, V> _container;

  @override
  Iterator<Pair<K, V>> get iterator =>
      _container.entries.map((e) => Pair<K, V>.fromMapEntry(e)).iterator;

  /// Creates an empty HashMap.
  HashMap() : _container = collection.HashMap<K, V>();

  /// Creates a HashMap from an existing Dart [Map].
  HashMap.from(Map<K, V> other)
      : _container = collection.HashMap<K, V>.from(other);

  /// Inserts a key-value pair.
  /// If the key already exists, its value is updated.
  void insert(K key, V value) {
    _container[key] = value;
  }

  /// Removes the element with the specified [key].
  ///
  /// Returns `true` if the key was found and removed, `false` otherwise.
  bool erase(K key) {
    if (_container.containsKey(key)) {
      _container.remove(key);
      return true;
    }
    return false;
  }

  /// Returns `true` if the map contains the specified [key].
  bool containsKey(K key) {
    return _container.containsKey(key);
  }

  /// Returns the value associated with the [key], or null if it doesn't exist.
  V? operator [](K key) => _container[key];

  /// Associates the [value] with the [key].
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
  void swap(HashMap<K, V> other) {
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
    if (other is! HashMap<K, V>) return false;
    if (size != other.size) return false;

    for (var key in _container.keys) {
      if (!other.containsKey(key) || other[key] != _container[key]) {
        return false;
      }
    }
    return true;
  }
}
