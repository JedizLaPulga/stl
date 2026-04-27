import 'dart:math' as math;

import '../utilities/pair.dart';

int _defaultCompare<T>(T a, T b) {
  if (a is Comparable && b is Comparable) {
    return a.compareTo(b);
  }
  throw ArgumentError(
    'Elements must be Comparable if no compare function is provided.',
  );
}

void _swap<T>(List<T> list, int i, int j) {
  final temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

void _reverseRange<T>(List<T> list, int start, int end) {
  var i = start;
  var j = end - 1;
  while (i < j) {
    _swap(list, i, j);
    i++;
    j--;
  }
}

/// Returns the index of the first element in the [list] that is not less than (i.e. greater or equal to) [value].
///
/// The [list] must be partitioned with respect to [value] (e.g., sorted).
/// Performs $O(\log N)$ comparisons via binary search.
///
/// Optionally takes a custom [compare] function to define the ordering.
///
/// Example:
/// ```dart
/// final list = [10, 20, 30, 30, 40, 50];
/// final index = lowerBound(list, 30); // Returns 2
/// ```
int lowerBound<T>(List<T> list, T value, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  var min = 0;
  var max = list.length;
  while (min < max) {
    var mid = min + ((max - min) >> 1);
    var element = list[mid];
    var comp = compare(element, value);
    if (comp < 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return min;
}

/// Returns the index of the first element in the [list] that is strictly greater than [value].
///
/// The [list] must be partitioned with respect to [value] (e.g., sorted).
/// Performs $O(\log N)$ comparisons via binary search.
///
/// Optionally takes a custom [compare] function to define the ordering.
///
/// Example:
/// ```dart
/// final list = [10, 20, 30, 30, 40, 50];
/// final index = upperBound(list, 30); // Returns 4
/// ```
int upperBound<T>(List<T> list, T value, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  var min = 0;
  var max = list.length;
  while (min < max) {
    var mid = min + ((max - min) >> 1);
    var element = list[mid];
    var comp = compare(element, value);
    if (comp <= 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return min;
}

/// Checks if an element equivalent to [value] appears within the [list].
///
/// The [list] must be partitioned with respect to [value] (e.g., sorted).
/// Performs $O(\log N)$ comparisons via binary search.
///
/// Optionally takes a custom [compare] function. Returns `true` if found, `false` otherwise.
///
/// Example:
/// ```dart
/// final list = [10, 20, 30, 30, 40, 50];
/// final found = binarySearch(list, 30); // Returns true
/// ```
bool binarySearch<T>(List<T> list, T value, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  var min = 0;
  var max = list.length;
  while (min < max) {
    var mid = min + ((max - min) >> 1);
    var element = list[mid];
    var comp = compare(element, value);
    if (comp == 0) return true;
    if (comp < 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return false;
}

/// Returns a [Pair] containing the [lowerBound] and [upperBound] of [value].
///
/// The [list] must be partitioned with respect to [value] (e.g., sorted).
/// The returned range effectively bounds all elements equivalent to [value].
///
/// Example:
/// ```dart
/// final list = [10, 20, 30, 30, 40, 50];
/// final range = equalRange(list, 30); // Returns Pair(2, 4)
/// ```
Pair<int, int> equalRange<T>(
  List<T> list,
  T value, {
  int Function(T, T)? compare,
}) {
  return makePair(
    lowerBound(list, value, compare: compare),
    upperBound(list, value, compare: compare),
  );
}

/// Transforms the [list] into the next permutation from the
/// set of all permutations that are lexicographically ordered.
///
/// Returns `true` if the new permutation is lexicographically strictly greater than the previous.
/// If the [list] is already in its highest permutation (e.g. sorted descending),
/// it wraps around to the lowest permutation and returns `false`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3];
/// nextPermutation(list); // list is now [1, 3, 2]
/// ```
bool nextPermutation<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  if (list.length <= 1) return false;

  var i = list.length - 1;
  while (true) {
    var ii = i;
    --i;
    if (compare(list[i], list[ii]) < 0) {
      var j = list.length - 1;
      while (compare(list[i], list[j]) >= 0) {
        --j;
      }
      _swap(list, i, j);
      _reverseRange(list, ii, list.length);
      return true;
    }
    if (i == 0) {
      _reverseRange(list, 0, list.length);
      return false;
    }
  }
}

/// Transforms the [list] into the previous permutation from the
/// set of all permutations that are lexicographically ordered.
///
/// Returns `true` if the new permutation is lexicographically strictly less than the previous.
/// If the [list] is already in its lowest permutation (e.g. sorted ascending),
/// it wraps around to the highest permutation and returns `false`.
///
/// Example:
/// ```dart
/// final list = [3, 2, 1];
/// prevPermutation(list); // list is now [3, 1, 2]
/// ```
bool prevPermutation<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  if (list.length <= 1) return false;

  var i = list.length - 1;
  while (true) {
    var ii = i;
    --i;
    if (compare(list[ii], list[i]) < 0) {
      var j = list.length - 1;
      while (compare(list[j], list[i]) >= 0) {
        --j;
      }
      _swap(list, i, j);
      _reverseRange(list, ii, list.length);
      return true;
    }
    if (i == 0) {
      _reverseRange(list, 0, list.length);
      return false;
    }
  }
}

/// Constructs a sorted union of elements from two sorted sequences [a] and [b].
///
/// Both sequences must be sorted according to the same [compare] function.
/// The resulting sequence contains all elements that are present in either [a] or [b],
/// keeping the sequence sorted. If an element exists in both, only the element from [a] is included.
///
/// Example:
/// ```dart
/// final list1 = [1, 2, 4];
/// final list2 = [2, 3, 5];
/// final union = setUnion(list1, list2); // Returns [1, 2, 3, 4, 5]
/// ```
List<T> setUnion<T>(
  Iterable<T> a,
  Iterable<T> b, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  var res = <T>[];
  var itA = a.iterator;
  var itB = b.iterator;
  bool hasA = itA.moveNext();
  bool hasB = itB.moveNext();

  while (hasA && hasB) {
    var comp = compare(itA.current, itB.current);
    if (comp < 0) {
      res.add(itA.current);
      hasA = itA.moveNext();
    } else if (comp > 0) {
      res.add(itB.current);
      hasB = itB.moveNext();
    } else {
      res.add(itA.current);
      hasA = itA.moveNext();
      hasB = itB.moveNext();
    }
  }
  while (hasA) {
    res.add(itA.current);
    hasA = itA.moveNext();
  }
  while (hasB) {
    res.add(itB.current);
    hasB = itB.moveNext();
  }
  return res;
}

/// Constructs a sorted intersection of elements from two sorted sequences [a] and [b].
///
/// Both sequences must be sorted according to the same [compare] function.
/// The resulting sequence contains only elements that are present in both [a] and [b],
/// keeping the sequence sorted.
///
/// Example:
/// ```dart
/// final list1 = [1, 2, 4];
/// final list2 = [2, 3, 4];
/// final intersection = setIntersection(list1, list2); // Returns [2, 4]
/// ```
List<T> setIntersection<T>(
  Iterable<T> a,
  Iterable<T> b, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  var res = <T>[];
  var itA = a.iterator;
  var itB = b.iterator;
  bool hasA = itA.moveNext();
  bool hasB = itB.moveNext();

  while (hasA && hasB) {
    var comp = compare(itA.current, itB.current);
    if (comp < 0) {
      hasA = itA.moveNext();
    } else if (comp > 0) {
      hasB = itB.moveNext();
    } else {
      res.add(itA.current);
      hasA = itA.moveNext();
      hasB = itB.moveNext();
    }
  }
  return res;
}

/// Constructs a sorted difference of elements from two sorted sequences [a] and [b].
///
/// Both sequences must be sorted according to the same [compare] function.
/// The resulting sequence contains all elements that are present in [a] but not in [b].
///
/// Example:
/// ```dart
/// final list1 = [1, 2, 4, 5];
/// final list2 = [2, 3, 5, 6];
/// final diff = setDifference(list1, list2); // Returns [1, 4]
/// ```
List<T> setDifference<T>(
  Iterable<T> a,
  Iterable<T> b, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  var res = <T>[];
  var itA = a.iterator;
  var itB = b.iterator;
  bool hasA = itA.moveNext();
  bool hasB = itB.moveNext();

  while (hasA && hasB) {
    var comp = compare(itA.current, itB.current);
    if (comp < 0) {
      res.add(itA.current);
      hasA = itA.moveNext();
    } else if (comp > 0) {
      hasB = itB.moveNext();
    } else {
      hasA = itA.moveNext();
      hasB = itB.moveNext();
    }
  }
  while (hasA) {
    res.add(itA.current);
    hasA = itA.moveNext();
  }
  return res;
}

/// Rotates the order of the elements in the [list] in such a way
/// that the element at index [n] becomes the new first element.
///
/// [n] can be positive or negative (for right-ward wrapping).
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5];
/// rotate(list, 2); // list is now [3, 4, 5, 1, 2]
/// ```
void rotate<T>(List<T> list, int n) {
  if (list.isEmpty) return;
  n = n % list.length;
  if (n < 0) n += list.length;
  if (n == 0) return;

  _reverseRange(list, 0, n);
  _reverseRange(list, n, list.length);
  _reverseRange(list, 0, list.length);
}

/// Reverses the order of the elements in the [list] in-place.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3];
/// reverse(list); // list is now [3, 2, 1]
/// ```
void reverse<T>(List<T> list) {
  _reverseRange(list, 0, list.length);
}

/// Eliminates all except the first element from every consecutive group of equivalent
/// elements from the [list] and returns the new logical length of the collection.
///
/// If the collection is growable, it will automatically shrink to the new size.
/// If the collection is fixed-length, the elements past the returned index are left in an unspecified state.
///
/// Example:
/// ```dart
/// final list = [1, 1, 2, 2, 3, 2, 1];
/// final newLength = unique(list); // list becomes [1, 2, 3, 2, 1], returns 5
/// ```
int unique<T>(List<T> list, {bool Function(T, T)? equals}) {
  if (list.isEmpty) return 0;
  equals ??= (a, b) => a == b;
  int writeIndex = 1;
  for (int readIndex = 1; readIndex < list.length; readIndex++) {
    if (!equals(list[writeIndex - 1], list[readIndex])) {
      list[writeIndex] = list[readIndex];
      writeIndex++;
    }
  }

  if (list.length > writeIndex) {
    try {
      list.length = writeIndex;
    } catch (_) {
      // Ignored if list is fixed-length, user will need to rely on the returned index.
    }
  }
  return writeIndex;
}

/// Reorders the elements in the [list] in such a way that all elements for which
/// the [predicate] returns `true` precede the elements for which it returns `false`.
///
/// The relative order of the elements is *not* guaranteed to be preserved.
/// Returns the index of the first element of the second group (i.e. returning `false`).
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5, 6];
/// final p = partition(list, (int n) => n % 2 == 0);
/// // list becomes [6, 2, 4, 3, 5, 1] (or similar), returns 3
/// ```
int partition<T>(List<T> list, bool Function(T) predicate) {
  var first = 0;
  var last = list.length;
  while (true) {
    while (first < last && predicate(list[first])) {
      ++first;
    }
    if (first == last) break;

    --last;
    while (first < last && !predicate(list[last])) {
      --last;
    }
    if (first == last) break;

    _swap(list, first, last);
    ++first;
  }
  return first;
}

/// Reorders the elements in the [list] in such a way that all elements for which
/// the [predicate] returns `true` precede the elements for which it returns `false`.
///
/// The relative order of the elements *is* strictly preserved.
/// Returns the index of the first element of the second group (i.e. returning `false`).
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5, 6];
/// final p = stablePartition(list, (int n) => n % 2 == 0);
/// // list becomes [2, 4, 6, 1, 3, 5], returns 3
/// ```
int stablePartition<T>(List<T> list, bool Function(T) predicate) {
  var trues = <T>[];
  var falses = <T>[];
  for (var element in list) {
    if (predicate(element)) {
      trues.add(element);
    } else {
      falses.add(element);
    }
  }
  var partitionPoint = trues.length;
  list.clear();
  list.addAll(trues);
  list.addAll(falses);
  return partitionPoint;
}

// ==============================================
// Non-modifying Sequence Operations
// ==============================================

/// Returns `true` if [predicate] returns `true` for every element in [iterable].
///
/// Equivalent to C++ `std::all_of`. Returns `true` for an empty range.
///
/// Example:
/// ```dart
/// allOf([2, 4, 6], (n) => n % 2 == 0); // true
/// ```
bool allOf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  for (final element in iterable) {
    if (!predicate(element)) return false;
  }
  return true;
}

/// Returns `true` if [predicate] returns `true` for at least one element in [iterable].
///
/// Equivalent to C++ `std::any_of`. Returns `false` for an empty range.
///
/// Example:
/// ```dart
/// anyOf([1, 3, 4], (n) => n % 2 == 0); // true
/// ```
bool anyOf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  for (final element in iterable) {
    if (predicate(element)) return true;
  }
  return false;
}

