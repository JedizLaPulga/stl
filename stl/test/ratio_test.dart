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

    test('Zero denominator throws ArgumentError at runtime', () {
      expect(() => Ratio(1, 0), throwsArgumentError);
      expect(() => Ratio(0, 0), throwsArgumentError);
    });

    test('compareTo and relational operators', () {
      final half = Ratio(1, 2);
      final third = Ratio(1, 3);
      final twoFourths = Ratio(2, 4); // equal to 1/2

      expect(half.compareTo(twoFourths), equals(0));
      expect(third.compareTo(half), isNegative);
      expect(half.compareTo(third), isPositive);

      expect(third < half, isTrue);
      expect(third <= half, isTrue);
      expect(half > third, isTrue);
      expect(half >= twoFourths, isTrue);
      expect(half <= twoFourths, isTrue);
      expect(half < third, isFalse);
    });

    test('negate returns negated simplified Ratio', () {
      expect(Ratio(3, 4).negate(), equals(Ratio(-3, 4)));
      expect(Ratio(-1, 2).negate(), equals(Ratio(1, 2)));
      expect(Ratio(0, 5).negate(), equals(Ratio(0, 1)));
    });

    test('reciprocal returns flipped simplified Ratio', () {
      expect(Ratio(2, 3).reciprocal(), equals(Ratio(3, 2)));
      expect(Ratio(1, 4).reciprocal(), equals(Ratio(4, 1)));
      expect(() => Ratio(0, 1).reciprocal(), throwsArgumentError);
    });

    test('abs returns absolute value', () {
      expect(Ratio(-3, 4).abs(), equals(Ratio(3, 4)));
      expect(Ratio(3, 4).abs(), equals(Ratio(3, 4)));
      expect(Ratio(0, 5).abs(), equals(Ratio(0, 1)));
    });
  });
}
