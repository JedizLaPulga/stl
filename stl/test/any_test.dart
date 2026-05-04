import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Any Core Features', () {
    test('Initialization and hasValue', () {
      final a = Any(42);
      expect(a.hasValue, isTrue);
      expect(a.empty(), isFalse);

      final b = Any.empty();
      expect(b.hasValue, isFalse);
      expect(b.empty(), isTrue);
    });

    test('get() and cast()', () {
      final a = Any('Hello');
      expect(a.get(), 'Hello');
      expect(a.cast<String>(), 'Hello');
      expect(() => a.cast<int>(), throwsA(isA<TypeError>()));

      final emptyAny = Any.empty();
      expect(() => emptyAny.get(), throwsStateError);
      expect(() => emptyAny.cast<int>(), throwsStateError);
    });

    test('set() and reset()', () {
      final a = Any.empty();
      a.set(100);
      expect(a.get(), 100);
      expect(a.hasValue, isTrue);

      a.reset();
      expect(a.empty(), isTrue);
      expect(() => a.get(), throwsStateError);
    });

    test('Equality and HashCode', () {
      final a = Any(10);
      final b = Any(10);
      final c = Any(20);
      final empty1 = Any.empty();
      final empty2 = Any.empty();

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
      expect(a == c, isFalse);
      expect(empty1 == empty2, isTrue);
      expect(a == empty1, isFalse);
    });

    test('type() method', () {
      final a = Any(42);
      expect(a.type(), int);
    });
  });

  group('Any Dynamic Operators', () {
    test('Math Operations', () {
      final a = Any(10);
      final b = Any(5);

      expect(a + b, 15);
      expect(a + 5, 15);
      expect(a - b, 5);
      expect(a - 2, 8);
      expect(a * b, 50);
      expect(a * 2, 20);
      expect(a / b, 2.0);
      expect(a / 2, 5.0);
      expect(a % 3, 1);
    });

    test('Relational Operations', () {
      final a = Any(10);
      final b = Any(5);
      final c = Any(10);

      expect(a > b, isTrue);
      expect(a > 15, isFalse);
      expect(b < a, isTrue);
      expect(b < 2, isFalse);
      expect(a >= c, isTrue);
      expect(a <= c, isTrue);
      expect(b <= a, isTrue);
      expect(a >= b, isTrue);
    });

    test('Index Operations [ ] and [ ]=', () {
      final list = Any([1, 2, 3]);
      expect(list[0], 1);
      expect(list[1], 2);
      expect(list[2], 3);

      list[1] = 42;
      expect(list[1], 42);
      expect(list.cast<List<int>>(), [1, 42, 3]);

      final map = Any({'key': 'value'});
      expect(map['key'], 'value');

      map['key'] = 'new_value';
      expect(map['key'], 'new_value');
    });

    test('Operations with Empty throws StateError', () {
      final a = Any.empty();
      expect(() => a + 1, throwsStateError);
      expect(() => a - 1, throwsStateError);
      expect(() => a * 1, throwsStateError);
      expect(() => a / 1, throwsStateError);
      expect(() => a % 1, throwsStateError);
      expect(() => a < 1, throwsStateError);
      expect(() => a > 1, throwsStateError);
      expect(() => a <= 1, throwsStateError);
      expect(() => a >= 1, throwsStateError);
      expect(() => a[0], throwsStateError);
      expect(() => a[0] = 1, throwsStateError);
    });
  });
}