/// Returns `true` if [predicate] returns `false` for every element in [iterable].
///
/// Equivalent to C++ `std::none_of`. Returns `true` for an empty range.
///
/// Example:
/// ```dart
/// noneOf([1, 3, 5], (n) => n % 2 == 0); // true
/// ```
bool noneOf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  for (final element in iterable) {
    if (predicate(element)) return false;
  }
  return true;
}

/// Applies [action] to every element of [iterable] in order.
///
/// Equivalent to C++ `std::for_each`.
///
/// Example:
/// ```dart
/// forEach([1, 2, 3], print); // prints 1, then 2, then 3
/// ```
void forEach<T>(Iterable<T> iterable, void Function(T) action) {
  for (final element in iterable) {
    action(element);
  }
}

/// Applies [action] to the first [n] elements of [iterable].
///
/// Equivalent to C++ `std::for_each_n`. If [n] exceeds the length, all elements are visited.
///
/// Example:
/// ```dart
/// forEachN([1, 2, 3, 4], 2, print); // prints 1, then 2
/// ```
void forEachN<T>(Iterable<T> iterable, int n, void Function(T) action) {
  var visited = 0;
  for (final element in iterable) {
    if (visited >= n) break;
    action(element);
    visited++;
  }
}

/// Returns the number of elements in [iterable] that are equal to [value].
///
/// Equivalent to C++ `std::count`. Equality is determined by `==`.
///
/// Example:
/// ```dart
/// count([1, 2, 1, 3, 1], 1); // 3
/// ```
int count<T>(Iterable<T> iterable, T value) {
  var result = 0;
  for (final element in iterable) {
    if (element == value) result++;
  }
  return result;
}

