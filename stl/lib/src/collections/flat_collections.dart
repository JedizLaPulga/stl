import 'dart:collection' show IterableMixin;

import '../exceptions/exceptions.dart';

int _defaultCompare<T>(T a, T b) {
  if (a is Comparable && b is Comparable) return a.compareTo(b);
  throw ArgumentError(
    'Elements must be Comparable if no compare function is provided.',
  );
}

int _lowerBound<T>(List<T> data, T value, int Function(T, T) compare) {
  var lo = 0;
  var hi = data.length;
  while (lo < hi) {
    final mid = lo + ((hi - lo) >> 1);
    if (compare(data[mid], value) < 0) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

int _upperBound<T>(List<T> data, T value, int Function(T, T) compare) {
  var lo = 0;
  var hi = data.length;
  while (lo < hi) {
    final mid = lo + ((hi - lo) >> 1);
    if (compare(data[mid], value) <= 0) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

/// An array-backed sorted set with $O(\log n)$ lookup and $O(n)$ insert/erase.
///
/// Mirrors C++23 `std::flat_set`. Unlike tree-based sets, [FlatSet] stores elements
/// in a contiguous sorted [List], giving excellent cache locality and fast binary-search
/// access at the cost of linear-time mutations. Prefer [FlatSet] for **small-to-medium**
/// read-heavy workloads where cache performance matters.
///
/// All elements must be [Comparable] or a custom [compare] function must be supplied.
/// Duplicate insertions are silently ignored.
///
/// ```dart
/// final s = FlatSet<int>();
/// s.insert(3); s.insert(1); s.insert(2);
/// print(s); // FlatSet([1, 2, 3])
/// print(s.contains(2)); // true
/// print(s.lowerBound(2)); // 1
/// ```
class FlatSet<T> with IterableMixin<T> {
  final List<T> _data;
  final int Function(T, T) _compare;

  /// Creates an empty [FlatSet].
  ///
  /// Supply a [compare] function if [T] is not [Comparable].
  FlatSet([int Function(T, T)? compare])
    : _data = [],
      _compare = compare ?? _defaultCompare<T>;

  /// Creates a [FlatSet] from an existing [Iterable], sorted and deduplicated.
  ///
  /// ```dart
  /// final s = FlatSet.from([3, 1, 2, 1]); // [1, 2, 3]
  /// ```
  factory FlatSet.from(Iterable<T> elements, [int Function(T, T)? compare]) {
    final set = FlatSet<T>(compare);
    for (final e in elements) {
      set.insert(e);
    }
    return set;
  }

  // ---------------------------------------------------------------------------
  // Core properties
  // ---------------------------------------------------------------------------

  /// The number of elements in this set. $O(1)$.
  @override
  int get length => _data.length;

  /// Whether this set contains no elements. $O(1)$.
  @override
  bool get isEmpty => _data.isEmpty;

  /// Whether this set contains at least one element. $O(1)$.
  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  Iterator<T> get iterator => _data.iterator;

  /// A read-only view of the underlying sorted data.
  List<T> get data => List.unmodifiable(_data);

  // ---------------------------------------------------------------------------
  // Element access — O(1)
  // ---------------------------------------------------------------------------

  /// The smallest element. Throws [StateError] if empty.
  @override
  T get first {
    if (_data.isEmpty) throw StateError('FlatSet is empty');
    return _data.first;
  }

  /// The largest element. Throws [StateError] if empty.
  @override
  T get last {
    if (_data.isEmpty) throw StateError('FlatSet is empty');
    return _data.last;
  }

  // ---------------------------------------------------------------------------
  // Lookup — O(log n)
  // ---------------------------------------------------------------------------

  /// Returns `true` if [element] is in this set. $O(\log n)$.
  @override
  bool contains(Object? element) {
    if (element is! T) return false;
    final idx = _lowerBound(_data, element, _compare);
    return idx < _data.length && _compare(_data[idx], element) == 0;
  }

  /// Returns the index of the first element `>= value`. $O(\log n)$.
  ///
  /// Mirrors C++ `std::flat_set::lower_bound`.
  int lowerBound(T value) => _lowerBound(_data, value, _compare);

  /// Returns the index of the first element `> value`. $O(\log n)$.
  ///
  /// Mirrors C++ `std::flat_set::upper_bound`.
  int upperBound(T value) => _upperBound(_data, value, _compare);

  // ---------------------------------------------------------------------------
  // Mutation — O(n) due to shifting
  // ---------------------------------------------------------------------------

  /// Inserts [element] into the set. Returns `true` if inserted, `false` if already present.
  ///
  /// $O(\log n)$ for the binary search + $O(n)$ for shifting.
  bool insert(T element) {
    final idx = _lowerBound(_data, element, _compare);
    if (idx < _data.length && _compare(_data[idx], element) == 0) return false;
    _data.insert(idx, element);
    return true;
  }

  /// Removes [element] from the set. Returns `true` if removed, `false` if absent. $O(n)$.
  bool erase(T element) {
    final idx = _lowerBound(_data, element, _compare);
    if (idx >= _data.length || _compare(_data[idx], element) != 0) return false;
    _data.removeAt(idx);
    return true;
  }

  /// Removes all elements from the set.
  void clear() => _data.clear();

  // ---------------------------------------------------------------------------
  // Set algebra — O(n)
  // ---------------------------------------------------------------------------

  /// Returns a new [FlatSet] that is the union of this set and [other]. $O(n + k)$.
  FlatSet<T> union(FlatSet<T> other) {
    final result = FlatSet<T>(_compare);
    var i = 0, j = 0;
    while (i < _data.length && j < other._data.length) {
      final cmp = _compare(_data[i], other._data[j]);
      if (cmp < 0) {
        result._data.add(_data[i++]);
      } else if (cmp > 0) {
        result._data.add(other._data[j++]);
      } else {
        result._data.add(_data[i++]);
        j++;
      }
    }
    while (i < _data.length) {
      result._data.add(_data[i++]);
    }
    while (j < other._data.length) {
      result._data.add(other._data[j++]);
    }
    return result;
  }

  /// Returns a new [FlatSet] that is the intersection of this set and [other]. $O(n + k)$.
  FlatSet<T> intersection(FlatSet<T> other) {
    final result = FlatSet<T>(_compare);
    var i = 0, j = 0;
    while (i < _data.length && j < other._data.length) {
      final cmp = _compare(_data[i], other._data[j]);
      if (cmp < 0) {
        i++;
      } else if (cmp > 0) {
        j++;
      } else {
        result._data.add(_data[i++]);
        j++;
      }
    }
    return result;
  }

  /// Returns a new [FlatSet] that is the difference $A \setminus B$. $O(n + k)$.
  FlatSet<T> difference(FlatSet<T> other) {
    final result = FlatSet<T>(_compare);
    var i = 0, j = 0;
    while (i < _data.length && j < other._data.length) {
      final cmp = _compare(_data[i], other._data[j]);
      if (cmp < 0) {
        result._data.add(_data[i++]);
      } else if (cmp > 0) {
        j++;
      } else {
        i++;
        j++;
      }
    }
    while (i < _data.length) {
      result._data.add(_data[i++]);
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Object overrides
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FlatSet<T>) return false;
    if (_data.length != other._data.length) return false;
    for (var i = 0; i < _data.length; i++) {
      if (_compare(_data[i], other._data[i]) != 0) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_data);

  @override
  String toString() => 'FlatSet($_data)';
}

// =============================================================================
// FlatMap
// =============================================================================

/// An entry in a [FlatMap].
final class FlatMapEntry<K, V> {
  /// The key.
  final K key;

  /// The value.
  V value;

  /// Creates a [FlatMapEntry] with the given [key] and [value].
  FlatMapEntry(this.key, this.value);

  @override
  String toString() => '$key: $value';
}

/// An array-backed sorted associative container with $O(\log n)$ lookup and $O(n)$ insert/erase.
///
/// Mirrors C++23 `std::flat_map`. Keys are stored in a single contiguous sorted [List];
/// values in a parallel [List]. This layout gives cache-friendly $O(\log n)$ binary-search
/// access with better spatial locality than a tree-based map, at the cost of $O(n)$ mutations.
/// Prefer [FlatMap] for **small-to-medium** read-heavy workloads.
///
/// All keys must be [Comparable] or a custom [compare] function must be supplied.
/// Duplicate key insertions overwrite the existing value.
///
/// ```dart
/// final m = FlatMap<String, int>();
/// m.insert('banana', 2);
/// m.insert('apple', 1);
/// m.insert('cherry', 3);
/// print(m);               // FlatMap({apple: 1, banana: 2, cherry: 3})
/// print(m['banana']);     // 2
/// print(m.lowerBound('b')); // 1
/// ```
class FlatMap<K, V> with IterableMixin<FlatMapEntry<K, V>> {
  final List<K> _keys;
  final List<V> _values;
  final int Function(K, K) _compare;

  /// Creates an empty [FlatMap].
  ///
  /// Supply a [compare] function if [K] is not [Comparable].
  FlatMap([int Function(K, K)? compare])
    : _keys = [],
      _values = [],
      _compare = compare ?? _defaultCompare<K>;

  /// Creates a [FlatMap] from an existing [Map], sorted by key.
  ///
  /// ```dart
  /// final m = FlatMap.from({'b': 2, 'a': 1}); // {a:1, b:2}
  /// ```
  factory FlatMap.from(Map<K, V> source, [int Function(K, K)? compare]) {
    final map = FlatMap<K, V>(compare);
    for (final entry in source.entries) {
      map.insert(entry.key, entry.value);
    }
    return map;
  }

  // ---------------------------------------------------------------------------
  // Core properties
  // ---------------------------------------------------------------------------

  /// The number of key-value pairs. $O(1)$.
  @override
  int get length => _keys.length;

  /// Whether this map contains no entries. $O(1)$.
  @override
  bool get isEmpty => _keys.isEmpty;

  /// Whether this map contains at least one entry. $O(1)$.
  @override
  bool get isNotEmpty => _keys.isNotEmpty;

  /// An iterable over all keys in sorted order.
  Iterable<K> get keys => List.unmodifiable(_keys);

  /// An iterable over all values in key-sorted order.
  Iterable<V> get values => List.unmodifiable(_values);

  @override
  Iterator<FlatMapEntry<K, V>> get iterator => _FlatMapIterator(_keys, _values);

  // ---------------------------------------------------------------------------
  // Lookup — O(log n)
  // ---------------------------------------------------------------------------

  /// Returns the value associated with [key], or `null` if absent. $O(\log n)$.
  V? operator [](K key) {
    final idx = _lowerBound(_keys, key, _compare);
    if (idx < _keys.length && _compare(_keys[idx], key) == 0) {
      return _values[idx];
    }
    return null;
  }

  /// Returns the value for [key]. Throws [OutOfRange] if [key] is absent. $O(\log n)$.
  V at(K key) {
    final idx = _lowerBound(_keys, key, _compare);
    if (idx < _keys.length && _compare(_keys[idx], key) == 0) {
      return _values[idx];
    }
    throw OutOfRange('Key not found: $key');
  }

  /// Returns `true` if [key] is present. $O(\log n)$.
  bool containsKey(K key) {
    final idx = _lowerBound(_keys, key, _compare);
    return idx < _keys.length && _compare(_keys[idx], key) == 0;
  }

  /// Returns `true` if [value] is present (uses `==`). $O(n)$.
  bool containsValue(V value) => _values.contains(value);

  /// Returns the index of the first key `>= key`. $O(\log n)$.
  ///
  /// Mirrors C++ `std::flat_map::lower_bound`.
  int lowerBound(K key) => _lowerBound(_keys, key, _compare);

  /// Returns the index of the first key `> key`. $O(\log n)$.
  ///
  /// Mirrors C++ `std::flat_map::upper_bound`.
  int upperBound(K key) => _upperBound(_keys, key, _compare);

  // ---------------------------------------------------------------------------
  // Mutation — O(n) due to shifting
  // ---------------------------------------------------------------------------

  /// Inserts or replaces the mapping for [key] with [value]. $O(\log n)$ search + $O(n)$ shift.
  ///
  /// Returns `true` if a new key was inserted, `false` if an existing value was replaced.
  bool insert(K key, V value) {
    final idx = _lowerBound(_keys, key, _compare);
    if (idx < _keys.length && _compare(_keys[idx], key) == 0) {
      _values[idx] = value;
      return false;
    }
    _keys.insert(idx, key);
    _values.insert(idx, value);
    return true;
  }

  /// Sets the value at [key]. Equivalent to [insert].
  void operator []=(K key, V value) => insert(key, value);

  /// Removes the entry for [key]. Returns `true` if removed, `false` if absent. $O(n)$.
  bool erase(K key) {
    final idx = _lowerBound(_keys, key, _compare);
    if (idx >= _keys.length || _compare(_keys[idx], key) != 0) return false;
    _keys.removeAt(idx);
    _values.removeAt(idx);
    return true;
  }

  /// Removes all entries from the map.
  void clear() {
    _keys.clear();
    _values.clear();
  }

  // ---------------------------------------------------------------------------
  // Object overrides
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FlatMap<K, V>) return false;
    if (_keys.length != other._keys.length) return false;
    for (var i = 0; i < _keys.length; i++) {
      if (_compare(_keys[i], other._keys[i]) != 0) return false;
      if (_values[i] != other._values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(_keys), Object.hashAll(_values));

  @override
  String toString() {
    final sb = StringBuffer('FlatMap({');
    for (var i = 0; i < _keys.length; i++) {
      if (i > 0) sb.write(', ');
      sb.write('${_keys[i]}: ${_values[i]}');
    }
    sb.write('})');
    return sb.toString();
  }
}

class _FlatMapIterator<K, V> implements Iterator<FlatMapEntry<K, V>> {
  final List<K> _keys;
  final List<V> _values;
  int _index = -1;

  _FlatMapIterator(this._keys, this._values);

  @override
  FlatMapEntry<K, V> get current =>
      FlatMapEntry(_keys[_index], _values[_index]);

  @override
  bool moveNext() {
    _index++;
    return _index < _keys.length;
  }
}
