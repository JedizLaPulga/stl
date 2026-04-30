library;

import 'point3d.dart';

/// An infinite plane in 3D space defined by a unit [normal] vector and a
/// signed [distance] from the origin.
///
/// The plane equation is: $\vec{n} \cdot \vec{p} = d$
/// where $\vec{n}$ is the [normal] and $d$ is [distance].
class Plane3D {
  /// The unit normal vector of the plane.
  final Point3D normal;

  /// The signed distance from the origin to the plane along [normal].
  final double distance;

  /// Creates a [Plane3D] from a [normal] vector and [distance].
  ///
  /// The [normal] is automatically normalised.
  /// Throws [ArgumentError] if [normal] is the zero vector.
  Plane3D({required Point3D normal, required num distance})
    : normal = normal.normalize(),
      distance = distance.toDouble();

  /// Creates a [Plane3D] from three non-collinear points on the plane.
  ///
  /// Throws [ArgumentError] if the points are collinear.
  factory Plane3D.fromPoints(Point3D a, Point3D b, Point3D c) {
    final ab = b - a;
    final ac = c - a;
    final n = ab.cross(ac);
    if (n.magnitude == 0) {
      throw ArgumentError('Points are collinear — cannot define a plane.');
    }
    final unitN = n.normalize();
    final d = unitN.dot(a);
    return Plane3D(normal: unitN, distance: d);
  }

  /// The signed distance from [point] to this plane.
  ///
  /// Positive if [point] is on the same side as [normal], negative otherwise.
  double distanceTo(Point3D point) => normal.dot(point) - distance;

  /// Whether [point] lies on the plane (within floating-point tolerance).
  bool containsPoint(Point3D point, {double epsilon = 1e-10}) =>
      distanceTo(point).abs() < epsilon;

  /// Projects [point] orthogonally onto this plane.
  Point3D project(Point3D point) => point - normal * distanceTo(point);

  /// Reflects [point] across this plane.
  Point3D reflect(Point3D point) => point - normal * (2 * distanceTo(point));

  @override
  String toString() => 'Plane3D(normal: $normal, distance: $distance)';
}
