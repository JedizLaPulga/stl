import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Ratio Tests', () {
    test('Initialization and simplification', () {
      final r1 = Ratio(2, 4);
      final simplified = r1.simplified();
      expect(simplified.num, equals(1));
      expect(simplified.den, equals(2));

      final r2 = Ratio(-2, -4);
      final sim2 = r2.simplified();
      expect(sim2.num, equals(1));
      expect(sim2.den, equals(2));

      final r3 = Ratio(2, -4);
      final sim3 = r3.simplified();
      expect(sim3.num, equals(-1));
      expect(sim3.den, equals(2));
    });

    test('Addition', () {
      final sum = Ratio(1, 3) + Ratio(1, 6);
      expect(sum, equals(Ratio(1, 2)));
    });

    test('Subtraction', () {
      final diff = Ratio(1, 2) - Ratio(1, 6);
      expect(diff, equals(Ratio(1, 3)));
    });

    test('Multiplication', () {
      final prod = Ratio(2, 3) * Ratio(3, 4);
      expect(prod, equals(Ratio(1, 2)));
    });

    test('Division', () {
      final quot = Ratio(1, 2) / Ratio(3, 4);
      expect(quot, equals(Ratio(2, 3)));
    });

    test('Equality and HashCode', () {
      expect(Ratio(1, 2), equals(Ratio(2, 4)));
      expect(Ratio(1, 2).hashCode, equals(Ratio(2, 4).hashCode));
      expect(Ratio(1, 3), isNot(equals(Ratio(1, 2))));
    });

    test('toDouble', () {
      expect(Ratio(1, 2).toDouble(), equals(0.5));
      expect(Ratio(3, 4).toDouble(), equals(0.75));
    });

    test('SI Constants', () {
      expect(Ratio.milli.num, equals(1));
      expect(Ratio.milli.den, equals(1000));
      expect(Ratio.kilo.num, equals(1000));
      expect(Ratio.kilo.den, equals(1));
      expect(Ratio.micro.num, equals(1));
      expect(Ratio.micro.den, equals(1000000));
    });
  });
}
