/// Comprehensive test suite for the `Tuple` utility module.
///
/// Ensures correct instantiation, deep equality semantics, cloning,
/// standard list conversions, and Dart 3 record translations across `Tuple3`
/// through `Tuple7`.
library;

import 'package:test/test.dart';
import 'package:stl/stl.dart';

/// Main entry point for `Tuple` unit testing.
void main() {
  group('Tuple', () {
    test('Tuple3 creation and equality', () {
      final t1 = Tuple3(1, 'Hello', 3.14);
      final t2 = makeTuple3(1, 'Hello', 3.14);
      final t3 = Tuple3.fromRecord((1, 'Hello', 3.14));

      expect(t1.item1, 1);
      expect(t1.item2, 'Hello');
      expect(t1.item3, 3.14);

      expect(t1 == t2, isTrue);
      expect(t1 == t3, isTrue);
      expect(t1.hashCode, equals(t2.hashCode));

      final clone = t1.clone();
      expect(clone == t1, isTrue);
      expect(identical(clone, t1), isFalse);
    });

    test('Tuple3 record destructuring', () {
      final t1 = Tuple3(1, 'A', true);
      final (a, b, c) = t1.record;
      expect(a, 1);
      expect(b, 'A');
      expect(c, isTrue);
    });

    test('Tuple4 functionality', () {
      final t1 = makeTuple4(1, 2, 3, 4);
      expect(t1.toList(), equals([1, 2, 3, 4]));
      expect(t1.toString(), '(1, 2, 3, 4)');

      final clone = t1.clone();
      expect(clone, equals(t1));
      
      final record = t1.record;
      expect(record.$1, 1);
      expect(record.$4, 4);
    });

    test('Tuple5 functionality', () {
      final t1 = makeTuple5('A', 'B', 'C', 'D', 'E');
      expect(t1.item5, 'E');
      expect(t1.toList(), equals(['A', 'B', 'C', 'D', 'E']));
      expect(Tuple5.fromRecord(('A', 'B', 'C', 'D', 'E')), equals(t1));
    });

    test('Tuple6 functionality', () {
      final t1 = makeTuple6(1, 2, 3, 4, 5, 6);
      expect(t1.item6, 6);
      expect(t1.toList().length, 6);
      expect(t1.clone() == t1, isTrue);
    });

    test('Tuple7 functionality', () {
      final t1 = makeTuple7(10, 20, 30, 40, 50, 60, 70);
      expect(t1.item7, 70);
      expect(t1.item1, 10);
      expect(t1.toList(), equals([10, 20, 30, 40, 50, 60, 70]));
      
      final clone = t1.clone();
      expect(clone == t1, isTrue);
      expect(clone.hashCode, equals(t1.hashCode));
    });
  });
}
