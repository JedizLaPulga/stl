import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Box<T>', () {
    test('constructs and evaluates functionally', () {
      final bx = Box<String>('Alpha');
      expect(bx.value, equals('Alpha'));
      expect(bx(), equals('Alpha'));
    });

    test('operates purely with primitive types mathematically', () {
      final x = Box<int>(10);
      final y = Box<int>(5);

      expect(x + y, equals(15));
      expect(x - 5, equals(5));
      expect(x * y, equals(50));
      expect(x / 2, equals(5.0));
      expect(x ~/ y, equals(2));
      expect(x % 3, equals(1));
    });

    test('validates equality tightly against primitives and other boxes', () {
      final b1 = Box<int>(100);
      final b2 = Box<int>(100);

      expect(b1 == b2, isTrue); // true internally checks box against box
      // ignore: unrelated_type_equality_checks
      expect(b1 == 100, isTrue); // matches inner value intelligently
      // ignore: unrelated_type_equality_checks
      expect(b1 == 99, isFalse);
    });

    test('comparison operators overloads correctly', () {
      final small = Box<int>(5);
      final large = Box<int>(100);

      expect(small < large, isTrue);
      expect(large > 50, isTrue);
      expect(small <= 5, isTrue);
      expect(large >= 100, isTrue);
    });
  });
}
