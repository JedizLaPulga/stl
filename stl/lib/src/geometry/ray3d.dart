library;

import 'dart:math' as math;
import 'point3d.dart';
import 'sphere3d.dart';
import 'plane3d.dart';

/// A semi-infinite ray in 3D space defined by an [origin] and a [direction].
///
/// The [direction] is normalised automatically upon construction.
class Ray3D {
  /// The origin of the ray.
  final Point3D origin;

  /// The unit direction vector of the ray.
  final Point3D direction;

  /// Creates a [Ray3D] from [origin] and [direction].
  ///
  /// Throws [ArgumentError] if [direction] is the zero vector.
  Ray3D({required this.origin, required Point3D direction})
    : direction = direction.normalize();

  /// Returns the point along the ray at parameter [t]: $\text{origin} + t \cdot \text{direction}$.
  Point3D at(double t) => origin + direction * t;

  /// Intersects this ray with a [Sphere3D].
  ///
  /// Returns the smallest non-negative parameter [t] at the first hit point,
  /// or `null` if the ray misses the sphere.
  double? intersectSphere(Sphere3D sphere) {
    final oc = origin - sphere.center;
    final a = direction.dot(direction);
    final b = 2.0 * oc.dot(direction);
    final c = oc.dot(oc) - sphere.radius * sphere.radius;

    final discriminant = b * b - 4 * a * c;
    if (discriminant < 0) return null;

    final s = math.sqrt(discriminant);
    final t0 = (-b - s) / (2 * a);
    final t1 = (-b + s) / (2 * a);

    if (t0 >= 0) return t0;
    if (t1 >= 0) return t1;
    return null;
  }

  /// Intersects this ray with a [Plane3D].
  ///
  /// Returns the parameter [t] ≥ 0 at the intersection point, or `null` if
  /// the ray is parallel to the plane or points away from it.
  double? intersectPlane(Plane3D plane) {
    final denom = plane.normal.dot(direction);
    if (denom.abs() < 1e-12) return null;
    final t = (plane.distance - plane.normal.dot(origin)) / denom;
    if (t < 0) return null;
    return t;
  }

  @override
  String toString() => 'Ray3D(origin: $origin, direction: $direction)';
}
