import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SortedSet', () {
    test('insert and size', () {
      final s = SortedSet<int>();
      expect(s.empty, isTrue);

      expect(s.insert(20), isTrue);
      expect(s.insert(10), isTrue);
      expect(s.insert(30), isTrue);

      expect(s.insert(20), isFalse);

      expect(s.size, equals(3));
      expect(s.empty, isFalse);
    });

    test('iterator order', () {
      final s = SortedSet<int>.from([30, 10, 20]);
      final list = s.toList();

      // Should be strictly sorted
      expect(list, equals([10, 20, 30]));
    });

    test('custom comparator', () {
      final s = SortedSet<String>((a, b) => b.length.compareTo(a.length));
      s.insert('banana');
      s.insert('kiwi');
      s.insert('apple');

      // Sort by length reversed: banana (6), apple (5), kiwi (4)
      final list = s.toList();
      expect(list, equals(['banana', 'apple', 'kiwi']));
    });

    test('erase and contains', () {
      final s = SortedSet<int>.from([1, 2, 3]);

      expect(s.contains(2), isTrue);
      expect(s.contains(4), isFalse);

      expect(s.erase(2), isTrue);
      expect(s.contains(2), isFalse);
      expect(s.size, equals(2));

      expect(s.erase(4), isFalse);
    });

    test('union, intersection, difference', () {
      final s1 = SortedSet<int>.from([1, 2, 3, 4]);
      final s2 = SortedSet<int>.from([3, 4, 5, 6]);

      final uni = s1.union(s2);
      expect(uni.size, equals(6));
      expect(uni.toList(), equals([1, 2, 3, 4, 5, 6]));

      final inter = s1.intersection(s2);
      expect(inter.size, equals(2));
      expect(inter.toList(), equals([3, 4]));

      final diff = s1.difference(s2);
      expect(diff.size, equals(2));
      expect(diff.toList(), equals([1, 2]));
    });

    test('swap', () {
      final s1 = SortedSet<int>.from([10, 20]);
      final s2 = SortedSet<int>.from([100, 200, 300]);

      s1.swap(s2);

      expect(s1.size, equals(3));
      expect(s1.toList(), equals([100, 200, 300]));
      expect(s2.size, equals(2));
      expect(s2.toList(), equals([10, 20]));
    });
  });
}
