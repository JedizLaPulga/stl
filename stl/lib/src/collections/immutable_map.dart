import 'dart:collection';

import '../utilities/pair.dart';

/// A persistent, immutable associative container mapping unique keys to values.
///
/// Mirrors `std::map` semantics but with persistent (copy-on-write) semantics:
/// every operation that modifies the map returns a **new** [ImmutableMap]
/// instance — the original is never changed.
///
/// Iteration order follows insertion order (backed by `LinkedHashMap`).
/// All single-key operations (`put`, `remove`, `get`) are amortised $O(1)$.
/// Structural bulk operations (`merge`, `mapValues`, etc.) are $O(n)$.
///
/// [ImmutableMap] implements [Iterable<Pair<K, V>>], making it a first-class
/// citizen of the range pipeline.
///
/// ```dart
/// final a = ImmutableMap.of({'x': 1, 'y': 2});
/// final b = a.put('z', 3);        // {x:1, y:2, z:3}
/// final c = b.remove('x');        // {y:2, z:3}
/// final d = c.update('y', (v) => v * 10); // {y:20, z:3}
/// print(a);                        // ImmutableMap({x: 1, y: 2}) — unchanged
/// ```
final class ImmutableMap<K, V> with IterableMixin<Pair<K, V>> {
  final Map<K, V> _data;

  ImmutableMap._(Map<K, V> data)
    : _data = Map.unmodifiable(LinkedHashMap.of(data));

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Creates an empty [ImmutableMap].
  ///
  /// ```dart
  /// final empty = ImmutableMap<String, int>.empty();
  /// ```
  factory ImmutableMap.empty() => ImmutableMap._({});

  /// Creates an [ImmutableMap] from an existing Dart [Map].
  ///
  /// ```dart
  /// final m = ImmutableMap.of({'a': 1, 'b': 2});
  /// ```
  factory ImmutableMap.of(Map<K, V> source) => ImmutableMap._(source);

  /// Creates an [ImmutableMap] from an iterable of [Pair]s.
  ///
  /// Later pairs overwrite earlier ones for duplicate keys.
  ///
  /// ```dart
  /// final m = ImmutableMap.fromPairs([Pair('a', 1), Pair('b', 2)]);
  /// ```
  factory ImmutableMap.fromPairs(Iterable<Pair<K, V>> pairs) {
    final map = <K, V>{};
    for (final p in pairs) {
      map[p.first] = p.second;
    }
    return ImmutableMap._(map);
  }

