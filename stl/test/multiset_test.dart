import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('MultiSet', () {
    test('Initialization and basic operations', () {
      final mset = MultiSet<int>();
      expect(mset.empty, isTrue);
      expect(mset.size, equals(0));

      mset.insert(10);
      mset.insert(20);
      mset.insert(10); // Duplicate

      expect(mset.empty, isFalse);
      expect(mset.size, equals(3));
      expect(mset.uniqueSize, equals(2));
      expect(mset.contains(10), isTrue);
      expect(mset.contains(20), isTrue);
    });

    test('count() returns correct number of occurrences', () {
      final mset = MultiSet<int>();
      mset.insert(5);
      mset.insert(5);
      mset.insert(5);

      expect(mset.count(5), equals(3));
      expect(mset.count(10), equals(0));
    });

    test('erase() removes all occurrences', () {
      final mset = MultiSet<int>();
      mset.insert(5);
      mset.insert(5);
      mset.insert(10);

      expect(mset.erase(5), equals(2));
      expect(mset.contains(5), isFalse);
      expect(mset.count(5), equals(0));
      expect(mset.size, equals(1));
    });

    test('eraseOne() removes a single occurrence', () {
      final mset = MultiSet<int>();
      mset.insert(5);
      mset.insert(5);
      mset.insert(10);

      expect(mset.eraseOne(5), isTrue);
      expect(mset.contains(5), isTrue); // Still contains one
      expect(mset.count(5), equals(1));
      expect(mset.size, equals(2));

      expect(mset.eraseOne(5), isTrue);
      expect(mset.contains(5), isFalse); // Now gone
      expect(mset.count(5), equals(0));
      expect(mset.size, equals(1));

      expect(mset.eraseOne(5), isFalse);
    });

    test('clear() empties the set', () {
      final mset = MultiSet<int>();
      mset.insert(5);
      mset.insert(5);
      mset.clear();

      expect(mset.empty, isTrue);
      expect(mset.size, equals(0));
      expect(mset.count(5), equals(0));
    });

    test('Iteration yields elements in sorted order including duplicates', () {
      final mset = MultiSet<int>();
      mset.insert(30);
      mset.insert(10);
      mset.insert(20);
      mset.insert(10);

      final elements = mset.toList();
      expect(elements, equals([10, 10, 20, 30]));
    });

    test('Equality operator and hashCode', () {
      final set1 = MultiSet<int>();
      set1.insert(10);
      set1.insert(20);
      set1.insert(10);

      final set2 = MultiSet<int>();
      set2.insert(10);
      set2.insert(10);
      set2.insert(20);

      expect(set1, equals(set2));
      expect(set1.hashCode, equals(set2.hashCode));

      set2.insert(20);
      expect(set1, isNot(equals(set2)));
      expect(set1.hashCode, isNot(equals(set2.hashCode)));
    });

    test('swap() exchanges contents', () {
      final set1 = MultiSet<int>();
      set1.insert(1);
      set1.insert(1);

      final set2 = MultiSet<int>();
      set2.insert(2);

      set1.swap(set2);

      expect(set1.count(2), equals(1));
      expect(set1.count(1), equals(0));
      expect(set2.count(1), equals(2));
      expect(set2.count(2), equals(0));
      expect(set1.size, equals(1));
      expect(set2.size, equals(2));
    });
  });
}
