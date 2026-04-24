import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('Functional Module Tests', () {
    test('invoke', () {
      int add(int a, int b) => a + b;
      expect(invoke(add, positional: [2, 3]), equals(5));

      int multiply({required int x, required int y}) => x * y;
      expect(invoke(multiply, named: {#x: 4, #y: 5}), equals(20));
    });

    group('Arithmetic Functors', () {
      test('Plus', () {
        const plus = Plus<int>();
        expect(plus(5, 3), equals(8));
      });

      test('Minus', () {
        const minus = Minus<double>();
        expect(minus(5.5, 3.0), equals(2.5));
      });

      test('Multiplies', () {
        const multiplies = Multiplies<int>();
        expect(multiplies(4, 3), equals(12));
      });

      test('Divides', () {
        const divides = Divides<double>();
        expect(divides(10.0, 2.0), equals(5.0));
      });

      test('Modulus', () {
        const modulus = Modulus<int>();
        expect(modulus(10, 3), equals(1));
      });

      test('Negate', () {
        const negate = Negate<int>();
        expect(negate(5), equals(-5));
        expect(negate(-10), equals(10));
      });
    });

    group('Comparison Functors', () {
      test('EqualTo', () {
        const equalTo = EqualTo<int>();
        expect(equalTo(5, 5), isTrue);
        expect(equalTo(5, 4), isFalse);
      });

      test('NotEqualTo', () {
        const notEqualTo = NotEqualTo<String>();
        expect(notEqualTo('a', 'b'), isTrue);
        expect(notEqualTo('a', 'a'), isFalse);
      });

      test('Greater', () {
        const greater = Greater<int>();
        expect(greater(5, 4), isTrue);
        expect(greater(5, 5), isFalse);
        expect(greater(4, 5), isFalse);
      });

      test('Less', () {
        const less = Less<int>();
        expect(less(4, 5), isTrue);
        expect(less(5, 5), isFalse);
        expect(less(6, 5), isFalse);
      });

      test('GreaterEqual', () {
        const greaterEqual = GreaterEqual<int>();
        expect(greaterEqual(5, 4), isTrue);
        expect(greaterEqual(5, 5), isTrue);
        expect(greaterEqual(4, 5), isFalse);
      });

      test('LessEqual', () {
        const lessEqual = LessEqual<int>();
        expect(lessEqual(4, 5), isTrue);
        expect(lessEqual(5, 5), isTrue);
        expect(lessEqual(6, 5), isFalse);
      });
    });

    group('Logical Functors', () {
      test('LogicalAnd', () {
        const logicalAnd = LogicalAnd<bool>();
        expect(logicalAnd(true, true), isTrue);
        expect(logicalAnd(true, false), isFalse);
        expect(logicalAnd(false, true), isFalse);
        expect(logicalAnd(false, false), isFalse);
      });

      test('LogicalOr', () {
        const logicalOr = LogicalOr<bool>();
        expect(logicalOr(true, true), isTrue);
        expect(logicalOr(true, false), isTrue);
        expect(logicalOr(false, true), isTrue);
        expect(logicalOr(false, false), isFalse);
      });

      test('LogicalNot', () {
        const logicalNot = LogicalNot<bool>();
        expect(logicalNot(true), isFalse);
        expect(logicalNot(false), isTrue);
      });
    });

    group('Bitwise Functors', () {
      test('BitAnd', () {
        const bitAnd = BitAnd<int>();
        expect(bitAnd(5, 3), equals(1)); // 101 & 011 = 001
      });

      test('BitOr', () {
        const bitOr = BitOr<int>();
        expect(bitOr(5, 3), equals(7)); // 101 | 011 = 111
      });

      test('BitXor', () {
        const bitXor = BitXor<int>();
        expect(bitXor(5, 3), equals(6)); // 101 ^ 011 = 110
      });

      test('BitNot', () {
        const bitNot = BitNot<int>();
        expect(bitNot(5), equals(-6)); // ~5 = -6
      });
    });
  });
}
