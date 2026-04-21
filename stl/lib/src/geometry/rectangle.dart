library;

import 'point.dart';
import 'shape.dart';

/// Defines a standard rectangle strictly via dimensions.
class Rectangle implements Shape {
  /// The width of the rectangle.
  final double width;
  /// The height of the rectangle.
  final double height;
  /// The center point of the rectangle.
  final Point<num>? center;

  /// Creates a [Rectangle] with the specified [width], [height], and [center].
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
