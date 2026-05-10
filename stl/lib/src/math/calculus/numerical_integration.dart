library;

/// Computes the definite integral of [f] from [a] to [b] using Simpson's 1/3 rule.
/// 
/// [intervals] specifies the number of sub-intervals. It will be forced to the 
/// nearest even integer greater than 0 if necessary. Higher intervals yield 
/// better accuracy but require more computation.
double integrate(double Function(double) f, double a, double b, {int intervals = 1000}) {
  if (intervals <= 0) intervals = 2;
  if (intervals % 2 != 0) intervals++; // Simpson's 1/3 rule requires an even number of intervals
  
  double h = (b - a) / intervals;
  double sum = f(a) + f(b);
  
  for (int i = 1; i < intervals; i++) {
    double x = a + i * h;
    sum += f(x) * (i % 2 == 0 ? 2 : 4);
  }
  
  return sum * h / 3.0;
}
