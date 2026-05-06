// v0.6.4 Extended Functional Tests
// Covers edge cases: identity laws for arithmetic functors, Divides integer
// div-by-zero behaviour, Modulus edge cases, invoke with edge inputs,
// and Plus identity / Multiplies zero properties.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Functional - Plus identity law', () {
    test('Plus(0, x) == x for ints', () {
      const plus = Plus<int>();
      for (final x in [0, 1, -1, 100, -999]) {
        expect(plus(0, x), equals(x));
        expect(plus(x, 0), equals(x));
      }
    });

    test('Plus(0.0, x) == x for doubles', () {
      const plus = Plus<double>();
      expect(plus(0.0, 3.14), closeTo(3.14, 1e-12));
    });
  });

  group('Functional - Multiplies zero and one laws', () {
    test('Multiplies(1, x) == x', () {
      const mul = Multiplies<int>();
      for (final x in [0, 1, -7, 42]) {
        expect(mul(1, x), equals(x));
        expect(mul(x, 1), equals(x));
      }
    });

    test('Multiplies(0, x) == 0', () {
      const mul = Multiplies<int>();
      for (final x in [1, -1, 100]) {
        expect(mul(0, x), equals(0));
        expect(mul(x, 0), equals(0));
      }
    });
  });

  group('Functional - Minus identity and negation', () {
    test('Minus(x, 0) == x', () {
      const minus = Minus<int>();
      expect(minus(5, 0), equals(5));
      expect(minus(-3, 0), equals(-3));
    });

    test('Minus(x, x) == 0', () {
      const minus = Minus<int>();
      expect(minus(7, 7), equals(0));
      expect(minus(-4, -4), equals(0));
    });
  });

  group('Functional - Divides edge cases', () {
    test('Divides integer 1 returns quotient', () {
      const divides = Divides<int>();
      expect(divides(10, 2), equals(5));
      expect(divides(7, 1), equals(7));
      expect(divides(9, 2), equals(4)); // truncates toward zero
    });

    test('Divides double by very small number yields large result', () {
      const divides = Divides<double>();
      final result = divides(1.0, 0.001);
      expect(result, closeTo(1000.0, 1e-9));
    });

    test('Divides integer by zero throws', () {
      const divides = Divides<int>();
      // Dart integer division by zero is an UnsupportedError
      expect(() => divides(5, 0), throwsA(anything));
    });
  });

  group('Functional - Modulus edge cases', () {
    test('Modulus(x, 1) == 0 for any positive x', () {
      const modulus = Modulus<int>();
      for (final x in [1, 5, 100, 999]) {
        expect(modulus(x, 1), equals(0));
      }
    });

    test('Modulus(0, x) == 0', () {
      const modulus = Modulus<int>();
      for (final x in [1, 7, 13]) {
        expect(modulus(0, x), equals(0));
      }
    });
  });

  group('Functional - Negate consistency with Minus', () {
    test('Negate(x) == Minus(0, x)', () {
      const negate = Negate<int>();
      const minus = Minus<int>();
      for (final x in [-5, 0, 1, 100]) {
        expect(negate(x), equals(minus(0, x)));
      }
    });
  });

  group('Functional - Comparison functor consistency', () {
    test('EqualTo and NotEqualTo are complements', () {
      const eq = EqualTo<int>();
      const ne = NotEqualTo<int>();
      for (final pair in [(1, 1), (1, 2), (0, 0), (-1, 1)]) {
        expect(eq(pair.$1, pair.$2), equals(!ne(pair.$1, pair.$2)));
      }
    });

    test('Greater and LessEqual are complements', () {
      const gt = Greater<int>();
      const le = LessEqual<int>();
      for (final pair in [(5, 3), (3, 5), (4, 4)]) {
        expect(gt(pair.$1, pair.$2), equals(!le(pair.$1, pair.$2)));
      }
    });

    test('Less and GreaterEqual are complements', () {
      const lt = Less<int>();
      const ge = GreaterEqual<int>();
      for (final pair in [(2, 5), (5, 2), (3, 3)]) {
        expect(lt(pair.$1, pair.$2), equals(!ge(pair.$1, pair.$2)));
      }
    });
  });

  group('Functional - Bitwise consistency', () {
    test('BitAnd(x, ~x) == 0 (via BitNot)', () {
      const bitAnd = BitAnd<int>();
      const bitNot = BitNot<int>();
      for (final x in [0, 1, 5, 255, -1]) {
        expect(bitAnd(x, bitNot(x)), equals(0));
      }
    });

    test('BitOr(x, ~x) == -1 (all bits set in twos-complement)', () {
      const bitOr = BitOr<int>();
      const bitNot = BitNot<int>();
      for (final x in [0, 1, 5, 255]) {
        expect(bitOr(x, bitNot(x)), equals(-1));
      }
    });

    test('BitXor(x, x) == 0', () {
      const bitXor = BitXor<int>();
      for (final x in [0, 1, 7, 255]) {
        expect(bitXor(x, x), equals(0));
      }
    });

    test('BitXor(x, 0) == x', () {
      const bitXor = BitXor<int>();
      for (final x in [0, 3, -5, 100]) {
        expect(bitXor(x, 0), equals(x));
      }
    });
  });

  group('Functional - LogicalAnd / LogicalOr / LogicalNot consistency', () {
    test('LogicalAnd and LogicalOr De Morgan laws', () {
      const and = LogicalAnd<bool>();
      const or = LogicalOr<bool>();
      const not = LogicalNot<bool>();

      // not(a AND b) == not(a) OR not(b)
      for (final a in [true, false]) {
        for (final b in [true, false]) {
          expect(not(and(a, b)), equals(or(not(a), not(b))));
          expect(not(or(a, b)), equals(and(not(a), not(b))));
        }
      }
    });
  });

  group('Functional - invoke', () {
    test('invoke with only named args', () {
      String greet({required String name}) => 'Hello, $name!';
      expect(invoke(greet, named: {#name: 'Dart'}), equals('Hello, Dart!'));
    });

    test('invoke with mix of positional and named args', () {
      String format(String prefix, {required int value}) => '$prefix$value';
      expect(
        invoke(format, positional: ['n='], named: {#value: 42}),
        equals('n=42'),
      );
    });

    test('invoke result is correct type', () {
      int square(int x) => x * x;
      final result = invoke(square, positional: [7]);
      expect(result, isA<int>());
      expect(result, equals(49));
    });
  });
}
