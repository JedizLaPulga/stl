import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('HashSet', () {
    test('insert and size', () {
      final s = HashSet<int>();
      expect(s.empty, isTrue);

      expect(s.insert(10), isTrue);
      expect(s.insert(20), isTrue);

      expect(s.insert(10), isFalse);

      expect(s.size, equals(2));
      expect(s.empty, isFalse);
    });

    test('erase and contains', () {
      final s = HashSet<String>.from(['apple', 'banana']);

      expect(s.contains('apple'), isTrue);
      expect(s.contains('kiwi'), isFalse);

      expect(s.erase('apple'), isTrue);
      expect(s.contains('apple'), isFalse);
      expect(s.size, equals(1));

      expect(s.erase('kiwi'), isFalse);
    });

    test('clear', () {
      final s = HashSet<int>.from([1, 2, 3]);
      s.clear();
      expect(s.size, equals(0));
      expect(s.empty, isTrue);
    });

    test('swap', () {
      final s1 = HashSet<int>.from([1, 2]);
      final s2 = HashSet<int>.from([3, 4, 5]);

      s1.swap(s2);

      expect(s1.size, equals(3));
      expect(s1.contains(3), isTrue);
      expect(s2.size, equals(2));
      expect(s2.contains(1), isTrue);
    });

    test('union, intersection, difference', () {
      final s1 = HashSet<int>.from([1, 2, 3, 4]);
      final s2 = HashSet<int>.from([3, 4, 5, 6]);

      final uni = s1.union(s2);
      expect(uni.size, equals(6));
      expect(uni.containsAll([1, 2, 3, 4, 5, 6]), isTrue);

      final inter = s1.intersection(s2);
      expect(inter.size, equals(2));
      expect(inter.containsAll([3, 4]), isTrue);

      final diff = s1.difference(s2);
      expect(diff.size, equals(2));
      expect(diff.containsAll([1, 2]), isTrue);
    });

    test('equality', () {
      final s1 = HashSet<int>.from([1, 2, 3]);
      final s2 = HashSet<int>.from([3, 2, 1]);
      final s3 = HashSet<int>.from([1, 2]);

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });
  });
}
