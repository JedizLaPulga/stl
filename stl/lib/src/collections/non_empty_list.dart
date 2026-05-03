import 'dart:collection';

import '../exceptions/exceptions.dart';

/// An immutable singly-linked list guaranteed to contain at least one element.
///
/// Mirrors Haskell's `NonEmpty a = a :| [a]` pattern, eliminating the need
/// for null checks on [first] and [last]. All operations that transform the
/// list return new [NonEmptyList] instances; the original is never modified.
///
/// ```dart
/// final nel = NonEmptyList.of(1, [2, 3, 4]);
/// print(nel.head);        // 1
/// print(nel.last);        // 4
/// print(nel.length);      // 4
/// final doubled = nel.map((x) => x * 2); // NonEmptyList(2, [4, 6, 8])
/// ```
final class NonEmptyList<T> with IterableMixin<T> {
  /// The first (guaranteed) element of the list.
  final T head;

  /// The remaining elements after [head]. May be empty.
  final List<T> _tail;

  /// Creates a [NonEmptyList] with [head] as the first element and [tail]
  /// as the remaining elements.
  NonEmptyList._(this.head, List<T> tail) : _tail = List.unmodifiable(tail);

  /// Creates a [NonEmptyList] with [head] as the first element and an
  /// optional [tail].
  ///
  /// ```dart
  /// final nel = NonEmptyList.of(42);            // [42]
  /// final nel2 = NonEmptyList.of(1, [2, 3]);    // [1, 2, 3]
  /// ```
  factory NonEmptyList.of(T head, [List<T> tail = const []]) =>
      NonEmptyList._(head, tail);

  /// Creates a [NonEmptyList] from any non-empty [Iterable].
  ///
  /// Throws [InvalidArgument] if [iterable] is empty.
  factory NonEmptyList.fromIterable(Iterable<T> iterable) {
    final list = iterable.toList(growable: false);
    if (list.isEmpty) {
      throw InvalidArgument(
        'Cannot create NonEmptyList from an empty iterable.',
      );
    }
    return NonEmptyList._(list.first, list.sublist(1));
  }

  /// Returns an unmodifiable view of the tail (elements after [head]).
  List<T> get tail => _tail;

  /// Returns the last element of this list (always exists, never null).
  @override
  T get last => _tail.isEmpty ? head : _tail.last;

  /// Returns the first element of this list. Identical to [head].
  @override
  T get first => head;

  /// Returns the number of elements in this list (always >= 1).
  @override
  int get length => 1 + _tail.length;

  @override
  Iterator<T> get iterator => _NonEmptyListIterator<T>(head, _tail);

  /// Transforms every element using [mapper], returning a new [NonEmptyList].
  @override
  NonEmptyList<U> map<U>(U Function(T) mapper) =>
      NonEmptyList._(mapper(head), _tail.map(mapper).toList(growable: false));

  /// Applies [mapper] to every element and flattens one level of nesting.
  NonEmptyList<U> flatMap<U>(NonEmptyList<U> Function(T) mapper) {
    final headResult = mapper(head);
    final tailResults = _tail.expand((e) => mapper(e));
    return NonEmptyList._(headResult.head, [
      ...headResult._tail,
      ...tailResults,
    ]);
  }

  /// Reduces the list to a single value by applying [combine] left-to-right.
  ///
  /// Unlike [Iterable.reduce], this always succeeds because the list is non-empty.
  @override
  T reduce(T Function(T acc, T element) combine) {
    var acc = head;
    for (final e in _tail) {
      acc = combine(acc, e);
    }
    return acc;
  }

  /// Folds the list from the left, starting with [initialValue].
  @override
  U fold<U>(U initialValue, U Function(U acc, T element) combine) {
    var acc = combine(initialValue, head);
    for (final e in _tail) {
      acc = combine(acc, e);
    }
    return acc;
  }

  /// Returns a new [NonEmptyList] with [value] prepended before [head].
  NonEmptyList<T> prepend(T value) => NonEmptyList._(value, [head, ..._tail]);

  /// Returns a new [NonEmptyList] with [value] appended after the last element.
  NonEmptyList<T> append(T value) => NonEmptyList._(head, [..._tail, value]);

  /// Concatenates this list with [other], returning a new [NonEmptyList].
  NonEmptyList<T> concat(NonEmptyList<T> other) =>
      NonEmptyList._(head, [..._tail, other.head, ...other._tail]);

  /// Returns a standard Dart [List] copy of all elements.
  @override
  List<T> toList({bool growable = true}) {
    final result = <T>[head, ..._tail];
    return growable ? result : List.unmodifiable(result);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NonEmptyList<T>) return false;
    if (head != other.head) return false;
    if (_tail.length != other._tail.length) return false;
    for (var i = 0; i < _tail.length; i++) {
      if (_tail[i] != other._tail[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll([head, ..._tail]);

  @override
  String toString() => 'NonEmptyList($head, $_tail)';
}

class _NonEmptyListIterator<T> implements Iterator<T> {
  final T _head;
  final List<T> _tail;
  int _index = -1;

  _NonEmptyListIterator(this._head, this._tail);

  @override
  T get current {
    if (_index == 0) return _head;
    return _tail[_index - 1];
  }

  @override
  bool moveNext() {
    _index++;
    return _index <= _tail.length;
  }
}
