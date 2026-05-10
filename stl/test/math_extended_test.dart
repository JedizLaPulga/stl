import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Symbolic Math', () {
    test('Variable evaluation', () {
      var x = Variable('x');
      expect(x.evaluate({'x': 5}), 5.0);
      expect(() => x.evaluate({'y': 2}), throwsStateError);
    });

    test('Addition & Multiplication', () {
      var x = Variable('x');
      var expr = x * 2 + 3; // (x * 2) + 3
      expect(expr.evaluate({'x': 10}), 23.0);
    });

    test('Symbolic Derivative', () {
      var x = Variable('x');
      var expr = x.pow(2) + x * 3 + 5; // x^2 + 3x + 5
      var dx = derivative(expr, x); // 2x + 3
      expect(dx.evaluate({'x': 10}), 23.0); // 2(10) + 3 = 23
    });

    test('Simplification', () {
      var x = Variable('x');
      var expr = x * 1 + 0;
      var simple = simplify(expr);
      expect(simple.toString(), 'x');
    });
  });

  group('Algebra - Polynomial', () {
    test('Evaluation', () {
      var p = Polynomial([1, 2, 3]); // 3x^2 + 2x + 1
      expect(p.evaluate(2), 3*4 + 2*2 + 1); // 12 + 4 + 1 = 17
    });

    test('Derivative', () {
      var p = Polynomial([1, 2, 3]); // 3x^2 + 2x + 1
      var dp = p.derivative(); // 6x + 2
      expect(dp.evaluate(2), 6*2 + 2); // 14
    });

    test('Root Finding', () {
      var p = Polynomial([-4, 0, 1]); // x^2 - 4 = 0 -> x = -2, 2
      var roots = p.findRealRoots();
      expect(roots, unorderedEquals([-2.0, 2.0]));
    });
  });

  group('Calculus - Numerical', () {
    test('Numerical Derivative', () {
      double f(double x) => x * x; // f(x) = x^2
      double dx = numericalDerivative(f, 2.0); // f'(2) = 4
      expect(dx, closeTo(4.0, 1e-4));
    });

    test('Numerical Integration', () {
      double f(double x) => x * x; // f(x) = x^2
      double integral = integrate(f, 0, 3); // int_0^3 x^2 = x^3/3 = 27/3 = 9
      expect(integral, closeTo(9.0, 1e-4));
    });
  });

  group('Algebra - Equation', () {
    test('Equation representation', () {
      var eq = Equation(Variable('x') * 2, ConstantExpr(4));
      var expr = eq.toExpression(); // 2x - 4
      expect(expr.evaluate({'x': 2}), 0.0);
    });
  });
}
