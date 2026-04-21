import 'dart:collection' as collection;
import 'dart:collection' show IterableMixin;
import '../utility/pair.dart';

class _MultiMapIterator<K, V> implements Iterator<Pair<K, V>> {
  final Iterator<MapEntry<K, List<V>>> _entryIterator;
  int _index = 0;
  List<V>? _currentList;
  K? _currentKey;

  _MultiMapIterator(Map<K, List<V>> map) : _entryIterator = map.entries.iterator;

  @override
  Pair<K, V> get current {
    if (_currentKey == null || _currentList == null) {
      throw StateError('Iterator is not valid');
    }
    return Pair<K, V>(_currentKey as K, _currentList![_index - 1]);
  }

  @override
  bool moveNext() {
    if (_currentList != null && _index < _currentList!.length) {
      _index++;
      return true;
    }
    if (_entryIterator.moveNext()) {
      _currentKey = _entryIterator.current.key;
      _currentList = _entryIterator.current.value;
      _index = 1;
      return true;
    }
    _currentKey = null;
    _currentList = null;
    return false;
  }
}

/// An associative collection that stores elements as key-value pairs,
/// sorted by key, and allows multiple elements with the same key.
///
/// In the C++ STL, this matches the behavior of `std::multimap`.
/// It utilizes a balanced tree structure under the hood, mapping keys to a list of values.
class MultiMap<K, V> with IterableMixin<Pair<K, V>> {
  final collection.SplayTreeMap<K, List<V>> _container;
  int _size = 0;
  final int Function(K, K)? _compare;

  @override
  Iterator<Pair<K, V>> get iterator => _MultiMapIterator<K, V>(_container);

  /// Creates an empty MultiMap.
  ///
  /// Optionally inject a [compare] function. If null, it assumes keys are `Comparable`.
  MultiMap([this._compare])
      : _container = collection.SplayTreeMap<K, List<V>>(_compare);

  /// Creates a MultiMap containing the key-value pairs of the given iterable.
  MultiMap.from(Iterable<Pair<K, V>> elements, [this._compare])
      : _container = collection.SplayTreeMap<K, List<V>>(_compare) {
    for (var element in elements) {
      insert(element.first, element.second);
    }
  }

  /// Inserts a new key-value pair into the map. Time complexity: O(log N).
  void insert(K key, V value) {
    if (!_container.containsKey(key)) {
      _container[key] = [];
    }
    _container[key]!.add(value);
    _size++;
  }

  /// Removes all values associated with the exact [key]. Time complexity: O(log N).
  ///
  /// Returns the number of elements removed.
  int erase(K key) {
    final removedList = _container.remove(key);
    if (removedList != null) {
      final count = removedList.length;
      _size -= count;
      return count;
    }
    return 0;
  }

  /// Returns the number of values associated with the exact [key]. Time complexity: O(log N).
  int count(K key) {
    return _container[key]?.length ?? 0;
  }

  /// Returns an iterable of all values associated with the [key]. Time complexity: O(log N).
  Iterable<V> equalRange(K key) {
    return _container[key] ?? const [];
  }

  /// Returns `true` if the map contains the exact [key]. Time complexity: O(log N).
  bool containsKey(K key) {
    return _container.containsKey(key);
  }

  /// Removes all elements from the map.
  void clear() {
    _container.clear();
    _size = 0;
  }

  /// Returns the total number of key-value pairs in the map.
  int get size => _size;

  /// Returns `true` if the map is empty.
  bool get empty => _size == 0;

  /// Returns `true` if the map is not empty.
  @override
  bool get isNotEmpty => _size > 0;

  /// Exchanges the contents of this map with those of [other].
  void swap(MultiMap<K, V> other) {
    final temp = Map<K, List<V>>.of(_container);
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
    if (other is! MultiMap<K, V>) return false;
    if (size != other.size) return false;

    var it1 = iterator;
    var it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current != it2.current) return false;
    }
    return true;
  }
}
