import 'dart:collection';

import '../exceptions/exceptions.dart';
import 'vector.dart';

/// A mutable dynamic-array container guaranteed to contain at least one element.
///
/// [NonEmptyVector] wraps a [Vector<T>] and enforces the non-empty invariant
/// at every mutation point. The [first] and [last] getters are always
/// non-nullable. Any operation that would leave the container empty throws
/// [InvalidArgument].
///
/// ```dart
/// final nev = NonEmptyVector.of(1, [2, 3, 4]);
/// print(nev.first);  // 1
/// print(nev.last);   // 4
/// nev.add(5);
/// print(nev.length); // 5
/// nev.removeAt(0);   // ok — still 4 elements
/// ```
final class NonEmptyVector<T extends Comparable<dynamic>>
    with IterableMixin<T> {
  final Vector<T> _inner;

  NonEmptyVector._(this._inner);

  /// Creates a [NonEmptyVector] with [first] as the mandatory first element
  /// and optional [rest] appended after it.
  factory NonEmptyVector.of(T first, [Iterable<T> rest = const []]) {
    final data = [first, ...rest];
    return NonEmptyVector._(Vector<T>(data));
  }

  /// Creates a [NonEmptyVector] from an existing [Vector].
  ///
  /// Throws [InvalidArgument] if [vector] is empty.
  factory NonEmptyVector.fromVector(Vector<T> vector) {
    if (vector.isEmpty) {
      throw InvalidArgument(
        'Cannot create NonEmptyVector from an empty Vector.',
      );
    }
    // Copy so we own the data independently.
    return NonEmptyVector._(Vector<T>(vector.toList()));
  }

  /// Creates a [NonEmptyVector] from any non-empty [Iterable].
  ///
  /// Throws [InvalidArgument] if [iterable] is empty.
  factory NonEmptyVector.fromIterable(Iterable<T> iterable) {
    final list = iterable.toList();
    if (list.isEmpty) {
      throw InvalidArgument(
        'Cannot create NonEmptyVector from an empty iterable.',
      );
    }
    return NonEmptyVector._(Vector<T>(list));
  }

  // ---------------------------------------------------------------------------
  // Read-only accessors
  // ---------------------------------------------------------------------------

  /// Returns the number of elements (always >= 1).
  @override
  int get length => _inner.length;

  /// Returns the first element (always non-null, never throws).
  @override
  T get first => _inner.first;

  /// Returns the last element (always non-null, never throws).
  @override
  T get last => _inner.last;

  /// Accesses the element at [index] with bounds checking.
  T operator [](int index) => _inner[index];

  @override
  Iterator<T> get iterator => _inner.iterator;

  // ---------------------------------------------------------------------------
  // Mutation
  // ---------------------------------------------------------------------------

  /// Sets the element at [index] to [value].
  void operator []=(int index, T value) => _inner[index] = value;

  /// Appends [value] to the end.
  void add(T value) => _inner.pushBack(value);

  /// Appends all elements of [elements] to the end.
  void addAll(Iterable<T> elements) {
    for (final e in elements) {
      _inner.pushBack(e);
    }
  }

  /// Removes the element at [index].
  ///
  /// Throws [InvalidArgument] if this is the only element in the vector.
  void removeAt(int index) {
    if (length == 1) {
      throw InvalidArgument(
        'Cannot removeAt: removing the last element would empty the NonEmptyVector.',
      );
    }
    if (index < 0 || index >= length) {
      throw RangeError.index(index, _inner, 'index');
    }
    final asList = _inner.toList();
    asList.removeAt(index);
    _inner.clear();
    for (final e in asList) {
      _inner.pushBack(e);
    }
  }

  /// Removes the last element.
  ///
  /// Throws [InvalidArgument] if this is the only element.
  void removeLast() => removeAt(length - 1);

  /// Inserts [value] at [index].
  void insert(int index, T value) => _inner.insert(index, value);

  // ---------------------------------------------------------------------------
  // Conversion
  // ---------------------------------------------------------------------------

  /// Returns a mutable [List] copy of all elements.
  @override
  List<T> toList({bool growable = true}) => _inner.toList(growable: growable);

  /// Returns the underlying [Vector] (read-only view — do not mutate directly).
  Vector<T> toVector() => _inner;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NonEmptyVector<T>) return false;
    return _inner == other._inner;
  }

  @override
  int get hashCode => _inner.hashCode;

  @override
  String toString() => 'NonEmptyVector(${_inner.toList()})';
}
