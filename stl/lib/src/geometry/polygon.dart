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
      center: Point(x: (minX + maxX) / 2, y: (minY + maxY) / 2),
    );
  }

  @override
  Point<double> get centroid {
    // Area-weighted centroid via the signed area decomposition (Shoelace variant).
    final a = area;
    if (a == 0) {
      // Degenerate: fall back to vertex mean.
      double sx = 0, sy = 0;
      for (final p in vertices) {
        sx += p.x;
        sy += p.y;
      }
      return Point(x: sx / vertices.length, y: sy / vertices.length);
    }
    double cx = 0.0, cy = 0.0;
    final n = vertices.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final cross =
          vertices[i].x * vertices[j].y - vertices[j].x * vertices[i].y;
      cx += (vertices[i].x + vertices[j].x) * cross;
      cy += (vertices[i].y + vertices[j].y) * cross;
    }
    final factor = 1.0 / (6.0 * a);
    return Point(x: cx * factor, y: cy * factor);
  }

  /// Whether the polygon is convex (all cross products of consecutive edges have
  /// the same sign).
  bool get isConvex {
    final n = vertices.length;
    int sign = 0;
    for (int i = 0; i < n; i++) {
      final a = vertices[i];
      final b = vertices[(i + 1) % n];
      final c = vertices[(i + 2) % n];
      final cross = (b.x - a.x) * (c.y - b.y) - (b.y - a.y) * (c.x - b.x);
      if (cross != 0) {
        final s = cross > 0 ? 1 : -1;
        if (sign == 0) {
          sign = s;
        } else if (sign != s) {
          return false;
        }
      }
    }
    return true;
  }

  /// Whether [point] lies inside or on the boundary of this polygon.
  ///
  /// Uses the ray-casting algorithm — $O(n)$.
  bool containsPoint(Point<num> point) {
    final px = point.x.toDouble();
    final py = point.y.toDouble();
    final n = vertices.length;
    bool inside = false;
    for (int i = 0, j = n - 1; i < n; j = i++) {
      final xi = vertices[i].x.toDouble();
      final yi = vertices[i].y.toDouble();
      final xj = vertices[j].x.toDouble();
      final yj = vertices[j].y.toDouble();
      final intersect =
          ((yi > py) != (yj > py)) &&
          (px < (xj - xi) * (py - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }

  @override
  Polygon translate(Point<num> offset) {
    return Polygon(vertices.map((p) => p + offset).toList(growable: false));
  }

  @override
  Polygon scale(num factor) {
    final c = centroid;
    return Polygon(
      vertices
          .map(
            (p) => Point(
              x: c.x + (p.x - c.x) * factor,
              y: c.y + (p.y - c.y) * factor,
            ),
          )
          .toList(growable: false),
    );
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
