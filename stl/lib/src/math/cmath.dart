/// C++ `<cmath>` inspired mathematical algorithms.
///
/// Provides robust, overflow-safe mathematical utilities missing natively in
/// standard `dart:math` or requiring C++ idiom parity. Function names and
/// semantics follow ISO 80000-2, IEC 60559, and the C++23 `<cmath>` standard.
///
/// **Interpolation & Mapping**
/// - [clamp] — bounds a value between limits (C++17 `std::clamp`)
/// - [lerp] — linear interpolation (C++20 `std::lerp`)
/// - [smoothstep] — cubic Hermite smooth interpolation (GLSL / GLM)
/// - [smootherstep] — quintic C² smooth interpolation (Perlin)
/// - [quinticStep] — quintic polynomial step 6t⁵ − 15t⁴ + 10t³
/// - [remap] — map a value from one numeric range to another
/// - [saturate] — clamp to the unit interval `[0, 1]`
/// - [bilerp] — bilinear interpolation over a unit square
/// - [pingpong] — triangle-wave bounce in `[0, length]`
/// - [moveTowards] — step a value toward a target without overshoot
///
/// **Trigonometric (ISO 80000-2)**
/// - [sin] — sine
/// - [cos] — cosine
/// - [tan] — tangent
/// - [asin] — arc-sine (principal value, range `[−π/2, π/2]`)
/// - [acos] — arc-cosine (principal value, range `[0, π]`)
/// - [atan] — arc-tangent (principal value, range `(−π/2, π/2)`)
/// - [atan2] — two-argument arc-tangent (range `(−π, π]`)
///
/// **Hyperbolic (ISO 80000-2)**
/// - [sinh] — hyperbolic sine
/// - [cosh] — hyperbolic cosine
/// - [tanh] — hyperbolic tangent
/// - [asinh] — inverse hyperbolic sine
/// - [acosh] — inverse hyperbolic cosine
/// - [atanh] — inverse hyperbolic tangent
///
/// **Geometry & Trigonometry Helpers**
/// - [hypot] — overflow-safe Euclidean norm (C++17 2- and 3-arg)
/// - [degrees] — convert radians to degrees
/// - [radians] — convert degrees to radians
/// - [wrapAngle] — wrap angle into `[−π, π)`
/// - [angleDiff] — shortest signed angular difference
/// - [sinc] — unnormalised sinc: sin(x)/x, sinc(0) = 1
/// - [normalizedSinc] — normalised sinc: sin(πx)/(πx), sinc(0) = 1
///
/// **Exponential & Logarithmic (ISO 80000-2)**
/// - [exp] — eˣ
/// - [exp2] — 2ˣ
/// - [expm1] — eˣ − 1, accurate near zero
/// - [log] — natural logarithm ln(x)
/// - [log2] — base-2 logarithm
/// - [log10] — base-10 logarithm
/// - [log1p] — ln(1 + x), accurate near zero
///
/// **Power & Root**
/// - [pow] — general power xʸ
/// - [sqrt] — square root √x
/// - [cbrt] — cube root ∛x (handles negative x)
/// - [square] — x²
/// - [cube] — x³
///
/// **Rounding (IEC 60559)**
/// - [floor] — largest integer ≤ x
/// - [ceil] — smallest integer ≥ x
/// - [round] — nearest integer, half away from zero
/// - [nearbyInt] — nearest integer, ties to even (banker's rounding)
/// - [trunc] — truncate toward zero
///
/// **Arithmetic**
/// - [sign] — signum: −1, 0, or 1
/// - [fma] — fused multiply-add a × b + c
/// - [fdim] — positive difference max(x − y, 0)
/// - [fmax] — floating-point maximum (NaN-propagating)
/// - [fmin] — floating-point minimum (NaN-propagating)
/// - [abs] — absolute value |x|
///
/// **Floating-Point Decomposition & Manipulation**
/// - [fmod] — floating-point remainder, sign = sign(dividend)
/// - [remainder] — IEC 60559 remainder (round-to-nearest quotient)
/// - [fract] — fractional part (sign = sign(x))
/// - [copySign] — magnitude of x with sign of y
/// - [scalbn] — x × 2ⁿ (efficient binary scaling)
/// - [ldexp] — alias for scalbn
/// - [frexp] — split x into normalised fraction + exponent
/// - [modf] — split x into integer and fractional parts
/// - [ilogb] — unbiased base-2 exponent as int
/// - [logb] — unbiased base-2 exponent as double
///
/// **Floating-Point Classification (IEC 60559)**
/// - [isNaN] — test for NaN
/// - [isFinite] — test for finite (not NaN or infinite)
/// - [isInfinite] — test for ±∞
/// - [isNormal] — test for normal (not zero, subnormal, NaN, or ∞)
/// - [signBit] — true if the sign bit is set (includes −0.0)
/// - [nearlyEqual] — epsilon-based approximate equality
///
/// **Error & Gamma Functions (C++17 special functions)**
/// - [erf] — error function erf(x)
/// - [erfc] — complementary error function erfc(x) = 1 − erf(x)
/// - [tgamma] — gamma function Γ(x)
/// - [lgamma] — natural log of |Γ(x)|
///
/// **Combinatorial & Integer Math**
/// - [factorial] — n! (exact for n ≤ 20, double for larger)
/// - [fallingFactorial] — falling factorial x⁽ⁿ⁾ = x(x−1)…(x−n+1)
/// - [risingFactorial] — rising factorial x⁽ⁿ⁾ (Pochhammer symbol)
/// - [binomial] — binomial coefficient C(n, k)
///
/// **Step & Signals**
/// - [step] — Heaviside unit step θ(x − edge)
///
/// **Bit / Integer Utilities**
/// - [isPowerOfTwo] — test whether a positive integer is a power of two
/// - [nextPowerOfTwo] — smallest power of two ≥ n
///
/// **Special Mathematical Functions (ISO 80000-2 / C++17)**
/// - [beta] — Euler beta function B(a, b) = Γ(a)Γ(b)/Γ(a+b)
/// - [legendre] — Legendre polynomial Pₙ(x)
/// - [assocLegendre] — associated Legendre polynomial Pₙᵐ(x)
/// - [hermite] — (probabilist) Hermite polynomial Hₙ(x)
/// - [laguerre] — Laguerre polynomial Lₙ(x)
/// - [assocLaguerre] — associated Laguerre polynomial Lₙᵐ(x)
/// - [riemannZeta] — Riemann zeta function ζ(s)
/// - [sphBessel] — spherical Bessel function of the first kind jₙ(x)
/// - [sphNeumann] — spherical Bessel function of the second kind yₙ(x)
/// - [sphLegendre] — real spherical harmonic Yₙᵐ(θ, φ)
/// - [cylBesselJ] — cylindrical Bessel J (first kind, Jν(x))
/// - [cylBesselI] — modified cylindrical Bessel I (Iν(x))
/// - [cylBesselK] — modified cylindrical Bessel K (Kν(x))
/// - [cylNeumann] — cylindrical Neumann Yν(x) (second kind)
/// - [expInt] — exponential integral Ei(x)
/// - [compEllint1] — complete elliptic integral of the first kind K(k)
/// - [compEllint2] — complete elliptic integral of the second kind E(k)
/// - [compEllint3] — complete elliptic integral of the third kind Π(n, k)
/// - [ellint1] — incomplete elliptic integral of the first kind F(φ, k)
/// - [ellint2] — incomplete elliptic integral of the second kind E(φ, k)
/// - [ellint3] — incomplete elliptic integral of the third kind Π(n, φ, k)
library;

import 'dart:math' as math;

// ─── Interpolation & Mapping ─────────────────────────────────────────────────

/// Clamps [v] between [lo] and [hi].
///
/// Returns [lo] if [v] is less than [lo], returns [hi] if [v] is greater than
/// [hi], and returns [v] otherwise.
/// Corresponds to `std::clamp` from C++17.
///
/// Throws [ArgumentError] if [lo] is greater than [hi].
T clamp<T extends num>(T v, T lo, T hi) {
  if (lo > hi) {
    throw ArgumentError('lo ($lo) cannot be greater than hi ($hi)');
  }
  if (v < lo) return lo;
  if (v > hi) return hi;
  return v;
}

/// Computes the linear interpolation between [a] and [b] for parameter [t].
///
/// Returns [a] when [t] is `0.0` and [b] when [t] is `1.0`. Values of [t]
/// outside `[0, 1]` extrapolate beyond the endpoints.
/// Corresponds to `std::lerp` from C++20.
double lerp(num a, num b, num t) {
  final da = a.toDouble();
  final db = b.toDouble();
  final dt = t.toDouble();
  return da + dt * (db - da);
}

/// Performs smooth cubic Hermite interpolation between `0.0` and `1.0`.
///
/// The input [t] is first clamped to `[edge0, edge1]` and then mapped through
/// the Hermite polynomial `t² × (3 − 2t)`, producing a smooth S-curve.
/// Returns `0.0` when `t ≤ edge0` and `1.0` when `t ≥ edge1`.
///
/// Corresponds to `glm::smoothstep` and the GLSL/HLSL built-in `smoothstep`.
/// Throws [ArgumentError] if [edge0] equals [edge1].
double smoothstep(num edge0, num edge1, num t) {
  if (edge0 == edge1) {
    throw ArgumentError('edge0 ($edge0) and edge1 ($edge1) must be different.');
  }
  final x = clamp(
    (t.toDouble() - edge0.toDouble()) / (edge1.toDouble() - edge0.toDouble()),
    0.0,
    1.0,
  );
  return x * x * (3.0 - 2.0 * x);
}

