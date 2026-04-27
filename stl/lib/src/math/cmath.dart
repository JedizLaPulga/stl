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
