import 'dart:collection';

import '../exceptions/exceptions.dart';

/// A persistent, immutable random-access list.
///
/// Mirrors the contract of `std::vector` but every mutating operation returns
/// a **new** [ImmutableList] instance — the original is never modified.
/// The underlying storage is a `List.unmodifiable`, so all index-based
/// accesses are $O(1)$ and structural operations (`add`, `removeAt`, etc.)
/// are $O(n)$ due to copying.
///
/// [ImmutableList] implements [Iterable<T>], making it a first-class citizen
/// of the range pipeline — it composes directly with [FilterRange],
/// [TransformRange], [ZipRange], and every other range adapter.
///
/// ```dart
/// final a = ImmutableList.of([1, 2, 3]);
/// final b = a.add(4);          // ImmutableList([1, 2, 3, 4])
/// final c = b.set(0, 99);      // ImmutableList([99, 2, 3, 4])
/// final d = c.removeAt(2);     // ImmutableList([99, 2, 4])
/// print(a);                     // ImmutableList([1, 2, 3])  — unchanged
/// ```
final class ImmutableList<T> with IterableMixin<T> {
  final List<T> _data;

  ImmutableList._(List<T> data) : _data = List.unmodifiable(data);

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Creates an empty [ImmutableList].
  ///
  /// ```dart
  /// final empty = ImmutableList<int>.empty();
  /// ```
  factory ImmutableList.empty() => ImmutableList._([]);

  /// Creates an [ImmutableList] from an existing [Iterable].
  ///
  /// ```dart
  /// final il = ImmutableList.of([1, 2, 3]);
  /// ```
  factory ImmutableList.of(Iterable<T> elements) =>
      ImmutableList._(elements.toList(growable: false));

  /// Creates an [ImmutableList] of [length] elements filled with [value].
  ///
  /// ```dart
  /// final zeros = ImmutableList.filled(5, 0); // [0, 0, 0, 0, 0]
  /// ```
  factory ImmutableList.filled(int length, T value) {
    if (length < 0) throw InvalidArgument('length must be >= 0');
    return ImmutableList._(List.filled(length, value, growable: false));
  }

  /// Creates an [ImmutableList] of [length] elements by calling [generator]
  /// with each index.
  ///
  /// ```dart
  /// final squares = ImmutableList.generate(5, (i) => i * i);
  /// // [0, 1, 4, 9, 16]
  /// ```
  factory ImmutableList.generate(int length, T Function(int index) generator) {
    if (length < 0) throw InvalidArgument('length must be >= 0');
    return ImmutableList._(List.generate(length, generator, growable: false));
  }

  // ---------------------------------------------------------------------------
  // Core properties
  // ---------------------------------------------------------------------------

  /// The number of elements in this list. $O(1)$.
  @override
  int get length => _data.length;

  /// Whether this list contains no elements. $O(1)$.
  @override
  bool get isEmpty => _data.isEmpty;

  /// Whether this list contains at least one element. $O(1)$.
  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  Iterator<T> get iterator => _data.iterator;

  // ---------------------------------------------------------------------------
  // Element access
  // ---------------------------------------------------------------------------

