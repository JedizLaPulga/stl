library;

import 'dart:math' as math;
import 'shape.dart';

/// Defines a mathematical triangle strictly via 3 sides.
class Triangle implements Shape {
  /// The first side of the triangle.
  final double sideA;
  /// The second side of the triangle.
  final double sideB;
  /// The third side of the triangle.
  final double sideC;

  /// Creates a [Triangle] by defining its three sides.
  Triangle({required this.sideA, required this.sideB, required this.sideC}) {
    if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
      throw ArgumentError('All sides must be positive real numbers.');
    }
    // Triangle Inequality Theorem check
    if (sideA + sideB <= sideC || sideA + sideC <= sideB || sideB + sideC <= sideA) {
      throw ArgumentError('Impossible triangle: Violates the Triangle Inequality Theorem.');
    }
  }

  @override
  double get area {
    // Heron's Formula
    final s = perimeter / 2.0;
    return math.sqrt(s * (s - sideA) * (s - sideB) * (s - sideC));
  }

  @override
  double get perimeter => sideA + sideB + sideC;

  @override
  String toString() => 'Triangle(sideA: $sideA, sideB: $sideB, sideC: $sideC)';
}