/// Returns the number of elements in [iterable] for which [predicate] returns `true`.
///
/// Equivalent to C++ `std::count_if`.
///
/// Example:
/// ```dart
/// countIf([1, 2, 3, 4], (n) => n % 2 == 0); // 2
/// ```
int countIf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  var result = 0;
  for (final element in iterable) {
    if (predicate(element)) result++;
  }
  return result;
}

/// Finds the first index at which [a] and [b] differ and returns it as a [Pair].
///
/// Equivalent to C++ `std::mismatch`. Returns `Pair(-1, -1)` if no mismatch is found within
/// the length of the shorter list. The [equals] function can override the default `==` check.
///
/// Example:
/// ```dart
/// mismatch([1, 2, 3], [1, 2, 4]); // Pair(2, 2)
/// mismatch([1, 2, 3], [1, 2, 3]); // Pair(-1, -1)
/// ```
Pair<int, int> mismatch<T>(
  List<T> a,
  List<T> b, {
  bool Function(T, T)? equals,
}) {
  equals ??= (x, y) => x == y;
  final len = a.length < b.length ? a.length : b.length;
  for (var i = 0; i < len; i++) {
    if (!equals(a[i], b[i])) return makePair(i, i);
  }
  return makePair(-1, -1);
}

/// Returns the index of the first element in [iterable] that equals [value].
///
/// Equivalent to C++ `std::find`. Returns `-1` if not found.
///
/// Example:
/// ```dart
/// find([10, 20, 30], 20); // 1
/// ```
int find<T>(Iterable<T> iterable, T value) {
  var index = 0;
  for (final element in iterable) {
    if (element == value) return index;
    index++;
  }
  return -1;
}

/// Returns the index of the first element in [iterable] for which [predicate] returns `true`.
///
/// Equivalent to C++ `std::find_if`. Returns `-1` if not found.
///
/// Example:
/// ```dart
/// findIf([1, 3, 4, 6], (n) => n % 2 == 0); // 2
/// ```
int findIf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  var index = 0;
  for (final element in iterable) {
    if (predicate(element)) return index;
    index++;
  }
  return -1;
}

/// Returns the index of the first element in [iterable] for which [predicate] returns `false`.
///
/// Equivalent to C++ `std::find_if_not`. Returns `-1` if all elements satisfy the predicate.
///
/// Example:
/// ```dart
/// findIfNot([2, 4, 5, 6], (n) => n % 2 == 0); // 2
/// ```
int findIfNot<T>(Iterable<T> iterable, bool Function(T) predicate) {
  var index = 0;
  for (final element in iterable) {
    if (!predicate(element)) return index;
    index++;
  }
  return -1;
}

/// Searches for the **last** occurrence of the subsequence [sub] within [list].
///
/// Returns the starting index of the last match, or `-1` if not found.
/// Returns [list].length if [sub] is empty (matches C++ convention).
/// Equivalent to C++ `std::find_end`.
///
/// Example:
/// ```dart
/// findEnd([1, 2, 3, 1, 2], [1, 2]); // 3
/// ```
int findEnd<T>(List<T> list, List<T> sub, {bool Function(T, T)? equals}) {
  equals ??= (a, b) => a == b;
  if (sub.isEmpty) return list.length;
  var result = -1;
  for (var i = 0; i <= list.length - sub.length; i++) {
    var match = true;
    for (var j = 0; j < sub.length; j++) {
      if (!equals(list[i + j], sub[j])) {
        match = false;
        break;
      }
    }
    if (match) result = i;
  }
  return result;
}

/// Returns the index of the first element in [list] that is also present in [targets].
///
/// Equivalent to C++ `std::find_first_of`. Returns `-1` if no element from [targets] appears in [list].
/// Uses [equals] if provided, otherwise uses `==`.
///
/// Example:
/// ```dart
/// findFirstOf([1, 2, 3, 4], [3, 5]); // 2
/// ```
int findFirstOf<T>(
  List<T> list,
  List<T> targets, {
  bool Function(T, T)? equals,
}) {
  equals ??= (a, b) => a == b;
  for (var i = 0; i < list.length; i++) {
    for (final target in targets) {
      if (equals(list[i], target)) return i;
    }
  }
  return -1;
}

