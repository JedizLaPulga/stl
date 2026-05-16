library;

import 'dart:math' as math;

/// Base class for all symbolic math expressions.
abstract class Expression {
  /// Creates a base [Expression] node.
  const Expression();

  /// Evaluates the expression using the provided [context] for variable values.
  double evaluate(Map<String, double> context);

  /// Computes the symbolic derivative with respect to [variableName].
  Expression derivative(String variableName);

  /// Simplifies the expression tree.
  Expression simplify();

  /// Adds this expression to another.
  Expression operator +(dynamic other) => Add(this, _toExpression(other));

  /// Subtracts another expression from this.
  Expression operator -(dynamic other) => Sub(this, _toExpression(other));

  /// Multiplies this expression by another.
  Expression operator *(dynamic other) => Mul(this, _toExpression(other));

  /// Divides this expression by another.
  Expression operator /(dynamic other) => Div(this, _toExpression(other));

  /// Negates this expression.
  Expression operator -() => Neg(this);

  /// Helper to wrap raw numbers in [ConstantExpr].
  static Expression _toExpression(dynamic val) {
    if (val is Expression) return val;
    if (val is num) return ConstantExpr(val.toDouble());
    throw ArgumentError(
      'Expected an Expression or num, got ${val.runtimeType}',
    );
  }
}

/// A constant numerical expression.
class ConstantExpr extends Expression {
  /// The constant numeric value.
  final double value;

  /// Creates a [ConstantExpr] wrapping [value].
  const ConstantExpr(this.value);

  @override
  double evaluate(Map<String, double> context) => value;

  @override
  Expression derivative(String variableName) => const ConstantExpr(0);

  @override
  Expression simplify() => this;

