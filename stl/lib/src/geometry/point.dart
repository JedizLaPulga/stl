library;

import '../math/cmath.dart';

/// Represents a 2D coordinate in Euclidean space.
class Point<T extends num> {
  /// The x-coordinate.
  final T x;
  /// The y-coordinate.
  final T y;

  /// Creates a [Point] at the given [x] and [y] coordinates.
  const Point({required this.x, required this.y});

  /// Computes the exact Euclidean distance to another [Point].
  double distanceTo(Point<num> other) {
    return hypot(x - other.x, y - other.y);
  }

  @override
  String toString() => 'Point($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
