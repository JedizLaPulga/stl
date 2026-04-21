library;

import 'dart:math' as math;
import 'point.dart';
import 'rectangle.dart';
import 'shape.dart';

/// Defines a mathematical line segment strictly via 2 points in 2D space.
class LineSegment implements Shape<LineSegment> {
  /// The starting vertex.
  final Point<num> p1;
  /// The ending vertex.
  final Point<num> p2;

  /// Creates a [LineSegment] by defining its two endpoints.
  LineSegment({required this.p1, required this.p2});

  /// The exact mathematical length of the line segment.
  double get length => p1.distanceTo(p2);

  @override
  double get area => 0.0; // A line has no area.

  @override
  double get perimeter => length;

  @override
  Rectangle get boundingBox {
    final minX = math.min(p1.x, p2.x).toDouble();
    final maxX = math.max(p1.x, p2.x).toDouble();
    final minY = math.min(p1.y, p2.y).toDouble();
    final maxY = math.max(p1.y, p2.y).toDouble();
    return Rectangle(
      width: maxX - minX,
      height: maxY - minY,
      center: Point(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    );
  }

  @override
  Point<double> get centroid {
    return Point(
      x: (p1.x + p2.x) / 2.0,
      y: (p1.y + p2.y) / 2.0
    );
  }

  @override
  LineSegment translate(Point<num> offset) {
    return LineSegment(p1: p1 + offset, p2: p2 + offset);
  }

  @override
  LineSegment scale(num factor) {
    final c = centroid;
    Point<num> scalePoint(Point<num> p) => Point(
      x: c.x + (p.x - c.x) * factor,
      y: c.y + (p.y - c.y) * factor
    );
    return LineSegment(p1: scalePoint(p1), p2: scalePoint(p2));
  }

  @override
  LineSegment rotate(double angle, [Point<num>? origin]) {
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

    return LineSegment(p1: rotatePoint(p1), p2: rotatePoint(p2));
  }

  @override
  String toString() => 'LineSegment(p1: $p1, p2: $p2)';
}
