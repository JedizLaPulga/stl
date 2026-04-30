library;

import 'dart:math' as math;
import 'point.dart';

/// A degree-2 (quadratic) Bézier curve defined by three control points.
///
/// The curve is parameterised over $t \in [0, 1]$ using the De Casteljau
/// algorithm:
/// $$B(t) = (1-t)^2 P_0 + 2(1-t)t P_1 + t^2 P_2$$
class QuadraticBezier {
  /// The first (start) control point.
  final Point<double> p0;

  /// The middle control point (the curve does not pass through this point).
  final Point<double> p1;

  /// The third (end) control point.
  final Point<double> p2;

  /// Creates a [QuadraticBezier] from three control points.
  QuadraticBezier({
    required Point<num> p0,
    required Point<num> p1,
    required Point<num> p2,
  }) : p0 = Point(x: p0.x.toDouble(), y: p0.y.toDouble()),
       p1 = Point(x: p1.x.toDouble(), y: p1.y.toDouble()),
       p2 = Point(x: p2.x.toDouble(), y: p2.y.toDouble());

  /// Evaluates the curve at parameter [t] ∈ [0, 1].
  Point<double> evaluate(double t) {
    final mt = 1 - t;
    return Point(
      x: mt * mt * p0.x + 2 * mt * t * p1.x + t * t * p2.x,
      y: mt * mt * p0.y + 2 * mt * t * p1.y + t * t * p2.y,
    );
  }

  /// The first derivative (tangent direction) at parameter [t].
  ///
  /// Returns the velocity vector $B'(t) = 2(1-t)(P_1 - P_0) + 2t(P_2 - P_1)$.
  Point<double> derivative(double t) {
    final mt = 1 - t;
    return Point(
      x: 2 * mt * (p1.x - p0.x) + 2 * t * (p2.x - p1.x),
      y: 2 * mt * (p1.y - p0.y) + 2 * t * (p2.y - p1.y),
    );
  }

  /// Approximates the arc length using [segments] line-segment samples.
  ///
  /// Higher [segments] values give more accurate results.
  /// Throws [ArgumentError] if [segments] < 1.
  double arcLength([int segments = 100]) {
    if (segments < 1) throw ArgumentError('segments must be >= 1.');
    double length = 0;
    var prev = evaluate(0);
    for (int i = 1; i <= segments; i++) {
      final curr = evaluate(i / segments);
      final dx = curr.x - prev.x;
      final dy = curr.y - prev.y;
      length += math.sqrt(dx * dx + dy * dy);
      prev = curr;
    }
    return length;
  }

  /// Splits the curve at parameter [t] ∈ (0, 1), returning a pair of
  /// [QuadraticBezier] curves via De Casteljau subdivision.
  (QuadraticBezier, QuadraticBezier) splitAt(double t) {
    final q0 = Point(
      x: (1 - t) * p0.x + t * p1.x,
      y: (1 - t) * p0.y + t * p1.y,
    );
    final q1 = Point(
      x: (1 - t) * p1.x + t * p2.x,
      y: (1 - t) * p1.y + t * p2.y,
    );
    final r0 = Point(
      x: (1 - t) * q0.x + t * q1.x,
      y: (1 - t) * q0.y + t * q1.y,
    );
    return (
      QuadraticBezier(p0: p0, p1: q0, p2: r0),
      QuadraticBezier(p0: r0, p1: q1, p2: p2),
    );
  }

  @override
  String toString() => 'QuadraticBezier(p0: $p0, p1: $p1, p2: $p2)';
}

/// A degree-3 (cubic) Bézier curve defined by four control points.
///
/// The curve is parameterised over $t \in [0, 1]$:
/// $$B(t) = (1-t)^3 P_0 + 3(1-t)^2 t P_1 + 3(1-t) t^2 P_2 + t^3 P_3$$
class CubicBezier {
  /// The first (start) control point.
  final Point<double> p0;

  /// The second control point.
  final Point<double> p1;

