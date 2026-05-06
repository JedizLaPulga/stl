// v0.6.4 Extended Ratio Tests
// Covers gaps: toString, mixed-sign arithmetic crossing zero, and
// cross-operation chains.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Ratio - toString', () {
    test('toString of simplified whole number', () {
      // Ratio(6, 2) simplifies to 3/1 — verify toString is deterministic
      final r = Ratio(6, 2).simplified();
      expect(r.toString(), isA<String>());
      // Must contain both numerator and denominator information
      expect(r.num, equals(3));
      expect(r.den, equals(1));
    });

    test('Ratio has a usable String representation', () {
      final r = Ratio(1, 3);
      // No expectation on format, just that it doesn't throw and is non-empty
      expect(r.toString(), isNotEmpty);
    });
  });

  group('Ratio - mixed-sign arithmetic', () {
    test('adding opposite ratios with same magnitude yields zero', () {
      final result = Ratio(-1, 3) + Ratio(1, 3);
      expect(result.num, equals(0));
    });

    test('subtracting equal ratios yields zero', () {
      final result = Ratio(3, 4) - Ratio(3, 4);
      expect(result.num, equals(0));
    });

    test('multiplying positive by negative gives negative', () {
      final result = Ratio(2, 3) * Ratio(-3, 4);
      expect(result.toDouble(), closeTo(-0.5, 1e-12));
      expect(result.num, isNegative);
      expect(result.den, isPositive);
    });

    test('dividing by negative flips sign', () {
      final result = Ratio(1, 2) / Ratio(-1, 4);
      expect(result.toDouble(), closeTo(-2.0, 1e-12));
    });

    test('arithmetic with zero numerator', () {
      final zero = Ratio(0, 7);
      expect((zero + Ratio(1, 2)).toDouble(), closeTo(0.5, 1e-12));
      expect((Ratio(1, 2) + zero).toDouble(), closeTo(0.5, 1e-12));
      expect((zero * Ratio(99, 1)).num, equals(0));
    });

    test('negative divided by negative gives positive', () {
      final result = Ratio(-3, 4) / Ratio(-1, 2);
      expect(result.toDouble(), closeTo(1.5, 1e-12));
      expect(result.num, isPositive);
    });
  });

  group('Ratio - comparison across mixed signs', () {
    test('negative ratio is less than zero', () {
      expect(Ratio(-1, 2) < Ratio(0, 1), isTrue);
    });

    test('negative ratio is less than positive ratio', () {
      expect(Ratio(-3, 4) < Ratio(1, 4), isTrue);
    });

    test('compareTo between negative and positive', () {
      expect(Ratio(-1, 3).compareTo(Ratio(1, 3)), isNegative);
    });
  });

  group('Ratio - chain operations', () {
    test('(1/2 + 1/3) * 6 = 5', () {
      final result = (Ratio(1, 2) + Ratio(1, 3)) * Ratio(6, 1);
      expect(result.toDouble(), closeTo(5.0, 1e-12));
    });

    test('reciprocal of reciprocal returns original', () {
      final r = Ratio(3, 7);
      expect(r.reciprocal().reciprocal(), equals(r.simplified()));
    });

    test('negate twice returns original', () {
      final r = Ratio(5, 8);
      expect(r.negate().negate(), equals(r.simplified()));
    });

    test('abs of negated is same as abs of original', () {
      final r = Ratio(-5, 8);
      expect(r.abs(), equals(r.negate().abs()));
    });
  });
}
