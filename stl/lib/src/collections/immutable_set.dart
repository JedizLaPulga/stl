// ignore_for_file: prefer_collection_literals

import 'dart:collection';

import '../exceptions/exceptions.dart';

/// A persistent, immutable set of unique elements.
///
/// Mirrors the contract of `std::unordered_set` but with persistent (copy-on-write)
/// semantics: every operation that modifies the set returns a **new** [ImmutableSet]
/// instance — the original is never changed.
///
/// Iteration order follows insertion order (backed by `LinkedHashSet`).
/// Membership tests are $O(1)$ amortised. Structural operations (`add`, `remove`, etc.)
/// are $O(n)$ due to copying.
///
/// [ImmutableSet] implements [Iterable<T>], making it a first-class citizen of the
/// range pipeline — it composes directly with [FilterRange], [TransformRange],
/// [ZipRange], and every other range adapter.
///
/// ```dart
/// final a = ImmutableSet.of({1, 2, 3});
/// final b = a.add(4);          // ImmutableSet({1, 2, 3, 4})
/// final c = b.remove(2);       // ImmutableSet({1, 3, 4})
/// final d = a.union(ImmutableSet.of({3, 4, 5})); // ImmutableSet({1, 2, 3, 4, 5})
/// print(a);                     // ImmutableSet({1, 2, 3})  — unchanged
/// ```
final class ImmutableSet<T> with IterableMixin<T> {
  final Set<T> _data;

  ImmutableSet._(Set<T> data)
    : _data = Set.unmodifiable(LinkedHashSet.of(data));

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Creates an empty [ImmutableSet].
  ///
  /// ```dart
  /// final empty = ImmutableSet<int>.empty();
  /// ```
  factory ImmutableSet.empty() => ImmutableSet._({});

  /// Creates an [ImmutableSet] from an existing [Iterable].
  ///
  /// Duplicate elements are silently discarded; only the first occurrence is kept.
  ///
  /// ```dart
  /// final s = ImmutableSet.of({1, 2, 3});
  /// ```
  factory ImmutableSet.of(Iterable<T> elements) {
    final linked = <T>{};
    for (final e in elements) {
      linked.add(e);
    }
    return ImmutableSet._(linked);
  }

  /// Creates an [ImmutableSet] with [n] elements by calling [generator] with
  /// each index `0..n-1`. Duplicate results are discarded.
  ///
  /// ```dart
  /// final s = ImmutableSet.generate(4, (i) => i * 2); // {0, 2, 4, 6}
  /// ```
  factory ImmutableSet.generate(int n, T Function(int index) generator) {
    if (n < 0) throw InvalidArgument('n must be >= 0');
    final linked = <T>{};
    for (var i = 0; i < n; i++) {
      linked.add(generator(i));
    }
    return ImmutableSet._(linked);
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

  // ---------------------------------------------------------------------------
  // Element access
  // ---------------------------------------------------------------------------

  /// The first element in insertion order. Throws [StateError] if empty. $O(1)$.
  @override
  T get first {
    if (_data.isEmpty) throw StateError('ImmutableSet is empty');
    return _data.first;
  }

  /// The last element in insertion order. Throws [StateError] if empty. $O(1)$.
  @override
  T get last {
    if (_data.isEmpty) throw StateError('ImmutableSet is empty');
    return _data.last;
  }

  // ---------------------------------------------------------------------------
  // Membership
  // ---------------------------------------------------------------------------

  /// Returns `true` if this set contains [element]. $O(1)$ amortised.
  @override
  bool contains(Object? element) => _data.contains(element);

  // ---------------------------------------------------------------------------
  // Persistent mutation — all O(n) due to copy
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableSet] with [element] added.
  ///
  /// If [element] is already present the returned set is equal to this one. $O(n)$.
  ///
  /// ```dart
  /// final b = ImmutableSet.of({1, 2}).add(3); // {1, 2, 3}
  /// ```
  ImmutableSet<T> add(T element) {
    if (_data.contains(element)) return this;
    final copy = {..._data, element};
    return ImmutableSet._(copy);
  }

  /// Returns a new [ImmutableSet] with all elements of [other] added. $O(n + k)$.
  ImmutableSet<T> addAll(Iterable<T> other) {
    final copy = {..._data, ...other};
    return ImmutableSet._(copy);
  }

  /// Returns a new [ImmutableSet] without [element].
  ///
  /// If [element] is not present the returned set is equal to this one. $O(n)$.
  ///
  /// ```dart
  /// final b = ImmutableSet.of({1, 2, 3}).remove(2); // {1, 3}
  /// ```
  ImmutableSet<T> remove(T element) {
    if (!_data.contains(element)) return this;
    final copy = (_data.toSet())..remove(element);
    return ImmutableSet._(copy);
  }

