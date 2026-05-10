library;

import '../symbolic/expression.dart';

/// Represents a mathematical equation $left = right$.
class Equation {
  final Expression left;
  final Expression right;

  const Equation(this.left, this.right);

  /// Converts the equation into a single expression $left - right = 0$.
  Expression toExpression() => Sub(left, right).simplify();

  @override
  String toString() => '$left = $right';
}