/// Returns the index of the first pair of consecutive equivalent elements in [list].
///
/// Equivalent to C++ `std::adjacent_find`. Returns `-1` if no such adjacent pair exists.
/// Uses [equals] if provided, otherwise uses `==`.
///
/// Example:
/// ```dart
/// adjacentFind([1, 2, 2, 3]); // 1
/// ```
int adjacentFind<T>(List<T> list, {bool Function(T, T)? equals}) {
  equals ??= (a, b) => a == b;
  for (var i = 0; i < list.length - 1; i++) {
    if (equals(list[i], list[i + 1])) return i;
  }
  return -1;
}

/// Searches for the **first** occurrence of the subsequence [sub] within [list].
///
/// Returns the starting index of the first match, or `-1` if not found.
/// Returns `0` if [sub] is empty (matches C++ convention).
/// Equivalent to C++ `std::search`.
///
/// Example:
/// ```dart
/// search([1, 2, 3, 4], [2, 3]); // 1
/// ```
int search<T>(List<T> list, List<T> sub, {bool Function(T, T)? equals}) {
  equals ??= (a, b) => a == b;
  if (sub.isEmpty) return 0;
  for (var i = 0; i <= list.length - sub.length; i++) {
    var match = true;
    for (var j = 0; j < sub.length; j++) {
      if (!equals(list[i + j], sub[j])) {
        match = false;
        break;
      }
    }
    if (match) return i;
  }
  return -1;
}

/// Searches for a run of [n] consecutive elements all equal to [value] within [list].
///
/// Returns the starting index of the first such run, or `-1` if not found.
/// Returns `0` if [n] <= 0 (matches C++ convention).
/// Equivalent to C++ `std::search_n`.
///
/// Example:
/// ```dart
/// searchN([1, 2, 2, 2, 3], 3, 2); // 1
/// ```
int searchN<T>(List<T> list, int n, T value, {bool Function(T, T)? equals}) {
  equals ??= (a, b) => a == b;
  if (n <= 0) return 0;
  for (var i = 0; i <= list.length - n; i++) {
    var match = true;
    for (var j = 0; j < n; j++) {
      if (!equals(list[i + j], value)) {
        match = false;
        break;
      }
    }
    if (match) return i;
  }
  return -1;
}

// ==============================================
// Modifying Sequence Operations
// ==============================================

/// Returns a new [List] that is a shallow copy of all elements in [iterable].
///
/// Equivalent to C++ `std::copy` writing to an output range.
///
/// Example:
/// ```dart
/// copy([1, 2, 3]); // [1, 2, 3]
/// ```
List<T> copy<T>(Iterable<T> iterable) => List<T>.of(iterable);

/// Returns a new [List] containing only the elements from [iterable] for which [predicate] returns `true`.
///
/// Equivalent to C++ `std::copy_if`.
///
/// Example:
/// ```dart
/// copyIf([1, 2, 3, 4, 5], (n) => n % 2 == 0); // [2, 4]
/// ```
List<T> copyIf<T>(Iterable<T> iterable, bool Function(T) predicate) {
  return [
    for (final e in iterable)
      if (predicate(e)) e,
  ];
}

/// Returns a new [List] containing the first [n] elements of [iterable].
///
/// Equivalent to C++ `std::copy_n`. If [n] exceeds the length, all elements are copied.
///
/// Example:
/// ```dart
/// copyN([1, 2, 3, 4], 3); // [1, 2, 3]
/// ```
List<T> copyN<T>(Iterable<T> iterable, int n) => iterable.take(n).toList();

/// Returns a new [List] that is a reversed copy of [iterable].
///
/// Equivalent to C++ `std::copy_backward` semantics (destination written back-to-front).
/// Unlike the C++ version, this returns a new list rather than writing into an existing range.
///
/// Example:
/// ```dart
/// copyBackward([1, 2, 3]); // [3, 2, 1]
/// ```
List<T> copyBackward<T>(Iterable<T> iterable) =>
    iterable.toList().reversed.toList();

/// Sets every element of [list] to [value] in-place.
///
/// Equivalent to C++ `std::fill`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3];
/// fill(list, 0); // list is now [0, 0, 0]
/// ```
void fill<T>(List<T> list, T value) {
  for (var i = 0; i < list.length; i++) {
    list[i] = value;
  }
}

/// Sets the first [n] elements of [list] to [value] in-place.
///
/// Equivalent to C++ `std::fill_n`. If [n] exceeds the length, only fills up to the end.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4];
/// fillN(list, 2, 0); // list is now [0, 0, 3, 4]
/// ```
void fillN<T>(List<T> list, int n, T value) {
  final end = n < list.length ? n : list.length;
  for (var i = 0; i < end; i++) {
    list[i] = value;
  }
}

/// Applies [fn] to each element of [iterable] and returns the results as a new [List].
///
/// Equivalent to the unary form of C++ `std::transform`.
///
/// Example:
/// ```dart
/// transform([1, 2, 3], (n) => n * 2); // [2, 4, 6]
/// ```
List<R> transform<T, R>(Iterable<T> iterable, R Function(T) fn) => [
  for (final e in iterable) fn(e),
];

/// Combines elements from [a] and [b] pairwise using [combiner] and returns results as a new [List].
///
/// Equivalent to the binary form of C++ `std::transform`. Stops at the shorter of the two iterables.
///
/// Example:
/// ```dart
/// transformBinary([1, 2, 3], [10, 20, 30], (a, b) => a + b); // [11, 22, 33]
/// ```
List<R> transformBinary<T1, T2, R>(
  Iterable<T1> a,
  Iterable<T2> b,
  R Function(T1, T2) combiner,
) {
  final result = <R>[];
  final itA = a.iterator;
  final itB = b.iterator;
  while (itA.moveNext() && itB.moveNext()) {
    result.add(combiner(itA.current, itB.current));
  }
  return result;
}

/// Fills each element of [list] by invoking [generator] once per position in-place.
///
/// Equivalent to C++ `std::generate`.
///
/// Example:
/// ```dart
/// final list = List<int>.filled(3, 0);
/// var i = 0;
/// generate(list, () => ++i); // list is [1, 2, 3]
/// ```
void generate<T>(List<T> list, T Function() generator) {
  for (var i = 0; i < list.length; i++) {
    list[i] = generator();
  }
}

/// Fills the first [n] elements of [list] by invoking [generator] once per position.
///
/// Equivalent to C++ `std::generate_n`. If [n] exceeds the length, only fills up to the end.
///
/// Example:
/// ```dart
/// final list = List<int>.filled(4, 0);
/// var i = 0;
/// generateN(list, 3, () => ++i); // list is [1, 2, 3, 0]
/// ```
void generateN<T>(List<T> list, int n, T Function() generator) {
  final end = n < list.length ? n : list.length;
  for (var i = 0; i < end; i++) {
    list[i] = generator();
  }
}

