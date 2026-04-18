library;

/// The foundational contract for all 2D entities.
abstract class Shape {
  /// The total surface area of the shape.
  double get area;

  /// The total length of the shape's boundary.
  double get perimeter;
}
