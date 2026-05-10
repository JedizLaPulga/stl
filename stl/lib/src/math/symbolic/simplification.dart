library;

import 'expression.dart';

/// Simplifies an expression to its most compact form.
/// 
/// This applies algebraic simplifications like `x + 0 -> x`, `x * 1 -> x`, 
/// and evaluates constant sub-trees.
Expression simplify(Expression expr) {
  return expr.simplify();
}