  /// Returns the element at [index]. Throws [RangeError] if out of bounds. $O(1)$.
  T operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return _data[index];
  }

  /// The first element. Throws [StateError] if empty. $O(1)$.
  @override
  T get first {
    if (_data.isEmpty) throw StateError('ImmutableList is empty');
    return _data.first;
  }

  /// The last element. Throws [StateError] if empty. $O(1)$.
  @override
  T get last {
    if (_data.isEmpty) throw StateError('ImmutableList is empty');
    return _data.last;
  }

  // ---------------------------------------------------------------------------
  // Persistent mutation — all O(n) due to copy
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableList] with [element] appended. $O(n)$.
  ///
  /// ```dart
  /// final b = ImmutableList.of([1, 2]).add(3); // [1, 2, 3]
  /// ```
  ImmutableList<T> add(T element) => ImmutableList._([..._data, element]);

  /// Returns a new [ImmutableList] with all elements of [other] appended. $O(n + k)$.
  ImmutableList<T> addAll(Iterable<T> other) =>
      ImmutableList._([..._data, ...other]);

  /// Returns a new [ImmutableList] with [element] inserted at [index]. $O(n)$.
  ///
  /// Throws [RangeError] if [index] is out of `[0, length]`.
  ImmutableList<T> insert(int index, T element) {
    RangeError.checkValidIndex(index, this, 'index', length + 1);
    final copy = _data.toList();
    copy.insert(index, element);
    return ImmutableList._(copy);
  }

  /// Returns a new [ImmutableList] with the element at [index] replaced by
  /// [value]. $O(n)$.
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  ImmutableList<T> set(int index, T value) {
    RangeError.checkValidIndex(index, this);
    final copy = _data.toList();
    copy[index] = value;
    return ImmutableList._(copy);
  }

  /// Returns a new [ImmutableList] with the element at [index] removed. $O(n)$.
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  ImmutableList<T> removeAt(int index) {
    RangeError.checkValidIndex(index, this);
    final copy = _data.toList()..removeAt(index);
    return ImmutableList._(copy);
  }

  /// Returns a new [ImmutableList] with the first occurrence of [element]
  /// removed, or this list unchanged if [element] is not present. $O(n)$.
  ImmutableList<T> remove(T element) {
    final copy = _data.toList();
    copy.remove(element);
    return ImmutableList._(copy);
  }

  /// Returns a new [ImmutableList] with all elements removed. $O(1)$.
  ImmutableList<T> clear() => ImmutableList._([]);

  /// Returns a new [ImmutableList] with elements in reversed order. $O(n)$.
  ImmutableList<T> reversed() =>
      ImmutableList._(_data.reversed.toList(growable: false));

  /// Returns a new [ImmutableList] sorted according to [compare]. $O(n log n)$.
  ///
  /// If [compare] is omitted, elements must implement [Comparable].
  ImmutableList<T> sorted([int Function(T a, T b)? compare]) {
    final copy = _data.toList()..sort(compare);
    return ImmutableList._(copy);
  }

  // ---------------------------------------------------------------------------
  // Functional transforms — return ImmutableList
  // ---------------------------------------------------------------------------

  /// Returns a new [ImmutableList] produced by applying [f] to every element.
  ///
  /// ```dart
  /// final doubled = ImmutableList.of([1, 2, 3]).map((x) => x * 2);
  /// // ImmutableList([2, 4, 6])
  /// ```
  @override
  ImmutableList<U> map<U>(U Function(T) f) =>
      ImmutableList._(_data.map(f).toList(growable: false));

  /// Returns a new [ImmutableList] containing only elements satisfying [test].
  ///
  /// ```dart
  /// final evens = ImmutableList.of([1, 2, 3, 4]).where((x) => x.isEven);
  /// // ImmutableList([2, 4])
  /// ```
  @override
  ImmutableList<T> where(bool Function(T) test) =>
      ImmutableList._(_data.where(test).toList(growable: false));

  /// Returns a new [ImmutableList] by expanding each element into zero or more
  /// elements via [f]. Equivalent to `flatMap` / `bind`.
  ///
  /// ```dart
  /// final flat = ImmutableList.of([1, 2, 3]).expand((x) => [x, x * 10]);
  /// // ImmutableList([1, 10, 2, 20, 3, 30])
  /// ```
  @override
  ImmutableList<U> expand<U>(Iterable<U> Function(T) f) =>
      ImmutableList._(_data.expand(f).toList(growable: false));

  /// Returns a new [ImmutableList] of the first [count] elements. $O(n)$.
  ///
  /// If [count] >= [length], returns an equal copy.
  ImmutableList<T> take(int count) {
    if (count < 0) throw InvalidArgument('count must be >= 0');
    return ImmutableList._(_data.take(count).toList(growable: false));
  }

  /// Returns a new [ImmutableList] without the first [count] elements. $O(n)$.
  ImmutableList<T> drop(int count) {
    if (count < 0) throw InvalidArgument('count must be >= 0');
    return ImmutableList._(_data.skip(count).toList(growable: false));
  }

  /// Returns a new [ImmutableList] consisting of elements in
  /// `[start, end)`. Equivalent to `sublist`. $O(n)$.
  ImmutableList<T> sublist(int start, [int? end]) =>
      ImmutableList._(_data.sublist(start, end));

  /// Returns a new [ImmutableList] formed by concatenating this list with
  /// [other].
  ImmutableList<T> concat(ImmutableList<T> other) =>
      ImmutableList._([..._data, ...other._data]);

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Returns `true` if this list contains [element]. $O(n)$.
  @override
  bool contains(Object? element) => _data.contains(element);

  /// Returns the first index of [element], or `-1` if not found. $O(n)$.
  int indexOf(T element) => _data.indexOf(element);

  /// Returns the last index of [element], or `-1` if not found. $O(n)$.
  int lastIndexOf(T element) => _data.lastIndexOf(element);

  // ---------------------------------------------------------------------------
  // Conversion
  // ---------------------------------------------------------------------------

  /// Returns a mutable [List] copy of all elements.
  @override
  List<T> toList({bool growable = true}) =>
      growable ? _data.toList() : List.unmodifiable(_data);

  // ---------------------------------------------------------------------------
  // Object overrides
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImmutableList<T>) return false;
    if (_data.length != other._data.length) return false;
    for (var i = 0; i < _data.length; i++) {
      if (_data[i] != other._data[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_data);

  @override
  String toString() => 'ImmutableList($_data)';
}