/// Replaces every element in [list] equal to [oldValue] with [newValue] in-place.
///
/// Equivalent to C++ `std::replace`. Equality is determined by `==`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 1, 3];
/// replace(list, 1, 9); // list is [9, 2, 9, 3]
/// ```
void replace<T>(List<T> list, T oldValue, T newValue) {
  for (var i = 0; i < list.length; i++) {
    if (list[i] == oldValue) list[i] = newValue;
  }
}

/// Replaces every element in [list] for which [predicate] returns `true` with [newValue] in-place.
///
/// Equivalent to C++ `std::replace_if`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4];
/// replaceIf(list, (n) => n % 2 == 0, 0); // list is [1, 0, 3, 0]
/// ```
void replaceIf<T>(List<T> list, bool Function(T) predicate, T newValue) {
  for (var i = 0; i < list.length; i++) {
    if (predicate(list[i])) list[i] = newValue;
  }
}

/// Returns a copy of [iterable] with all elements equal to [oldValue] replaced by [newValue].
///
/// Equivalent to C++ `std::replace_copy`. The original is not modified.
///
/// Example:
/// ```dart
/// replaceCopy([1, 2, 1, 3], 1, 9); // [9, 2, 9, 3]
/// ```
List<T> replaceCopy<T>(Iterable<T> iterable, T oldValue, T newValue) => [
  for (final e in iterable) e == oldValue ? newValue : e,
];

/// Returns a copy of [iterable] with all elements satisfying [predicate] replaced by [newValue].
///
/// Equivalent to C++ `std::replace_copy_if`. The original is not modified.
///
/// Example:
/// ```dart
/// replaceCopyIf([1, 2, 3, 4], (n) => n % 2 == 0, 0); // [1, 0, 3, 0]
/// ```
List<T> replaceCopyIf<T>(
  Iterable<T> iterable,
  bool Function(T) predicate,
  T newValue,
) => [for (final e in iterable) predicate(e) ? newValue : e];

/// Removes all elements equal to [value] from [list] in-place, compacting the remaining elements.
///
/// Returns the new logical length after removal. If the list is growable, it is shrunk automatically.
/// Equivalent to C++ `std::remove`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 1, 3, 1];
/// final len = remove(list, 1); // list is [2, 3], returns 2
/// ```
int remove<T>(List<T> list, T value) {
  var writeIndex = 0;
  for (var i = 0; i < list.length; i++) {
    if (list[i] != value) list[writeIndex++] = list[i];
  }
  try {
    list.length = writeIndex;
  } catch (_) {}
  return writeIndex;
}

/// Removes all elements for which [predicate] returns `true` from [list] in-place.
///
/// Returns the new logical length after removal. If the list is growable, it is shrunk automatically.
/// Equivalent to C++ `std::remove_if`.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5];
/// final len = removeIf(list, (n) => n % 2 == 0); // list is [1, 3, 5], returns 3
/// ```
int removeIf<T>(List<T> list, bool Function(T) predicate) {
  var writeIndex = 0;
  for (var i = 0; i < list.length; i++) {
    if (!predicate(list[i])) list[writeIndex++] = list[i];
  }
  try {
    list.length = writeIndex;
  } catch (_) {}
  return writeIndex;
}

/// Returns a new [List] containing only the elements from [iterable] that are **not** equal to [value].
///
/// Equivalent to C++ `std::remove_copy`. The original is not modified.
///
/// Example:
/// ```dart
/// removeCopy([1, 2, 1, 3], 1); // [2, 3]
/// ```
List<T> removeCopy<T>(Iterable<T> iterable, T value) => [
  for (final e in iterable)
    if (e != value) e,
];

/// Returns a new [List] with all elements from [iterable] for which [predicate] returns `false`.
///
/// Equivalent to C++ `std::remove_copy_if`. The original is not modified.
///
/// Example:
/// ```dart
/// removeCopyIf([1, 2, 3, 4], (n) => n % 2 == 0); // [1, 3]
/// ```
List<T> removeCopyIf<T>(Iterable<T> iterable, bool Function(T) predicate) => [
  for (final e in iterable)
    if (!predicate(e)) e,
];

/// Swaps elements at corresponding positions between [a] and [b] in-place.
///
/// Both lists must have the same length; otherwise a [RangeError] is thrown.
/// Equivalent to C++ `std::swap_ranges`.
///
/// Example:
/// ```dart
/// final a = [1, 2, 3];
/// final b = [4, 5, 6];
/// swapRanges(a, b); // a is [4, 5, 6], b is [1, 2, 3]
/// ```
void swapRanges<T>(List<T> a, List<T> b) {
  if (a.length != b.length) {
    throw RangeError(
      'swapRanges: both lists must have the same length '
      '(${a.length} vs ${b.length}).',
    );
  }
  for (var i = 0; i < a.length; i++) {
    final temp = a[i];
    a[i] = b[i];
    b[i] = temp;
  }
}

/// Randomly reorders the elements of [list] in-place using a Fisher-Yates shuffle.
///
/// Equivalent to C++ `std::shuffle`. An optional [random] instance may be supplied for
/// deterministic seeding; if omitted, a new `dart:math` [math.Random] instance is used.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5];
/// shuffle(list); // e.g. [3, 1, 5, 2, 4]
/// ```
void shuffle<T>(List<T> list, {math.Random? random}) {
  random ??= math.Random();
  for (var i = list.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    _swap(list, i, j);
  }
}

/// Selects [n] distinct elements from [list] uniformly at random using reservoir sampling.
///
/// Returns a new [List] of exactly [n] elements. If [n] >= [list].length, a shuffled copy of
/// the entire list is returned. An optional [random] instance may be supplied for deterministic
/// seeding. Equivalent to C++ `std::sample` (reservoir sampling variant) — $O(N)$ time.
///
/// Example:
/// ```dart
/// final list = [1, 2, 3, 4, 5];
/// sample(list, 3); // e.g. [2, 4, 1]
/// ```
List<T> sample<T>(List<T> list, int n, {math.Random? random}) {
  random ??= math.Random();
  if (n >= list.length) {
    final copy = List<T>.of(list);
    shuffle(copy, random: random);
    return copy;
  }
  // Reservoir sampling: O(N) time.
  final reservoir = List<T>.of(list.take(n));
  for (var i = n; i < list.length; i++) {
    final j = random.nextInt(i + 1);
    if (j < n) reservoir[j] = list[i];
  }
  return reservoir;
}

