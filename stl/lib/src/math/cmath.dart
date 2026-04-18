/// C++ `<cmath>` inspired mathematical algorithms.
///
/// Provides robust, overflow-safe mathematical constraints missing natively
/// in standard `dart:math`. Includes:
/// - [clamp] — bounds a value between limits
/// - [lerp] — linear interpolation linearly distancing values
/// - [hypot] — calculate 2D / 3D euclidean distance safely
library;

import 'dart:math' as math;

/// Clamps [v] between [lo] and [hi].
///
/// Returns [lo] if [v] is less than [lo], returns [hi] if [v] is greater than [hi],
/// and returns [v] otherwise.
/// Corresponds to `std::clamp` from C++17.
T clamp<T extends num>(T v, T lo, T hi) {
  if (lo > hi) {
    throw ArgumentError('lo ($lo) cannot be greater than hi ($hi)');
  }
  if (v < lo) return lo;
  if (v > hi) return hi;
  return v;
}

/// Computes the linear interpolation between [a] and [b] for the parameter [t].
///
/// Corresponds to `std::lerp` from C++20.
/// When [t] corresponds to `0.0`, returns `a`.
/// When [t] corresponds to `1.0`, returns `b`.
/// The function accurately computes the intermediate bound cleanly.
double lerp(num a, num b, num t) {
  final da = a.toDouble();
  final db = b.toDouble();
  final dt = t.toDouble();
  // Exact mathematically stable lerp equation
  return da + dt * (db - da);
}

/// Computes the length of the hypotenuse `sqrt(x^2 + y^2)`.
///
/// Optionally computes the 3D magnitude `sqrt(x^2 + y^2 + z^2)` if [z] is provided.
/// Avoids intermediate overflow and underflow common with raw `x*x + y*y`.
/// Corresponds to `std::hypot` from C++11 (2 args) / C++17 (3 args).
double hypot(num x, num y, [num? z]) {
  final dx = x.abs().toDouble();
  final dy = y.abs().toDouble();
  final dz = z?.abs().toDouble() ?? 0.0;

  final maxVal = math.max(dx, math.max(dy, dz));
  if (maxVal == 0.0) return 0.0;

  final cx = dx / maxVal;
  final cy = dy / maxVal;
  final cz = dz / maxVal;

  return maxVal * math.sqrt(cx * cx + cy * cy + cz * cz);
}