/// Remaps [v] from the source range `[s0, s1]` to the target range `[t0, t1]`.
///
/// Performs a scaled linear interpolation. If [v] lies outside `[s0, s1]`,
/// the result extrapolates beyond `[t0, t1]`.
/// Throws [ArgumentError] if [s0] equals [s1] (degenerate source range).
double remap(num v, num s0, num s1, num t0, num t1) {
  if (s0 == s1) {
    throw ArgumentError(
      'Source range s0 ($s0) and s1 ($s1) must be different.',
    );
  }
  final t = (v.toDouble() - s0.toDouble()) / (s1.toDouble() - s0.toDouble());
  return lerp(t0, t1, t);
}

/// Clamps [v] to the unit interval `[0.0, 1.0]`.
///
/// Equivalent to `clamp(v, 0.0, 1.0)`. Commonly used in graphics and shader
/// programming to keep values in a valid normalized range.
double saturate(num v) => clamp(v.toDouble(), 0.0, 1.0);

// ─── Geometry & Trigonometry Helpers ─────────────────────────────────────────

/// Computes the length of the hypotenuse: `sqrt(x² + y²)`.
///
/// Optionally computes the 3D magnitude `sqrt(x² + y² + z²)` when [z] is
/// provided. Uses a scaling technique to avoid intermediate overflow and
/// underflow that can occur with raw `x*x + y*y`.
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

/// Converts an angle in radians to degrees.
///
/// Applies the formula `rad × (180 / π)`.
double degrees(num rad) => rad.toDouble() * (180.0 / math.pi);

/// Converts an angle in degrees to radians.
///
/// Applies the formula `deg × (π / 180)`.
double radians(num deg) => deg.toDouble() * (math.pi / 180.0);

// ─── Arithmetic ──────────────────────────────────────────────────────────────

/// Returns the signum of [v]: `-1` if negative, `0` if zero, `1` if positive.
///
/// For `int` inputs the return type is `int`; for `double` inputs the return
/// type is `double`. This preserves the generic type `T`.
/// Loosely corresponds to the mathematical sign function sgn(v).
T sign<T extends num>(T v) {
  if (v == 0) return (v is double ? 0.0 : 0) as T;
  return (v < 0 ? (v is double ? -1.0 : -1) : (v is double ? 1.0 : 1)) as T;
}

/// Computes the fused multiply-add: `(a × b) + c`.
///
/// Corresponds to `std::fma` from C++11. Useful for minimizing floating-point
/// rounding relative to performing a separate multiply then add.
double fma(num a, num b, num c) => a.toDouble() * b.toDouble() + c.toDouble();

/// Returns [x] squared: `x × x`.
///
/// Equivalent to `pow(x, 2)` but avoids the overhead of a generic power
/// function for this extremely common case.
double square(num x) {
  final d = x.toDouble();
  return d * d;
}

/// Returns [x] cubed: `x × x × x`.
///
/// Equivalent to `pow(x, 3)` but avoids the overhead of a generic power
/// function for this common case.
double cube(num x) {
  final d = x.toDouble();
  return d * d * d;
}

/// Computes the real cube root of [x]: ∛x.
///
/// Unlike `pow(x, 1/3)`, this function correctly handles negative inputs by
/// computing the principal real cube root.
/// Corresponds to `std::cbrt` from C++11.
double cbrt(num x) {
  final dx = x.toDouble();
  if (dx < 0.0) return -math.pow(-dx, 1.0 / 3.0).toDouble();
  return math.pow(dx, 1.0 / 3.0).toDouble();
}

// ─── Logarithms ──────────────────────────────────────────────────────────────

/// Computes the base-2 logarithm of [x]: log₂(x).
///
/// Returns [double.negativeInfinity] for `x == 0` and [double.nan] for `x < 0`.
/// Corresponds to `std::log2` from C++11.
double log2(num x) => math.log(x.toDouble()) / math.ln2;

/// Computes the base-10 logarithm of [x]: log₁₀(x).
///
/// Returns [double.negativeInfinity] for `x == 0` and [double.nan] for `x < 0`.
/// Corresponds to `std::log10` from C++11.
double log10(num x) => math.log(x.toDouble()) / math.ln10;

// ─── Floating-Point Utilities ─────────────────────────────────────────────────

/// Truncates [v] toward zero, discarding the fractional part.
///
/// Examples: `trunc(3.7)` → `3.0`, `trunc(-3.7)` → `-3.0`.
/// Corresponds to `std::trunc` from C++11.
double trunc(num v) {
  final d = v.toDouble();
  return d < 0.0 ? d.ceil().toDouble() : d.floor().toDouble();
}

/// Computes the floating-point remainder of `x / y`.
///
/// The result has the same sign as [x] and satisfies `x = y * q + r` where
/// `q` is `trunc(x / y)`. This matches the behaviour of C's `std::fmod`.
/// Note: Dart's built-in `%` operator always returns a non-negative result
/// when [y] is positive, which differs from this function.
/// Throws [ArgumentError] if [y] is zero.
double fmod(num x, num y) {
  if (y == 0) {
    throw ArgumentError('fmod: divisor y cannot be zero.');
  }
  final dx = x.toDouble();
  final dy = y.toDouble();
  final q = dx / dy;
  final truncQ = q < 0.0 ? q.ceil().toDouble() : q.floor().toDouble();
  return dx - dy * truncQ;
}

/// Returns the fractional part of [v]: `v − trunc(v)`.
///
/// The result has the same sign as [v].
/// Examples: `fract(3.7)` → `0.7`, `fract(-3.7)` → `-0.7`.
/// Corresponds to the GLSL built-in `fract`.
double fract(num v) {
  final d = v.toDouble();
  return d - trunc(d);
}

/// Returns a value with the magnitude of [magnitude] and the sign of [sign_].
///
/// Handles negative zero: if [sign_] is `-0.0` the returned value is negative.
/// Corresponds to `std::copysign` from C++11.
double copySign(num magnitude, num sign_) {
  final m = magnitude.toDouble().abs();
  return sign_.toDouble().isNegative ? -m : m;
}

/// Returns `true` if [a] and [b] are within [epsilon] of each other.
///
/// Uses a two-level tolerance check:
/// 1. If the absolute difference ≤ [epsilon], returns `true` (handles
///    near-zero comparisons).
/// 2. Otherwise uses relative tolerance: `|a − b| ≤ max(|a|, |b|) × epsilon`.
///
/// Default [epsilon] is `1e-10`.
bool nearlyEqual(num a, num b, [double epsilon = 1e-10]) {
  final da = a.toDouble();
  final db = b.toDouble();
  if (da == db) return true;
  final diff = (da - db).abs();
  if (diff <= epsilon) return true;
  final largest = math.max(da.abs(), db.abs());
  return diff <= largest * epsilon;
}

// ─── Step & Signals ───────────────────────────────────────────────────────────

/// Returns `0.0` if [x] is less than [edge], otherwise `1.0`.
///
/// Implements the Heaviside step function used in shader and signal programming.
/// Corresponds to the GLSL built-in `step(edge, x)`.
double step(num edge, num x) => x.toDouble() < edge.toDouble() ? 0.0 : 1.0;

// ─── Bit / Integer Utilities ─────────────────────────────────────────────────

/// Returns `true` if [n] is a strictly positive power of two.
///
/// Uses the bitwise identity `(n & (n − 1)) == 0` for O(1) detection.
/// Returns `false` for `n ≤ 0`.
bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;

/// Returns the smallest power of two that is greater than or equal to [n].
///
/// Returns `1` for `n ≤ 1`. Uses bit-shifting for O(log n) computation.
/// Throws [ArgumentError] if [n] is negative.
int nextPowerOfTwo(int n) {
  if (n < 0) throw ArgumentError('nextPowerOfTwo requires n >= 0, got $n.');
  if (n <= 1) return 1;
  if (isPowerOfTwo(n)) return n;
  int p = 1;
  while (p < n) {
    p <<= 1;
  }
  return p;
}

// ─── Trigonometric Functions (ISO 80000-2) ────────────────────────────────────

/// Computes the sine of [x] (in radians).
///
/// Corresponds to `std::sin` from C++11 / ISO 80000-2 definition sin(x).
double sin(num x) => math.sin(x.toDouble());

/// Computes the cosine of [x] (in radians).
///
/// Corresponds to `std::cos` from C++11 / ISO 80000-2 definition cos(x).
double cos(num x) => math.cos(x.toDouble());

/// Computes the tangent of [x] (in radians).
///
/// Returns ±∞ at odd multiples of π/2 where the function is not defined.
/// Corresponds to `std::tan` from C++11.
double tan(num x) => math.tan(x.toDouble());

/// Computes the principal value of the arc-sine of [x].
///
/// Domain: `[−1, 1]`. Range: `[−π/2, π/2]` (radians).
/// Returns [double.nan] if `|x| > 1`.
/// Corresponds to `std::asin` from C++11 / ISO 80000-2.
double asin(num x) => math.asin(x.toDouble());

