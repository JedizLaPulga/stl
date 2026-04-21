library;

import 'dart:math' as math;
import 'point.dart';
import 'rectangle.dart';
import 'shape.dart';

/// Defines a mathematical polygon via an ordered collection of vertices.
class Polygon implements Shape<Polygon> {
  /// The ordered list of vertices defining the polygon.
  final List<Point<num>> vertices;

  /// Creates a [Polygon] from an ordered sequence of [vertices].
  Polygon(this.vertices) {
    if (vertices.length < 3) {
      throw ArgumentError('A polygon must have at least 3 vertices.');
    }
  }

  @override
  double get area {
    // Mathematically beautiful Shoelace formula for polygon area.
    double sum = 0.0;
    final n = vertices.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      sum += (vertices[i].x * vertices[j].y) - (vertices[j].x * vertices[i].y);
    }
    return (sum / 2.0).abs();
  }

  @override
  double get perimeter {
    double sum = 0.0;
    final n = vertices.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      sum += vertices[i].distanceTo(vertices[j]);
    }
    return sum;
  }

  @override
  Rectangle get boundingBox {
    double minX = vertices.first.x.toDouble();
    double maxX = minX;
    double minY = vertices.first.y.toDouble();
    double maxY = minY;
    
    for (final p in vertices.skip(1)) {
      if (p.x < minX) minX = p.x.toDouble();
      if (p.x > maxX) maxX = p.x.toDouble();
      if (p.y < minY) minY = p.y.toDouble();
      if (p.y > maxY) maxY = p.y.toDouble();
    }
    
    return Rectangle(
      width: maxX - minX,
      height: maxY - minY,
      center: Point(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    );
  }

  @override
  Point<double> get centroid {
    // For a simple polygon, calculating the geometric centroid requires area.
    // To keep it computationally lightweight and robust, we calculate the arithmetic mean 
    // of the vertices (center of mass of the vertices, not the solid).
    double sumX = 0.0;
    double sumY = 0.0;
    for (final p in vertices) {
      sumX += p.x;
      sumY += p.y;
    }
    final n = vertices.length;
    return Point(x: sumX / n, y: sumY / n);
  }

  @override
  Polygon translate(Point<num> offset) {
    return Polygon(vertices.map((p) => p + offset).toList(growable: false));
  }

  @override
  Polygon scale(num factor) {
    final c = centroid;
    return Polygon(vertices.map((p) => Point(
      x: c.x + (p.x - c.x) * factor,
      y: c.y + (p.y - c.y) * factor
    )).toList(growable: false));
  }

  @override
  Polygon rotate(double angle, [Point<num>? origin]) {
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

    return Polygon(vertices.map(rotatePoint).toList(growable: false));
  }

  @override
  String toString() => 'Polygon(vertices: ${vertices.length})';
}
