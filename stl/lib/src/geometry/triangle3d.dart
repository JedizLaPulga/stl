library;

import 'point3d.dart';
import 'triangle.dart';
import 'point.dart';

/// A triangle in 3D space defined by three vertices.
class Triangle3D {
  /// The first vertex.
  final Point3D p1;

  /// The second vertex.
  final Point3D p2;

  /// The third vertex.
  final Point3D p3;

  /// Creates a [Triangle3D] from three vertices.
  ///
  /// Throws [ArgumentError] if the vertices are collinear.
  Triangle3D({required this.p1, required this.p2, required this.p3}) {
    final n = (p2 - p1).cross(p3 - p1);
    if (n.magnitude == 0) {
      throw ArgumentError('Triangle3D: vertices are collinear.');
    }
  }

  /// The outward-facing unit normal of the triangle.
  Point3D get normal => (p2 - p1).cross(p3 - p1).normalize();

  /// The surface area of the triangle: $\frac{1}{2} |\vec{AB} \times \vec{AC}|$.
  double get area => (p2 - p1).cross(p3 - p1).magnitude / 2.0;

  /// The geometric centroid of the triangle.
  Point3D get centroid => Point3D(
    x: (p1.x + p2.x + p3.x) / 3.0,
    y: (p1.y + p2.y + p3.y) / 3.0,
    z: (p1.z + p2.z + p3.z) / 3.0,
  );

  /// Whether [point] lies inside or on the boundary of this triangle using
  /// the barycentric coordinate test.
  bool containsPoint(Point3D point) {
    final v0 = p3 - p1;
    final v1 = p2 - p1;
    final v2 = point - p1;

    final dot00 = v0.dot(v0);
    final dot01 = v0.dot(v1);
    final dot02 = v0.dot(v2);
    final dot11 = v1.dot(v1);
    final dot12 = v1.dot(v2);

    final denom = dot00 * dot11 - dot01 * dot01;
    if (denom.abs() < 1e-12) return false;

    final invDenom = 1.0 / denom;
    final u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    final v = (dot00 * dot12 - dot01 * dot02) * invDenom;

    return u >= 0 && v >= 0 && u + v <= 1;
  }

  /// Projects this triangle onto the XY plane, returning a 2D [Triangle].
  Triangle toTriangle() => Triangle(
    p1: Point(x: p1.x, y: p1.y),
    p2: Point(x: p2.x, y: p2.y),
    p3: Point(x: p3.x, y: p3.y),
  );

  @override
  String toString() => 'Triangle3D(p1: $p1, p2: $p2, p3: $p3)';
}