  /// The third control point.
  final Point<double> p2;

  /// The fourth (end) control point.
  final Point<double> p3;

  /// Creates a [CubicBezier] from four control points.
  CubicBezier({
    required Point<num> p0,
    required Point<num> p1,
    required Point<num> p2,
    required Point<num> p3,
  }) : p0 = Point(x: p0.x.toDouble(), y: p0.y.toDouble()),
       p1 = Point(x: p1.x.toDouble(), y: p1.y.toDouble()),
       p2 = Point(x: p2.x.toDouble(), y: p2.y.toDouble()),
       p3 = Point(x: p3.x.toDouble(), y: p3.y.toDouble());

  /// Evaluates the curve at parameter [t] ∈ [0, 1].
  Point<double> evaluate(double t) {
    final mt = 1 - t;
    final mt2 = mt * mt;
    final mt3 = mt2 * mt;
    final t2 = t * t;
    final t3 = t2 * t;
    return Point(
      x: mt3 * p0.x + 3 * mt2 * t * p1.x + 3 * mt * t2 * p2.x + t3 * p3.x,
      y: mt3 * p0.y + 3 * mt2 * t * p1.y + 3 * mt * t2 * p2.y + t3 * p3.y,
    );
  }

  /// The first derivative (tangent direction) at parameter [t].
  ///
  /// $B'(t) = 3(1-t)^2(P_1-P_0) + 6(1-t)t(P_2-P_1) + 3t^2(P_3-P_2)$
  Point<double> derivative(double t) {
    final mt = 1 - t;
    return Point(
      x:
          3 * mt * mt * (p1.x - p0.x) +
          6 * mt * t * (p2.x - p1.x) +
          3 * t * t * (p3.x - p2.x),
      y:
          3 * mt * mt * (p1.y - p0.y) +
          6 * mt * t * (p2.y - p1.y) +
          3 * t * t * (p3.y - p2.y),
    );
  }

  /// Approximates the arc length using [segments] line-segment samples.
  ///
  /// Higher [segments] values give more accurate results.
  /// Throws [ArgumentError] if [segments] < 1.
  double arcLength([int segments = 100]) {
    if (segments < 1) throw ArgumentError('segments must be >= 1.');
    double length = 0;
    var prev = evaluate(0);
    for (int i = 1; i <= segments; i++) {
      final curr = evaluate(i / segments);
      final dx = curr.x - prev.x;
      final dy = curr.y - prev.y;
      length += math.sqrt(dx * dx + dy * dy);
      prev = curr;
    }
    return length;
  }

  /// Splits the curve at parameter [t] ∈ (0, 1), returning a pair of
  /// [CubicBezier] curves via De Casteljau subdivision.
  (CubicBezier, CubicBezier) splitAt(double t) {
    final q0 = Point(
      x: (1 - t) * p0.x + t * p1.x,
      y: (1 - t) * p0.y + t * p1.y,
    );
    final q1 = Point(
      x: (1 - t) * p1.x + t * p2.x,
      y: (1 - t) * p1.y + t * p2.y,
    );
    final q2 = Point(
      x: (1 - t) * p2.x + t * p3.x,
      y: (1 - t) * p2.y + t * p3.y,
    );

    final r0 = Point(
      x: (1 - t) * q0.x + t * q1.x,
      y: (1 - t) * q0.y + t * q1.y,
    );
    final r1 = Point(
      x: (1 - t) * q1.x + t * q2.x,
      y: (1 - t) * q1.y + t * q2.y,
    );

    final s0 = Point(
      x: (1 - t) * r0.x + t * r1.x,
      y: (1 - t) * r0.y + t * r1.y,
    );

    return (
      CubicBezier(p0: p0, p1: q0, p2: r0, p3: s0),
      CubicBezier(p0: s0, p1: r1, p2: q2, p3: p3),
    );
  }

  @override
  String toString() => 'CubicBezier(p0: $p0, p1: $p1, p2: $p2, p3: $p3)';
}
