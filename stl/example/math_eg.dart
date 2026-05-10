import 'package:stl/stl.dart';

void main() {
  print('=======================================');
  print('         STL MATH SHOWCASE V0.6.6      ');
  print('=======================================\n');

  // ---------------------------------------------------------------------------
  // 1. Constants
  // ---------------------------------------------------------------------------
  print('--- Mathematical Constants ---');
  print('Pi (π): $pi');
  print('Euler\'s number (e): $e');
  print('Golden Ratio (φ): $phi');
  print('Omega constant (Ω): $omega');
  print('Glaisher-Kinkelin constant: $glaisherKinkelin');
  print('');

  // ---------------------------------------------------------------------------
  // 2. Symbolic Math (Variables and Expressions)
  // ---------------------------------------------------------------------------
  print('--- Symbolic Math (AST) ---');
  // Create a symbolic variable 'x'
  var x = Variable('x');
  
  // Build an expression dynamically: 3x^2 + 5x - 7
  var expr = (x.pow(2) * 3) + (x * 5) - 7;
  print('Expression: $expr');
  
  // Evaluate the expression with x = 2
  // Expect: 3(4) + 5(2) - 7 = 12 + 10 - 7 = 15
  double evaluated = expr.evaluate({'x': 2.0});
  print('Evaluated at x=2: $evaluated');
  
  // Simplify expressions (e.g. x * 1 + 0 => x)
  var messyExpr = (x * 1) + 0 - (x * 0);
  print('Messy: $messyExpr  -->  Simplified: ${simplify(messyExpr)}');
  print('');

  // ---------------------------------------------------------------------------
  // 3. Calculus
  // ---------------------------------------------------------------------------
  print('--- Calculus ---');
  // Symbolic Derivative
  // d/dx [3x^2 + 5x - 7] = 6x + 5
  var dExpr = derivative(expr, x);
  print('Symbolic Derivative of $expr');
  print('d/dx: $dExpr');
  print('Evaluated derivative at x=2: ${dExpr.evaluate({'x': 2.0})}'); // 6(2) + 5 = 17

  // Numerical Derivative
  // Function: f(x) = x^3
  double f(double val) => val * val * val;
  double numDeriv = numericalDerivative(f, 2.0); // f'(2) = 3(2^2) = 12
  print('\nNumerical Derivative of f(x)=x^3 at x=2: $numDeriv');

  // Numerical Integration
  // Integral of x^3 from 0 to 4 => (x^4)/4 = 256/4 = 64
  double integral = integrate(f, 0, 4);
  print('Numerical Integration of f(x)=x^3 from 0 to 4: $integral');
  print('');

  // ---------------------------------------------------------------------------
  // 4. Algebra (Polynomials & Rational)
  // ---------------------------------------------------------------------------
  print('--- Algebra ---');
  // Polynomial: x^2 - 4
  var poly = Polynomial([-4, 0, 1]); 
  print('Polynomial: $poly');
  
  // Find real roots analytically
  var roots = poly.findRealRoots();
  print('Roots of $poly: $roots'); // Should be [-2.0, 2.0]

  // Add and subtract polynomials
  var poly2 = Polynomial([1, 2]); // 2x + 1
  print('Polynomial 2: $poly2');
  print('Sum: ${poly + poly2}');
  print('Derivative of Sum: ${(poly + poly2).derivative()}');

  // Rational (Exact fractions)
  var r1 = Rational(1, 3);
  var r2 = Rational(1, 6);
  var rSum = r1 + r2; // 1/3 + 1/6 = 3/18 = 1/2
  print('\nRational Math: $r1 + $r2 = $rSum');
  print('');

  // ---------------------------------------------------------------------------
  // 5. Existing Math Capabilities
  // ---------------------------------------------------------------------------
  print('--- Complex Numbers & Number Theory ---');
  var c1 = Complex(1, 2);
  var c2 = Complex(3, 4);
  print('Complex Math: $c1 * $c2 = ${c1 * c2}');
  
  print('GCD of 48 and 18: ${gcd(48, 18)}');
  print('Is 17 prime?: ${isPrime(17)}');
  
  print('\n=======================================');
  print('         END OF SHOWCASE               ');
  print('=======================================');
}
