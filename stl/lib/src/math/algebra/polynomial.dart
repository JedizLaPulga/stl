library;

import 'dart:math' as math;

/// A Polynomial representation $a_n x^n + \dots + a_1 x + a_0$.
class Polynomial {
  /// Coefficients from lowest degree (index 0) to highest degree.
  /// Example: [1, 2, 3] represents $3x^2 + 2x + 1$.
  final List<double> coefficients;

  /// Creates a polynomial from a list of coefficients.
  /// Trailing zeros (highest degree terms with 0 coefficient) are stripped.
  Polynomial(List<double> coeffs) : coefficients = _stripTrailingZeros(coeffs);

  static List<double> _stripTrailingZeros(List<double> coeffs) {
    if (coeffs.isEmpty) return [0.0];
    int lastNonZero = coeffs.length - 1;
    while (lastNonZero > 0 && coeffs[lastNonZero] == 0) {
      lastNonZero--;
    }
    return List<double>.unmodifiable(coeffs.sublist(0, lastNonZero + 1));
  }

  /// The degree of the polynomial.
  int get degree => coefficients.length - 1;

  /// Evaluates the polynomial at a given value [x].
  double evaluate(double x) {
    if (coefficients.isEmpty) return 0.0;
    double result = coefficients.last;
    for (int i = coefficients.length - 2; i >= 0; i--) {
      result = result * x + coefficients[i];
    }
    return result;
  }

  /// Returns the analytical derivative of this polynomial.
  Polynomial derivative() {
    if (degree == 0) return Polynomial([0.0]);
    List<double> derivCoeffs = List<double>.filled(degree, 0.0);
    for (int i = 1; i <= degree; i++) {
      derivCoeffs[i - 1] = coefficients[i] * i;
    }
    return Polynomial(derivCoeffs);
  }

  /// Adds another polynomial to this one.
  Polynomial operator +(Polynomial other) {
    int maxLen = math.max(coefficients.length, other.coefficients.length);
    List<double> result = List<double>.filled(maxLen, 0.0);
    for (int i = 0; i < maxLen; i++) {
      double a = i < coefficients.length ? coefficients[i] : 0.0;
      double b = i < other.coefficients.length ? other.coefficients[i] : 0.0;
      result[i] = a + b;
    }
    return Polynomial(result);
  }

  /// Subtracts another polynomial from this one.
  Polynomial operator -(Polynomial other) {
    int maxLen = math.max(coefficients.length, other.coefficients.length);
    List<double> result = List<double>.filled(maxLen, 0.0);
    for (int i = 0; i < maxLen; i++) {
      double a = i < coefficients.length ? coefficients[i] : 0.0;
      double b = i < other.coefficients.length ? other.coefficients[i] : 0.0;
      result[i] = a - b;
    }
    return Polynomial(result);
  }

  /// Multiplies this polynomial by another.
  Polynomial operator *(Polynomial other) {
    if (coefficients.isEmpty || other.coefficients.isEmpty) return Polynomial([0.0]);
    List<double> result = List<double>.filled(coefficients.length + other.coefficients.length - 1, 0.0);
    for (int i = 0; i < coefficients.length; i++) {
      for (int j = 0; j < other.coefficients.length; j++) {
        result[i + j] += coefficients[i] * other.coefficients[j];
      }
    }
    return Polynomial(result);
  }

  /// Finds the real roots of polynomials up to degree 2 (quadratic).
  /// For higher degrees, returns an empty list (requires numerical methods).
  List<double> findRealRoots() {
    if (degree == 0) return [];
    if (degree == 1) {
      // ax + b = 0 -> x = -b/a
      return [-coefficients[0] / coefficients[1]];
    }
    if (degree == 2) {
      // ax^2 + bx + c = 0
      double c = coefficients[0];
      double b = coefficients[1];
      double a = coefficients[2];
      double discriminant = b * b - 4 * a * c;
      if (discriminant < 0) return []; // Complex roots
      if (discriminant == 0) return [-b / (2 * a)];
      double sqrtD = math.sqrt(discriminant);
      return [(-b - sqrtD) / (2 * a), (-b + sqrtD) / (2 * a)];
    }
    // Analytical solution for degree 3 is complex, degree >= 5 has no general analytical solution.
    throw UnimplementedError('Root finding for degree > 2 is not yet implemented.');
  }

  @override
  String toString() {
    if (degree == 0) return coefficients[0].toString();
    List<String> terms = [];
    for (int i = degree; i >= 0; i--) {
      if (coefficients[i] == 0) continue;
      String term = coefficients[i].toString();
      if (i > 0) term += 'x';
      if (i > 1) term += '^$i';
      terms.add(term);
    }
    return terms.join(' + ').replaceAll('+ -', '- ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Polynomial) return false;
    if (coefficients.length != other.coefficients.length) return false;
    for (int i = 0; i < coefficients.length; i++) {
      if (coefficients[i] != other.coefficients[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coefficients);
}