  /// Returns a new [ImmutableSet] with all elements removed. $O(1)$.
  ImmutableSet<T> clear() => ImmutableSet._({});

  // ---------------------------------------------------------------------------
  // Set algebra — all O(n)
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableSet] containing all elements in either this set or [other]
  /// (i.e. set union, $A \cup B$). $O(n + k)$.
  ///
  /// ```dart
  /// final u = ImmutableSet.of({1, 2}).union(ImmutableSet.of({2, 3})); // {1, 2, 3}
  /// ```
  ImmutableSet<T> union(ImmutableSet<T> other) {
    final copy = {..._data, ...other._data};
    return ImmutableSet._(copy);
  }

  /// Returns a new [ImmutableSet] containing only elements present in **both** this set
  /// and [other] (i.e. set intersection, $A \cap B$). $O(n)$.
  ///
  /// ```dart
  /// final i = ImmutableSet.of({1, 2, 3}).intersection(ImmutableSet.of({2, 3, 4}));
  /// // {2, 3}
  /// ```
  ImmutableSet<T> intersection(ImmutableSet<T> other) {
    final result = <T>{};
    for (final e in _data) {
      if (other._data.contains(e)) result.add(e);
    }
    return ImmutableSet._(result);
  }

  /// Returns a new [ImmutableSet] containing elements in this set that are **not** in [other]
  /// (i.e. set difference, $A \setminus B$). $O(n)$.
  ///
  /// ```dart
  /// final d = ImmutableSet.of({1, 2, 3}).difference(ImmutableSet.of({2, 3, 4})); // {1}
  /// ```
  ImmutableSet<T> difference(ImmutableSet<T> other) {
    final result = <T>{};
    for (final e in _data) {
      if (!other._data.contains(e)) result.add(e);
    }
    return ImmutableSet._(result);
  }

  /// Returns a new [ImmutableSet] containing elements present in exactly one of the two sets
  /// (i.e. symmetric difference, $A \triangle B$). $O(n + k)$.
  ///
  /// ```dart
  /// final s = ImmutableSet.of({1, 2, 3}).symmetricDifference(ImmutableSet.of({2, 3, 4}));
  /// // {1, 4}
  /// ```
  ImmutableSet<T> symmetricDifference(ImmutableSet<T> other) {
    return union(other).difference(intersection(other));
  }

  /// Returns `true` if every element of this set is also in [other] ($A \subseteq B$). $O(n)$.
  bool isSubsetOf(ImmutableSet<T> other) {
    for (final e in _data) {
      if (!other._data.contains(e)) return false;
    }
    return true;
  }

  /// Returns `true` if every element of [other] is also in this set ($A \supseteq B$). $O(n)$.
  bool isSupersetOf(ImmutableSet<T> other) => other.isSubsetOf(this);

  /// Returns `true` if this set and [other] have no elements in common. $O(n)$.
  bool isDisjointFrom(ImmutableSet<T> other) {
    for (final e in _data) {
      if (other._data.contains(e)) return false;
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // Functional transforms — return ImmutableSet / ImmutableList
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableSet] produced by applying [f] to every element.
  ///
  /// Duplicate results are silently discarded.
  ///
  /// ```dart
  /// final doubled = ImmutableSet.of({1, 2, 3}).map((x) => x * 2);
  /// // ImmutableSet({2, 4, 6})
  /// ```
  @override
  ImmutableSet<U> map<U>(U Function(T) f) {
    final result = <U>{};
    for (final e in _data) {
      result.add(f(e));
    }
    return ImmutableSet._(result);
  }

  /// Returns a new [ImmutableSet] containing only elements satisfying [test]. $O(n)$.
  ///
  /// ```dart
  /// final evens = ImmutableSet.of({1, 2, 3, 4}).where((x) => x.isEven);
  /// // ImmutableSet({2, 4})
  /// ```
  @override
  ImmutableSet<T> where(bool Function(T) test) {
    final result = <T>{};
    for (final e in _data) {
      if (test(e)) result.add(e);
    }
    return ImmutableSet._(result);
  }

  // ---------------------------------------------------------------------------
  // Conversion
  // ---------------------------------------------------------------------------

  /// Returns a mutable [Set] copy of all elements (insertion-order).
  @override
  Set<T> toSet() => _data.toSet();

  /// Returns a mutable [List] of all elements in insertion order.
  @override
  List<T> toList({bool growable = true}) =>
      growable ? _data.toList() : List.unmodifiable(_data);

  // ---------------------------------------------------------------------------
  // Object overrides
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImmutableSet<T>) return false;
    if (_data.length != other._data.length) return false;
    for (final e in _data) {
      if (!other._data.contains(e)) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_data);

  @override
  String toString() => 'ImmutableSet($_data)';
}
