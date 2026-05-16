library;

import 'expression.dart';

/// A symbolic mathematical variable.
class Variable extends Expression {
  /// The symbolic name of this variable (e.g., `'x'`, `'y'`).
  final String name;

  /// Creates a [Variable] with the given [name].
  const Variable(this.name);

  @override
  double evaluate(Map<String, double> context) {
    if (!context.containsKey(name)) {
      throw StateError(
        'Variable $name is not provided in the evaluation context.',
      );
    }
    return context[name]!;
  }

  @override
  Expression derivative(String variableName) {
    return name == variableName ? const ConstantExpr(1) : const ConstantExpr(0);
  }

  @override
  Expression simplify() => this;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is Variable && other.name == name;

  @override
  int get hashCode => name.hashCode;

  /// Convenience syntax to raise this variable to a power.
  Expression pow(dynamic exponent) {
    var expExpr = (exponent is Expression)
        ? exponent
        : ConstantExpr(exponent.toDouble());
    return Pow(this, expExpr).simplify();
  }
}
