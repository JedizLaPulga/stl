import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Algorithm - Search and Bounds', () {
    test('lowerBound', () {
      final list = [10, 20, 30, 30, 40, 50];
      expect(lowerBound(list, 30), 2);
      expect(lowerBound(list, 35), 4);
      expect(lowerBound(list, 5), 0);
      expect(lowerBound(list, 60), 6);
    });

    test('upperBound', () {
      final list = [10, 20, 30, 30, 40, 50];
      expect(upperBound(list, 30), 4);
      expect(upperBound(list, 35), 4);
      expect(upperBound(list, 5), 0);
      expect(upperBound(list, 60), 6);
    });

    test('binarySearch', () {
      final list = [10, 20, 30, 30, 40, 50];
      expect(binarySearch(list, 30), isTrue);
      expect(binarySearch(list, 35), isFalse);
    });

    test('equalRange', () {
      final list = [10, 20, 30, 30, 40, 50];
      final range = equalRange(list, 30);
      expect(range.first, 2);
      expect(range.second, 4);
    });
  });

  group('Algorithm - Permutations', () {
    test('nextPermutation', () {
      final list = [1, 2, 3];
      expect(nextPermutation(list), isTrue);
      expect(list, [1, 3, 2]);
      
      expect(nextPermutation(list), isTrue);
      expect(list, [2, 1, 3]);

      nextPermutation(list); // 2, 3, 1
      nextPermutation(list); // 3, 1, 2
      nextPermutation(list); // 3, 2, 1
      
      expect(nextPermutation(list), isFalse); // Wraps around
      expect(list, [1, 2, 3]);
    });

    test('prevPermutation', () {
      final list = [3, 2, 1];
      expect(prevPermutation(list), isTrue);
      expect(list, [3, 1, 2]);

      expect(prevPermutation(list), isTrue);
      expect(list, [2, 3, 1]);

      prevPermutation(list); // 2, 1, 3
      prevPermutation(list); // 1, 3, 2
      prevPermutation(list); // 1, 2, 3

      expect(prevPermutation(list), isFalse); // Wraps around
      expect(list, [3, 2, 1]);
    });
  });

  group('Algorithm - Set Operations', () {
    test('setUnion', () {
      final list1 = [1, 2, 4, 5, 5];
      final list2 = [2, 3, 5, 6];
      expect(setUnion(list1, list2), [1, 2, 3, 4, 5, 5, 6]);
    });

    test('setIntersection', () {
      final list1 = [1, 2, 4, 5, 5];
      final list2 = [2, 3, 5, 6];
      expect(setIntersection(list1, list2), [2, 5]);
    });

    test('setDifference', () {
      final list1 = [1, 2, 4, 5, 5];
      final list2 = [2, 3, 5, 6];
      expect(setDifference(list1, list2), [1, 4, 5]);
      expect(setDifference(list2, list1), [3, 6]);
    });
  });

  group('Algorithm - Mutations', () {
    test('rotate', () {
      final list1 = [1, 2, 3, 4, 5];
      rotate(list1, 2);
      expect(list1, [3, 4, 5, 1, 2]);

      final list2 = [1, 2, 3, 4, 5];
      rotate(list2, -1);
      expect(list2, [5, 1, 2, 3, 4]);
    });

    test('reverse', () {
      final list = [1, 2, 3, 4, 5];
      reverse(list);
      expect(list, [5, 4, 3, 2, 1]);
    });

    test('unique', () {
      final list = [1, 1, 2, 2, 3, 2, 1];
      final end = unique(list);
      expect(end, 5);
      expect(list, [1, 2, 3, 2, 1]);
    });

    test('partition', () {
      final list = [1, 2, 3, 4, 5, 6];
      final p = partition(list, (int n) => n % 2 == 0);
      expect(p, 3);
      // Even numbers first, odd numbers last, order is unspecified
      for (int i = 0; i < p; i++) {
        expect(list[i] % 2 == 0, isTrue);
      }
      for (int i = p; i < list.length; i++) {
        expect(list[i] % 2 != 0, isTrue);
      }
    });

    test('stablePartition', () {
      final list = [1, 2, 3, 4, 5, 6];
      final p = stablePartition(list, (int n) => n % 2 == 0);
      expect(p, 3);
      expect(list, [2, 4, 6, 1, 3, 5]);
    });
  });
}
