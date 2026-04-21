library;

import 'dart:math' as math;
import 'point.dart';
import 'rectangle.dart';
import 'shape.dart';

/// Defines a mathematical ellipse strictly via its semi-axes.
class Ellipse implements Shape<Ellipse> {
  /// The semi-major axis (half the width).
  final double semiMajorAxis;
  /// The semi-minor axis (half the height).
  final double semiMinorAxis;
  final Point<num> _center;

  /// Creates an [Ellipse] with the given semi-axes and optional [center].
  Ellipse({required this.semiMajorAxis, required this.semiMinorAxis, Point<num>? center}) 
      : _center = center ?? const Point(x: 0, y: 0) {
    if (semiMajorAxis < 0 || semiMinorAxis < 0) {
      throw ArgumentError('Axes cannot be negative');
    }
  }

  /// The center point of the ellipse.
  Point<num> get center => _center;

  @override
  double get area => math.pi * semiMajorAxis * semiMinorAxis;

  @override
  double get perimeter {
    // Ramanujan's approximation for the circumference of an ellipse.
    final a = semiMajorAxis;
    final b = semiMinorAxis;
    final h = math.pow((a - b) / (a + b), 2);
    return math.pi * (a + b) * (1 + (3 * h) / (10 + math.sqrt(4 - 3 * h)));
  }

  @override
  Rectangle get boundingBox => Rectangle(
    width: semiMajorAxis * 2, 
    height: semiMinorAxis * 2, 
    center: _center
  );

  @override
  Point<double> get centroid => Point(x: _center.x.toDouble(), y: _center.y.toDouble());

  @override
  Ellipse translate(Point<num> offset) => Ellipse(
    semiMajorAxis: semiMajorAxis, 
    semiMinorAxis: semiMinorAxis, 
    center: _center + offset
  );

  @override
  Ellipse scale(num factor) => Ellipse(
    semiMajorAxis: semiMajorAxis * factor.abs(), 
    semiMinorAxis: semiMinorAxis * factor.abs(), 
    center: _center
  );

  @override
  Ellipse rotate(double angle, [Point<num>? origin]) {
    // For an axis-aligned Ellipse, rotating perfectly requires transforming it into a general polygon 
    // or tracking an orientation angle. To maintain mathematical purity of our CRTP 
    // without expanding state unnecessarily, we rotate its geometric center around the origin.
    final rotOrigin = origin ?? centroid;
    final ox = rotOrigin.x.toDouble();
    final oy = rotOrigin.y.toDouble();
    final cx = _center.x.toDouble();
    final cy = _center.y.toDouble();

    final cosA = math.cos(angle);
    final sinA = math.sin(angle);

    final nx = cosA * (cx - ox) - sinA * (cy - oy) + ox;
    final ny = sinA * (cx - ox) + cosA * (cy - oy) + oy;

    return Ellipse(semiMajorAxis: semiMajorAxis, semiMinorAxis: semiMinorAxis, center: Point(x: nx, y: ny));
  }

  @override
  String toString() => 'Ellipse(semiMajor: $semiMajorAxis, semiMinor: $semiMinorAxis, center: $_center)';
}