  /// Creates an [ImmutableMap] from an iterable of [MapEntry]s.
  ///
  /// ```dart
  /// final m = ImmutableMap.fromEntries([MapEntry('a', 1)]);
  /// ```
  factory ImmutableMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    return ImmutableMap._(Map.fromEntries(entries));
  }

  // ---------------------------------------------------------------------------
  // Core properties
  // ---------------------------------------------------------------------------

  /// The number of key-value pairs. $O(1)$.
  @override
  int get length => _data.length;

  /// Whether this map contains no entries. $O(1)$.
  @override
  bool get isEmpty => _data.isEmpty;

  /// Whether this map contains at least one entry. $O(1)$.
  @override
  bool get isNotEmpty => _data.isNotEmpty;

  /// An iterable over all keys.
  Iterable<K> get keys => _data.keys;

  /// An iterable over all values.
  Iterable<V> get values => _data.values;

  /// An iterable over all [MapEntry]s.
  Iterable<MapEntry<K, V>> get entries => _data.entries;

  @override
  Iterator<Pair<K, V>> get iterator =>
      _data.entries.map((e) => Pair<K, V>(e.key, e.value)).iterator;

  // ---------------------------------------------------------------------------
  // Element access
  // ---------------------------------------------------------------------------

  /// Returns the value for [key], or `null` if absent. $O(1)$.
  V? operator [](K key) => _data[key];

  /// Returns the value for [key]. Throws [ArgumentError] if [key] is absent.
  V at(K key) {
    if (!_data.containsKey(key)) {
      throw ArgumentError('Key not found: $key');
    }
    return _data[key] as V;
  }

  /// Returns `true` if [key] is present. $O(1)$.
  bool containsKey(K key) => _data.containsKey(key);

  /// Returns `true` if [value] is present (uses `==`). $O(n)$.
  bool containsValue(V value) => _data.containsValue(value);

  // ---------------------------------------------------------------------------
  // Persistent mutation
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableMap] with [key] mapped to [value].
  ///
  /// If [key] already exists, its value is replaced. $O(n)$ due to copy.
  ///
  /// ```dart
  /// final m2 = m.put('c', 3);
  /// ```
  ImmutableMap<K, V> put(K key, V value) =>
      ImmutableMap._({..._data, key: value});

  /// Returns a new [ImmutableMap] with all entries from [other] added.
  ///
  /// Duplicate keys are overwritten by [other]'s values. $O(n + k)$.
  ImmutableMap<K, V> putAll(Map<K, V> other) =>
      ImmutableMap._({..._data, ...other});

  /// Returns a new [ImmutableMap] without the entry for [key].
  ///
  /// If [key] is not present, returns an equal copy. $O(n)$.
  ///
  /// ```dart
  /// final m2 = m.remove('a');
  /// ```
  ImmutableMap<K, V> remove(K key) {
    final copy = LinkedHashMap.of(_data)..remove(key);
    return ImmutableMap._(copy);
  }

  /// Returns a new [ImmutableMap] with [key]'s value replaced by
  /// `updater(currentValue)`. Throws [ArgumentError] if [key] is absent.
  ///
  /// ```dart
  /// final m2 = m.update('score', (v) => v + 1);
  /// ```
  ImmutableMap<K, V> update(K key, V Function(V current) updater) {
    if (!_data.containsKey(key)) {
      throw ArgumentError('Key not found: $key');
    }
    return ImmutableMap._({..._data, key: updater(_data[key] as V)});
  }

  /// Returns a new [ImmutableMap] with [key]'s value replaced by
  /// `updater(currentValue)`, or [ifAbsent] inserted if [key] is absent.
  ImmutableMap<K, V> updateOrInsert(
    K key,
    V Function(V current) updater,
    V Function() ifAbsent,
  ) {
    if (_data.containsKey(key)) {
      return ImmutableMap._({..._data, key: updater(_data[key] as V)});
    }
    return ImmutableMap._({..._data, key: ifAbsent()});
  }

  /// Returns an empty [ImmutableMap]. $O(1)$.
  ImmutableMap<K, V> clear() => ImmutableMap._({});

  // ---------------------------------------------------------------------------
  // Functional transforms
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableMap] with each value transformed by [f].
  ///
  /// ```dart
  /// final doubled = m.mapValues((v) => v * 2);
  /// ```
  ImmutableMap<K, W> mapValues<W>(W Function(V value) f) {
    return ImmutableMap._(
      Map.fromEntries(_data.entries.map((e) => MapEntry(e.key, f(e.value)))),
    );
  }

  /// Returns a new [ImmutableMap] with each key-value pair transformed by [f].
  ImmutableMap<K2, V2> mapEntries<K2, V2>(
    MapEntry<K2, V2> Function(K key, V value) f,
  ) {
    return ImmutableMap._(
      Map.fromEntries(_data.entries.map((e) => f(e.key, e.value))),
    );
  }

  /// Returns a new [ImmutableMap] containing only entries where [test] returns
  /// `true`.
  ///
  /// ```dart
  /// final positive = m.filter((k, v) => v > 0);
  /// ```
  ImmutableMap<K, V> filter(bool Function(K key, V value) test) {
    final copy = <K, V>{};
    for (final e in _data.entries) {
      if (test(e.key, e.value)) copy[e.key] = e.value;
    }
    return ImmutableMap._(copy);
  }

  /// Returns a new [ImmutableMap] containing only entries whose keys satisfy
  /// [test].
  ImmutableMap<K, V> whereKey(bool Function(K key) test) =>
      filter((k, _) => test(k));

  /// Returns a new [ImmutableMap] containing only entries whose values satisfy
  /// [test].
  ImmutableMap<K, V> whereValue(bool Function(V value) test) =>
      filter((_, v) => test(v));

  /// Returns a new [ImmutableMap] that is the result of merging this map with
  /// [other].
  ///
  /// When a key exists in both maps, [resolve] is called with both values to
  /// produce the merged value. If [resolve] is omitted, [other]'s value wins.
  ///
  /// ```dart
  /// final merged = a.merge(b, resolve: (v1, v2) => v1 + v2);
  /// ```
  ImmutableMap<K, V> merge(
    ImmutableMap<K, V> other, {
    V Function(V existing, V incoming)? resolve,
  }) {
    final copy = LinkedHashMap.of(_data);
    for (final e in other._data.entries) {
      if (copy.containsKey(e.key) && resolve != null) {
        copy[e.key] = resolve(copy[e.key] as V, e.value);
      } else {
        copy[e.key] = e.value;
      }
    }
    return ImmutableMap._(copy);
  }

  // ---------------------------------------------------------------------------
  // Conversion
  // ---------------------------------------------------------------------------

  /// Returns a mutable [Map] copy of all entries (insertion-ordered).
  Map<K, V> toMap() => LinkedHashMap.of(_data);

  /// Returns a [List] of all [Pair]s.
  @override
  List<Pair<K, V>> toList({bool growable = true}) {
    final result = _data.entries
        .map((e) => Pair<K, V>(e.key, e.value))
        .toList();
    return growable ? result : List.unmodifiable(result);
  }

  // ---------------------------------------------------------------------------
  // Object overrides
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImmutableMap<K, V>) return false;
    if (_data.length != other._data.length) return false;
    for (final e in _data.entries) {
      if (!other._data.containsKey(e.key) || other._data[e.key] != e.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hashAll(_data.entries.map((e) => Object.hash(e.key, e.value)));

  @override
  String toString() => 'ImmutableMap($_data)';
}
