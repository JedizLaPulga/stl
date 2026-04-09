import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Variant2', () {
    test('should hold and retrieve T0 alternative correctly', () {
      final Variant2<int, String> variant = Variant2.withT0(42);

      expect(variant.holdsAlternative<int>(), isTrue);
      expect(variant.holdsAlternative<String>(), isFalse);
      expect(variant.index, equals(0));
      expect(variant.value, equals(42));

      final result = variant.visit(
        onT0: (int val) => 'Integer: $val',
        onT1: (String val) => 'String: $val',
      );
      expect(result, equals('Integer: 42'));
    });

    test('should hold and retrieve T1 alternative correctly', () {
      final Variant2<int, String> variant = Variant2.withT1('Hello');

      expect(variant.holdsAlternative<int>(), isFalse);
      expect(variant.holdsAlternative<String>(), isTrue);
      expect(variant.index, equals(1));
      expect(variant.value, equals('Hello'));

      final result = variant.visit(
        onT0: (int val) => 'Integer: $val',
        onT1: (String val) => 'String: $val',
      );
      expect(result, equals('String: Hello'));
    });

    test('equality and hashcode', () {
      final v1 = Variant2<int, String>.withT0(100);
      final v2 = Variant2<int, String>.withT0(100);
      final v3 = Variant2<int, String>.withT1('100');

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1, isNot(equals(v3)));
    });
  });

  group('Variant3', () {
    test('should hold and retrieve T2 alternative correctly', () {
      final Variant3<int, String, double> variant = Variant3.withT2(3.14);

      expect(variant.holdsAlternative<int>(), isFalse);
      expect(variant.holdsAlternative<String>(), isFalse);
      expect(variant.holdsAlternative<double>(), isTrue);
      expect(variant.index, equals(2));
      expect(variant.value, equals(3.14));

      final result = variant.visit(
        onT0: (int val) => 'Integer: $val',
        onT1: (String val) => 'String: $val',
        onT2: (double val) => 'Double: $val',
      );
      expect(result, equals('Double: 3.14'));
    });

    test('equality and hashcode', () {
      final v1 = Variant3<int, String, bool>.withT2(true);
      final v2 = Variant3<int, String, bool>.withT2(true);
      final v3 = Variant3<int, String, bool>.withT2(false);
      final v4 = Variant3<int, String, bool>.withT1('true');

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1, isNot(equals(v3)));
      expect(v1, isNot(equals(v4)));
    });
  });
}
