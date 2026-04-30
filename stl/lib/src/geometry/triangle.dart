library;

import 'dart:math' as math;
import 'point.dart';
import 'rectangle.dart';
import 'shape.dart';

/// Defines a mathematical triangle strictly via 3 points in 2D space.
class Triangle implements Shape<Triangle> {
  /// The first vertex.
  final Point<num> p1;

  /// The second vertex.
  final Point<num> p2;

  /// The third vertex.
  final Point<num> p3;

  /// Creates a [Triangle] by defining its three vertices.
  Triangle({required this.p1, required this.p2, required this.p3}) {
    final crossProduct =
        (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
    if (crossProduct == 0) {
      throw ArgumentError('Impossible triangle: Points are collinear.');
    }
  }

  /// The length of the side opposite [p1] (between [p2] and [p3]).
  double get sideA => p2.distanceTo(p3);

  /// The length of the side opposite [p2] (between [p1] and [p3]).
  double get sideB => p1.distanceTo(p3);

  /// The length of the side opposite [p3] (between [p1] and [p2]).
  double get sideC => p1.distanceTo(p2);

  @override
  double get area {
    final areaX2 =
        (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y))
            .abs();
    return areaX2 / 2.0;
  }

  @override
  double get perimeter => sideA + sideB + sideC;

  @override
  Rectangle get boundingBox {
    final minX = math.min(p1.x, math.min(p2.x, p3.x)).toDouble();
    final maxX = math.max(p1.x, math.max(p2.x, p3.x)).toDouble();
    final minY = math.min(p1.y, math.min(p2.y, p3.y)).toDouble();
    final maxY = math.max(p1.y, math.max(p2.y, p3.y)).toDouble();
    return Rectangle(
      width: maxX - minX,
      height: maxY - minY,
      center: Point(x: (minX + maxX) / 2, y: (minY + maxY) / 2),
    );
  }

  @override
  Point<double> get centroid =>
      Point(x: (p1.x + p2.x + p3.x) / 3.0, y: (p1.y + p2.y + p3.y) / 3.0);

  /// The circumcenter — the center of the circumscribed circle passing through
  /// all three vertices.
  Point<double> get circumcenter {
    final ax = p1.x.toDouble();
    final ay = p1.y.toDouble();
    final bx = p2.x.toDouble();
    final by = p2.y.toDouble();
    final cx = p3.x.toDouble();
    final cy = p3.y.toDouble();

    final d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by));
    final ux =
        ((ax * ax + ay * ay) * (by - cy) +
            (bx * bx + by * by) * (cy - ay) +
            (cx * cx + cy * cy) * (ay - by)) /
        d;
    final uy =
        ((ax * ax + ay * ay) * (cx - bx) +
            (bx * bx + by * by) * (ax - cx) +
            (cx * cx + cy * cy) * (bx - ax)) /
        d;
    return Point(x: ux, y: uy);
  }

  /// The radius of the circumscribed circle.
  double get circumradius {
    final c = circumcenter;
    return p1.distanceTo(c);
  }

  /// The incenter — the center of the inscribed circle tangent to all three sides.
  Point<double> get incenter {
    final a = sideA;
    final b = sideB;
    final c = sideC;
    final perim = a + b + c;
    return Point(
      x: (a * p1.x + b * p2.x + c * p3.x) / perim,
      y: (a * p1.y + b * p2.y + c * p3.y) / perim,
    );
  }

  /// The radius of the inscribed circle: $r = \text{area} / s$ where $s$ is the
  /// semi-perimeter.
  double get inradius => area / (perimeter / 2.0);

  /// The interior angle at vertex [p1] in radians.
  double get angleA {
    final b = sideB;
    final c = sideC;
    final a = sideA;
    return math.acos((b * b + c * c - a * a) / (2 * b * c));
  }

  /// The interior angle at vertex [p2] in radians.
  double get angleB {
    final a = sideA;
    final c = sideC;
    final b = sideB;
    return math.acos((a * a + c * c - b * b) / (2 * a * c));
  }

  /// The interior angle at vertex [p3] in radians.
  double get angleC => math.pi - angleA - angleB;

  /// Whether all interior angles are less than 90°.
  bool get isAcute =>
      angleA < math.pi / 2 && angleB < math.pi / 2 && angleC < math.pi / 2;

  /// Whether one interior angle equals exactly 90° (within floating-point tolerance).
  bool get isRight {
    const eps = 1e-10;
    return (angleA - math.pi / 2).abs() < eps ||
        (angleB - math.pi / 2).abs() < eps ||
        (angleC - math.pi / 2).abs() < eps;
  }

  /// Whether one interior angle is greater than 90°.
  bool get isObtuse =>
      angleA > math.pi / 2 || angleB > math.pi / 2 || angleC > math.pi / 2;

  /// Whether all three sides are equal in length (within floating-point tolerance).
  bool get isEquilateral {
    const eps = 1e-10;
    return (sideA - sideB).abs() < eps && (sideB - sideC).abs() < eps;
  }

  /// Whether exactly two sides are equal in length (within floating-point tolerance).
  bool get isIsoceles {
    const eps = 1e-10;
    return (sideA - sideB).abs() < eps ||
        (sideB - sideC).abs() < eps ||
        (sideA - sideC).abs() < eps;
  }

  /// Whether all three sides have different lengths.
  bool get isScalene => !isIsoceles;

  @override
  Triangle translate(Point<num> offset) =>
      Triangle(p1: p1 + offset, p2: p2 + offset, p3: p3 + offset);

  @override
  Triangle scale(num factor) {
    final c = centroid;
    Point<num> scalePoint(Point<num> p) =>
        Point(x: c.x + (p.x - c.x) * factor, y: c.y + (p.y - c.y) * factor);
    return Triangle(p1: scalePoint(p1), p2: scalePoint(p2), p3: scalePoint(p3));
  }

  @override
  Triangle rotate(double angle, [Point<num>? origin]) {
    final rotOrigin = origin ?? centroid;
    final ox = rotOrigin.x.toDouble();
    final oy = rotOrigin.y.toDouble();
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);

    Point<double> rotatePoint(Point<num> p) {
      final px = p.x.toDouble();
      final py = p.y.toDouble();
      return Point(
        x: cosA * (px - ox) - sinA * (py - oy) + ox,
        y: sinA * (px - ox) + cosA * (py - oy) + oy,
      );
    }

    return Triangle(
      p1: rotatePoint(p1),
      p2: rotatePoint(p2),
      p3: rotatePoint(p3),
    );
  }

  @override
  String toString() => 'Triangle(p1: $p1, p2: $p2, p3: $p3)';
}
