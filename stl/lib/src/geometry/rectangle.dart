library;

import 'dart:math' as math;
import 'point.dart';
import 'shape.dart';

/// Defines a standard rectangle strictly via dimensions.
class Rectangle implements Shape<Rectangle> {
  /// The width of the rectangle.
  final double width;

  /// The height of the rectangle.
  final double height;
  final Point<num> _center;

  /// Creates a [Rectangle] with the specified [width], [height], and [center].
  Rectangle({required this.width, required this.height, Point<num>? center})
    : _center = center ?? const Point(x: 0, y: 0) {
    if (width < 0 || height < 0) {
      throw ArgumentError('Dimensions cannot be negative');
    }
  }

  /// The center point of the rectangle.
  Point<num> get center => _center;

  @override
  double get area => width * height;

  @override
  double get perimeter => 2 * (width + height);

  @override
  Rectangle get boundingBox => this;

  @override
  Point<double> get centroid =>
      Point(x: _center.x.toDouble(), y: _center.y.toDouble());

  @override
  Rectangle translate(Point<num> offset) =>
      Rectangle(width: width, height: height, center: _center + offset);

  @override
  Rectangle scale(num factor) => Rectangle(
    width: width * factor.abs(),
    height: height * factor.abs(),
    center: _center,
  );

  @override
  Rectangle rotate(double angle, [Point<num>? origin]) {
    final rotOrigin = origin ?? centroid;
    final ox = rotOrigin.x.toDouble();
    final oy = rotOrigin.y.toDouble();
    final cx = _center.x.toDouble();
    final cy = _center.y.toDouble();

    final cosA = math.cos(angle);
    final sinA = math.sin(angle);

    final nx = cosA * (cx - ox) - sinA * (cy - oy) + ox;
    final ny = sinA * (cx - ox) + cosA * (cy - oy) + oy;

    final absCos = cosA.abs();
    final absSin = sinA.abs();

    final newWidth = width * absCos + height * absSin;
    final newHeight = width * absSin + height * absCos;

    return Rectangle(
      width: newWidth,
      height: newHeight,
      center: Point(x: nx, y: ny),
    );
  }

  /// Whether the given [point] lies strictly inside or on the boundary of this rectangle.
  bool containsPoint(Point<num> point) {
    final cx = _center.x.toDouble();
    final cy = _center.y.toDouble();
    final px = point.x.toDouble();
    final py = point.y.toDouble();
    return px >= cx - width / 2 &&
        px <= cx + width / 2 &&
        py >= cy - height / 2 &&
        py <= cy + height / 2;
  }

  /// Whether this rectangle overlaps with [other] (axis-aligned intersection test).
  bool intersects(Rectangle other) {
    final dx = (_center.x - other._center.x).abs();
    final dy = (_center.y - other._center.y).abs();
    return dx <= (width + other.width) / 2 && dy <= (height + other.height) / 2;
  }

  /// The four corner vertices of the rectangle in counter-clockwise order:
  /// bottom-left, bottom-right, top-right, top-left.
  List<Point<double>> get corners {
    final cx = _center.x.toDouble();
    final cy = _center.y.toDouble();
    final hw = width / 2;
    final hh = height / 2;
    return [
      Point(x: cx - hw, y: cy - hh),
      Point(x: cx + hw, y: cy - hh),
      Point(x: cx + hw, y: cy + hh),
      Point(x: cx - hw, y: cy + hh),
    ];
  }

  @override
  String toString() =>
      'Rectangle(width: $width, height: $height, center: $_center)';
}