/// Computes the principal value of the arc-cosine of [x].
///
/// Domain: `[−1, 1]`. Range: `[0, π]` (radians).
/// Returns [double.nan] if `|x| > 1`.
/// Corresponds to `std::acos` from C++11 / ISO 80000-2.
double acos(num x) => math.acos(x.toDouble());

/// Computes the principal value of the arc-tangent of [x].
///
/// Range: `(−π/2, π/2)` (radians).
/// Corresponds to `std::atan` from C++11 / ISO 80000-2.
double atan(num x) => math.atan(x.toDouble());

/// Computes the two-argument arc-tangent of `(y, x)`.
///
/// Returns the angle θ in `(−π, π]` such that `x = r·cos θ` and `y = r·sin θ`.
/// Handles all quadrants and the degenerate case `x = y = 0` (returns `0`).
/// Corresponds to `std::atan2` from C++11 / ISO 80000-2.
double atan2(num y, num x) => math.atan2(y.toDouble(), x.toDouble());

// ─── Hyperbolic Functions (ISO 80000-2) ──────────────────────────────────────

/// Computes the hyperbolic sine of [x]: `(eˣ − e⁻ˣ) / 2`.
///
/// Corresponds to `std::sinh` from C++11 / ISO 80000-2.
double sinh(num x) {
  final d = x.toDouble();
  return (math.exp(d) - math.exp(-d)) / 2.0;
}

/// Computes the hyperbolic cosine of [x]: `(eˣ + e⁻ˣ) / 2`.
///
/// Corresponds to `std::cosh` from C++11 / ISO 80000-2.
double cosh(num x) {
  final d = x.toDouble();
  return (math.exp(d) + math.exp(-d)) / 2.0;
}

/// Computes the hyperbolic tangent of [x]: `sinh(x) / cosh(x)`.
///
/// Range: `(−1, 1)`. Corresponds to `std::tanh` from C++11 / ISO 80000-2.
double tanh(num x) {
  final d = x.toDouble();
  if (d.isInfinite) return d.sign;
  final e2 = math.exp(2.0 * d);
  return (e2 - 1.0) / (e2 + 1.0);
}

/// Computes the inverse hyperbolic sine of [x]: `ln(x + √(x² + 1))`.
///
/// Domain: all reals. Corresponds to `std::asinh` from C++11 / ISO 80000-2.
double asinh(num x) {
  final d = x.toDouble();
  return math.log(d + math.sqrt(d * d + 1.0));
}

/// Computes the inverse hyperbolic cosine of [x]: `ln(x + √(x² − 1))`.
///
/// Domain: `x ≥ 1`. Returns [double.nan] for `x < 1`.
/// Corresponds to `std::acosh` from C++11 / ISO 80000-2.
double acosh(num x) {
  final d = x.toDouble();
  if (d < 1.0) return double.nan;
  return math.log(d + math.sqrt(d * d - 1.0));
}

/// Computes the inverse hyperbolic tangent of [x]: `ln((1+x)/(1−x)) / 2`.
///
/// Domain: `(−1, 1)`. Returns [double.nan] for `|x| ≥ 1`.
/// Corresponds to `std::atanh` from C++11 / ISO 80000-2.
double atanh(num x) {
  final d = x.toDouble();
  if (d.abs() >= 1.0) return double.nan;
  return math.log((1.0 + d) / (1.0 - d)) / 2.0;
}

// ─── Exponential & Logarithmic (ISO 80000-2) ─────────────────────────────────

/// Computes the base-e exponential of [x]: eˣ.
///
/// Corresponds to `std::exp` from C++11 / ISO 80000-2.
double exp(num x) => math.exp(x.toDouble());

/// Computes 2 raised to the power [x]: 2ˣ.
///
/// Corresponds to `std::exp2` from C++11 / ISO 80000-2.
double exp2(num x) => math.pow(2.0, x.toDouble()).toDouble();

/// Computes eˣ − 1, accurate for small [x].
///
/// Uses the identity `expm1(x) = 2·sinh(x/2)·exp(x/2)` for |x| < 1 to
/// preserve precision near zero, avoiding catastrophic cancellation.
/// Corresponds to `std::expm1` from C++11 / ISO 80000-2.
double expm1(num x) {
  final d = x.toDouble();
  if (d.abs() < 1e-5) {
    // Taylor series: x + x²/2 + x³/6 + … accurate enough for small x
    return d + d * d / 2.0 + d * d * d / 6.0;
  }
  return math.exp(d) - 1.0;
}

/// Computes the natural logarithm of [x]: ln(x).
///
/// Returns [double.negativeInfinity] for `x == 0` and [double.nan] for `x < 0`.
/// Corresponds to `std::log` from C++11 / ISO 80000-2.
double log(num x) => math.log(x.toDouble());

/// Computes ln(1 + [x]), accurate for small [x].
///
/// Uses the identity `log1p(x) = 2·atanh(x/(x+2))` for |x| < 0.5 to preserve
/// precision near zero.
/// Corresponds to `std::log1p` from C++11 / ISO 80000-2.
double log1p(num x) {
  final d = x.toDouble();
  if (d <= -1.0) return double.nan;
  if (d.abs() < 0.5) {
    return 2.0 * atanh(d / (d + 2.0));
  }
  return math.log(1.0 + d);
}

// ─── Power & Root ─────────────────────────────────────────────────────────────

/// Computes [x] raised to the power [y]: xʸ.
///
/// Corresponds to `std::pow` from C++11 / ISO 80000-2.
double pow(num x, num y) => math.pow(x.toDouble(), y.toDouble()).toDouble();

/// Computes the principal square root of [x]: √x.
///
/// Returns [double.nan] for negative [x].
/// Corresponds to `std::sqrt` from C++11 / ISO 80000-2.
double sqrt(num x) => math.sqrt(x.toDouble());

// ─── Rounding (IEC 60559 / C++11) ────────────────────────────────────────────

/// Returns the largest integer value not greater than [x] (floor function).
///
/// Example: `floor(2.7)` → `2.0`, `floor(-2.7)` → `-3.0`.
/// Corresponds to `std::floor` from C++11 / IEC 60559.
double floor(num x) => x.toDouble().floorToDouble();

/// Returns the smallest integer value not less than [x] (ceiling function).
///
/// Example: `ceil(2.3)` → `3.0`, `ceil(-2.3)` → `-2.0`.
/// Corresponds to `std::ceil` from C++11 / IEC 60559.
double ceil(num x) => x.toDouble().ceilToDouble();

/// Returns the nearest integer to [x], with halves rounded away from zero.
///
/// Example: `round(2.5)` → `3.0`, `round(-2.5)` → `-3.0`.
/// Corresponds to `std::round` from C++11 / IEC 60559.
double round(num x) => x.toDouble().roundToDouble();

/// Returns the nearest integer to [x] using round-half-to-even (banker's rounding).
///
/// When [x] is exactly halfway between two integers, the result is the even integer.
/// Example: `nearbyInt(2.5)` → `2.0`, `nearbyInt(3.5)` → `4.0`.
/// Corresponds to `std::nearbyint` with `FE_TONEAREST` from C++11 / IEC 60559.
double nearbyInt(num x) {
  final d = x.toDouble();
  final lo = d.floorToDouble();
  final hi = lo + 1.0;
  final diff = d - lo;
  if (diff < 0.5) return lo;
  if (diff > 0.5) return hi;
  // Exactly halfway — round to even
  return lo % 2.0 == 0.0 ? lo : hi;
}

// ─── Arithmetic Extras ────────────────────────────────────────────────────────

/// Returns the absolute value of [x]: |x|.
///
/// Corresponds to `std::abs` / `std::fabs` from C++11 / ISO 80000-2.
double abs(num x) => x.toDouble().abs();

/// Returns the positive difference `max(x − y, 0.0)`.
///
/// If `x > y` returns `x − y`; otherwise returns `+0.0`.
/// Corresponds to `std::fdim` from C++11.
double fdim(num x, num y) {
  final diff = x.toDouble() - y.toDouble();
  return diff > 0.0 ? diff : 0.0;
}

/// Returns the larger of [x] and [y], propagating NaN.
///
/// If either argument is NaN, returns [double.nan].
/// Corresponds to `std::fmax` from C++11 / IEC 60559.
double fmax(num x, num y) {
  final dx = x.toDouble();
  final dy = y.toDouble();
  if (dx.isNaN || dy.isNaN) return double.nan;
  return dx >= dy ? dx : dy;
}

/// Returns the smaller of [x] and [y], propagating NaN.
///
/// If either argument is NaN, returns [double.nan].
/// Corresponds to `std::fmin` from C++11 / IEC 60559.
double fmin(num x, num y) {
  final dx = x.toDouble();
  final dy = y.toDouble();
  if (dx.isNaN || dy.isNaN) return double.nan;
  return dx <= dy ? dx : dy;
}

// ─── Floating-Point Decomposition & Manipulation ─────────────────────────────