// ==============================================
// Sorting Operations
// ==============================================

/// Returns `true` if the elements of [list] are in non-descending sorted order.
///
/// Equivalent to C++ `std::is_sorted`. Uses [compare] if provided, otherwise uses natural order.
/// Returns `true` for empty or single-element lists.
///
/// Example:
/// ```dart
/// isSorted([1, 2, 3, 3, 5]); // true
/// isSorted([1, 3, 2]);        // false
/// ```
bool isSorted<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  for (var i = 0; i < list.length - 1; i++) {
    if (compare(list[i], list[i + 1]) > 0) return false;
  }
  return true;
}

/// Returns the index of the first element in [list] that violates the sorted order.
///
/// Equivalent to C++ `std::is_sorted_until`. Returns [list].length if the entire list is sorted.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// isSortedUntil([1, 2, 5, 3, 4]); // 3 — list[3] (3) < list[2] (5)
/// ```
int isSortedUntil<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  for (var i = 0; i < list.length - 1; i++) {
    if (compare(list[i], list[i + 1]) > 0) return i + 1;
  }
  return list.length;
}

/// Sorts the [list] in-place, strictly preserving the relative order of equivalent elements.
///
/// Equivalent to C++ `std::stable_sort`. Implemented as a top-down merge sort, which is
/// stable by construction. Time complexity: $O(N \log^2 N)$; space: $O(N)$.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// final list = [3, 1, 2];
/// stableSort(list); // [1, 2, 3]
/// ```
void stableSort<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  _mergeSort(list, 0, list.length, compare);
}

void _mergeSort<T>(
  List<T> list,
  int start,
  int end,
  int Function(T, T) compare,
) {
  if (end - start <= 1) return;
  final mid = start + ((end - start) >> 1);
  _mergeSort(list, start, mid, compare);
  _mergeSort(list, mid, end, compare);
  _mergeSortedHalves(list, start, mid, end, compare);
}

void _mergeSortedHalves<T>(
  List<T> list,
  int start,
  int mid,
  int end,
  int Function(T, T) compare,
) {
  final left = list.sublist(start, mid);
  final right = list.sublist(mid, end);
  var i = 0, j = 0, k = start;
  while (i < left.length && j < right.length) {
    if (compare(left[i], right[j]) <= 0) {
      list[k++] = left[i++];
    } else {
      list[k++] = right[j++];
    }
  }
  while (i < left.length) {
    list[k++] = left[i++];
  }
  while (j < right.length) {
    list[k++] = right[j++];
  }
}

/// Rearranges [list] such that the element at index [n] is the element that would appear there
/// if the entire list were sorted, with all elements before it ≤ it and all elements after it ≥ it.
///
/// Equivalent to C++ `std::nth_element`. Uses quickselect — $O(N)$ average time.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// final list = [5, 3, 1, 4, 2];
/// nthElement(list, 2); // list[2] is the 3rd-smallest (== 3)
/// ```
void nthElement<T>(List<T> list, int n, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  _quickSelect(list, 0, list.length - 1, n, compare);
}

void _quickSelect<T>(
  List<T> list,
  int low,
  int high,
  int k,
  int Function(T, T) compare,
) {
  if (low >= high) return;
  final pivotIdx = _qsPartition(list, low, high, compare);
  if (pivotIdx == k) return;
  if (k < pivotIdx) {
    _quickSelect(list, low, pivotIdx - 1, k, compare);
  } else {
    _quickSelect(list, pivotIdx + 1, high, k, compare);
  }
}

int _qsPartition<T>(
  List<T> list,
  int low,
  int high,
  int Function(T, T) compare,
) {
  final pivot = list[high];
  var i = low;
  for (var j = low; j < high; j++) {
    if (compare(list[j], pivot) <= 0) {
      _swap(list, i, j);
      i++;
    }
  }
  _swap(list, i, high);
  return i;
}

/// Rearranges [list] such that the first [n] elements are the smallest [n] elements in sorted order.
///
/// Elements beyond index [n] are in an unspecified order. Equivalent to C++ `std::partial_sort`.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// final list = [5, 3, 1, 4, 2];
/// partialSort(list, 3); // list[0..2] == [1, 2, 3]
/// ```
void partialSort<T>(List<T> list, int n, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  if (n <= 0 || list.isEmpty) return;
  if (n >= list.length) {
    stableSort(list, compare: compare);
    return;
  }
  for (var i = 0; i < n; i++) {
    var minIdx = i;
    for (var j = i + 1; j < list.length; j++) {
      if (compare(list[j], list[minIdx]) < 0) minIdx = j;
    }
    _swap(list, i, minIdx);
  }
}

// ==============================================
// Min / Max Operations
// ==============================================

/// Returns the minimum element of [iterable] according to [compare].
///
/// Throws a [StateError] if [iterable] is empty.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::min_element`.
///
/// Example:
/// ```dart
/// minElement([3, 1, 4, 1, 5]); // 1
/// ```
T minElement<T>(Iterable<T> iterable, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  final it = iterable.iterator;
  if (!it.moveNext()) {
    throw StateError('minElement: iterable must not be empty.');
  }
  var min = it.current;
  while (it.moveNext()) {
    if (compare(it.current, min) < 0) min = it.current;
  }
  return min;
}

/// Returns the maximum element of [iterable] according to [compare].
///
/// Throws a [StateError] if [iterable] is empty.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::max_element`.
///
/// Example:
/// ```dart
/// maxElement([3, 1, 4, 1, 5]); // 5
/// ```
T maxElement<T>(Iterable<T> iterable, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  final it = iterable.iterator;
  if (!it.moveNext()) {
    throw StateError('maxElement: iterable must not be empty.');
  }
  var max = it.current;
  while (it.moveNext()) {
    if (compare(it.current, max) > 0) max = it.current;
  }
  return max;
}

/// Returns a [Pair] containing the minimum and maximum elements of [iterable] in a single pass.
///
/// Throws a [StateError] if [iterable] is empty.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::minmax_element`.
///
/// Example:
/// ```dart
/// minMaxElement([3, 1, 4, 1, 5]); // Pair(1, 5)
/// ```
Pair<T, T> minMaxElement<T>(
  Iterable<T> iterable, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  final it = iterable.iterator;
  if (!it.moveNext()) {
    throw StateError('minMaxElement: iterable must not be empty.');
  }
  var min = it.current;
  var max = it.current;
  while (it.moveNext()) {
    if (compare(it.current, min) < 0) min = it.current;
    if (compare(it.current, max) > 0) max = it.current;
  }
  return makePair(min, max);
}

