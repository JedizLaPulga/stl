library;

import 'point.dart';
import 'rectangle.dart';

/// The foundational contract for all 2D entities.
/// 
/// Utilizing the Curiously Recurring Template Pattern (CRTP), `Shape` ensures 
/// that spatial transformations logically return the exact mathematical entity.
abstract interface class Shape<T extends Shape<T>> {
  /// The total surface area of the shape.
  double get area;

  /// The total length of the shape's boundary.
  double get perimeter;

  /// The smallest axis-aligned rectangle that completely encloses the shape.
  Rectangle get boundingBox;

  /// The mathematical center of mass of the shape.
  Point<double> get centroid;

  /// Translates the shape by the given vector [offset].
  T translate(Point<num> offset);

  /// Scales the shape uniformly by the given [factor] originating from [centroid].
  T scale(num factor);

  /// Rotates the shape by the given [angle] (in radians) around the [origin].
  /// If [origin] is omitted, rotates around the shape's [centroid].
  T rotate(double angle, [Point<num>? origin]);
}
