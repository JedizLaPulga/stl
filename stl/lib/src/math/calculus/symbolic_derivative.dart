library;

import '../symbolic/expression.dart';
import '../symbolic/variable.dart';

/// Computes the symbolic derivative of an [Expression] with respect to a [Variable].
/// 
/// Returns a new simplified [Expression] representing the mathematical derivative.
Expression derivative(Expression expr, Variable respectTo) {
  return expr.derivative(respectTo.name).simplify();
}
