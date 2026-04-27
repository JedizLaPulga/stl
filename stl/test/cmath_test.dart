import 'dart:math' as math;

// cmath exports `isNaN(num)` which clashes with the `isNaN` Matcher from
// package:test/matcher. We hide the stl symbol here and expose it via a local
// alias so every other stl name remains unqualified.
import 'package:stl/stl.dart' hide isNaN;
import 'package:stl/stl.dart' as stl show isNaN;
import 'package:test/test.dart';

/// Tolerance used for floating-point comparisons throughout this file.
const _eps = 1e-9;

/// Asserts that [actual] is within [eps] of [expected].
void approx(double actual, double expected, {double eps = _eps}) {
  if (expected.isNaN) {
    expect(actual.isNaN, isTrue, reason: 'expected NaN but got $actual');
    return;
  }
  if (expected.isInfinite) {
    expect(actual, expected);
    return;
  }
  expect(
    (actual - expected).abs(),
    lessThanOrEqualTo(eps),
    reason:
        'expected $expected but got $actual (diff ${(actual - expected).abs()})',
  );
}

void main() {
  // ─── Existing 20 functions ────────────────────────────────────────────────

  group('clamp', () {
    test('int within range', () => expect(clamp(5, 0, 10), 5));
    test('int below range', () => expect(clamp(-1, 0, 10), 0));
    test('int above range', () => expect(clamp(11, 0, 10), 10));
    test('double', () => approx(clamp(3.14, 0.0, 3.0), 3.0));
    test(
      'invalid lo > hi throws',
      () => expect(() => clamp(5, 10, 0), throwsArgumentError),
    );
  });

  group('lerp', () {
    test('midpoint', () => approx(lerp(0, 10, 0.5), 5.0));
    test('at 0', () => approx(lerp(0, 10, 0.0), 0.0));
    test('at 1', () => approx(lerp(0, 10, 1.0), 10.0));
    test('extrapolate', () => approx(lerp(0, 10, 1.5), 15.0));
  });

  group('hypot', () {
    test('3-4-5', () => approx(hypot(3, 4), 5.0));
    test('3D', () => approx(hypot(2, 3, 6), 7.0));
    test('zero', () => approx(hypot(0, 0), 0.0));
  });

  group('sign', () {
    test('positive int', () => expect(sign(5), 1));
    test('negative int', () => expect(sign(-5), -1));
    test('zero int', () => expect(sign(0), 0));
    test('positive double', () => approx(sign(3.14), 1.0));
    test('negative double', () => approx(sign(-3.14), -1.0));
  });

  group('degrees / radians', () {
    test('pi -> 180', () => approx(degrees(math.pi), 180.0));
    test('180 -> pi', () => approx(radians(180.0), math.pi));
    test('round-trip', () => approx(radians(degrees(1.23)), 1.23));
  });

  group('fma', () {
    test('2*3+4 = 10', () => approx(fma(2, 3, 4), 10.0));
    test('1.5*2+0.5 = 3.5', () => approx(fma(1.5, 2.0, 0.5), 3.5));
  });

  group('smoothstep', () {
    test('at edge0 = 0', () => approx(smoothstep(0, 1, 0.0), 0.0));
    test('at edge1 = 1', () => approx(smoothstep(0, 1, 1.0), 1.0));
    test('midpoint S-curve', () => approx(smoothstep(0, 1, 0.5), 0.5));
    test('clamps below', () => approx(smoothstep(0, 1, -1.0), 0.0));
    test('clamps above', () => approx(smoothstep(0, 1, 2.0), 1.0));
    test(
      'equal edges throws',
      () => expect(() => smoothstep(1, 1, 0.5), throwsArgumentError),
    );
  });

  group('remap', () {
    test('midpoint', () => approx(remap(5, 0, 10, 0, 100), 50.0));
    test('extrapolate', () => approx(remap(15, 0, 10, 0, 100), 150.0));
    test(
      'degenerate source throws',
      () => expect(() => remap(5, 3, 3, 0, 1), throwsArgumentError),
    );
  });

  group('saturate', () {
    test('inside', () => approx(saturate(0.4), 0.4));
    test('below 0', () => approx(saturate(-0.5), 0.0));
    test('above 1', () => approx(saturate(1.5), 1.0));
  });

  group('step', () {
    test('x < edge = 0', () => approx(step(5, 3), 0.0));
    test('x == edge = 1', () => approx(step(5, 5), 1.0));
    test('x > edge = 1', () => approx(step(5, 7), 1.0));
  });

  group('cbrt', () {
    test('cbrt(8) = 2', () => approx(cbrt(8), 2.0));
    test('cbrt(-8) = -2', () => approx(cbrt(-8), -2.0));
    test('cbrt(0) = 0', () => approx(cbrt(0), 0.0));
    test('cbrt(27) = 3', () => approx(cbrt(27), 3.0));
  });

  group('log2', () {
    test('log2(1) = 0', () => approx(log2(1), 0.0));
    test('log2(2) = 1', () => approx(log2(2), 1.0));
    test('log2(1024) = 10', () => approx(log2(1024), 10.0));
  });

  group('log10', () {
    test('log10(1) = 0', () => approx(log10(1), 0.0));
    test('log10(10) = 1', () => approx(log10(10), 1.0));
    test('log10(1000) = 3', () => approx(log10(1000), 3.0));
  });

  group('trunc', () {
    test('positive', () => approx(trunc(3.7), 3.0));
    test('negative', () => approx(trunc(-3.7), -3.0));
    test('integer', () => approx(trunc(3.0), 3.0));
  });

  group('fmod', () {
    test('7 mod 3 = 1', () => approx(fmod(7, 3), 1.0));
    test('-7 mod 3 = -1 (sign of dividend)', () => approx(fmod(-7, 3), -1.0));
    test('7 mod -3 = 1 (sign of dividend)', () => approx(fmod(7, -3), 1.0));
    test(
      'divisor zero throws',
      () => expect(() => fmod(5, 0), throwsArgumentError),
    );
  });

  group('fract', () {
    test('positive', () => approx(fract(3.7), 0.7));
    test('negative', () => approx(fract(-3.7), -0.7));
    test('integer', () => approx(fract(5.0), 0.0));
  });

  group('copySign', () {
    test('pos magnitude, pos sign', () => approx(copySign(5, 1), 5.0));
    test('pos magnitude, neg sign', () => approx(copySign(5, -1), -5.0));
    test('neg magnitude, pos sign', () => approx(copySign(-5, 1), 5.0));
  });

  group('nearlyEqual', () {
    test('exactly equal', () => expect(nearlyEqual(1.0, 1.0), isTrue));
    test('within eps', () => expect(nearlyEqual(1.0, 1.0 + 1e-11), isTrue));
    test('outside eps', () => expect(nearlyEqual(1.0, 1.1), isFalse));
    test('custom eps', () => expect(nearlyEqual(1.0, 1.05, 0.1), isTrue));
  });

  group('square', () {
    test('square(3) = 9', () => approx(square(3), 9.0));
    test('square(-4) = 16', () => approx(square(-4), 16.0));
    test('square(2.5) = 6.25', () => approx(square(2.5), 6.25));
  });

  group('cube', () {
    test('cube(2) = 8', () => approx(cube(2), 8.0));
    test('cube(-3) = -27', () => approx(cube(-3), -27.0));
    test('cube(1.5) = 3.375', () => approx(cube(1.5), 3.375));
  });

  group('isPowerOfTwo', () {
    test('1 is power of two', () => expect(isPowerOfTwo(1), isTrue));
    test('2 is power of two', () => expect(isPowerOfTwo(2), isTrue));
    test('0 is not', () => expect(isPowerOfTwo(0), isFalse));
    test('3 is not', () => expect(isPowerOfTwo(3), isFalse));
    test('128 is', () => expect(isPowerOfTwo(128), isTrue));
  });

  group('nextPowerOfTwo', () {
    test('0 -> 1', () => expect(nextPowerOfTwo(0), 1));
    test('1 -> 1', () => expect(nextPowerOfTwo(1), 1));
    test('3 -> 4', () => expect(nextPowerOfTwo(3), 4));
    test('128 -> 128', () => expect(nextPowerOfTwo(128), 128));
    test('129 -> 256', () => expect(nextPowerOfTwo(129), 256));
    test(
      'negative throws',
      () => expect(() => nextPowerOfTwo(-1), throwsArgumentError),
    );
  });

  // ─── Trigonometric ────────────────────────────────────────────────────────

  group('sin', () {
    test('sin(0) = 0', () => approx(sin(0), 0.0));
    test('sin(pi/2) = 1', () => approx(sin(math.pi / 2), 1.0));
    test('sin(pi) ≈ 0', () => approx(sin(math.pi), 0.0));
    test('sin(-pi/2) = -1', () => approx(sin(-math.pi / 2), -1.0));
  });

  group('cos', () {
    test('cos(0) = 1', () => approx(cos(0), 1.0));
    test('cos(pi) = -1', () => approx(cos(math.pi), -1.0));
    test('cos(pi/2) ≈ 0', () => approx(cos(math.pi / 2), 0.0));
  });

  group('tan', () {
    test('tan(0) = 0', () => approx(tan(0), 0.0));
    test('tan(pi/4) = 1', () => approx(tan(math.pi / 4), 1.0));
    test('tan(-pi/4) = -1', () => approx(tan(-math.pi / 4), -1.0));
  });

  group('asin', () {
    test('asin(0) = 0', () => approx(asin(0), 0.0));
    test('asin(1) = pi/2', () => approx(asin(1), math.pi / 2));
    test('asin(-1) = -pi/2', () => approx(asin(-1), -math.pi / 2));
    test('asin(2) = NaN', () => expect(asin(2).isNaN, isTrue));
  });

  group('acos', () {
    test('acos(1) = 0', () => approx(acos(1), 0.0));
    test('acos(0) = pi/2', () => approx(acos(0), math.pi / 2));
    test('acos(-1) = pi', () => approx(acos(-1), math.pi));
  });

  group('atan', () {
    test('atan(0) = 0', () => approx(atan(0), 0.0));
    test('atan(1) = pi/4', () => approx(atan(1), math.pi / 4));
    test('atan(-1) = -pi/4', () => approx(atan(-1), -math.pi / 4));
  });

  group('atan2', () {
    test('atan2(1,1) = pi/4', () => approx(atan2(1, 1), math.pi / 4));
    test('atan2(1,-1) = 3pi/4', () => approx(atan2(1, -1), 3 * math.pi / 4));
    test('atan2(0,1) = 0', () => approx(atan2(0, 1), 0.0));
    test('atan2(1,0) = pi/2', () => approx(atan2(1, 0), math.pi / 2));
  });

  // ─── Hyperbolic ───────────────────────────────────────────────────────────

  group('sinh', () {
    test('sinh(0) = 0', () => approx(sinh(0), 0.0));
    test('sinh(1) ≈ 1.1752', () => approx(sinh(1), 1.1752011936438014));
    test('sinh(-1) = -sinh(1)', () => approx(sinh(-1), -1.1752011936438014));
  });

  group('cosh', () {
    test('cosh(0) = 1', () => approx(cosh(0), 1.0));
    test('cosh(1) ≈ 1.5430', () => approx(cosh(1), 1.5430806348152437));
    test('cosh(-1) = cosh(1)', () => approx(cosh(-1), 1.5430806348152437));
  });

  group('tanh', () {
    test('tanh(0) = 0', () => approx(tanh(0), 0.0));
    test('tanh(inf) = 1', () => approx(tanh(double.infinity), 1.0));
    test('tanh(-inf) = -1', () => approx(tanh(double.negativeInfinity), -1.0));
    test('tanh(1) ≈ 0.7616', () => approx(tanh(1), 0.7615941559557649));
  });

  group('asinh', () {
    test('asinh(0) = 0', () => approx(asinh(0), 0.0));
    test('asinh(sinh(1)) = 1', () => approx(asinh(sinh(1)), 1.0));
    test('asinh(-1) = -asinh(1)', () => approx(asinh(-1), -asinh(1)));
  });

  group('acosh', () {
    test('acosh(1) = 0', () => approx(acosh(1), 0.0));
    test('acosh(cosh(2)) = 2', () => approx(acosh(cosh(2)), 2.0));
    test('acosh(0) = NaN', () => expect(acosh(0).isNaN, isTrue));
  });

  group('atanh', () {
    test('atanh(0) = 0', () => approx(atanh(0), 0.0));
    test('atanh(tanh(1)) = 1', () => approx(atanh(tanh(1)), 1.0));
    test('atanh(1) = NaN', () => expect(atanh(1).isNaN, isTrue));
    test('atanh(-1) = NaN', () => expect(atanh(-1).isNaN, isTrue));
  });

  // ─── Exponential & Logarithmic ────────────────────────────────────────────

  group('exp', () {
    test('exp(0) = 1', () => approx(exp(0), 1.0));
    test('exp(1) = e', () => approx(exp(1), math.e));
    test('exp(-1) = 1/e', () => approx(exp(-1), 1 / math.e));
  });

  group('exp2', () {
    test('exp2(0) = 1', () => approx(exp2(0), 1.0));
    test('exp2(3) = 8', () => approx(exp2(3), 8.0));
    test('exp2(-1) = 0.5', () => approx(exp2(-1), 0.5));
  });

  group('expm1', () {
    test('expm1(0) = 0', () => approx(expm1(0), 0.0));
    test('expm1(1) = e-1', () => approx(expm1(1), math.e - 1, eps: 1e-6));
    test('accurate near zero', () => approx(expm1(1e-7), 1e-7, eps: 1e-14));
  });

  group('log', () {
    test('log(1) = 0', () => approx(log(1), 0.0));
    test('log(e) = 1', () => approx(log(math.e), 1.0));
    test('log(e²) = 2', () => approx(log(math.e * math.e), 2.0));
  });

  group('log1p', () {
    test('log1p(0) = 0', () => approx(log1p(0), 0.0));
    test('log1p(e-1) = 1', () => approx(log1p(math.e - 1), 1.0, eps: 1e-7));
    test('accurate near zero', () => approx(log1p(1e-10), 1e-10, eps: 1e-14));
    test('log1p(-1) or below = NaN', () => expect(log1p(-2).isNaN, isTrue));
  });

  // ─── Power & Root ─────────────────────────────────────────────────────────

  group('pow', () {
    test('pow(2, 10) = 1024', () => approx(pow(2, 10), 1024.0));
    test('pow(9, 0.5) = 3', () => approx(pow(9, 0.5), 3.0));
    test('pow(0, 0) = 1', () => approx(pow(0, 0), 1.0));
  });

  group('sqrt', () {
    test('sqrt(4) = 2', () => approx(sqrt(4), 2.0));
    test('sqrt(9) = 3', () => approx(sqrt(9), 3.0));
    test('sqrt(-1) = NaN', () => expect(sqrt(-1).isNaN, isTrue));
  });

  // ─── Rounding ─────────────────────────────────────────────────────────────

  group('floor', () {
    test('floor(2.7) = 2', () => approx(floor(2.7), 2.0));
    test('floor(-2.7) = -3', () => approx(floor(-2.7), -3.0));
    test('floor(3.0) = 3', () => approx(floor(3.0), 3.0));
  });

  group('ceil', () {
    test('ceil(2.3) = 3', () => approx(ceil(2.3), 3.0));
    test('ceil(-2.3) = -2', () => approx(ceil(-2.3), -2.0));
    test('ceil(3.0) = 3', () => approx(ceil(3.0), 3.0));
  });

  group('round', () {
    test('round(2.5) = 3', () => approx(round(2.5), 3.0));
    test('round(-2.5) = -3', () => approx(round(-2.5), -3.0));
    test('round(2.4) = 2', () => approx(round(2.4), 2.0));
  });

  group('nearbyInt', () {
    test('2.4 -> 2 (floor)', () => approx(nearbyInt(2.4), 2.0));
    test('2.6 -> 3 (ceil)', () => approx(nearbyInt(2.6), 3.0));
    test('2.5 -> 2 (ties to even)', () => approx(nearbyInt(2.5), 2.0));
    test('3.5 -> 4 (ties to even)', () => approx(nearbyInt(3.5), 4.0));
  });

  // ─── Arithmetic extras ────────────────────────────────────────────────────

  group('abs', () {
    test('abs(3) = 3', () => approx(abs(3), 3.0));
    test('abs(-3) = 3', () => approx(abs(-3), 3.0));
    test('abs(0) = 0', () => approx(abs(0), 0.0));
  });

  group('fdim', () {
    test('fdim(5, 3) = 2', () => approx(fdim(5, 3), 2.0));
    test('fdim(3, 5) = 0', () => approx(fdim(3, 5), 0.0));
    test('fdim(2, 2) = 0', () => approx(fdim(2, 2), 0.0));
  });

  group('fmax', () {
    test('fmax(3, 5) = 5', () => approx(fmax(3, 5), 5.0));
    test('fmax(5, 3) = 5', () => approx(fmax(5, 3), 5.0));
    test('fmax(NaN, 1) = NaN', () => expect(fmax(double.nan, 1).isNaN, isTrue));
  });

  group('fmin', () {
    test('fmin(3, 5) = 3', () => approx(fmin(3, 5), 3.0));
    test('fmin(5, 3) = 3', () => approx(fmin(5, 3), 3.0));
    test('fmin(NaN, 1) = NaN', () => expect(fmin(double.nan, 1).isNaN, isTrue));
  });

  // ─── Floating-point decomposition ─────────────────────────────────────────

  group('remainder', () {
    test(
      'remainder(5, 3) = -1 (nearest quotient = 2)',
      () => approx(remainder(5, 3), -1.0),
    );
    test(
      'remainder(7, 4) = -1 (nearest quotient = 2)',
      () => approx(remainder(7, 4), -1.0),
    );
    test(
      'remainder(0.3, 0.1) near 0',
      () => approx(remainder(0.3, 0.1).abs(), 0.0, eps: 1e-10),
    );
    test(
      'zero divisor throws',
      () => expect(() => remainder(5, 0), throwsArgumentError),
    );
  });

  group('scalbn', () {
    test('scalbn(1, 3) = 8', () => approx(scalbn(1, 3), 8.0));
    test('scalbn(3, -1) = 1.5', () => approx(scalbn(3, -1), 1.5));
    test('scalbn(0, 5) = 0', () => approx(scalbn(0, 5), 0.0));
  });

  group('ldexp', () {
    test('ldexp(1, 4) = 16', () => approx(ldexp(1, 4), 16.0));
    test('ldexp(1.5, 2) = 6', () => approx(ldexp(1.5, 2), 6.0));
  });

  group('frexp', () {
    test('frexp(8) -> (0.5, 4)', () {
      final r = frexp(8);
      approx(r.fraction, 0.5);
      expect(r.exponent, 4);
    });
    test('frexp(0) -> (0, 0)', () {
      final r = frexp(0);
      approx(r.fraction, 0.0);
      expect(r.exponent, 0);
    });
    test('frexp(-4) -> (-0.5, 3)', () {
      final r = frexp(-4);
      approx(r.fraction, -0.5);
      expect(r.exponent, 3);
    });
  });

  group('modf', () {
    test('modf(3.7) -> (3, 0.7)', () {
      final r = modf(3.7);
      approx(r.intPart, 3.0);
      approx(r.fracPart, 0.7);
    });
    test('modf(-3.7) -> (-3, -0.7)', () {
      final r = modf(-3.7);
      approx(r.intPart, -3.0);
      approx(r.fracPart, -0.7);
    });
  });

  group('ilogb', () {
    test('ilogb(8) = 3', () => expect(ilogb(8), 3));
    test('ilogb(1) = 0', () => expect(ilogb(1), 0));
    test('ilogb(0) throws', () => expect(() => ilogb(0), throwsArgumentError));
  });

  group('logb', () {
    test('logb(8) = 3', () => approx(logb(8), 3.0));
    test('logb(0) = -inf', () => expect(logb(0), double.negativeInfinity));
    test(
      'logb(inf) = inf',
      () => expect(logb(double.infinity), double.infinity),
    );
  });

  // ─── Classification ───────────────────────────────────────────────────────

  group('isNaN', () {
    test('NaN -> true', () => expect(stl.isNaN(double.nan), isTrue));
    test('1.0 -> false', () => expect(stl.isNaN(1.0), isFalse));
  });

  group('isFinite', () {
    test('1.0 -> true', () => expect(isFinite(1.0), isTrue));
    test('inf -> false', () => expect(isFinite(double.infinity), isFalse));
    test('NaN -> false', () => expect(isFinite(double.nan), isFalse));
  });

  group('isInfinite', () {
    test('inf -> true', () => expect(isInfinite(double.infinity), isTrue));
    test(
      '-inf -> true',
      () => expect(isInfinite(double.negativeInfinity), isTrue),
    );
    test('1.0 -> false', () => expect(isInfinite(1.0), isFalse));
  });

  group('isNormal', () {
    test('1.0 is normal', () => expect(isNormal(1.0), isTrue));
    test('0.0 is not normal', () => expect(isNormal(0.0), isFalse));
    test('inf is not normal', () => expect(isNormal(double.infinity), isFalse));
    test('NaN is not normal', () => expect(isNormal(double.nan), isFalse));
  });

  group('signBit', () {
    test('negative -> true', () => expect(signBit(-1.0), isTrue));
    test('positive -> false', () => expect(signBit(1.0), isFalse));
    test('-0.0 -> true', () => expect(signBit(-0.0), isTrue));
    test('+0.0 -> false', () => expect(signBit(0.0), isFalse));
  });

  // ─── Error & Gamma ────────────────────────────────────────────────────────

  group('erf', () {
    test('erf(0) = 0', () => approx(erf(0), 0.0));
    test('erf(inf) = 1', () => approx(erf(double.infinity), 1.0));
    test('erf(-inf) = -1', () => approx(erf(double.negativeInfinity), -1.0));
    test(
      'erf(1) ≈ 0.8427',
      () => approx(erf(1), 0.8427007929497149, eps: 1e-6),
    );
    test('erf(-1) = -erf(1)', () => approx(erf(-1), -erf(1), eps: 1e-6));
  });

  group('erfc', () {
    test('erfc(0) = 1', () => approx(erfc(0), 1.0));
    test('erfc(inf) = 0', () => approx(erfc(double.infinity), 0.0));
    test(
      'erfc + erf = 2 for erf(-inf)',
      () => approx(erfc(double.negativeInfinity), 2.0),
    );
    test('erfc(1) = 1 - erf(1)', () => approx(erfc(1), 1 - erf(1), eps: 1e-6));
  });

  group('tgamma', () {
    test('tgamma(1) = 1', () => approx(tgamma(1), 1.0, eps: 1e-7));
    test('tgamma(2) = 1', () => approx(tgamma(2), 1.0, eps: 1e-7));
    test('tgamma(3) = 2', () => approx(tgamma(3), 2.0, eps: 1e-7));
    test('tgamma(5) = 24', () => approx(tgamma(5), 24.0, eps: 1e-6));
    test(
      'tgamma(0.5) = sqrt(pi)',
      () => approx(tgamma(0.5), math.sqrt(math.pi), eps: 1e-6),
    );
  });

  group('lgamma', () {
    test('lgamma(1) = 0', () => approx(lgamma(1), 0.0, eps: 1e-7));
    test(
      'lgamma(5) = log(24)',
      () => approx(lgamma(5), math.log(24), eps: 1e-6),
    );
  });

  // ─── Angle & Signal ───────────────────────────────────────────────────────

  group('wrapAngle', () {
    test('0 -> 0', () => approx(wrapAngle(0), 0.0));
    test(
      'pi -> -pi or pi edge',
      () => expect(wrapAngle(math.pi).abs(), closeTo(math.pi, 1e-9)),
    );
    test(
      '3pi -> -pi (range [-pi,pi))',
      () => approx(wrapAngle(3 * math.pi), -math.pi, eps: 1e-9),
    );
    test(
      '-3pi -> -pi edge',
      () => expect(wrapAngle(-3 * math.pi).abs(), closeTo(math.pi, 1e-9)),
    );
    test('2pi -> 0', () => approx(wrapAngle(2 * math.pi), 0.0));
  });

  group('angleDiff', () {
    test(
      '0 to pi/2 = pi/2',
      () => approx(angleDiff(0, math.pi / 2), math.pi / 2),
    );
    test('pi to 0 = -pi (shortest)', () {
      final d = angleDiff(math.pi, 0);
      expect(d.abs(), closeTo(math.pi, 1e-9));
    });
  });

  group('sinc', () {
    test('sinc(0) = 1', () => approx(sinc(0), 1.0));
    test('sinc(pi) = 0', () => approx(sinc(math.pi), 0.0, eps: 1e-9));
    test('sinc(-x) = sinc(x)', () => approx(sinc(-1.0), sinc(1.0)));
  });

  group('normalizedSinc', () {
    test('normalizedSinc(0) = 1', () => approx(normalizedSinc(0), 1.0));
    test(
      'normalizedSinc(1) = 0',
      () => approx(normalizedSinc(1), 0.0, eps: 1e-9),
    );
    test(
      'normalizedSinc(-x) = normalizedSinc(x)',
      () => approx(normalizedSinc(-2.0), normalizedSinc(2.0)),
    );
  });

  // ─── Interpolation extras ─────────────────────────────────────────────────

  group('smootherstep', () {
    test('at 0 = 0', () => approx(smootherstep(0), 0.0));
    test('at 1 = 1', () => approx(smootherstep(1), 1.0));
    test('at 0.5 = 0.5', () => approx(smootherstep(0.5), 0.5));
    test('clamps below 0', () => approx(smootherstep(-1), 0.0));
    test('clamps above 1', () => approx(smootherstep(2), 1.0));
  });

  group('quinticStep', () {
    test('at 0 = 0', () => approx(quinticStep(0), 0.0));
    test('at 1 = 1', () => approx(quinticStep(1), 1.0));
    test('at 0.5 = 0.5', () => approx(quinticStep(0.5), 0.5));
  });

  group('bilerp', () {
    test('corners', () {
      approx(bilerp(0, 1, 2, 3, 0, 0), 0.0);
      approx(bilerp(0, 1, 2, 3, 1, 0), 1.0);
      approx(bilerp(0, 1, 2, 3, 0, 1), 2.0);
      approx(bilerp(0, 1, 2, 3, 1, 1), 3.0);
    });
    test('center', () => approx(bilerp(0, 1, 2, 3, 0.5, 0.5), 1.5));
  });

  group('pingpong', () {
    test('start = 0', () => approx(pingpong(0, 1), 0.0));
    test('middle = 1', () => approx(pingpong(1, 1), 1.0));
    test('bounces back', () => approx(pingpong(1.5, 1), 0.5));
    test('full cycle', () => approx(pingpong(2, 1), 0.0));
    test('zero length = 0', () => approx(pingpong(5, 0), 0.0));
  });

  group('moveTowards', () {
    test('reaches target', () => approx(moveTowards(0, 5, 10), 5.0));
    test('steps partially', () => approx(moveTowards(0, 10, 3), 3.0));
    test('negative direction', () => approx(moveTowards(10, 0, 3), 7.0));
    test(
      'negative delta throws',
      () => expect(() => moveTowards(0, 5, -1), throwsArgumentError),
    );
  });

  // ─── Combinatorial ────────────────────────────────────────────────────────

  group('factorial', () {
    test('0! = 1', () => expect(factorial(0), 1));
    test('1! = 1', () => expect(factorial(1), 1));
    test('5! = 120', () => expect(factorial(5), 120));
    test('20! exact int', () => expect(factorial(20), 2432902008176640000));
    test(
      'negative throws',
      () => expect(() => factorial(-1), throwsArgumentError),
    );
  });

  group('fallingFactorial', () {
    test('x=5, n=0 = 1', () => approx(fallingFactorial(5, 0), 1.0));
    test('x=5, n=1 = 5', () => approx(fallingFactorial(5, 1), 5.0));
    test('x=5, n=3 = 5*4*3 = 60', () => approx(fallingFactorial(5, 3), 60.0));
    test(
      'negative n throws',
      () => expect(() => fallingFactorial(5, -1), throwsArgumentError),
    );
  });

  group('risingFactorial', () {
    test('x=3, n=0 = 1', () => approx(risingFactorial(3, 0), 1.0));
    test('x=3, n=1 = 3', () => approx(risingFactorial(3, 1), 3.0));
    test('x=3, n=3 = 3*4*5 = 60', () => approx(risingFactorial(3, 3), 60.0));
    test(
      'negative n throws',
      () => expect(() => risingFactorial(3, -1), throwsArgumentError),
    );
  });

  group('binomial', () {
    test('C(5,0) = 1', () => expect(binomial(5, 0), 1));
    test('C(5,5) = 1', () => expect(binomial(5, 5), 1));
    test('C(5,2) = 10', () => expect(binomial(5, 2), 10));
    test('C(10,3) = 120', () => expect(binomial(10, 3), 120));
    test(
      'k > n throws',
      () => expect(() => binomial(3, 5), throwsArgumentError),
    );
    test(
      'negative throws',
      () => expect(() => binomial(-1, 0), throwsArgumentError),
    );
  });

  // ─── Special Mathematical Functions ──────────────────────────────────────

  group('beta', () {
    test('B(1,1) = 1', () => approx(beta(1, 1), 1.0, eps: 1e-7));
    test('B(2,2) = 1/6', () => approx(beta(2, 2), 1.0 / 6.0, eps: 1e-7));
    test('B(0.5,0.5) = pi', () => approx(beta(0.5, 0.5), math.pi, eps: 1e-5));
  });

  group('legendre', () {
    test('P0(x) = 1', () => approx(legendre(0, 0.5), 1.0));
    test('P1(x) = x', () => approx(legendre(1, 0.5), 0.5));
    test(
      'P2(x) = (3x²-1)/2',
      () => approx(legendre(2, 0.5), (3 * 0.25 - 1) / 2),
    );
    test('P3(0) = 0', () => approx(legendre(3, 0), 0.0));
    test(
      'negative n throws',
      () => expect(() => legendre(-1, 0), throwsArgumentError),
    );
  });

  group('assocLegendre', () {
    test('P00 = 1', () => approx(assocLegendre(0, 0, 0.5), 1.0));
    test('P11(x) = -sqrt(1-x²)', () {
      // With positive convention (no Condon-Shortley): Pₙᵐ starts positive
      final result = assocLegendre(1, 1, 0.5);
      // |result| should be sqrt(1-0.25) = sqrt(0.75)
      approx(result.abs(), math.sqrt(0.75), eps: 1e-7);
    });
    test(
      'invalid args throw',
      () => expect(() => assocLegendre(1, 2, 0.5), throwsArgumentError),
    );
  });

  group('hermite', () {
    test('H0 = 1', () => approx(hermite(0, 1.0), 1.0));
    test('H1(x) = x', () => approx(hermite(1, 2.0), 2.0));
    test('H2(x) = x²-1', () => approx(hermite(2, 2.0), 2.0 * 2.0 - 1.0));
    test(
      'negative n throws',
      () => expect(() => hermite(-1, 1), throwsArgumentError),
    );
  });

  group('laguerre', () {
    test('L0 = 1', () => approx(laguerre(0, 1.0), 1.0));
    test('L1(x) = 1-x', () => approx(laguerre(1, 2.0), -1.0));
    test(
      'L2(x) = (x²-4x+2)/2',
      () => approx(laguerre(2, 2.0), (4 - 8 + 2) / 2),
    );
    test(
      'negative n throws',
      () => expect(() => laguerre(-1, 1), throwsArgumentError),
    );
  });

  group('assocLaguerre', () {
    test('L00 = 1', () => approx(assocLaguerre(0, 0, 1.0), 1.0));
    test('L10(x) = 1-x', () => approx(assocLaguerre(1, 0, 2.0), -1.0));
    test('L11(x) = 2-x', () => approx(assocLaguerre(1, 1, 2.0), 0.0));
    test(
      'negative args throw',
      () => expect(() => assocLaguerre(-1, 0, 1), throwsArgumentError),
    );
  });

  group('riemannZeta', () {
    test(
      'zeta(2) = pi²/6',
      () => approx(riemannZeta(2), math.pi * math.pi / 6, eps: 1e-3),
    );
    test('zeta(1) = infinity', () => expect(riemannZeta(1), double.infinity));
    test('zeta(0) = -0.5', () => approx(riemannZeta(0), -0.5, eps: 1e-3));
  });

  group('sphBessel', () {
    test('j0(0) = 1', () => approx(sphBessel(0, 0), 1.0));
    test('j0(pi) ≈ 0', () => approx(sphBessel(0, math.pi), 0.0, eps: 1e-9));
    test('j1(0) = 0', () => approx(sphBessel(1, 0), 0.0));
    test(
      'negative n throws',
      () => expect(() => sphBessel(-1, 1), throwsArgumentError),
    );
  });

  group('sphNeumann', () {
    test(
      'y0(x) diverges near 0',
      () => expect(sphNeumann(0, 0.0001) < -100, isTrue),
    );
    test(
      'negative n throws',
      () => expect(() => sphNeumann(-1, 1), throwsArgumentError),
    );
  });

  group('sphLegendre', () {
    test('Y00 = 1/sqrt(4pi)', () {
      approx(
        sphLegendre(0, 0, 0.0, 0.0),
        1 / math.sqrt(4 * math.pi),
        eps: 1e-7,
      );
    });
    test(
      'invalid args throw',
      () => expect(() => sphLegendre(1, 2, 0, 0), throwsArgumentError),
    );
  });

  group('cylBesselJ', () {
    test('J0(0) = 1', () => approx(cylBesselJ(0, 0), 1.0));
    test('J1(0) = 0', () => approx(cylBesselJ(1, 0), 0.0));
    test(
      'J0(2.4048) ≈ 0 (first zero)',
      () => approx(cylBesselJ(0, 2.4048), 0.0, eps: 1e-3),
    );
  });

  group('cylBesselI', () {
    test('I0(0) = 1', () => approx(cylBesselI(0, 0), 1.0));
    test('I1(0) = 0', () => approx(cylBesselI(1, 0), 0.0));
    test(
      'I0(1) ≈ 1.2661',
      () => approx(cylBesselI(0, 1), 1.2660658777520082, eps: 1e-5),
    );
  });

  group('cylBesselK', () {
    test('K diverges at 0', () => expect(cylBesselK(0, 0), double.infinity));
    test('K0(1) ≈ 0.4210', () => approx(cylBesselK(0, 1), 0.4210, eps: 1e-3));
  });

  group('cylNeumann', () {
    test(
      'Y0 diverges at 0',
      () => expect(cylNeumann(0, 0), double.negativeInfinity),
    );
    test('Y0(1) finite positive', () => expect(cylNeumann(0, 1) > 0, isTrue));
  });

  group('expInt', () {
    test('expInt(0) = -inf', () => expect(expInt(0), double.negativeInfinity));
    test(
      'expInt(1) ≈ 1.8951',
      () => approx(expInt(1), 1.8951178163559368, eps: 1e-4),
    );
  });

  group('compEllint1', () {
    test('K(0) = pi/2', () => approx(compEllint1(0), math.pi / 2, eps: 1e-10));
    test(
      '|k|>=1 throws',
      () => expect(() => compEllint1(1), throwsArgumentError),
    );
  });

  group('compEllint2', () {
    test('E(0) = pi/2', () => approx(compEllint2(0), math.pi / 2, eps: 1e-10));
    test('E(1) = 1', () => approx(compEllint2(1), 1.0, eps: 1e-10));
    test(
      '|k|>1 throws',
      () => expect(() => compEllint2(1.1), throwsArgumentError),
    );
  });

  group('compEllint3', () {
    test(
      'Π(0,0) = pi/2',
      () => approx(compEllint3(0, 0), math.pi / 2, eps: 1e-8),
    );
    test(
      '|k|>=1 throws',
      () => expect(() => compEllint3(0, 1), throwsArgumentError),
    );
  });

  group('ellint1', () {
    test('F(0,k) = 0', () => approx(ellint1(0, 0.5), 0.0));
    test(
      'F(pi/2, 0) = pi/2',
      () => approx(ellint1(math.pi / 2, 0), math.pi / 2, eps: 1e-8),
    );
    test(
      '|k|>=1 throws',
      () => expect(() => ellint1(1, 1), throwsArgumentError),
    );
  });

  group('ellint2', () {
    test('E(0,k) = 0', () => approx(ellint2(0, 0.5), 0.0));
    test(
      'E(pi/2, 0) = pi/2',
      () => approx(ellint2(math.pi / 2, 0), math.pi / 2, eps: 1e-8),
    );
    test(
      '|k|>1 throws',
      () => expect(() => ellint2(1, 1.1), throwsArgumentError),
    );
  });

  group('ellint3', () {
    test('Π(0,0,0) = 0', () => approx(ellint3(0, 0, 0), 0.0));
    test(
      'Π(0,pi/2,0) = pi/2',
      () => approx(ellint3(0, math.pi / 2, 0), math.pi / 2, eps: 1e-8),
    );
    test(
      '|k|>=1 throws',
      () => expect(() => ellint3(0, 1, 1), throwsArgumentError),
    );
  });
}
