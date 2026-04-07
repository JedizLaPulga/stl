import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Pair', () {
    test('Initialization', () {
      final pair = Pair<int, String>(1, 'hello');
      expect(pair.first, equals(1));
      expect(pair.second, equals('hello'));
    });

    test('makePair', () {
      final pair = makePair(2.5, false);
      expect(pair.first, equals(2.5));
      expect(pair.second, isFalse);
    });

    test('Equality and HashCode', () {
      final p1 = makePair(1, 2);
      final p2 = makePair(1, 2);
      final p3 = makePair(1, 3);
      final p4 = makePair(2, 2);

      expect(p1 == p2, isTrue);
      expect(p1.hashCode == p2.hashCode, isTrue);

      expect(p1 == p3, isFalse);
      expect(p1 == p4, isFalse);
    });

    test('Swap', () {
      final p1 = makePair(1, 'a');
      final p2 = makePair(2, 'b');

      p1.swap(p2);

      expect(p1.first, equals(2));
      expect(p1.second, equals('b'));

      expect(p2.first, equals(1));
      expect(p2.second, equals('a'));
    });

    test('ToString', () {
      final pair = makePair(10, 20);
      expect(pair.toString(), equals('(10, 20)'));
    });

    test('Dart 3 Record Interoperability', () {
      final pair = makePair('Hello', 99);

      // record getter
      final rec = pair.record;
      expect(rec.$1, equals('Hello'));
      expect(rec.$2, equals(99));

      // fromRecord constructor
      final fromRec = Pair<String, int>.fromRecord(('World', 100));
      expect(fromRec.first, equals('World'));
      expect(fromRec.second, equals(100));
    });

    test('MapEntry Interoperability', () {
      final pair = makePair('Key', 'Value');

      final entry = pair.toMapEntry();
      expect(entry.key, equals('Key'));
      expect(entry.value, equals('Value'));

      final fromEntry = Pair<String, String>.fromMapEntry(MapEntry('A', 'B'));
      expect(fromEntry.first, equals('A'));
      expect(fromEntry.second, equals('B'));
    });

    test('Comparable Extension (Lexicographical Sorting)', () {
      final p1 = makePair(1, 2);
      final p2 = makePair(1, 4);
      final p3 = makePair(2, 0);

      expect(p1 < p2, isTrue); // 1 == 1, 2 < 4
      expect(p2 < p3, isTrue); // 1 < 2
      expect(p3 > p1, isTrue);
      expect(p1 <= makePair(1, 2), isTrue);
    });

    test('Utility Converters (toList, clone)', () {
      final pair = makePair(99, 'Balloons');

      final list = pair.toList();
      expect(list, equals([99, 'Balloons']));

      final cloned = pair.clone();
      expect(cloned == pair, isTrue);
      // Ensure it is a different instance
      expect(identical(cloned, pair), isFalse);
    });
  });
}