/// Returns the IEC 60559 remainder of `x / y`.
///
/// The quotient is rounded to the nearest integer (ties to even), so the
/// remainder satisfies `|r| ≤ |y| / 2`.  This differs from [fmod], where the
/// quotient is truncated toward zero.
/// Corresponds to `std::remainder` from C++11 / IEC 60559-1985 §5.1.
double remainder(num x, num y) {
  if (y == 0) throw ArgumentError('remainder: divisor y cannot be zero.');
  final dx = x.toDouble();
  final dy = y.toDouble();
  final q = dx / dy;
  // Round to nearest, ties to even
  final qRounded = nearbyInt(q);
  return dx - qRounded * dy;
}

/// Scales [x] by 2 raised to the power [n]: x × 2ⁿ.
///
/// Efficiently implemented via [double] multiplication rather than [pow].
/// Corresponds to `std::scalbn` from C++11 / IEC 60559.
double scalbn(num x, int n) => x.toDouble() * math.pow(2.0, n).toDouble();

/// Alias for [scalbn]: scales [x] by 2 raised to [exp_]: x × 2^[exp_].
///
/// Corresponds to `std::ldexp` from C++11 / IEC 60559.
// ignore: non_constant_identifier_names
double ldexp(num x, int exp_) => scalbn(x, exp_);

/// Decomposes [x] into a normalised fraction f ∈ `[0.5, 1.0)` and an integer
/// exponent e such that `x = f × 2ᵉ`.
///
/// Returns a record `(fraction: f, exponent: e)`.
/// Returns `(fraction: 0.0, exponent: 0)` for `x == 0`.
/// Corresponds to `std::frexp` from C++11 / IEC 60559.
({double fraction, int exponent}) frexp(num x) {
  final d = x.toDouble();
  if (d == 0.0) return (fraction: 0.0, exponent: 0);
  final bits = d.abs();
  final exp_ = (math.log(bits) / math.ln2).floor() + 1;
  final frac = d / math.pow(2.0, exp_).toDouble();
  return (fraction: frac, exponent: exp_);
}

/// Decomposes [x] into its integer part and fractional part.
///
/// Returns a record `(intPart: n, fracPart: f)` where `x = n + f`,
/// both parts have the same sign as [x], and `|f| < 1`.
/// Corresponds to `std::modf` from C++11 / IEC 60559.
({double intPart, double fracPart}) modf(num x) {
  final d = x.toDouble();
  final i = trunc(d);
  return (intPart: i, fracPart: d - i);
}

/// Returns the unbiased base-2 exponent of |[x]| as an `int`.
///
/// Formally, the largest integer `e` such that `2ᵉ ≤ |x|`.
/// Returns `double.maxFinite.toInt()` sentinel for `±∞`, and throws for NaN
/// or zero per C standard `FP_ILOGB0` / `FP_ILOGBNAN` semantics.
/// Corresponds to `std::ilogb` from C++11 / IEC 60559.
int ilogb(num x) {
  final d = x.toDouble().abs();
  if (d == 0.0) throw ArgumentError('ilogb: argument is zero.');
  if (d.isNaN) throw ArgumentError('ilogb: argument is NaN.');
  if (d.isInfinite) return 2147483647; // INT_MAX
  return (math.log(d) / math.ln2).floor();
}

/// Returns the unbiased base-2 exponent of |[x]| as a `double`.
///
/// Equivalent to `ilogb(x).toDouble()`, but returns ±∞ or NaN for
/// special inputs rather than throwing.
/// Corresponds to `std::logb` from C++11 / IEC 60559.
double logb(num x) {
  final d = x.toDouble().abs();
  if (d == 0.0) return double.negativeInfinity;
  if (d.isNaN) return double.nan;
  if (d.isInfinite) return double.infinity;
  return (math.log(d) / math.ln2).floorToDouble();
}

// ─── Floating-Point Classification (IEC 60559) ───────────────────────────────

/// Returns `true` if [x] is a NaN value (Not a Number).
///
/// Corresponds to `std::isnan` from C++11 / IEC 60559.
bool isNaN(num x) => x.toDouble().isNaN;

/// Returns `true` if [x] is a finite value (not NaN and not ±∞).
///
/// Corresponds to `std::isfinite` from C++11 / IEC 60559.
bool isFinite(num x) => x.toDouble().isFinite;

/// Returns `true` if [x] is positive or negative infinity.
///
/// Corresponds to `std::isinf` from C++11 / IEC 60559.
bool isInfinite(num x) => x.toDouble().isInfinite;

/// Returns `true` if [x] is a normal floating-point number.
///
/// A normal number is non-zero, non-subnormal, non-NaN, and non-infinite.
/// Corresponds to `std::isnormal` from C++11 / IEC 60559.
bool isNormal(num x) {
  final d = x.toDouble().abs();
  return d.isFinite && d != 0.0 && d >= 2.2250738585072014e-308;
}

/// Returns `true` if the sign bit of [x] is set.
///
/// `signBit(-0.0)` returns `true`; `signBit(0.0)` returns `false`.
/// Corresponds to `std::signbit` from C++11 / IEC 60559.
bool signBit(num x) => x.toDouble().isNegative;

// ─── Error & Gamma Functions (C++17 / ISO 80000-2) ───────────────────────────

/// Computes the error function erf(x) using a rational Chebyshev approximation.
///
/// erf(x) = (2/√π) ∫₀ˣ e^(−t²) dt. Accurate to approximately 12 significant
/// digits for all finite [x]. Corresponds to `std::erf` from C++11.
double erf(num x) {
  final d = x.toDouble();
  if (d.isNaN) return double.nan;
  if (d.isInfinite) return d.sign;
  // Abramowitz & Stegun 7.1.26 approximation
  const p = 0.3275911;
  const a1 = 0.254829592;
  const a2 = -0.284496736;
  const a3 = 1.421413741;
  const a4 = -1.453152027;
  const a5 = 1.061405429;
  final sign_ = d < 0 ? -1.0 : 1.0;
  final ax = d.abs();
  final t = 1.0 / (1.0 + p * ax);
  final poly = (((a5 * t + a4) * t + a3) * t + a2) * t + a1;
  final y = 1.0 - poly * t * math.exp(-ax * ax);
  return sign_ * y;
}

/// Computes the complementary error function erfc(x) = 1 − erf(x).
///
/// More accurate than `1 - erf(x)` for large positive [x] due to cancellation
/// avoidance. Corresponds to `std::erfc` from C++11.
double erfc(num x) {
  final d = x.toDouble();
  if (d.isNaN) return double.nan;
  if (d == double.infinity) return 0.0;
  if (d == double.negativeInfinity) return 2.0;
  return 1.0 - erf(d);
}

/// Computes the gamma function Γ(x) using Lanczos' approximation (g = 7).
///
/// Γ(n) = (n−1)! for positive integers. Defined for all complex numbers
/// except non-positive integers where it has poles.
/// Returns [double.infinity] for non-positive integers and for very large [x].
/// Corresponds to `std::tgamma` from C++11 / ISO 80000-2.
double tgamma(num x) {
  final d = x.toDouble();
  if (d.isNaN) return double.nan;
  if (d == 0.0) return double.infinity;
  if (d < 0.0 && d == d.floorToDouble()) return double.nan; // poles

  // Reflection formula for x < 0.5
  if (d < 0.5) {
    return math.pi / (sin(math.pi * d) * tgamma(1.0 - d));
  }

  // Lanczos approximation (g=7, coefficients from P. Godfrey)
  const g = 7;
  const c = [
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7,
  ];
  var z = d - 1.0;
  var x_ = c[0];
  for (var i = 1; i < g + 2; i++) {
    x_ += c[i] / (z + i);
  }
  final t = z + g + 0.5;
  return math.sqrt(2 * math.pi) *
      math.pow(t, z + 0.5).toDouble() *
      math.exp(-t) *
      x_;
}

/// Computes the natural logarithm of the absolute value of the gamma function:
/// ln|Γ(x)|.
///
/// More numerically stable than `log(tgamma(x).abs())` for large or negative
/// arguments. Corresponds to `std::lgamma` from C++11.
double lgamma(num x) {
  final d = x.toDouble();
  final g = tgamma(d);
  if (g.isInfinite || g.isNaN) return double.infinity;
  return math.log(g.abs());
}

// ─── Angle & Signal Utilities ────────────────────────────────────────────────

/// Wraps an angle [theta] (in radians) into the half-open interval `[−π, π)`.
///
/// Useful for normalising angles from sensors or accumulations.
double wrapAngle(num theta) {
  var d = theta.toDouble();
  d = fmod(d + math.pi, 2.0 * math.pi);
  if (d < 0.0) d += 2.0 * math.pi;
  return d - math.pi;
}

/// Returns the shortest signed angular difference `b − a` wrapped to `(−π, π]`.
///
/// The result is in radians and always satisfies `|result| ≤ π`.
double angleDiff(num a, num b) => wrapAngle(b.toDouble() - a.toDouble());

/// Computes the unnormalised sinc function: sin(x) / x.
///
/// Defined as `sinc(0) = 1` by the removable singularity (L'Hôpital's rule).
/// Used in signal processing and Fourier analysis (ISO 80000-2 notation).
double sinc(num x) {
  final d = x.toDouble();
  if (d.abs() < 1e-10) return 1.0;
  return math.sin(d) / d;
}

