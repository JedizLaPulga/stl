// v0.6.4 Extended Algorithm Tests
// Covers all public algorithm functions not tested in algorithm_test.dart,
// plus empty-list edge cases for functions that were tested.
import 'package:test/test.dart';
import 'package:stl/stl.dart' as stl;
import 'package:stl/stl.dart'
    hide allOf, anyOf, isSorted, isHeap, isHeapUntil, isPartitioned;

void main() {
  // -----------------------------------------------------------------------
  // Edge cases for already-tested functions
  // -----------------------------------------------------------------------
  group('Algorithm - Edge Cases for Search & Bounds', () {
    test('lowerBound on empty list returns 0', () {
      expect(lowerBound(<int>[], 5), equals(0));
    });

    test('upperBound on empty list returns 0', () {
      expect(upperBound(<int>[], 5), equals(0));
    });

    test('binarySearch on empty list returns false', () {
      expect(binarySearch(<int>[], 5), isFalse);
    });

    test('lowerBound / upperBound with custom comparator (reverse order)', () {
      // Descending list — comparator reverses natural order
      final list = [50, 40, 30, 20, 10];
      int cmp(int a, int b) => b.compareTo(a); // reverse
      expect(lowerBound(list, 30, compare: cmp), equals(2));
      expect(upperBound(list, 30, compare: cmp), equals(3));
    });

    test('binarySearch with custom comparator', () {
      final list = [50, 40, 30, 20, 10];
      int cmp(int a, int b) => b.compareTo(a);
      expect(binarySearch(list, 30, compare: cmp), isTrue);
      expect(binarySearch(list, 35, compare: cmp), isFalse);
    });

    test('equalRange on empty list returns Pair(0, 0)', () {
      final r = equalRange(<int>[], 5);
      expect(r.first, equals(0));
      expect(r.second, equals(0));
    });

    test('lowerBound single-element list — value present', () {
      expect(lowerBound([42], 42), equals(0));
    });

    test('lowerBound single-element list — value absent (less)', () {
      expect(lowerBound([42], 10), equals(0));
    });

    test('lowerBound single-element list — value absent (greater)', () {
      expect(lowerBound([42], 99), equals(1));
    });
  });

  group('Algorithm - Edge Cases for Set Operations', () {
    test('setUnion with empty inputs', () {
      expect(setUnion(<int>[], <int>[]), isEmpty);
      expect(setUnion([1, 2], <int>[]), equals([1, 2]));
      expect(setUnion(<int>[], [3, 4]), equals([3, 4]));
    });

    test('setIntersection with empty inputs', () {
      expect(setIntersection(<int>[], <int>[]), isEmpty);
      expect(setIntersection([1, 2], <int>[]), isEmpty);
    });

    test('setDifference with empty inputs', () {
      expect(setDifference(<int>[], <int>[]), isEmpty);
      expect(setDifference([1, 2], <int>[]), equals([1, 2]));
      expect(setDifference(<int>[], [1, 2]), isEmpty);
    });

    test('setSymmetricDifference', () {
      expect(setSymmetricDifference([1, 2, 3], [2, 3, 4]), equals([1, 4]));
      expect(setSymmetricDifference(<int>[], <int>[]), isEmpty);
      expect(setSymmetricDifference([1, 2], [1, 2]), isEmpty);
    });
  });

  group('Algorithm - Edge Cases for Mutations', () {
    test('rotate by 0 is a no-op', () {
      final list = [1, 2, 3];
      rotate(list, 0);
      expect(list, equals([1, 2, 3]));
    });

    test('rotate by list length is a no-op', () {
      final list = [1, 2, 3];
      rotate(list, 3);
      expect(list, equals([1, 2, 3]));
    });

    test('rotate empty list is safe', () {
      final list = <int>[];
      rotate(list, 5);
      expect(list, isEmpty);
    });

    test('reverse empty list is safe', () {
      final list = <int>[];
      reverse(list);
      expect(list, isEmpty);
    });

    test('reverse single element', () {
      final list = [99];
      reverse(list);
      expect(list, equals([99]));
    });

    test('unique on empty list returns 0', () {
      final list = <int>[];
      expect(unique(list), equals(0));
    });

    test('unique on already-unique list leaves it unchanged', () {
      final list = [1, 2, 3];
      expect(unique(list), equals(3));
      expect(list, equals([1, 2, 3]));
    });

    test('unique with custom equals', () {
      // Treat case-insensitive equal strings as duplicates
      final list = ['a', 'A', 'b', 'B'];
      final end = unique(
        list,
        equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      );
      expect(end, equals(2));
      expect(list.sublist(0, end), equals(['a', 'b']));
    });

    test('partition on empty list', () {
      final list = <int>[];
      expect(partition(list, (n) => n.isEven), equals(0));
    });

    test('partition all-true predicate', () {
      final list = [2, 4, 6];
      final p = partition(list, (n) => n.isEven);
      expect(p, equals(3));
      expect(list.every((n) => n.isEven), isTrue);
    });

    test('partition all-false predicate', () {
      final list = [1, 3, 5];
      final p = partition(list, (n) => n.isEven);
      expect(p, equals(0));
    });

    test('stablePartition on empty list', () {
      final list = <int>[];
      expect(stablePartition(list, (n) => n.isEven), equals(0));
    });
  });

  // -----------------------------------------------------------------------
  // Non-modifying sequence operations (untested in algorithm_test.dart)
  // -----------------------------------------------------------------------
  group('Algorithm - allOf / anyOf / noneOf', () {
    test('allOf true for all-matching', () {
      expect(stl.allOf([2, 4, 6], (n) => n.isEven), isTrue);
    });

    test('allOf false when one element fails', () {
      expect(stl.allOf([2, 3, 6], (n) => n.isEven), isFalse);
    });

    test('allOf true for empty range', () {
      expect(stl.allOf(<int>[], (n) => n.isEven), isTrue);
    });

    test('anyOf true when at least one matches', () {
      expect(stl.anyOf([1, 3, 4], (n) => n.isEven), isTrue);
    });

    test('anyOf false when nothing matches', () {
      expect(stl.anyOf([1, 3, 5], (n) => n.isEven), isFalse);
    });

    test('anyOf false for empty range', () {
      expect(stl.anyOf(<int>[], (n) => n.isEven), isFalse);
    });

    test('noneOf true when nothing matches', () {
      expect(noneOf([1, 3, 5], (n) => n.isEven), isTrue);
    });

    test('noneOf false when at least one matches', () {
      expect(noneOf([1, 2, 5], (n) => n.isEven), isFalse);
    });

    test('noneOf true for empty range', () {
      expect(noneOf(<int>[], (n) => n.isEven), isTrue);
    });
  });

  group('Algorithm - forEach / forEachN', () {
    test('forEach visits every element in order', () {
      final visited = <int>[];
      forEach([1, 2, 3], visited.add);
      expect(visited, equals([1, 2, 3]));
    });

    test('forEach on empty range visits nothing', () {
      var count = 0;
      forEach(<int>[], (_) => count++);
      expect(count, equals(0));
    });

    test('forEachN visits first n elements', () {
      final visited = <int>[];
      forEachN([10, 20, 30, 40], 2, visited.add);
      expect(visited, equals([10, 20]));
    });

    test('forEachN with n > length visits all elements', () {
      final visited = <int>[];
      forEachN([1, 2, 3], 100, visited.add);
      expect(visited, equals([1, 2, 3]));
    });

    test('forEachN with n == 0 visits nothing', () {
      var count = 0;
      forEachN([1, 2, 3], 0, (_) => count++);
      expect(count, equals(0));
    });
  });

  group('Algorithm - count / countIf', () {
    test('count returns correct occurrence count', () {
      expect(count([1, 2, 1, 3, 1], 1), equals(3));
    });

    test('count returns 0 when element absent', () {
      expect(count([1, 2, 3], 99), equals(0));
    });

    test('count on empty iterable returns 0', () {
      expect(count(<int>[], 1), equals(0));
    });

    test('countIf returns matching count', () {
      expect(countIf([1, 2, 3, 4], (n) => n.isEven), equals(2));
    });

    test('countIf returns 0 when nothing matches', () {
      expect(countIf([1, 3, 5], (n) => n.isEven), equals(0));
    });

    test('countIf on empty iterable returns 0', () {
      expect(countIf(<int>[], (n) => n.isEven), equals(0));
    });
  });

  group('Algorithm - find / findIf / findIfNot', () {
    test('find returns index of first match', () {
      expect(find([10, 20, 30, 20], 20), equals(1));
    });

    test('find returns -1 when absent', () {
      expect(find([1, 2, 3], 99), equals(-1));
    });

    test('find on empty iterable returns -1', () {
      expect(find(<int>[], 5), equals(-1));
    });

    test('findIf returns index of first match', () {
      expect(findIf([1, 3, 4, 6], (n) => n.isEven), equals(2));
    });

    test('findIf returns -1 when nothing matches', () {
      expect(findIf([1, 3, 5], (n) => n.isEven), equals(-1));
    });

    test('findIf on empty iterable returns -1', () {
      expect(findIf(<int>[], (n) => n.isEven), equals(-1));
    });

    test('findIfNot returns index of first non-matching', () {
      expect(findIfNot([2, 4, 5, 6], (n) => n.isEven), equals(2));
    });

    test('findIfNot returns -1 when all match', () {
      expect(findIfNot([2, 4, 6], (n) => n.isEven), equals(-1));
    });

    test('findIfNot on empty iterable returns -1', () {
      expect(findIfNot(<int>[], (n) => n.isEven), equals(-1));
    });
  });

  group('Algorithm - findEnd / findFirstOf / adjacentFind', () {
    test('findEnd returns index of last subsequence occurrence', () {
      expect(findEnd([1, 2, 3, 1, 2], [1, 2]), equals(3));
    });

    test('findEnd returns -1 when sub not present', () {
      expect(findEnd([1, 2, 3], [4, 5]), equals(-1));
    });

    test('findEnd with empty sub returns list.length', () {
      expect(findEnd([1, 2, 3], <int>[]), equals(3));
    });

    test('findEnd on empty list returns -1', () {
      expect(findEnd(<int>[], [1]), equals(-1));
    });

    test('findFirstOf returns index of first element also in targets', () {
      expect(findFirstOf([1, 2, 3, 4], [3, 5]), equals(2));
    });

    test('findFirstOf returns -1 when no target element found', () {
      expect(findFirstOf([1, 2, 3], [4, 5]), equals(-1));
    });

    test('findFirstOf on empty list returns -1', () {
      expect(findFirstOf(<int>[], [1, 2]), equals(-1));
    });

    test('adjacentFind returns index of first adjacent duplicate', () {
      expect(adjacentFind([1, 2, 2, 3]), equals(1));
    });

    test('adjacentFind returns -1 when no adjacent duplicates', () {
      expect(adjacentFind([1, 2, 3, 4]), equals(-1));
    });

    test('adjacentFind on empty / single-element list returns -1', () {
      expect(adjacentFind(<int>[]), equals(-1));
      expect(adjacentFind([42]), equals(-1));
    });

    test('adjacentFind with custom equals', () {
      // Consecutive elements differing by 1 are "adjacent"
      final list = [1, 2, 4, 5, 7];
      final idx = adjacentFind(list, equals: (a, b) => (b - a) == 1);
      expect(idx, equals(0)); // 1 and 2 differ by 1
    });
  });

  group('Algorithm - search / searchN / mismatch', () {
    test('search finds first subsequence', () {
      expect(search([1, 2, 3, 4], [2, 3]), equals(1));
    });

    test('search returns -1 when sub not found', () {
      expect(search([1, 2, 3], [4, 5]), equals(-1));
    });

    test('search returns 0 for empty sub', () {
      expect(search([1, 2, 3], <int>[]), equals(0));
    });

    test('search on empty list returns -1 for non-empty sub', () {
      expect(search(<int>[], [1]), equals(-1));
    });

    test('searchN finds first run of n identical elements', () {
      expect(searchN([1, 2, 2, 2, 3], 3, 2), equals(1));
    });

    test('searchN returns -1 when no such run', () {
      expect(searchN([1, 2, 2, 3], 3, 2), equals(-1));
    });

    test('searchN returns 0 when n <= 0', () {
      expect(searchN([1, 2, 3], 0, 5), equals(0));
    });

    test('mismatch returns first differing index', () {
      final r = mismatch([1, 2, 3], [1, 2, 4]);
      expect(r.first, equals(2));
      expect(r.second, equals(2));
    });

    test('mismatch returns Pair(-1,-1) when identical', () {
      final r = mismatch([1, 2, 3], [1, 2, 3]);
      expect(r.first, equals(-1));
      expect(r.second, equals(-1));
    });

    test('mismatch on empty lists returns Pair(-1,-1)', () {
      final r = mismatch(<int>[], <int>[]);
      expect(r.first, equals(-1));
      expect(r.second, equals(-1));
    });
  });

  // -----------------------------------------------------------------------
  // Modifying sequence operations
  // -----------------------------------------------------------------------
  group('Algorithm - fill / fillN / generate / generateN', () {
    test('fill replaces all elements', () {
      final list = [1, 2, 3];
      fill(list, 0);
      expect(list, equals([0, 0, 0]));
    });

    test('fill on empty list is safe', () {
      final list = <int>[];
      fill(list, 9);
      expect(list, isEmpty);
    });

    test('fillN fills first n elements', () {
      final list = [1, 2, 3, 4, 5];
      fillN(list, 3, 0);
      expect(list, equals([0, 0, 0, 4, 5]));
    });

    test('fillN with n == 0 changes nothing', () {
      final list = [1, 2, 3];
      fillN(list, 0, 99);
      expect(list, equals([1, 2, 3]));
    });

    test('generate overwrites with produced values', () {
      final list = [0, 0, 0];
      var i = 0;
      generate(list, () => ++i);
      expect(list, equals([1, 2, 3]));
    });

    test('generate on empty list is safe', () {
      final list = <int>[];
      generate(list, () => 42);
      expect(list, isEmpty);
    });

    test('generateN overwrites first n elements', () {
      final list = [0, 0, 0, 0];
      var i = 10;
      generateN(list, 2, () => i++);
      expect(list.sublist(0, 2), equals([10, 11]));
      expect(list.sublist(2), equals([0, 0]));
    });
  });

  group('Algorithm - replace / replaceIf / remove / removeIf', () {
    test('replace swaps all matching values', () {
      final list = [1, 2, 1, 3, 1];
      replace(list, 1, 9);
      expect(list, equals([9, 2, 9, 3, 9]));
    });

    test('replace with absent value changes nothing', () {
      final list = [1, 2, 3];
      replace(list, 99, 0);
      expect(list, equals([1, 2, 3]));
    });

    test('replace on empty list is safe', () {
      final list = <int>[];
      replace(list, 1, 0);
      expect(list, isEmpty);
    });

    test('replaceIf replaces matching elements', () {
      final list = [1, 2, 3, 4, 5];
      replaceIf(list, (n) => n.isEven, 0);
      expect(list, equals([1, 0, 3, 0, 5]));
    });

    test('replaceIf on empty list is safe', () {
      final list = <int>[];
      replaceIf(list, (n) => true, 0);
      expect(list, isEmpty);
    });

    test('remove erases all matching and returns new length', () {
      final list = [1, 2, 1, 3, 1];
      final newLen = remove(list, 1);
      expect(newLen, equals(2));
      expect(list.sublist(0, newLen), equals([2, 3]));
    });

    test('remove on empty list returns 0', () {
      expect(remove(<int>[], 5), equals(0));
    });

    test('removeIf erases matching elements and returns new length', () {
      final list = [1, 2, 3, 4, 5];
      final newLen = removeIf(list, (n) => n.isEven);
      expect(newLen, equals(3));
      expect(list.sublist(0, newLen), equals([1, 3, 5]));
    });

    test('removeIf with all-matching predicate returns 0', () {
      final list = [2, 4, 6];
      expect(removeIf(list, (n) => n.isEven), equals(0));
    });
  });

  group('Algorithm - swapRanges', () {
    test('swapRanges swaps corresponding elements', () {
      final a = [1, 2, 3];
      final b = [4, 5, 6];
      swapRanges(a, b);
      expect(a, equals([4, 5, 6]));
      expect(b, equals([1, 2, 3]));
    });

    test('swapRanges on empty lists is safe', () {
      final a = <int>[];
      final b = <int>[];
      swapRanges(a, b);
      expect(a, isEmpty);
      expect(b, isEmpty);
    });
  });

  // -----------------------------------------------------------------------
  // Sorting & selection
  // -----------------------------------------------------------------------
  group('Algorithm - isSorted / isSortedUntil', () {
    test('isSorted true for sorted list', () {
      expect(stl.isSorted([1, 2, 3, 4, 5]), isTrue);
    });

    test('isSorted true for single element', () {
      expect(stl.isSorted([42]), isTrue);
    });

    test('isSorted true for empty list', () {
      expect(stl.isSorted(<int>[]), isTrue);
    });

    test('isSorted false for unsorted list', () {
      expect(stl.isSorted([1, 3, 2, 4]), isFalse);
    });

    test('isSorted with custom comparator (descending)', () {
      expect(
        stl.isSorted([5, 4, 3, 2, 1], compare: (a, b) => b.compareTo(a)),
        isTrue,
      );
      expect(
        stl.isSorted([5, 3, 4, 2, 1], compare: (a, b) => b.compareTo(a)),
        isFalse,
      );
    });

    test('isSortedUntil returns length for fully sorted list', () {
      expect(isSortedUntil([1, 2, 3, 4]), equals(4));
    });

    test('isSortedUntil returns index of first out-of-order element', () {
      expect(isSortedUntil([1, 2, 5, 3, 4]), equals(3));
    });

    test('isSortedUntil on empty list returns 0', () {
      expect(isSortedUntil(<int>[]), equals(0));
    });
  });

  group('Algorithm - stableSort', () {
    test('stableSort sorts correctly', () {
      final list = [5, 3, 1, 4, 2];
      stableSort(list);
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('stableSort with custom comparator (descending)', () {
      final list = [1, 3, 2, 5, 4];
      stableSort(list, compare: (a, b) => b.compareTo(a));
      expect(list, equals([5, 4, 3, 2, 1]));
    });

    test('stableSort preserves relative order of equal elements', () {
      // Sort by first character only — equal keys should maintain input order
      final list = ['b1', 'a2', 'a1', 'b2'];
      stableSort(list, compare: (a, b) => a[0].compareTo(b[0]));
      // a2 must precede a1 — wait, input order of a-items is a2,a1 → preserved
      expect(list[0], equals('a2'));
      expect(list[1], equals('a1'));
      expect(list[2], equals('b1'));
      expect(list[3], equals('b2'));
    });

    test('stableSort on empty list is safe', () {
      final list = <int>[];
      stableSort(list);
      expect(list, isEmpty);
    });

    test('stableSort on single-element list is safe', () {
      final list = [7];
      stableSort(list);
      expect(list, equals([7]));
    });
  });

  group('Algorithm - nthElement / partialSort', () {
    test('nthElement places correct element at index n', () {
      final list = [3, 1, 4, 1, 5, 9, 2, 6];
      nthElement(list, 4);
      // The 5th smallest element (0-indexed: 4) of the sorted [1,1,2,3,4,5,6,9] is 4
      final sorted = [...list]..sort();
      expect(list[4], equals(sorted[4]));
      // Elements before index 4 must all be ≤ list[4]
      for (var i = 0; i < 4; i++) {
        expect(list[i], lessThanOrEqualTo(list[4]));
      }
    });

    test('nthElement on single element is safe', () {
      final list = [42];
      nthElement(list, 0);
      expect(list, equals([42]));
    });

    test('partialSort sorts first n elements', () {
      final list = [5, 3, 1, 4, 2];
      partialSort(list, 3);
      expect(list.sublist(0, 3), equals([1, 2, 3]));
    });

    test('partialSort on empty list is safe', () {
      final list = <int>[];
      partialSort(list, 0);
      expect(list, isEmpty);
    });
  });

  group('Algorithm - minElement / maxElement', () {
    test('minElement returns minimum', () {
      expect(minElement([3, 1, 4, 1, 5, 9, 2]), equals(1));
    });

    test('maxElement returns maximum', () {
      expect(maxElement([3, 1, 4, 1, 5, 9, 2]), equals(9));
    });

    test('minElement single element', () {
      expect(minElement([42]), equals(42));
    });

    test('maxElement single element', () {
      expect(maxElement([42]), equals(42));
    });

    test('minElement with custom comparator', () {
      // Pick the "minimum" by string length
      final result = minElement([
        'apple',
        'fig',
        'banana',
      ], compare: (a, b) => a.length.compareTo(b.length));
      expect(result, equals('fig'));
    });

    test('maxElement with custom comparator', () {
      final result = maxElement([
        'apple',
        'fig',
        'banana',
      ], compare: (a, b) => a.length.compareTo(b.length));
      expect(result, equals('banana'));
    });
  });

  // -----------------------------------------------------------------------
  // Comparison / permutation
  // -----------------------------------------------------------------------
  group('Algorithm - equal / isPermutation / lexicographicalCompare', () {
    test('equal returns true for identical iterables', () {
      expect(equal([1, 2, 3], [1, 2, 3]), isTrue);
    });

    test('equal returns false for different elements', () {
      expect(equal([1, 2, 3], [1, 2, 4]), isFalse);
    });

    test('equal returns true for two empty iterables', () {
      expect(equal(<int>[], <int>[]), isTrue);
    });

    test('equal returns false for different lengths', () {
      expect(equal([1, 2], [1, 2, 3]), isFalse);
    });

    test('equal with custom equals (case-insensitive strings)', () {
      expect(
        equal(
          ['a', 'B'],
          ['A', 'b'],
          equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
        ),
        isTrue,
      );
    });

    test('isPermutation returns true when lists are permutations', () {
      expect(isPermutation([1, 2, 3], [3, 1, 2]), isTrue);
    });

    test('isPermutation returns false for different multisets', () {
      expect(isPermutation([1, 2, 2], [1, 2, 3]), isFalse);
    });

    test('isPermutation returns true for equal empty lists', () {
      expect(isPermutation(<int>[], <int>[]), isTrue);
    });

    test('isPermutation returns false for different lengths', () {
      expect(isPermutation([1, 2], [1, 2, 3]), isFalse);
    });

    test('lexicographicalCompare less when prefix is shorter', () {
      expect(lexicographicalCompare([1, 2], [1, 2, 3]), isNegative);
    });

    test('lexicographicalCompare equal for identical lists', () {
      expect(lexicographicalCompare([1, 2, 3], [1, 2, 3]), equals(0));
    });

    test('lexicographicalCompare greater when element is larger', () {
      expect(lexicographicalCompare([1, 3], [1, 2]), isPositive);
    });

    test('lexicographicalCompare: empty < non-empty', () {
      expect(lexicographicalCompare(<int>[], [1]), isNegative);
    });

    test('lexicographicalCompare: empty == empty', () {
      expect(lexicographicalCompare(<int>[], <int>[]), equals(0));
    });
  });

  // -----------------------------------------------------------------------
  // Heap operations
  // -----------------------------------------------------------------------
  group('Algorithm - makeHeap / pushHeap / popHeap / sortHeap / isHeap', () {
    bool isMaxHeapProperty(List<int> list) {
      for (var i = 1; i < list.length; i++) {
        final parent = (i - 1) ~/ 2;
        if (list[parent] < list[i]) return false;
      }
      return true;
    }

    test('makeHeap produces a valid max-heap', () {
      final list = [3, 1, 4, 1, 5, 9, 2, 6];
      makeHeap(list);
      expect(isMaxHeapProperty(list), isTrue);
      expect(stl.isHeap(list), isTrue);
    });

    test('makeHeap on already-sorted list', () {
      final list = [1, 2, 3, 4, 5];
      makeHeap(list);
      expect(stl.isHeap(list), isTrue);
    });

    test('makeHeap on empty list is safe', () {
      final list = <int>[];
      makeHeap(list);
      expect(list, isEmpty);
    });

    test('pushHeap inserts value maintaining heap property', () {
      final list = [9, 5, 4, 1, 2, 3]; // already a heap
      pushHeap(list, 8);
      expect(stl.isHeap(list), isTrue);
      expect(list.contains(8), isTrue);
    });

    test('popHeap moves max to end and maintains heap for rest', () {
      final list = [9, 5, 4, 1, 2, 3];
      makeHeap(list);
      final oldMax = list[0];
      popHeap(list);
      // The removed max is now at the last position
      expect(list.last, equals(oldMax));
      // The remaining prefix must still be a heap
      expect(stl.isHeap(list.sublist(0, list.length - 1)), isTrue);
    });

    test('sortHeap produces sorted ascending list', () {
      final list = [3, 1, 4, 1, 5, 9, 2, 6];
      makeHeap(list);
      sortHeap(list);
      final sorted = [...list]..sort();
      expect(list, equals(sorted));
    });

    test('isHeap false for unsorted list', () {
      expect(stl.isHeap([1, 9, 3, 4]), isFalse);
    });

    test('isHeap true for empty and single-element lists', () {
      expect(stl.isHeap(<int>[]), isTrue);
      expect(stl.isHeap([42]), isTrue);
    });

    test('isHeapUntil returns index of first violation', () {
      // [9, 5, 4, 1, 2, 3, 10] — 10 violates heap at index 6 (parent 2 is 4 < 10)
      final list = [9, 5, 4, 1, 2, 3, 10];
      final idx = stl.isHeapUntil(list);
      expect(idx, lessThan(list.length));
      expect(list[idx], equals(10));
    });

    test('isHeapUntil returns list.length for valid heap', () {
      final list = [9, 5, 4, 1, 2, 3];
      makeHeap(list);
      expect(stl.isHeapUntil(list), equals(list.length));
    });

    test('heap with custom comparator (min-heap)', () {
      final list = [3, 1, 4, 1, 5, 9, 2, 6];
      int minCmp(int a, int b) => b.compareTo(a); // reverse → min-heap
      makeHeap(list, compare: minCmp);
      expect(stl.isHeap(list, compare: minCmp), isTrue);
      expect(list[0], equals(list.reduce((a, b) => a < b ? a : b)));
    });
  });

  // -----------------------------------------------------------------------
  // Partition utilities
  // -----------------------------------------------------------------------
  group('Algorithm - isPartitioned / partitionPoint', () {
    test('isPartitioned true when evens precede odds', () {
      expect(stl.isPartitioned([2, 4, 1, 3], (n) => n.isEven), isTrue);
    });

    test('isPartitioned false when interleaved', () {
      expect(stl.isPartitioned([1, 2, 3, 4], (n) => n.isEven), isFalse);
    });

    test('isPartitioned true for empty range', () {
      expect(stl.isPartitioned(<int>[], (n) => n.isEven), isTrue);
    });

    test('isPartitioned true when all satisfy predicate', () {
      expect(stl.isPartitioned([2, 4, 6], (n) => n.isEven), isTrue);
    });

    test('isPartitioned true when none satisfy predicate', () {
      expect(stl.isPartitioned([1, 3, 5], (n) => n.isEven), isTrue);
    });

    test('partitionPoint returns index of first false element', () {
      expect(partitionPoint([2, 4, 1, 3], (n) => n.isEven), equals(2));
    });

    test('partitionPoint returns 0 when first element fails predicate', () {
      expect(partitionPoint([1, 3, 5], (n) => n.isEven), equals(0));
    });

    test('partitionPoint returns length when all satisfy predicate', () {
      expect(partitionPoint([2, 4, 6], (n) => n.isEven), equals(3));
    });
  });

  // -----------------------------------------------------------------------
  // Merge operations
  // -----------------------------------------------------------------------
  group('Algorithm - merge / inplaceMerge', () {
    test('merge combines two sorted lists', () {
      final result = merge([1, 3, 5], [2, 4, 6]);
      expect(result, equals([1, 2, 3, 4, 5, 6]));
    });

    test('merge with one empty input', () {
      expect(merge(<int>[], [1, 2, 3]), equals([1, 2, 3]));
      expect(merge([1, 2, 3], <int>[]), equals([1, 2, 3]));
    });

    test('merge with both empty inputs', () {
      expect(merge(<int>[], <int>[]), isEmpty);
    });

    test('inplaceMerge merges two contiguous sorted halves', () {
      final list = [1, 3, 5, 2, 4, 6];
      inplaceMerge(list, 3);
      expect(list, equals([1, 2, 3, 4, 5, 6]));
    });

    test('inplaceMerge with middle == 0 is a no-op', () {
      final list = [1, 2, 3];
      inplaceMerge(list, 0);
      expect(list, equals([1, 2, 3]));
    });

    test('inplaceMerge with middle == list.length is a no-op', () {
      final list = [1, 2, 3];
      inplaceMerge(list, 3);
      expect(list, equals([1, 2, 3]));
    });
  });

  // -----------------------------------------------------------------------
  // Clamp
  // -----------------------------------------------------------------------
  group('Algorithm - clampRange', () {
    test('clampRange clamps all values into [low, high]', () {
      final list = [-5, 3, 15, 7, -1, 10];
      clampRange(list, 0, 10);
      expect(list, equals([0, 3, 10, 7, 0, 10]));
    });

    test('clampRange with all values already in range changes nothing', () {
      final list = [2, 4, 6];
      clampRange(list, 1, 9);
      expect(list, equals([2, 4, 6]));
    });

    test('clampRange on empty list is safe', () {
      final list = <int>[];
      clampRange(list, 0, 10);
      expect(list, isEmpty);
    });
  });

  // -----------------------------------------------------------------------
  // Permutations — edge cases
  // -----------------------------------------------------------------------
  group('Algorithm - Permutation edge cases', () {
    test('nextPermutation on single-element list returns false', () {
      final list = [1];
      expect(nextPermutation(list), isFalse);
      expect(list, equals([1]));
    });

    test('prevPermutation on single-element list returns false', () {
      final list = [1];
      expect(prevPermutation(list), isFalse);
      expect(list, equals([1]));
    });

    test('nextPermutation with custom comparator', () {
      // With a reverse comparator (b.compareTo(a)), descending order is "ascending"
      // [3, 2, 1] is the "first" (lowest) permutation under this comparator,
      // so nextPermutation returns true and advances it.
      final list = [3, 2, 1];
      int cmp(int a, int b) => b.compareTo(a);
      final result = nextPermutation(list, compare: cmp);
      // There is a next permutation from [3, 2, 1] under this comparator
      expect(result, isTrue);
    });
  });
}
