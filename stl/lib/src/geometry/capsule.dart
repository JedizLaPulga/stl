library;

import 'dart:math' as math;
import 'point.dart';
import 'line_segment.dart';

/// A capsule (stadium) shape defined by a [spine] line segment and a [radius].
///
/// A capsule is the Minkowski sum of a [LineSegment] and a disk of the given
/// [radius] — equivalently, the set of all points within [radius] of the
/// spine segment.
class Capsule {
  /// The central spine of the capsule.
  final LineSegment spine;

  /// The radius of the semicircular end caps.
  final double radius;

  /// Creates a [Capsule] with the given [spine] and [radius].
  ///
  /// Throws [ArgumentError] if [radius] is negative.
  Capsule({required this.spine, required this.radius}) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative.');
  }

  /// The total surface area: rectangle body + two semicircles = $l \cdot 2r + \pi r^2$.
  double get area => spine.length * 2 * radius + math.pi * radius * radius;

  /// The total perimeter: two side edges + two semicircles = $2l + 2\pi r$.
  double get perimeter => 2 * spine.length + 2 * math.pi * radius;

  /// The geometric center of the capsule (midpoint of the spine).
  Point<double> get centroid => spine.centroid;

  /// Whether the given [point] lies within or on the boundary of the capsule.
  ///
  /// A point is inside the capsule if its distance to the closest point on
  /// the [spine] is ≤ [radius].
  bool containsPoint(Point<num> point) {
    return _distanceToSegment(point) <= radius;
  }

  double _distanceToSegment(Point<num> p) {
    final ax = spine.p1.x.toDouble();
    final ay = spine.p1.y.toDouble();
    final bx = spine.p2.x.toDouble();
    final by = spine.p2.y.toDouble();
    final px = p.x.toDouble();
    final py = p.y.toDouble();

    final abx = bx - ax;
    final aby = by - ay;
    final apx = px - ax;
    final apy = py - ay;

    final lenSq = abx * abx + aby * aby;
    if (lenSq == 0) {
      // Degenerate spine (single point).
      return math.sqrt(apx * apx + apy * apy);
    }

    final t = ((apx * abx + apy * aby) / lenSq).clamp(0.0, 1.0);
    final closestX = ax + t * abx;
    final closestY = ay + t * aby;
    final dx = px - closestX;
    final dy = py - closestY;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  String toString() => 'Capsule(spine: $spine, radius: $radius)';
}
