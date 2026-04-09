import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Var<T>', () {
    test('initializes and holds value correctly', () {
      final counter = Var(10);
      expect(counter.value, equals(10));
      // Call as function
      expect(counter(), equals(10));
    });

    test('can mutate value', () {
      final flag = Var(false);
      flag.value = true;
      expect(flag(), isTrue);
    });

    test('update helper modifies value securely', () {
      final score = Var(50);
      score.update((current) => current + 25);
      expect(score(), equals(75));
    });

    test('equality and hashcode verification', () {
      final v1 = Var('hello');
      final v2 = Var('hello');
      final v3 = Var('world');

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1, isNot(equals(v3)));
    });

    test('toString formats correctly', () {
      final decimal = Var(3.14);
      expect(decimal.toString(), equals('3.14'));
    });
  });
}