// ==============================================
// Comparison Operations
// ==============================================

/// Returns `true` if the two iterables contain the same elements in the same order.
///
/// Equivalent to C++ `std::equal`. Two iterables of different lengths are never equal.
/// Uses [equals] if provided, otherwise uses `==`.
///
/// Example:
/// ```dart
/// equal([1, 2, 3], [1, 2, 3]); // true
/// equal([1, 2],    [1, 2, 3]); // false
/// ```
bool equal<T>(Iterable<T> a, Iterable<T> b, {bool Function(T, T)? equals}) {
  equals ??= (x, y) => x == y;
  final itA = a.iterator;
  final itB = b.iterator;
  while (itA.moveNext()) {
    if (!itB.moveNext()) return false;
    if (!equals(itA.current, itB.current)) return false;
  }
  return !itB.moveNext();
}

/// Returns `true` if [a] and [b] contain the same elements regardless of order (multiset equality).
///
/// Equivalent to C++ `std::is_permutation`. $O(N^2)$ time.
///
/// Example:
/// ```dart
/// isPermutation([1, 2, 3], [3, 1, 2]); // true
/// isPermutation([1, 2, 3], [1, 2, 4]); // false
/// ```
bool isPermutation<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  final bCopy = List<T>.of(b);
  for (final element in a) {
    final idx = bCopy.indexOf(element);
    if (idx == -1) return false;
    bCopy.removeAt(idx);
  }
  return true;
}

/// Compares two ranges lexicographically and returns a three-way result.
///
/// Returns a negative integer if [a] < [b], a positive integer if [a] > [b], or `0` if equal.
/// Equivalent to C++ `std::lexicographical_compare` (three-way / C++20 `<=>` variant).
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// lexicographicalCompare([1, 2, 3], [1, 2, 4]); // negative
/// lexicographicalCompare([1, 2, 4], [1, 2, 3]); // positive
/// lexicographicalCompare([1, 2],    [1, 2, 3]); // negative (shorter is less)
/// ```
int lexicographicalCompare<T>(
  Iterable<T> a,
  Iterable<T> b, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  final itA = a.iterator;
  final itB = b.iterator;
  while (itA.moveNext()) {
    if (!itB.moveNext()) return 1; // a is longer
    final cmp = compare(itA.current, itB.current);
    if (cmp != 0) return cmp;
  }
  return itB.moveNext() ? -1 : 0; // b is longer → a is less
}

// ==============================================
// Heap Operations
// ==============================================

/// Rearranges the elements of [list] into a max-heap in-place.
///
/// After this call, `list[0]` is the largest element. $O(N)$ time.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::make_heap`.
///
/// Example:
/// ```dart
/// final list = [3, 1, 4, 1, 5];
/// makeHeap(list); // list[0] == 5
/// ```
void makeHeap<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  final n = list.length;
  for (var i = n ~/ 2 - 1; i >= 0; i--) {
    _siftDown(list, i, n, compare);
  }
}

void _siftDown<T>(List<T> list, int i, int n, int Function(T, T) compare) {
  while (true) {
    var largest = i;
    final left = 2 * i + 1;
    final right = 2 * i + 2;
    if (left < n && compare(list[left], list[largest]) > 0) largest = left;
    if (right < n && compare(list[right], list[largest]) > 0) largest = right;
    if (largest == i) break;
    _swap(list, i, largest);
    i = largest;
  }
}

/// Inserts [value] into the heap [list], maintaining the max-heap property.
///
/// The list must already satisfy the heap property before this call. $O(\log N)$ time.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::push_heap` (appends then sifts up).
///
/// Example:
/// ```dart
/// final heap = [5, 3, 4, 1];
/// pushHeap(heap, 6); // heap[0] == 6
/// ```
void pushHeap<T>(List<T> list, T value, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  list.add(value);
  var i = list.length - 1;
  while (i > 0) {
    final parent = (i - 1) ~/ 2;
    if (compare(list[i], list[parent]) > 0) {
      _swap(list, i, parent);
      i = parent;
    } else {
      break;
    }
  }
}

/// Removes the largest element from the heap [list] by moving it to the end.
///
/// Returns the new logical heap length (the removed element is now at `list[list.length - 1]`).
/// Shrinks the list if it is growable.
/// Uses [compare] if provided, otherwise uses natural order.
/// Equivalent to C++ `std::pop_heap` followed by a `pop_back`. $O(\log N)$ time.
///
/// Example:
/// ```dart
/// final heap = [5, 3, 4, 1];
/// final top = heap.last; // peek before pop
/// final newLen = popHeap(heap); // heap[newLen] == 5, newLen == 3
/// ```
int popHeap<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  if (list.isEmpty) return 0;
  final newLen = list.length - 1;
  _swap(list, 0, newLen);
  _siftDown(list, 0, newLen, compare);
  return newLen;
}

/// Sorts the heap [list] in ascending order in-place, destroying the heap property.
///
/// Equivalent to C++ `std::sort_heap`. Uses [compare] if provided, otherwise uses natural order.
/// $O(N \log N)$ time.
///
/// Example:
/// ```dart
/// final heap = [5, 4, 3, 1];
/// sortHeap(heap); // heap is now [1, 3, 4, 5]
/// ```
void sortHeap<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  var size = list.length;
  while (size > 1) {
    _swap(list, 0, size - 1);
    size--;
    _siftDown(list, 0, size, compare);
  }
}

/// Returns `true` if [list] satisfies the max-heap property throughout.
///
/// Equivalent to C++ `std::is_heap`.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// isHeap([5, 3, 4, 1]); // true
/// isHeap([1, 3, 4, 5]); // false
/// ```
bool isHeap<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  return isHeapUntil(list, compare: compare) == list.length;
}

/// Returns the index of the first element in [list] that violates the max-heap property.
///
/// Returns [list].length if the entire list is a valid max-heap.
/// Equivalent to C++ `std::is_heap_until`.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// isHeapUntil([5, 3, 4, 1, 6]); // 4 — list[4] (6) > its parent list[1] (3)
/// ```
int isHeapUntil<T>(List<T> list, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  final n = list.length;
  for (var i = 1; i < n; i++) {
    final parent = (i - 1) ~/ 2;
    if (compare(list[i], list[parent]) > 0) return i;
  }
  return n;
}

