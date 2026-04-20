import '../utility/pair.dart';

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
