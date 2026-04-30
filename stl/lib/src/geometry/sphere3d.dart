library;

import 'dart:math' as math;
import 'point3d.dart';

/// A sphere in 3D space defined by a [center] and [radius].
class Sphere3D {
  /// The center of the sphere.
  final Point3D center;

  /// The radius of the sphere.
  final double radius;

  /// Creates a [Sphere3D] with the given [center] and [radius].
  ///
  /// Throws [ArgumentError] if [radius] is negative.
  Sphere3D({required this.center, required num radius})
    : radius = radius.toDouble() {
    if (radius < 0) throw ArgumentError('Radius cannot be negative.');
  }

  /// The volume of the sphere: $\frac{4}{3} \pi r^3$.
  double get volume => (4.0 / 3.0) * math.pi * radius * radius * radius;

  /// The surface area of the sphere: $4 \pi r^2$.
  double get surfaceArea => 4 * math.pi * radius * radius;

  /// Whether the given [point] lies inside or on the surface of the sphere.
  bool containsPoint(Point3D point) => center.distanceTo(point) <= radius;

  /// Whether this sphere overlaps with [other] (their surfaces or interiors intersect).
  bool intersectsSphere(Sphere3D other) =>
      center.distanceTo(other.center) <= radius + other.radius;

  @override
  String toString() => 'Sphere3D(center: $center, radius: $radius)';
}