  @override
  String toString() {
    if (value == value.toInt().toDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is ConstantExpr && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Addition of two expressions.
class Add extends Expression {
  /// The left operand.
  final Expression left;

  /// The right operand.
  final Expression right;

  /// Creates an [Add] node for `left + right`.
  const Add(this.left, this.right);

  @override
  double evaluate(Map<String, double> context) =>
      left.evaluate(context) + right.evaluate(context);

  @override
  Expression derivative(String variableName) => Add(
    left.derivative(variableName),
    right.derivative(variableName),
  ).simplify();

  @override
  Expression simplify() {
    var l = left.simplify();
    var r = right.simplify();
    if (l is ConstantExpr && r is ConstantExpr) {
      return ConstantExpr(l.value + r.value);
    }
    if (l is ConstantExpr && l.value == 0) return r;
    if (r is ConstantExpr && r.value == 0) return l;
    return Add(l, r);
  }

  @override
  String toString() => '($left + $right)';
}

/// Subtraction of two expressions.
class Sub extends Expression {
  /// The left (minuend) operand.
  final Expression left;

  /// The right (subtrahend) operand.
  final Expression right;

  /// Creates a [Sub] node for `left - right`.
  const Sub(this.left, this.right);

  @override
  double evaluate(Map<String, double> context) =>
      left.evaluate(context) - right.evaluate(context);

  @override
  Expression derivative(String variableName) => Sub(
    left.derivative(variableName),
    right.derivative(variableName),
  ).simplify();

  @override
  Expression simplify() {
    var l = left.simplify();
    var r = right.simplify();
    if (l is ConstantExpr && r is ConstantExpr) {
      return ConstantExpr(l.value - r.value);
    }
    if (r is ConstantExpr && r.value == 0) return l;
    if (l is ConstantExpr && l.value == 0) return Neg(r).simplify();
    return Sub(l, r);
  }

  @override
  String toString() => '($left - $right)';
}

/// Multiplication of two expressions.
class Mul extends Expression {
  /// The left factor.
  final Expression left;

  /// The right factor.
  final Expression right;

  /// Creates a [Mul] node for `left * right`.
  const Mul(this.left, this.right);

  @override
  double evaluate(Map<String, double> context) =>
      left.evaluate(context) * right.evaluate(context);

  @override
  Expression derivative(String variableName) => Add(
    Mul(left.derivative(variableName), right),
    Mul(left, right.derivative(variableName)),
  ).simplify();

  @override
  Expression simplify() {
    var l = left.simplify();
    var r = right.simplify();
    if (l is ConstantExpr && r is ConstantExpr) {
      return ConstantExpr(l.value * r.value);
    }
    if (l is ConstantExpr && l.value == 0) return const ConstantExpr(0);
    if (r is ConstantExpr && r.value == 0) return const ConstantExpr(0);
    if (l is ConstantExpr && l.value == 1) return r;
    if (r is ConstantExpr && r.value == 1) return l;
    return Mul(l, r);
  }

  @override
  String toString() => '($left * $right)';
}

/// Division of two expressions.
class Div extends Expression {
  /// The numerator (dividend).
  final Expression left;

  /// The denominator (divisor).
  final Expression right;

  /// Creates a [Div] node for `left / right`.
  const Div(this.left, this.right);

  @override
  double evaluate(Map<String, double> context) =>
      left.evaluate(context) / right.evaluate(context);

  @override
  Expression derivative(String variableName) => Div(
    Sub(
      Mul(left.derivative(variableName), right),
      Mul(left, right.derivative(variableName)),
    ),
    Mul(right, right),
  ).simplify();

  @override
  Expression simplify() {
    var l = left.simplify();
    var r = right.simplify();
    if (l is ConstantExpr && r is ConstantExpr && r.value != 0) {
      return ConstantExpr(l.value / r.value);
    }
    if (l is ConstantExpr && l.value == 0) return const ConstantExpr(0);
    if (r is ConstantExpr && r.value == 1) return l;
    return Div(l, r);
  }

  @override
  String toString() => '($left / $right)';
}

/// Negation of an expression.
class Neg extends Expression {
  /// The expression to negate.
  final Expression expr;

  /// Creates a [Neg] node representing `−expr`.
  const Neg(this.expr);

  @override
  double evaluate(Map<String, double> context) => -expr.evaluate(context);

  @override
  Expression derivative(String variableName) =>
      Neg(expr.derivative(variableName)).simplify();

  @override
  Expression simplify() {
    var e = expr.simplify();
    if (e is ConstantExpr) return ConstantExpr(-e.value);
    if (e is Neg) return e.expr;
    return Neg(e);
  }

  @override
  String toString() => '-$expr';
}

/// Power expression.
class Pow extends Expression {
  /// The base of the power expression.
  final Expression baseExpr;

  /// The exponent of the power expression.
  final Expression exponentExpr;

  /// Creates a [Pow] node for `baseExpr ^ exponentExpr`.
  const Pow(this.baseExpr, this.exponentExpr);

  @override
  double evaluate(Map<String, double> context) => math
      .pow(baseExpr.evaluate(context), exponentExpr.evaluate(context))
      .toDouble();

  @override
  Expression derivative(String variableName) {
    // d/dx (f^g) = f^g * (g' * ln(f) + g * f' / f)
    return Mul(
      this,
      Add(
        Mul(exponentExpr.derivative(variableName), Log(baseExpr)),
        Div(Mul(exponentExpr, baseExpr.derivative(variableName)), baseExpr),
      ),
    ).simplify();
  }

  @override
  Expression simplify() {
    var b = baseExpr.simplify();
    var e = exponentExpr.simplify();
    if (b is ConstantExpr && e is ConstantExpr) {
      return ConstantExpr(math.pow(b.value, e.value).toDouble());
    }
    if (e is ConstantExpr && e.value == 0) return const ConstantExpr(1);
    if (e is ConstantExpr && e.value == 1) return b;
    if (b is ConstantExpr && b.value == 0) return const ConstantExpr(0);
    if (b is ConstantExpr && b.value == 1) return const ConstantExpr(1);
    return Pow(b, e);
  }

  @override
  String toString() => '($baseExpr ^ $exponentExpr)';
}

/// Sine function expression.
class Sin extends Expression {
  /// The argument to the sine function.
  final Expression expr;

  /// Creates a [Sin] node representing `sin(expr)`.
  const Sin(this.expr);

  @override
  double evaluate(Map<String, double> context) =>
      math.sin(expr.evaluate(context));

  @override
  Expression derivative(String variableName) =>
      Mul(Cos(expr), expr.derivative(variableName)).simplify();

  @override
  Expression simplify() {
    var e = expr.simplify();
    if (e is ConstantExpr) return ConstantExpr(math.sin(e.value));
    return Sin(e);
  }

  @override
  String toString() => 'sin($expr)';
}

/// Cosine function expression.
class Cos extends Expression {
  /// The argument to the cosine function.
  final Expression expr;

  /// Creates a [Cos] node representing `cos(expr)`.
  const Cos(this.expr);

  @override
  double evaluate(Map<String, double> context) =>
      math.cos(expr.evaluate(context));

  @override
  Expression derivative(String variableName) =>
      Mul(Neg(Sin(expr)), expr.derivative(variableName)).simplify();

  @override
  Expression simplify() {
    var e = expr.simplify();
    if (e is ConstantExpr) return ConstantExpr(math.cos(e.value));
    return Cos(e);
  }

  @override
  String toString() => 'cos($expr)';
}

/// Natural logarithm expression.
class Log extends Expression {
  /// The argument to the natural logarithm.
  final Expression expr;

  /// Creates a [Log] node representing `ln(expr)`.
  const Log(this.expr);

  @override
  double evaluate(Map<String, double> context) =>
      math.log(expr.evaluate(context));

  @override
  Expression derivative(String variableName) =>
      Div(expr.derivative(variableName), expr).simplify();

  @override
  Expression simplify() {
    var e = expr.simplify();
    if (e is ConstantExpr) return ConstantExpr(math.log(e.value));
    return Log(e);
  }

  @override
  String toString() => 'ln($expr)';
}

/// Exponential function expression (e^x).
class Exp extends Expression {
  /// The exponent expression (i.e., x in e^x).
  final Expression expr;

  /// Creates an [Exp] node representing `e^expr`.
  const Exp(this.expr);

  @override
  double evaluate(Map<String, double> context) =>
      math.exp(expr.evaluate(context));

  @override
  Expression derivative(String variableName) =>
      Mul(this, expr.derivative(variableName)).simplify();

  @override
  Expression simplify() {
    var e = expr.simplify();
    if (e is ConstantExpr) return ConstantExpr(math.exp(e.value));
    if (e is ConstantExpr && e.value == 0) return const ConstantExpr(1);
    return Exp(e);
  }

  @override
  String toString() => 'exp($expr)';
}
