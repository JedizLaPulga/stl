library;

import '../symbolic/expression.dart';

/// Represents a mathematical equation $left = right$.
class Equation {
  /// The left-hand side of the equation.
  final Expression left;

  /// The right-hand side of the equation.
  final Expression right;

  /// Creates an [Equation] asserting [left] = [right].
  const Equation(this.left, this.right);

  /// Converts the equation into a single expression $left - right = 0$.
  Expression toExpression() => Sub(left, right).simplify();

  @override
  String toString() => '$left = $right';
}
