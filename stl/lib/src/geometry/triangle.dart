library;

import 'dart:math' as math;
import 'shape.dart';

/// Defines a mathematical triangle strictly via 3 sides.
class Triangle implements Shape {
  final double sideA;
  final double sideB;
  final double sideC;

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
