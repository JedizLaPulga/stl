library;

import 'dart:math' as math;
import 'point.dart';
import 'line_segment.dart';
import 'polygon.dart';
import 'triangle.dart';

/// Computes the convex hull of [points] using the Graham scan algorithm.
///
/// Returns the vertices of the convex hull in counter-clockwise order.
/// If fewer than 3 points are given the result is the input sorted by x then y.
/// Duplicate points are handled gracefully.
///
/// Time complexity: O(n log n).
List<Point<num>> convexHull(List<Point<num>> points) {
  if (points.length < 3) {
    final copy = List<Point<num>>.from(points)
      ..sort((a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
    return copy;
  }

  // Find pivot: lowest y (break ties by leftmost x).
  var pivot = points[0];
  for (final p in points) {
    if (p.y < pivot.y || (p.y == pivot.y && p.x < pivot.x)) pivot = p;
  }

  // Sort by polar angle relative to pivot.
  final sorted = List<Point<num>>.from(points)..remove(pivot);
  sorted.sort((a, b) {
    final ax = a.x - pivot.x, ay = a.y - pivot.y;
    final bx = b.x - pivot.x, by = b.y - pivot.y;
    final cross = ax * by - ay * bx;
    if (cross != 0) return cross > 0 ? -1 : 1;
    // Collinear: closer point first.
    final da = ax * ax + ay * ay;
    final db = bx * bx + by * by;
    return da.compareTo(db);
  });

  final hull = <Point<num>>[pivot];
  for (final p in sorted) {
    while (hull.length >= 2) {
      final o = hull[hull.length - 2];
      final a = hull[hull.length - 1];
      final cross = (a.x - o.x) * (p.y - o.y) - (a.y - o.y) * (p.x - o.x);
      if (cross <= 0) {
        hull.removeLast();
      } else {
        break;
      }
    }
    hull.add(p);
  }

  return hull;
}

/// Finds the closest pair of points from [points] using the divide-and-conquer
/// algorithm.
///
/// Returns a [List] of two [Point]s that are closest to each other.
/// Throws [ArgumentError] if fewer than 2 points are given.
///
/// Time complexity: O(n log n).
List<Point<num>> closestPairOfPoints(List<Point<num>> points) {
  if (points.length < 2) throw ArgumentError('Need at least 2 points.');
  final sorted = List<Point<num>>.from(points)
    ..sort((a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
  final result = _closestPair(sorted);
  return [result.$1, result.$2];
}

double _dist(Point<num> a, Point<num> b) {
  final dx = a.x - b.x, dy = a.y - b.y;
  return math.sqrt(dx * dx + dy * dy);
}

(Point<num>, Point<num>) _closestPair(List<Point<num>> pts) {
  if (pts.length <= 3) {
    // Brute force for small sets.
    var best = (pts[0], pts[1]);
    var bestD = _dist(pts[0], pts[1]);
    for (var i = 0; i < pts.length; i++) {
      for (var j = i + 1; j < pts.length; j++) {
        final d = _dist(pts[i], pts[j]);
        if (d < bestD) {
          bestD = d;
          best = (pts[i], pts[j]);
        }
      }
    }
    return best;
  }

  final mid = pts.length ~/ 2;
  final midX = pts[mid].x;

  final leftResult = _closestPair(pts.sublist(0, mid));
  final rightResult = _closestPair(pts.sublist(mid));

  var best =
      _dist(leftResult.$1, leftResult.$2) <=
          _dist(rightResult.$1, rightResult.$2)
      ? leftResult
      : rightResult;
  var bestD = _dist(best.$1, best.$2);

  // Build strip.
  final strip = pts.where((p) => (p.x - midX).abs() < bestD).toList()
    ..sort((a, b) => a.y.compareTo(b.y));

  for (var i = 0; i < strip.length; i++) {
    for (
      var j = i + 1;
      j < strip.length && (strip[j].y - strip[i].y) < bestD;
      j++
    ) {
      final d = _dist(strip[i], strip[j]);
      if (d < bestD) {
        bestD = d;
        best = (strip[i], strip[j]);
      }
    }
  }

  return best;
}

/// Finds the intersection point of two line segments [a] and [b].
///
/// Returns the [Point] of intersection, or `null` if the segments do not
/// intersect or are collinear.
Point<double>? segmentIntersection(LineSegment a, LineSegment b) {
  final x1 = a.p1.x, y1 = a.p1.y;
  final x2 = a.p2.x, y2 = a.p2.y;
  final x3 = b.p1.x, y3 = b.p1.y;
  final x4 = b.p2.x, y4 = b.p2.y;

  final denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  if (denom.abs() < 1e-12) return null; // Parallel or collinear.

  final t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom;
  final u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom;

  if (t < 0 || t > 1 || u < 0 || u > 1) return null;

  return Point(x: x1 + t * (x2 - x1), y: y1 + t * (y2 - y1));
}

/// Tests whether [point] lies inside [polygon] using the ray-casting algorithm.
///
/// Returns `true` if inside or on the boundary, `false` otherwise.
///
/// Time complexity: O(n).
bool pointInPolygon(Point<num> point, Polygon polygon) =>
    polygon.containsPoint(point);

/// Triangulates [polygon] into a list of [Triangle]s using the ear-clipping
/// algorithm.
///
/// Returns a list of non-overlapping triangles that together cover the polygon.
/// The [polygon] must be simple (non-self-intersecting).
///
/// Time complexity: O(n²).
List<Triangle> triangulate(Polygon polygon) {
  final verts = List<Point<num>>.from(polygon.vertices);
  final triangles = <Triangle>[];

  while (verts.length > 3) {
    var earFound = false;
    for (var i = 0; i < verts.length; i++) {
      final prev = verts[(i - 1 + verts.length) % verts.length];
      final curr = verts[i];
      final next = verts[(i + 1) % verts.length];

      if (!_isEar(prev, curr, next, verts)) continue;

      triangles.add(Triangle(p1: prev, p2: curr, p3: next));
      verts.removeAt(i);
      earFound = true;
      break;
    }
    if (!earFound) break; // Malformed polygon — bail out.
  }

  if (verts.length == 3) {
    triangles.add(Triangle(p1: verts[0], p2: verts[1], p3: verts[2]));
  }

  return triangles;
}

/// Returns whether vertex [curr] is an ear tip of the polygon defined by
/// [all] vertices.
bool _isEar(
  Point<num> prev,
  Point<num> curr,
  Point<num> next,
  List<Point<num>> all,
) {
  // The triangle must be counter-clockwise (positive area).
  if (_cross2D(prev, curr, next) <= 0) return false;

  // No other vertex may lie inside the triangle.
  for (final p in all) {
    if (identical(p, prev) || identical(p, curr) || identical(p, next)) {
      continue;
    }
    if (_pointInTriangle(p, prev, curr, next)) return false;
  }
  return true;
}

/// 2D cross product of vectors (b−a) × (c−a).
double _cross2D(Point<num> a, Point<num> b, Point<num> c) =>
    ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).toDouble();

/// Tests if [p] is inside or on the triangle (a, b, c).
bool _pointInTriangle(Point<num> p, Point<num> a, Point<num> b, Point<num> c) {
  final d1 = _cross2D(p, a, b);
  final d2 = _cross2D(p, b, c);
  final d3 = _cross2D(p, c, a);

  final hasNeg = d1 < 0 || d2 < 0 || d3 < 0;
  final hasPos = d1 > 0 || d2 > 0 || d3 > 0;
  return !(hasNeg && hasPos);
}
