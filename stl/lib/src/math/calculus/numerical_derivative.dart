library;

/// Computes the numerical derivative of a function [f] at point [x].
/// 
/// Uses the central difference method for better accuracy:
/// `f'(x) ≈ (f(x + h) - f(x - h)) / (2h)`
/// 
/// The step size [h] defaults to `1e-5`.
double numericalDerivative(double Function(double) f, double x, {double h = 1e-5}) {
  return (f(x + h) - f(x - h)) / (2 * h);
}
