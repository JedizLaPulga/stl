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
    // A valid triangle must have a non-zero area. 
    // We check if the points are collinear using a determinant (cross product).
    final crossProduct = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
    if (crossProduct == 0) {
      throw ArgumentError('Impossible triangle: Points are collinear.');
    }
  }

  /// The first side length.
  double get sideA => p2.distanceTo(p3);
  /// The second side length.
  double get sideB => p1.distanceTo(p3);
  /// The third side length.
  double get sideC => p1.distanceTo(p2);

  @override
  double get area {
    final areaX2 = (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)).abs();
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
      center: Point(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    );
  }

  @override
  Point<double> get centroid {
    return Point(
      x: (p1.x + p2.x + p3.x) / 3.0,
      y: (p1.y + p2.y + p3.y) / 3.0
    );
  }

  @override
  Triangle translate(Point<num> offset) {
    return Triangle(
      p1: p1 + offset,
      p2: p2 + offset,
      p3: p3 + offset
    );
  }

  @override
  Triangle scale(num factor) {
    final c = centroid;
    Point<num> scalePoint(Point<num> p) => Point(
      x: c.x + (p.x - c.x) * factor,
      y: c.y + (p.y - c.y) * factor
    );
    return Triangle(
      p1: scalePoint(p1),
      p2: scalePoint(p2),
      p3: scalePoint(p3)
    );
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
      final nx = cosA * (px - ox) - sinA * (py - oy) + ox;
      final ny = sinA * (px - ox) + cosA * (py - oy) + oy;
      return Point(x: nx, y: ny);
    }

    return Triangle(
      p1: rotatePoint(p1),
      p2: rotatePoint(p2),
      p3: rotatePoint(p3)
    );
  }

  @override
  String toString() => 'Triangle(p1: $p1, p2: $p2, p3: $p3)';
}
