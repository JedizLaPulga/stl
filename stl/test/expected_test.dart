import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('Expected<T, E>', () {
    test('value constructor should hold value and not error', () {
      final expected = Expected<int, String>.value(42);
      expect(expected.hasValue, isTrue);
      expect(expected.value, equals(42));
      expect(() => expected.error, throwsStateError);
      expect(expected.valueOr(0), equals(42));
    });

    test('error constructor should hold error and not value', () {
      final expected = Expected<int, String>.error('Not Found');
      expect(expected.hasValue, isFalse);
      expect(expected.error, equals('Not Found'));
      expect(() => expected.value, throwsStateError);
      expect(expected.valueOr(0), equals(0));
    });

    test('map should transform value', () {
      final expected = Expected<int, String>.value(5);
      final mapped = expected.map((v) => v * 2);
      expect(mapped.hasValue, isTrue);
      expect(mapped.value, equals(10));
    });

    test('map should ignore error', () {
      final expected = Expected<int, String>.error('Error');
      final mapped = expected.map((v) => v * 2);
      expect(mapped.hasValue, isFalse);
      expect(mapped.error, equals('Error'));
    });

    test('mapError should transform error', () {
      final expected = Expected<int, String>.error('Error');
      final mapped = expected.mapError((e) => e.length);
      expect(mapped.hasValue, isFalse);
      expect(mapped.error, equals(5));
    });

    test('mapError should ignore value', () {
      final expected = Expected<int, String>.value(10);
      final mapped = expected.mapError((e) => e.length);
      expect(mapped.hasValue, isTrue);
      expect(mapped.value, equals(10));
    });

    test('equality and hashCode', () {
      final v1 = Expected<int, String>.value(42);
      final v2 = Expected<int, String>.value(42);
      final v3 = Expected<int, String>.value(43);
      final e1 = Expected<int, String>.error('err');
      final e2 = Expected<int, String>.error('err');

      expect(v1 == v2, isTrue);
      expect(v1.hashCode == v2.hashCode, isTrue);
      expect(v1 == v3, isFalse);

      expect(e1 == e2, isTrue);
      expect(e1.hashCode == e2.hashCode, isTrue);
      expect(e1 == v1, isFalse);
    });

    test('flatMap chains operations and short-circuits on error', () {
      Expected<int, String> doubleIt(int n) => Expected.value(n * 2);
      Expected<int, String> failAt10(int n) =>
          n == 10 ? Expected.error('too big') : Expected.value(n);

      // Happy path: chain succeeds end-to-end
      final result = Expected<int, String>.value(3)
          .flatMap(doubleIt) // 6
          .flatMap(doubleIt); // 12
      expect(result.hasValue, isTrue);
      expect(result.value, equals(12));

      // Short-circuit: doubling 5 → 10 then failAt10 errors out
      final errResult = Expected<int, String>.value(5)
          .flatMap(doubleIt) // 10
          .flatMap(failAt10); // 10 == 10 → error
      expect(errResult.hasValue, isFalse);
      expect(errResult.error, equals('too big'));

      // Starting from error: flatMap not called
      final startErr = Expected<int, String>.error('initial').flatMap(doubleIt);
      expect(startErr.hasValue, isFalse);
      expect(startErr.error, equals('initial'));
    });

    test('fold reduces to a single value via the matching branch', () {
      final value = Expected<int, String>.value(42);
      final error = Expected<int, String>.error('oops');

      expect(value.fold((v) => 'got $v', (e) => 'err: $e'), equals('got 42'));
      expect(
        error.fold((v) => 'got $v', (e) => 'err: $e'),
        equals('err: oops'),
      );
    });
  });
}