// ==============================================
// Partition Utilities
// ==============================================

/// Returns `true` if [iterable] is partitioned with respect to [predicate].
///
/// A range is partitioned if all elements for which [predicate] returns `true` come before
/// all elements for which it returns `false`. Empty ranges are considered partitioned.
/// Equivalent to C++ `std::is_partitioned`.
///
/// Example:
/// ```dart
/// isPartitioned([2, 4, 6, 1, 3, 5], (n) => n % 2 == 0); // true
/// isPartitioned([2, 1, 4, 3],        (n) => n % 2 == 0); // false
/// ```
bool isPartitioned<T>(Iterable<T> iterable, bool Function(T) predicate) {
  var seenFalse = false;
  for (final element in iterable) {
    if (predicate(element)) {
      if (seenFalse) return false;
    } else {
      seenFalse = true;
    }
  }
  return true;
}

/// Copies elements of [iterable] into two separate lists based on [predicate].
///
/// Returns a [Pair] where [Pair.first] contains elements for which [predicate] is `true`,
/// and [Pair.second] contains elements for which it is `false`.
/// Equivalent to C++ `std::partition_copy`.
///
/// Example:
/// ```dart
/// partitionCopy([1, 2, 3, 4], (n) => n % 2 == 0); // Pair([2, 4], [1, 3])
/// ```
Pair<List<T>, List<T>> partitionCopy<T>(
  Iterable<T> iterable,
  bool Function(T) predicate,
) {
  final trues = <T>[];
  final falses = <T>[];
  for (final element in iterable) {
    if (predicate(element)) {
      trues.add(element);
    } else {
      falses.add(element);
    }
  }
  return makePair(trues, falses);
}

/// Finds the partition point in an already-partitioned [list] via binary search.
///
/// Returns the index of the first element for which [predicate] returns `false`.
/// The [list] **must** already be partitioned by [predicate] (all `true` elements precede all
/// `false` elements). $O(\log N)$ time. Equivalent to C++ `std::partition_point`.
///
/// Example:
/// ```dart
/// partitionPoint([2, 4, 6, 1, 3, 5], (n) => n % 2 == 0); // 3
/// ```
int partitionPoint<T>(List<T> list, bool Function(T) predicate) {
  var lo = 0;
  var hi = list.length;
  while (lo < hi) {
    final mid = lo + ((hi - lo) >> 1);
    if (predicate(list[mid])) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

// ==============================================
// Additional Set Operations
// ==============================================

/// Constructs a sorted symmetric difference from two sorted sequences [a] and [b].
///
/// Both sequences must be sorted according to the same [compare] function.
/// The resulting sequence contains elements present in either [a] or [b] but **not** in both.
/// Equivalent to C++ `std::set_symmetric_difference`.
///
/// Example:
/// ```dart
/// setSymmetricDifference([1, 2, 3], [2, 3, 4]); // [1, 4]
/// ```
List<T> setSymmetricDifference<T>(
  Iterable<T> a,
  Iterable<T> b, {
  int Function(T, T)? compare,
}) {
  compare ??= _defaultCompare;
  final res = <T>[];
  final itA = a.iterator;
  final itB = b.iterator;
  bool hasA = itA.moveNext();
  bool hasB = itB.moveNext();
  while (hasA && hasB) {
    final comp = compare(itA.current, itB.current);
    if (comp < 0) {
      res.add(itA.current);
      hasA = itA.moveNext();
    } else if (comp > 0) {
      res.add(itB.current);
      hasB = itB.moveNext();
    } else {
      hasA = itA.moveNext();
      hasB = itB.moveNext();
    }
  }
  while (hasA) {
    res.add(itA.current);
    hasA = itA.moveNext();
  }
  while (hasB) {
    res.add(itB.current);
    hasB = itB.moveNext();
  }
  return res;
}

// ==============================================
// Merge Operations
// ==============================================

/// Merges two sorted sequences [a] and [b] into a single sorted sequence, keeping all duplicates.
///
/// Both sequences must be sorted according to the same [compare] function.
/// Unlike [setUnion], every element from both ranges is included (including duplicates).
/// Equivalent to C++ `std::merge`.
///
/// Example:
/// ```dart
/// merge([1, 2, 2, 4], [2, 3, 5]); // [1, 2, 2, 2, 3, 4, 5]
/// ```
List<T> merge<T>(Iterable<T> a, Iterable<T> b, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  final res = <T>[];
  final itA = a.iterator;
  final itB = b.iterator;
  bool hasA = itA.moveNext();
  bool hasB = itB.moveNext();
  while (hasA && hasB) {
    if (compare(itA.current, itB.current) <= 0) {
      res.add(itA.current);
      hasA = itA.moveNext();
    } else {
      res.add(itB.current);
      hasB = itB.moveNext();
    }
  }
  while (hasA) {
    res.add(itA.current);
    hasA = itA.moveNext();
  }
  while (hasB) {
    res.add(itB.current);
    hasB = itB.moveNext();
  }
  return res;
}

/// Merges two consecutive sorted sub-ranges `[0, middle)` and `[middle, list.length)` of [list]
/// in-place.
///
/// Both sub-ranges must be sorted according to the same [compare] function.
/// Equivalent to C++ `std::inplace_merge`.
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// final list = [1, 3, 5, 2, 4, 6];
/// inplaceMerge(list, 3); // list is now [1, 2, 3, 4, 5, 6]
/// ```
void inplaceMerge<T>(List<T> list, int middle, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  _mergeSortedHalves(list, 0, middle, list.length, compare);
}

// ==============================================
// Utility
// ==============================================

/// Clamps every element of [list] into the closed interval `[low, high]` in-place.
///
/// Each element `e` becomes:
/// - [low]  if `compare(e, low)  < 0`
/// - [high] if `compare(e, high) > 0`
/// - `e`    otherwise
///
/// Uses [compare] if provided, otherwise uses natural order.
///
/// Example:
/// ```dart
/// final list = [-1, 3, 7, 15];
/// clampRange(list, 0, 10); // list is now [0, 3, 7, 10]
/// ```
void clampRange<T>(List<T> list, T low, T high, {int Function(T, T)? compare}) {
  compare ??= _defaultCompare;
  for (var i = 0; i < list.length; i++) {
    if (compare(list[i], low) < 0) {
      list[i] = low;
    } else if (compare(list[i], high) > 0) {
      list[i] = high;
    }
  }
}