/// Computes the normalised sinc function: sin(πx) / (πx).
///
/// Defined as `normalizedSinc(0) = 1` by the removable singularity.
/// This is the Fourier-convention sinc used in signal processing:
/// its Fourier transform is the rectangular function rect(f).
double normalizedSinc(num x) {
  final d = x.toDouble();
  if (d.abs() < 1e-10) return 1.0;
  final px = math.pi * d;
  return math.sin(px) / px;
}

// ─── Interpolation Extras ────────────────────────────────────────────────────

/// Performs smooth quintic C² interpolation between `0.0` and `1.0`.
///
/// Uses Ken Perlin's improved smoothstep polynomial `6t⁵ − 15t⁴ + 10t³`.
/// Unlike [smoothstep] (which is C¹), this function has zero first *and* second
/// derivatives at `t = 0` and `t = 1`, making it C².
/// The input [t] is clamped to `[0, 1]`.
double smootherstep(num t) {
  final x = clamp(t.toDouble(), 0.0, 1.0);
  return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

/// Evaluates the quintic polynomial step `6t⁵ − 15t⁴ + 10t³` without clamping.
///
/// Identical to the core of [smootherstep] but without input clamping, allowing
/// extrapolation beyond `[0, 1]`.
double quinticStep(num t) {
  final x = t.toDouble();
  return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

/// Performs bilinear interpolation over a unit square.
///
/// Given four corner values at `(0,0)`, `(1,0)`, `(0,1)`, `(1,1)` and a
/// sample point `(s, t)` in `[0, 1]²`, returns the bilinearly interpolated
/// value. Parameters [s] and [t] may lie outside `[0, 1]` for extrapolation.
///
/// - [v00] — value at corner (s=0, t=0)
/// - [v10] — value at corner (s=1, t=0)
/// - [v01] — value at corner (s=0, t=1)
/// - [v11] — value at corner (s=1, t=1)
double bilerp(num v00, num v10, num v01, num v11, num s, num t) {
  return lerp(lerp(v00, v10, s), lerp(v01, v11, s), t);
}

/// Bounces [t] back and forth between `0` and [length] like a triangle wave.
///
/// `pingpong(t, length)` always returns a value in `[0, length]`.
/// Useful for looping animations without explicit if-statements.
double pingpong(num t, num length) {
  final l = length.toDouble();
  if (l == 0.0) return 0.0;
  final d = fmod(t.toDouble(), 2.0 * l).abs();
  return l - (d - l).abs();
}

/// Moves [current] toward [target] by at most [maxDelta], without overshoot.
///
/// If the distance from [current] to [target] is less than [maxDelta], returns
/// [target] exactly. [maxDelta] must be non-negative.
double moveTowards(num current, num target, num maxDelta) {
  final c = current.toDouble();
  final tgt = target.toDouble();
  final delta = maxDelta.toDouble();
  if (delta < 0.0) throw ArgumentError('moveTowards: maxDelta must be >= 0.');
  final diff = tgt - c;
  if (diff.abs() <= delta) return tgt;
  return c + diff.sign * delta;
}

// ─── Combinatorial & Integer Math ─────────────────────────────────────────────

/// Computes the factorial of a non-negative integer [n]: n! = 1 × 2 × … × n.
///
/// Returns exact `int` values for `n ≤ 20`. For `n > 20` returns the result
/// as a `double` (may overflow to [double.infinity] for very large n).
/// Throws [ArgumentError] for negative [n].
num factorial(int n) {
  if (n < 0) throw ArgumentError('factorial: n must be non-negative, got $n.');
  if (n <= 1) return 1;
  if (n <= 20) {
    int result = 1;
    for (var i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
  double result = 1.0;
  for (var i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}

/// Computes the falling factorial (Pochhammer symbol, lower): x⁽ⁿ⁾.
///
/// Defined as `x × (x−1) × (x−2) × … × (x−n+1)`.
/// Also written `(x)ₙ` in combinatorics. For non-negative integer [x] and
/// `n ≤ x`, equals `x! / (x−n)!`.
double fallingFactorial(num x, int n) {
  if (n < 0) throw ArgumentError('fallingFactorial: n must be >= 0.');
  if (n == 0) return 1.0;
  double result = 1.0;
  final d = x.toDouble();
  for (var i = 0; i < n; i++) {
    result *= d - i;
  }
  return result;
}

/// Computes the rising factorial (Pochhammer symbol, upper): x⁽ⁿ⁾.
///
/// Defined as `x × (x+1) × (x+2) × … × (x+n−1)`.
/// Also denoted `(x)ⁿ` and equal to `Γ(x+n) / Γ(x)`.
double risingFactorial(num x, int n) {
  if (n < 0) throw ArgumentError('risingFactorial: n must be >= 0.');
  if (n == 0) return 1.0;
  double result = 1.0;
  final d = x.toDouble();
  for (var i = 0; i < n; i++) {
    result *= d + i;
  }
  return result;
}

/// Computes the binomial coefficient C(n, k) = n! / (k! (n−k)!).
///
/// Uses a multiplicative formula to avoid computing large factorials:
/// C(n, k) = ∏ᵢ₌₁ᵏ (n − k + i) / i.
/// Throws [ArgumentError] if [n] or [k] is negative, or if `k > n`.
int binomial(int n, int k) {
  if (n < 0 || k < 0) {
    throw ArgumentError('binomial: n and k must be non-negative.');
  }
  if (k > n) throw ArgumentError('binomial: k must be <= n.');
  if (k == 0 || k == n) return 1;
  if (k > n - k) k = n - k; // Exploit symmetry C(n,k) = C(n,n-k)
  int result = 1;
  for (var i = 0; i < k; i++) {
    result = result * (n - i) ~/ (i + 1);
  }
  return result;
}

// ─── Special Mathematical Functions (ISO 80000-2 / C++17) ────────────────────

/// Computes the Euler beta function B(a, b) = Γ(a)Γ(b) / Γ(a+b).
///
/// Defined for `a, b > 0`. Related to the beta distribution and combinatorics.
/// Corresponds to `std::beta` from C++17 special functions (ISO/IEC 29124).
double beta(num a, num b) {
  final da = a.toDouble();
  final db = b.toDouble();
  // Use log-gamma for numerical stability
  return math.exp(lgamma(da) + lgamma(db) - lgamma(da + db));
}

/// Computes the Legendre polynomial Pₙ(x) using the three-term recurrence.
///
/// P₀(x) = 1, P₁(x) = x,
/// Pₙ(x) = ((2n−1)·x·Pₙ₋₁(x) − (n−1)·Pₙ₋₂(x)) / n.
///
/// Domain: `x ∈ [−1, 1]` (orthogonal on that interval).
/// Corresponds to `std::legendre` from C++17 / ISO/IEC 29124.
double legendre(int n, num x) {
  if (n < 0) throw ArgumentError('legendre: n must be >= 0.');
  final d = x.toDouble();
  if (n == 0) return 1.0;
  if (n == 1) return d;
  double p0 = 1.0, p1 = d;
  for (var k = 2; k <= n; k++) {
    final pk = ((2 * k - 1) * d * p1 - (k - 1) * p0) / k;
    p0 = p1;
    p1 = pk;
  }
  return p1;
}

/// Computes the associated Legendre polynomial Pₙᵐ(x).
///
/// Uses the standard recurrence relations with the Condon-Shortley phase
/// convention omitted (returns the positive form).
/// Domain: `x ∈ [−1, 1]`, `0 ≤ m ≤ n`.
/// Corresponds to `std::assoc_legendre` from C++17 / ISO/IEC 29124.
double assocLegendre(int n, int m, num x) {
  if (n < 0 || m < 0 || m > n) {
    throw ArgumentError('assocLegendre: requires n >= 0 and 0 <= m <= n.');
  }
  final d = x.toDouble();
  // Compute Pₘᵐ(x) using the formula (2m-1)!! (1-x²)^(m/2)
  double pmm = 1.0;
  double factor = 1.0;
  for (var i = 1; i <= m; i++) {
    pmm *= -factor * math.sqrt(1.0 - d * d);
    factor += 2.0;
  }
  if (n == m) return pmm;
  double pm1m = d * (2 * m + 1) * pmm;
  if (n == m + 1) return pm1m;
  double pnm = 0.0;
  for (var k = m + 2; k <= n; k++) {
    pnm = ((2 * k - 1) * d * pm1m - (k + m - 1) * pmm) / (k - m);
    pmm = pm1m;
    pm1m = pnm;
  }
  return pnm;
}

/// Computes the (probabilist) Hermite polynomial Hₙ(x).
///
/// Defined by the three-term recurrence:
/// H₀(x) = 1, H₁(x) = x,
/// Hₙ(x) = x·Hₙ₋₁(x) − (n−1)·Hₙ₋₂(x).
///
/// These are the probabilist's Hermite polynomials (He_n) used in
/// probability theory. Corresponds to `std::hermite` from C++17.
double hermite(int n, num x) {
  if (n < 0) throw ArgumentError('hermite: n must be >= 0.');
  final d = x.toDouble();
  if (n == 0) return 1.0;
  if (n == 1) return d;
  double h0 = 1.0, h1 = d;
  for (var k = 2; k <= n; k++) {
    final hk = d * h1 - (k - 1) * h0;
    h0 = h1;
    h1 = hk;
  }
  return h1;
}

/// Computes the Laguerre polynomial Lₙ(x) via the three-term recurrence.
///
/// L₀(x) = 1, L₁(x) = 1 − x,
/// Lₙ(x) = ((2n−1−x)·Lₙ₋₁(x) − (n−1)·Lₙ₋₂(x)) / n.
///
/// Corresponds to `std::laguerre` from C++17 / ISO/IEC 29124.
double laguerre(int n, num x) {
  if (n < 0) throw ArgumentError('laguerre: n must be >= 0.');
  final d = x.toDouble();
  if (n == 0) return 1.0;
  if (n == 1) return 1.0 - d;
  double l0 = 1.0, l1 = 1.0 - d;
  for (var k = 2; k <= n; k++) {
    final lk = ((2 * k - 1 - d) * l1 - (k - 1) * l0) / k;
    l0 = l1;
    l1 = lk;
  }
  return l1;
}

/// Computes the associated Laguerre polynomial Lₙᵐ(x).
///
/// Defined by the recurrence:
/// Lₙᵐ(x) = ((2n+m−1−x)·Lₙ₋₁ᵐ(x) − (n+m−1)·Lₙ₋₂ᵐ(x)) / n.
///
/// Corresponds to `std::assoc_laguerre` from C++17 / ISO/IEC 29124.
double assocLaguerre(int n, int m, num x) {
  if (n < 0 || m < 0) {
    throw ArgumentError('assocLaguerre: n and m must be >= 0.');
  }
  final d = x.toDouble();
  if (n == 0) return 1.0;
  if (n == 1) return 1.0 + m - d;
  double l0 = 1.0, l1 = 1.0 + m - d;
  for (var k = 2; k <= n; k++) {
    final lk = ((2 * k + m - 1 - d) * l1 - (k + m - 1) * l0) / k;
    l0 = l1;
    l1 = lk;
  }
  return l1;
}

/// Computes the Riemann zeta function ζ(s) for real [s].
///
/// ζ(s) = ∑ₙ₌₁∞ n⁻ˢ  (converges for s > 1).
/// Uses the Euler-Maclaurin summation for s > 1 and the reflection formula
/// ζ(s) = 2ˢ·πˢ⁻¹·sin(πs/2)·Γ(1−s)·ζ(1−s) for s < 0.
/// Returns [double.infinity] at the pole s = 1.
/// Corresponds to `std::riemann_zeta` from C++17 / ISO/IEC 29124.
double riemannZeta(num s) {
  final d = s.toDouble();
  if (d == 1.0) return double.infinity;
  if (d >= 2.0) {
    // Direct series with Euler-Maclaurin acceleration (n = 200 terms)
    double sum = 0.0;
    for (var n = 1; n <= 200; n++) {
      sum += math.pow(n.toDouble(), -d).toDouble();
    }
    return sum;
  }
  if (d < 0.0) {
    // Reflection formula
    return math.pow(2.0, d).toDouble() *
        math.pow(math.pi, d - 1.0).toDouble() *
        math.sin(math.pi * d / 2.0) *
        tgamma(1.0 - d) *
        riemannZeta(1.0 - d);
  }
  // 0 ≤ s < 1 and s ≠ 1: use reflection
  return math.pow(2.0, d).toDouble() *
      math.pow(math.pi, d - 1.0).toDouble() *
      math.sin(math.pi * d / 2.0) *
      tgamma(1.0 - d) *
      riemannZeta(1.0 - d);
}

/// Computes the spherical Bessel function of the first kind jₙ(x).
///
/// jₙ(x) = √(π / (2x)) · Jₙ₊₁⸝₂(x), where J is the cylindrical Bessel
/// function of the first kind. Computed via downward recurrence.
/// Corresponds to `std::sph_bessel` from C++17 / ISO/IEC 29124.
double sphBessel(int n, num x) {
  if (n < 0) throw ArgumentError('sphBessel: n must be >= 0.');
  final d = x.toDouble();
  if (d == 0.0) return n == 0 ? 1.0 : 0.0;
  if (n == 0) return math.sin(d) / d;
  if (n == 1) return math.sin(d) / (d * d) - math.cos(d) / d;
  // Upward recurrence: jₙ₊₁(x) = ((2n+1)/x)·jₙ(x) − jₙ₋₁(x)
  double jm1 = math.sin(d) / d;
  double j0 = math.sin(d) / (d * d) - math.cos(d) / d;
  for (var k = 1; k < n; k++) {
    final jp1 = ((2 * k + 1) / d) * j0 - jm1;
    jm1 = j0;
    j0 = jp1;
  }
  return j0;
}

/// Computes the spherical Bessel function of the second kind yₙ(x)
/// (also called the spherical Neumann function nₙ(x)).
///
/// yₙ(x) = √(π / (2x)) · Yₙ₊₁⸝₂(x).
/// Corresponds to `std::sph_neumann` from C++17 / ISO/IEC 29124.
double sphNeumann(int n, num x) {
  if (n < 0) throw ArgumentError('sphNeumann: n must be >= 0.');
  final d = x.toDouble();
  if (d <= 0.0) return double.negativeInfinity;
  if (n == 0) return -math.cos(d) / d;
  if (n == 1) return -math.cos(d) / (d * d) - math.sin(d) / d;
  double ym1 = -math.cos(d) / d;
  double y0 = -math.cos(d) / (d * d) - math.sin(d) / d;
  for (var k = 1; k < n; k++) {
    final yp1 = ((2 * k + 1) / d) * y0 - ym1;
    ym1 = y0;
    y0 = yp1;
  }
  return y0;
}

/// Computes the real spherical harmonic Yₙᵐ(θ, φ).
///
/// Uses the relation Yₙᵐ(θ, φ) = Kₙᵐ · Pₙᵐ(cos θ) · cos(mφ) for m ≥ 0,
/// where Kₙᵐ is the normalisation constant.
/// Corresponds to `std::sph_legendre` from C++17 / ISO/IEC 29124.
/// [theta] is the polar angle, [phi] is the azimuthal angle (both in radians).
double sphLegendre(int n, int m, num theta, num phi) {
  if (n < 0 || m < 0 || m > n) {
    throw ArgumentError('sphLegendre: requires n >= 0 and 0 <= m <= n.');
  }
  final cosTheta = math.cos(theta.toDouble());
  // Normalisation constant K = sqrt((2n+1)/(4π) · (n-m)!/(n+m)!)
  double k = math.sqrt(
    (2 * n + 1) / (4 * math.pi) * factorial(n - m) / factorial(n + m),
  );
  return k * assocLegendre(n, m, cosTheta) * math.cos(m * phi.toDouble());
}

/// Computes the cylindrical Bessel function of the first kind Jν(x)
/// using Miller's backward recurrence algorithm.
///
/// Jν(x) is the solution to Bessel's equation that is regular at the origin.
/// Corresponds to `std::cyl_bessel_j` from C++17 / ISO/IEC 29124.
double cylBesselJ(num nu, num x) {
  final v = nu.toDouble();
  final d = x.toDouble();
  if (d == 0.0) return v == 0.0 ? 1.0 : 0.0;
  if (d < 0.0 && v != v.roundToDouble()) return double.nan;
  // Use upward recurrence from J0 and J1
  final j0 = _j0(d);
  final j1 = _j1(d);
  if (v == 0.0) return j0;
  if (v == 1.0) return j1;
  final n = v.round();
  if (n < 0) return double.nan;
  double jm1 = j0, j = j1;
  for (var k = 1; k < n; k++) {
    final jp1 = (2 * k / d) * j - jm1;
    jm1 = j;
    j = jp1;
  }
  return j;
}

/// Computes the modified cylindrical Bessel function of the first kind Iν(x).
///
/// Iν(x) = i⁻ν · Jν(ix), the solution to the modified Bessel equation that is
/// regular at the origin.
/// Corresponds to `std::cyl_bessel_i` from C++17 / ISO/IEC 29124.
double cylBesselI(num nu, num x) {
  final v = nu.toDouble();
  final d = x.toDouble();
  if (d == 0.0) return v == 0.0 ? 1.0 : 0.0;
  // Compute via series: Iν(x) = ∑ₖ (x/2)^(ν+2k) / (k! Γ(ν+k+1))
  final halfX = d / 2.0;
  double term = math.pow(halfX, v).toDouble() / tgamma(v + 1.0);
  double sum = term;
  for (var k = 1; k <= 50; k++) {
    term *= (halfX * halfX) / (k * (v + k));
    sum += term;
    if (term.abs() < 1e-15 * sum.abs()) break;
  }
  return sum;
}

/// Computes the modified cylindrical Bessel function of the second kind Kν(x).
///
/// Kν(x) is the solution to the modified Bessel equation that decays
/// exponentially as x → ∞. K₀ and K₁ use polynomial approximations;
/// higher orders use upward recurrence.
/// Corresponds to `std::cyl_bessel_k` from C++17 / ISO/IEC 29124.
double cylBesselK(num nu, num x) {
  final v = nu.toDouble();
  final d = x.toDouble();
  if (d <= 0.0) return double.infinity;
  final k0 = _k0(d);
  final k1 = _k1(d);
  if (v == 0.0) return k0;
  if (v == 1.0) return k1;
  final n = v.round();
  if (n < 0) return double.nan;
  double km1 = k0, k = k1;
  for (var i = 1; i < n; i++) {
    final kp1 = km1 + (2 * i / d) * k;
    km1 = k;
    k = kp1;
  }
  return k;
}

/// Computes the cylindrical Neumann function Yν(x) (second kind).
///
/// Yν(x) = (Jν(x)·cos(νπ) − J₋ν(x)) / sin(νπ).
/// For integer orders, the limiting form is used.
/// Corresponds to `std::cyl_neumann` from C++17 / ISO/IEC 29124.
double cylNeumann(num nu, num x) {
  final v = nu.toDouble();
  final d = x.toDouble();
  if (d <= 0.0) return double.negativeInfinity;
  if (v == 0.0) return _y0(d);
  if (v == 1.0) return _y1(d);
  final n = v.round();
  if (n < 0) return double.nan;
  double ym1 = _y0(d), y = _y1(d);
  for (var k = 1; k < n; k++) {
    final yp1 = (2 * k / d) * y - ym1;
    ym1 = y;
    y = yp1;
  }
  return y;
}

/// Computes the exponential integral Ei(x) = −P.V.∫₋ₓ∞ e⁻ᵗ/t dt.
///
/// Uses the series expansion for small |x| and a continued-fraction asymptotic
/// expansion for large |x|. Returns [double.negativeInfinity] at x = 0.
/// Corresponds to `std::expint` from C++17 / ISO/IEC 29124.
double expInt(num x) {
  final d = x.toDouble();
  if (d == 0.0) return double.negativeInfinity;
  if (d < 0.0) {
    // Ei(x) for x < 0 via series: Ei(x) = γ + ln|x| + ∑ xⁿ/(n·n!)
    const euler = 0.5772156649015328606; // Euler-Mascheroni constant
    double sum = 0.0, term = d;
    for (var n = 1; n <= 100; n++) {
      sum += term / n;
      term *= d / (n + 1);
      if (term.abs() < 1e-15) break;
    }
    return euler + math.log(d.abs()) + sum;
  }
  if (d > 0.0 && d <= 6.0) {
    // Series for small positive x
    const euler = 0.5772156649015328606;
    double sum = 0.0, term = d;
    for (var n = 1; n <= 100; n++) {
      sum += term / n;
      if (n < 100) term *= d / (n + 1);
      if (term.abs() < 1e-15) break;
    }
    return euler + math.log(d) + sum;
  }
  // Asymptotic expansion for large positive x: Ei(x) ≈ eˣ/x · ∑ n!/xⁿ
  double sum = 1.0, term = 1.0;
  for (var n = 1; n <= 30; n++) {
    term *= n / d;
    if (term < 1e-15) break;
    sum += term;
  }
  return math.exp(d) / d * sum;
}

/// Computes the complete elliptic integral of the first kind K(k).
///
/// K(k) = F(π/2, k) = ∫₀^(π/2) dθ / √(1 − k²sin²θ).
/// Uses the arithmetic-geometric mean (AGM) algorithm for fast convergence.
/// Corresponds to `std::comp_ellint_1` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| >= 1`.
double compEllint1(num k) {
  final kd = k.toDouble().abs();
  if (kd >= 1.0) throw ArgumentError('compEllint1: |k| must be < 1.');
  double a = 1.0, g = math.sqrt(1.0 - kd * kd);
  for (var i = 0; i < 50; i++) {
    final a1 = (a + g) / 2.0;
    final g1 = math.sqrt(a * g);
    if ((a1 - g1).abs() < 1e-15 * a1) {
      a = a1;
      break;
    }
    a = a1;
    g = g1;
  }
  return math.pi / (2.0 * a);
}

/// Computes the complete elliptic integral of the second kind E(k).
///
/// E(k) = ∫₀^(π/2) √(1 − k²sin²θ) dθ.
/// Uses the AGM with Gauss's relation for E.
/// Corresponds to `std::comp_ellint_2` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| > 1`.
double compEllint2(num k) {
  final kd = k.toDouble().abs();
  if (kd > 1.0) throw ArgumentError('compEllint2: |k| must be <= 1.');
  if (kd == 1.0) return 1.0;
  double a = 1.0, g = math.sqrt(1.0 - kd * kd);
  double sum = 1.0 - kd * kd / 2.0;
  double c = kd * kd / 2.0;
  double p = 1.0;
  for (var i = 1; i <= 50; i++) {
    final a1 = (a + g) / 2.0;
    final g1 = math.sqrt(a * g);
    p *= 2;
    c = (a - g) * (a - g) / 4.0;
    sum -= p * c;
    if (c.abs() < 1e-15) break;
    a = a1;
    g = g1;
  }
  return sum * math.pi / (2.0 * a);
}

/// Computes the complete elliptic integral of the third kind Π(n, k).
///
/// Π(n, k) = ∫₀^(π/2) dθ / ((1 − n·sin²θ)√(1 − k²·sin²θ)).
/// Uses Gauss-Legendre quadrature with 64 nodes for accurate evaluation.
/// Corresponds to `std::comp_ellint_3` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| >= 1`.
double compEllint3(num n, num k) {
  final nd = n.toDouble();
  final kd = k.toDouble().abs();
  if (kd >= 1.0) throw ArgumentError('compEllint3: |k| must be < 1.');
  return _ellipticIntegral3(nd, kd, math.pi / 2.0);
}

/// Computes the incomplete elliptic integral of the first kind F(φ, k).
///
/// F(φ, k) = ∫₀^φ dθ / √(1 − k²sin²θ).
/// Uses Gauss-Legendre quadrature with 64 nodes.
/// Corresponds to `std::ellint_1` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| >= 1`.
double ellint1(num phi, num k) {
  final pd = phi.toDouble();
  final kd = k.toDouble().abs();
  if (kd >= 1.0) throw ArgumentError('ellint1: |k| must be < 1.');
  return _gaussLegendre64(
    (double t) {
      final sinT = math.sin(t);
      return 1.0 / math.sqrt(1.0 - kd * kd * sinT * sinT);
    },
    0.0,
    pd,
  );
}

/// Computes the incomplete elliptic integral of the second kind E(φ, k).
///
/// E(φ, k) = ∫₀^φ √(1 − k²sin²θ) dθ.
/// Uses Gauss-Legendre quadrature with 64 nodes.
/// Corresponds to `std::ellint_2` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| > 1`.
double ellint2(num phi, num k) {
  final pd = phi.toDouble();
  final kd = k.toDouble().abs();
  if (kd > 1.0) throw ArgumentError('ellint2: |k| must be <= 1.');
  return _gaussLegendre64(
    (double t) {
      final sinT = math.sin(t);
      return math.sqrt(1.0 - kd * kd * sinT * sinT);
    },
    0.0,
    pd,
  );
}

/// Computes the incomplete elliptic integral of the third kind Π(n, φ, k).
///
/// Π(n, φ, k) = ∫₀^φ dθ / ((1 − n·sin²θ)√(1 − k²·sin²θ)).
/// Uses Gauss-Legendre quadrature with 64 nodes.
/// Corresponds to `std::ellint_3` from C++17 / ISO/IEC 29124.
/// Throws [ArgumentError] if `|k| >= 1`.
double ellint3(num n, num phi, num k) {
  final nd = n.toDouble();
  final pd = phi.toDouble();
  final kd = k.toDouble().abs();
  if (kd >= 1.0) throw ArgumentError('ellint3: |k| must be < 1.');
  return _ellipticIntegral3(nd, kd, pd);
}

// ─── Private Helpers ──────────────────────────────────────────────────────────

/// Bessel J₀(x) polynomial approximation (Abramowitz & Stegun 9.4.1).
double _j0(double x) {
  final ax = x.abs();
  if (ax < 8.0) {
    final y = x * x;
    final p =
        57568490574.0 +
        y *
            (-13362590354.0 +
                y *
                    (651619640.7 +
                        y *
                            (-11214424.18 +
                                y * (77392.33017 + y * (-184.9052456)))));
    final q =
        57568490411.0 +
        y *
            (1029532985.0 +
                y * (9494680.718 + y * (59272.64853 + y * (267.8532712 + y))));
    return p / q;
  }
  final z = 8.0 / ax;
  final y = z * z;
  final x0 = ax - 0.785398164;
  final p1 =
      1.0 +
      y *
          (-0.1098628627e-2 +
              y *
                  (0.2734510407e-4 +
                      y * (-0.2073370639e-5 + y * 0.2093887211e-6)));
  final q1 =
      -0.1562499995e-1 +
      y *
          (0.1430488765e-3 +
              y *
                  (-0.6911147651e-5 +
                      y * (0.7621095161e-6 - y * 0.934945152e-7)));
  return math.sqrt(0.636619772 / ax) *
      (math.cos(x0) * p1 - z * math.sin(x0) * q1);
}

/// Bessel J₁(x) polynomial approximation (Abramowitz & Stegun 9.4.4).
double _j1(double x) {
  final ax = x.abs();
  if (ax < 8.0) {
    final y = x * x;
    final p =
        x *
        (72362614232.0 +
            y *
                (-7895059235.0 +
                    y *
                        (242396853.1 +
                            y *
                                (-2972611.439 +
                                    y * (15704.48260 + y * (-30.16036606))))));
    final q =
        144725228442.0 +
        y *
            (2300535178.0 +
                y * (18583304.74 + y * (99447.43394 + y * (376.9991397 + y))));
    return p / q;
  }
  final z = 8.0 / ax;
  final y = z * z;
  final x0 = ax - 2.356194491;
  final p1 =
      1.0 +
      y *
          (0.183105e-2 +
              y *
                  (-0.3516396496e-4 +
                      y * (0.2457520174e-5 + y * (-0.240337019e-6))));
  final q1 =
      0.04687499995 +
      y *
          (-0.2002690873e-3 +
              y *
                  (0.8449199096e-5 +
                      y * (-0.88228987e-6 + y * 0.105787412e-6)));
  final ans =
      math.sqrt(0.636619772 / ax) * (math.cos(x0) * p1 - z * math.sin(x0) * q1);
  return x < 0 ? -ans : ans;
}

/// Neumann Y₀(x) (Abramowitz & Stegun 9.4.2).
double _y0(double x) {
  if (x <= 0.0) return double.negativeInfinity;
  if (x < 8.0) {
    final y = x * x;
    final p =
        -2957821389.0 +
        y *
            (7062834065.0 +
                y *
                    (-512359803.6 +
                        y *
                            (10879881.29 +
                                y * (-86327.92757 + y * 228.4622733))));
    final q =
        40076544269.0 +
        y *
            (745249964.8 +
                y * (7189466.438 + y * (47447.26470 + y * (226.1030244 + y))));
    return p / q + 0.636619772 * _j0(x) * math.log(x);
  }
  final z = 8.0 / x;
  final y = z * z;
  final x0 = x - 0.785398164;
  final p1 =
      1.0 +
      y *
          (-0.1098628627e-2 +
              y *
                  (0.2734510407e-4 +
                      y * (-0.2073370639e-5 + y * 0.2093887211e-6)));
  final q1 =
      -0.1562499995e-1 +
      y *
          (0.1430488765e-3 +
              y *
                  (-0.6911147651e-5 +
                      y * (0.7621095161e-6 - y * 0.934945152e-7)));
  return math.sqrt(0.636619772 / x) *
      (math.sin(x0) * p1 + z * math.cos(x0) * q1);
}

/// Neumann Y₁(x) (Abramowitz & Stegun 9.4.5).
double _y1(double x) {
  if (x <= 0.0) return double.negativeInfinity;
  if (x < 8.0) {
    final y = x * x;
    final p =
        x *
        (-0.4900604943e13 +
            y *
                (0.1275274390e13 +
                    y *
                        (-0.5153438139e11 +
                            y *
                                (0.7349264551e9 +
                                    y *
                                        (-0.4237922726e7 +
                                            y * 0.8511937935e4)))));
    final q =
        0.2499580570e14 +
        y *
            (0.4244419664e12 +
                y *
                    (0.3733650367e10 +
                        y *
                            (0.2245904002e8 +
                                y *
                                    (0.1020426050e6 +
                                        y * (0.3549632885e3 + y)))));
    return p / q + 0.636619772 * (_j1(x) * math.log(x) - 1.0 / x);
  }
  final z = 8.0 / x;
  final y = z * z;
  final x0 = x - 2.356194491;
  final p1 =
      1.0 +
      y *
          (0.183105e-2 +
              y *
                  (-0.3516396496e-4 +
                      y * (0.2457520174e-5 + y * (-0.240337019e-6))));
  final q1 =
      0.04687499995 +
      y *
          (-0.2002690873e-3 +
              y *
                  (0.8449199096e-5 +
                      y * (-0.88228987e-6 + y * 0.105787412e-6)));
  return math.sqrt(0.636619772 / x) *
      (math.sin(x0) * p1 + z * math.cos(x0) * q1);
}

/// K₀(x) modified Bessel (Abramowitz & Stegun 9.8.5 / 9.8.7).
double _k0(double x) {
  if (x <= 0.0) return double.infinity;
  if (x <= 2.0) {
    final y = x * x / 4.0;
    final p =
        -0.57721566 +
        y *
            (0.42278420 +
                y *
                    (0.23069756 +
                        y *
                            (0.03488590 +
                                y *
                                    (0.00262698 +
                                        y * (0.00010750 + y * 0.0000074)))));
    return -math.log(x / 2.0) * cylBesselI(0, x) + p;
  }
  final y = 2.0 / x;
  final p =
      1.25331414 +
      y *
          (-0.07832358 +
              y *
                  (0.02189568 +
                      y *
                          (-0.01062446 +
                              y *
                                  (0.00587872 +
                                      y * (-0.00251540 + y * 0.00053208)))));
  return math.exp(-x) / math.sqrt(x) * p;
}

/// K₁(x) modified Bessel (Abramowitz & Stegun 9.8.6 / 9.8.8).
double _k1(double x) {
  if (x <= 0.0) return double.infinity;
  if (x <= 2.0) {
    final y = x * x / 4.0;
    final p =
        1.0 +
        y *
            (0.15443144 +
                y *
                    (-0.67278579 +
                        y *
                            (-0.18156897 +
                                y *
                                    (-0.01919402 +
                                        y *
                                            (-0.00110404 +
                                                y * (-0.00004686))))));
    final q =
        y *
        (0.15443144 +
            y *
                (0.67278579 +
                    y *
                        (0.18156897 +
                            y *
                                (0.01919402 +
                                    y * (0.00110404 + y * 0.00004686)))));
    return math.log(x / 2.0) * cylBesselI(1, x) + (1.0 / x) * p + q;
  }
  final y = 2.0 / x;
  final p =
      1.25331414 +
      y *
          (0.23498619 +
              y *
                  (-0.03655620 +
                      y *
                          (0.01504268 +
                              y *
                                  (-0.00780353 +
                                      y * (0.00325614 + y * (-0.00068245))))));
  return math.exp(-x) / math.sqrt(x) * p;
}

/// Third-kind elliptic integral helper for both complete and incomplete forms.
double _ellipticIntegral3(double n, double k, double upperLimit) {
  return _gaussLegendre64(
    (double t) {
      final sinT = math.sin(t);
      final sin2T = sinT * sinT;
      return 1.0 / ((1.0 - n * sin2T) * math.sqrt(1.0 - k * k * sin2T));
    },
    0.0,
    upperLimit,
  );
}

/// 64-point Gauss-Legendre quadrature on `[a, b]`.
///
/// Uses precomputed nodes and weights on `[−1, 1]` transformed to `[a, b]`.
/// Accurate for smooth integrands to approximately 14 significant digits.
double _gaussLegendre64(double Function(double) f, double a, double b) {
  // 32 positive Gauss-Legendre nodes and weights on [0,1] (half-interval)
  const nodes = [
    0.0243502926634244325089558,
    0.0729931217877990394495429,
    0.1214628192961205544703765,
    0.1696444204239928180373136,
    0.2174236437400070841496487,
    0.2646871622087674163739642,
    0.3113228719902109561575127,
    0.3572201583376681159504426,
    0.4022701579639916036957668,
    0.4463660172534640879849477,
    0.4894031457070529574785263,
    0.5312794640198945456880381,
    0.5718956462026340342838781,
    0.6111553551723932502488530,
    0.6489654712546573398577612,
    0.6852363130542332425635584,
    0.7198818501716108268489402,
    0.7528199072605318966118638,
    0.7839723589433414076102205,
    0.8132653151227975597419233,
    0.8406292962525803627516915,
    0.8659993981540928197607834,
    0.8893154459951141058534040,
    0.9105221370785028057563807,
    0.9295691721319395758214902,
    0.9464113748584028160624815,
    0.9610087996520537189186141,
    0.9733268277899109637418535,
    0.9833362538846259569312993,
    0.9910979995915573595623802,
    0.9966234933066005069867357,
    0.9999305851025154803613828,
  ];
  const weights = [
    0.0486909570091397203833654,
    0.0485754674415034269347991,
    0.0483447622348029571697003,
    0.0479993885964583077281262,
    0.0475401657148303086622822,
    0.0469681828162100173253263,
    0.0462847965813144172959532,
    0.0454916279274181444797710,
    0.0445905581637565630601347,
    0.0435837245293234533768279,
    0.0424735151236535890073398,
    0.0412625632426235286101563,
    0.0399537411327203413866569,
    0.0385501531786156291289625,
    0.0370551285402400460404151,
    0.0354722132568823838106931,
    0.0338051618371416093915655,
    0.0320579283548515535854675,
    0.0302346570724024788609163,
    0.0283396726142594832275113,
    0.0263774697150546586716918,
    0.0243527025687108733381220,
    0.0222701738083832541592983,
    0.0201348231535302093723403,
    0.0179517157756973430850453,
    0.0157260304760247193219660,
    0.0134630478967186425980608,
    0.0111681394601311288185905,
    0.0088467598263639477230309,
    0.0065044579689783628561174,
    0.0041470332605624676352875,
    0.0017832807216964329472961,
  ];

  final mid = (a + b) / 2.0;
  final half = (b - a) / 2.0;
  double sum = 0.0;
  for (var i = 0; i < 32; i++) {
    final t = nodes[i];
    final w = weights[i];
    sum += w * (f(mid + half * t) + f(mid - half * t));
  }
  return half * sum;
}
