library;

import 'point.dart';
import 'shape.dart';

/// Defines a standard rectangle strictly via dimensions.
class Rectangle implements Shape {
  final double width;
  final double height;
  final Point<num>? center;

  Rectangle({required this.width, required this.height, this.center = const Point(x: 0, y: 0)}) {
    if (width < 0 || height < 0) {
      throw ArgumentError('Dimensions cannot be negative');
    }
  }

  @override
  double get area => width * height;

  @override
  double get perimeter => 2 * (width + height);

  @override
  String toString() => 'Rectangle(width: $width, height: $height, center: $center)';
}
