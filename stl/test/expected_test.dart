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
  });
}
