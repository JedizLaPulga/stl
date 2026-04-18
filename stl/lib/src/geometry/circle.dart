library;

import 'dart:math' as math;
import 'point.dart';
import 'shape.dart';

/// Defines a mathematical circle strictly via a radius.
class Circle implements Shape {
  final double radius;
  final Point<num>? center;

  Circle({required this.radius, this.center = const Point(x: 0, y: 0)}) {
    if (radius < 0) {
      throw ArgumentError('Radius cannot be negative');
    }
  }

  @override
  double get area => math.pi * radius * radius;

  @override
  double get perimeter => 2 * math.pi * radius; // Circumference

  @override
  String toString() => 'Circle(radius: $radius, center: $center)';
}
