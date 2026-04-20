

import '../utility/pair.dart';

int _defaultCompare<T>(T a, T b) {
  if (a is Comparable && b is Comparable) {
    return a.compareTo(b);
  }
  throw ArgumentError('Elements must be Comparable if no compare function is provided.');
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

/// Returns an iterator pointing to the first element in the range [first, last)
/// that is not less than (i.e. greater or equal to) [value].
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

/// Returns an iterator pointing to the first element in the range [first, last)
/// that is greater than [value].
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

/// Checks if an element equivalent to [value] appears within the range [first, last).
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

/// Returns a pair containing the lower and upper bounds of [value].
Pair<int, int> equalRange<T>(List<T> list, T value, {int Function(T, T)? compare}) {
  return makePair(
    lowerBound(list, value, compare: compare),
    upperBound(list, value, compare: compare),
  );
}

/// Transforms the range [first, last) into the next permutation from the
/// set of all permutations that are lexicographically ordered.
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

/// Transforms the range [first, last) into the previous permutation from the
/// set of all permutations that are lexicographically ordered.
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

/// Constructs a sorted union of elements from two sorted sequences.
List<T> setUnion<T>(Iterable<T> a, Iterable<T> b, {int Function(T, T)? compare}) {
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

/// Constructs a sorted intersection of elements from two sorted sequences.
List<T> setIntersection<T>(Iterable<T> a, Iterable<T> b, {int Function(T, T)? compare}) {
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

/// Constructs a sorted difference of elements from two sorted sequences.
List<T> setDifference<T>(Iterable<T> a, Iterable<T> b, {int Function(T, T)? compare}) {
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

/// Rotates the order of the elements in the range [first, last), in such a way 
/// that the element pointed by n becomes the new first element.
void rotate<T>(List<T> list, int n) {
  if (list.isEmpty) return;
  n = n % list.length;
  if (n < 0) n += list.length;
  if (n == 0) return;

  _reverseRange(list, 0, n);
  _reverseRange(list, n, list.length);
  _reverseRange(list, 0, list.length);
}

/// Reverses the order of the elements in the range.
void reverse<T>(List<T> list) {
  _reverseRange(list, 0, list.length);
}

/// Eliminates all except the first element from every consecutive group of equivalent
/// elements from the range [first, last) and returns a past-the-end index for the new logical end of the collection.
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

/// Reorders the elements in the range [first, last) in such a way that all elements for which
/// the predicate returns `true` precede the elements for which predicate returns `false`.
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

/// Reorders the elements in the range [first, last) in such a way that all elements for which
/// the predicate returns `true` precede the elements for which predicate returns `false`.
/// Relative order of the elements is preserved.
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
