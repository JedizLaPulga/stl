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
  });
}
