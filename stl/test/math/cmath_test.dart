import 'package:stl/stl.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('cmath', () {
    // ─── clamp ────────────────────────────────────────────────────────────────
    group('clamp', () {
      test('keeps value within range', () {
        expect(clamp(5, 0, 10), equals(5));
      });

      test('clamps to lower bound', () {
        expect(clamp(-5, 0, 10), equals(0));
      });

      test('clamps to upper bound', () {
        expect(clamp(15, 0, 10), equals(10));
      });

      test('works with doubles', () {
        expect(clamp(3.14, 0.0, 3.0), equals(3.0));
        expect(clamp(-3.14, -5.0, -1.0), equals(-3.14));
      });

      test('throws error if lo > hi', () {
        expect(() => clamp(5, 10, 0), throwsArgumentError);
      });
    });

    // ─── lerp ─────────────────────────────────────────────────────────────────
    group('lerp', () {
      test('interpolates correctly', () {
        expect(lerp(0, 10, 0.5), equals(5.0));
        expect(lerp(0, 10, 0.0), equals(0.0));
        expect(lerp(0, 10, 1.0), equals(10.0));
        expect(lerp(10, 0, 0.5), equals(5.0));
      });

      test('works with negative values', () {
        expect(lerp(-10, 10, 0.5), equals(0.0));
      });

      test('extrapolates correctly', () {
        expect(lerp(0, 10, 1.5), equals(15.0));
        expect(lerp(0, 10, -0.5), equals(-5.0));
      });
    });

    // ─── hypot ────────────────────────────────────────────────────────────────
    group('hypot', () {
      test('computes 2D hypotenuse', () {
        expect(hypot(3, 4), equals(5.0));
        expect(hypot(-3, 4), equals(5.0));
        expect(hypot(3, -4), equals(5.0));
        expect(hypot(-3, -4), equals(5.0));
      });

      test('computes 3D hypotenuse', () {
        // sqrt(2^2 + 3^2 + 6^2) = sqrt(4 + 9 + 36) = sqrt(49) = 7
        expect(hypot(2, 3, 6), equals(7.0));
      });

      test('handles zeros', () {
        expect(hypot(0, 0), equals(0.0));
        expect(hypot(0, 0, 0), equals(0.0));
        expect(hypot(0, 5), equals(5.0));
      });

      test('avoids overflow', () {
        final huge = 1e160;
        expect(math.pow(huge, 2), equals(double.infinity));
        final result = hypot(huge, huge);
        expect(result.isInfinite, isFalse);
        expect(result, closeTo(huge * math.sqrt(2), 1e155));
      });

      test('avoids underflow', () {
        final tiny = 1e-200;
        expect(math.pow(tiny, 2), equals(0.0));
        final result = hypot(tiny, tiny);
        expect(result, greaterThan(0));
        expect(result, closeTo(tiny * math.sqrt(2), 1e-205));
      });
    });

    // ─── sign ─────────────────────────────────────────────────────────────────
    group('sign', () {
      test('positive integer returns 1', () {
        expect(sign(42), equals(1));
        expect(sign(1), equals(1));
      });

      test('negative integer returns -1', () {
        expect(sign(-42), equals(-1));
        expect(sign(-1), equals(-1));
      });

      test('zero integer returns 0', () {
        expect(sign(0), equals(0));
      });

      test('positive double returns 1.0', () {
        expect(sign(3.14), equals(1.0));
      });

      test('negative double returns -1.0', () {
        expect(sign(-3.14), equals(-1.0));
      });

      test('zero double returns 0.0', () {
        expect(sign(0.0), equals(0.0));
      });
    });

    // ─── degrees / radians ────────────────────────────────────────────────────
    group('degrees', () {
      test('converts pi to 180', () {
        expect(degrees(math.pi), closeTo(180.0, 1e-10));
      });

      test('converts 0 to 0', () {
        expect(degrees(0), equals(0.0));
      });

      test('converts pi/2 to 90', () {
        expect(degrees(math.pi / 2), closeTo(90.0, 1e-10));
      });

      test('converts negative radians', () {
        expect(degrees(-math.pi), closeTo(-180.0, 1e-10));
      });
    });

    group('radians', () {
      test('converts 180 to pi', () {
        expect(radians(180), closeTo(math.pi, 1e-10));
      });

      test('converts 0 to 0', () {
        expect(radians(0), equals(0.0));
      });

      test('converts 90 to pi/2', () {
        expect(radians(90), closeTo(math.pi / 2, 1e-10));
      });

      test('converts negative degrees', () {
        expect(radians(-180), closeTo(-math.pi, 1e-10));
      });

      test('degrees and radians are inverse', () {
        const angle = 37.5;
        expect(degrees(radians(angle)), closeTo(angle, 1e-10));
      });
    });

    // ─── fma ──────────────────────────────────────────────────────────────────
    group('fma', () {
      test('computes a * b + c', () {
        expect(fma(2, 3, 4), equals(10.0)); // 2*3 + 4
        expect(fma(1.5, 2.0, 0.5), equals(3.5)); // 1.5*2 + 0.5
      });

      test('handles zero operands', () {
        expect(fma(0, 99, 5), equals(5.0));
        expect(fma(3, 4, 0), equals(12.0));
      });

      test('handles negative values', () {
        expect(fma(-2, 3, 10), equals(4.0)); // -6 + 10
        expect(fma(2, -3, -1), equals(-7.0)); // -6 - 1
      });
    });

    // ─── smoothstep ───────────────────────────────────────────────────────────
    group('smoothstep', () {
      test('returns 0 at or below edge0', () {
        expect(smoothstep(0, 1, 0.0), equals(0.0));
        expect(smoothstep(0, 1, -1.0), equals(0.0));
      });

      test('returns 1 at or above edge1', () {
        expect(smoothstep(0, 1, 1.0), equals(1.0));
        expect(smoothstep(0, 1, 2.0), equals(1.0));
      });

      test('returns 0.5 at midpoint', () {
        expect(smoothstep(0, 1, 0.5), closeTo(0.5, 1e-10));
      });

      test('output is always in [0, 1]', () {
        for (var i = 0; i <= 10; i++) {
          final v = smoothstep(0, 10, i.toDouble());
          expect(v, greaterThanOrEqualTo(0.0));
          expect(v, lessThanOrEqualTo(1.0));
        }
      });

      test('throws if edge0 == edge1', () {
        expect(() => smoothstep(5, 5, 3), throwsArgumentError);
      });
    });

    // ─── remap ────────────────────────────────────────────────────────────────
    group('remap', () {
      test('maps midpoint correctly', () {
        expect(remap(5, 0, 10, 0, 100), closeTo(50.0, 1e-10));
      });

      test('maps start of range', () {
        expect(remap(0, 0, 10, 0, 100), closeTo(0.0, 1e-10));
      });

      test('maps end of range', () {
        expect(remap(10, 0, 10, 0, 100), closeTo(100.0, 1e-10));
      });

      test('maps between different ranges', () {
        expect(remap(0, -1, 1, 0, 100), closeTo(50.0, 1e-10));
      });

      test('extrapolates outside source range', () {
        expect(remap(15, 0, 10, 0, 100), closeTo(150.0, 1e-10));
      });

      test('throws if s0 == s1', () {
        expect(() => remap(5, 3, 3, 0, 1), throwsArgumentError);
      });
    });

    // ─── saturate ─────────────────────────────────────────────────────────────
    group('saturate', () {
      test('clamps above 1', () {
        expect(saturate(1.5), equals(1.0));
        expect(saturate(100), equals(1.0));
      });

      test('clamps below 0', () {
        expect(saturate(-0.5), equals(0.0));
        expect(saturate(-100), equals(0.0));
      });

      test('keeps value in [0, 1]', () {
        expect(saturate(0.0), equals(0.0));
        expect(saturate(0.5), equals(0.5));
        expect(saturate(1.0), equals(1.0));
      });
    });

    // ─── step ─────────────────────────────────────────────────────────────────
    group('step', () {
      test('returns 0 when x < edge', () {
        expect(step(5.0, 3.0), equals(0.0));
        expect(step(1.0, 0.0), equals(0.0));
      });

      test('returns 1 when x >= edge', () {
        expect(step(5.0, 5.0), equals(1.0));
        expect(step(5.0, 10.0), equals(1.0));
      });

      test('works with zero edge', () {
        expect(step(0.0, -1.0), equals(0.0));
        expect(step(0.0, 0.0), equals(1.0));
        expect(step(0.0, 1.0), equals(1.0));
      });
    });

    // ─── cbrt ─────────────────────────────────────────────────────────────────
    group('cbrt', () {
      test('computes cube root of perfect cubes', () {
        expect(cbrt(8), closeTo(2.0, 1e-10));
        expect(cbrt(27), closeTo(3.0, 1e-10));
        expect(cbrt(125), closeTo(5.0, 1e-10));
        expect(cbrt(1), closeTo(1.0, 1e-10));
      });

      test('handles negative input', () {
        expect(cbrt(-8), closeTo(-2.0, 1e-10));
        expect(cbrt(-27), closeTo(-3.0, 1e-10));
      });

      test('handles zero', () {
        expect(cbrt(0), equals(0.0));
      });

      test('non-perfect cube', () {
        expect(cbrt(2), closeTo(1.2599210498948732, 1e-10));
      });
    });

    // ─── log2 ─────────────────────────────────────────────────────────────────
    group('log2', () {
      test('powers of two', () {
        expect(log2(1), closeTo(0.0, 1e-10));
        expect(log2(2), closeTo(1.0, 1e-10));
        expect(log2(4), closeTo(2.0, 1e-10));
        expect(log2(8), closeTo(3.0, 1e-10));
        expect(log2(1024), closeTo(10.0, 1e-10));
      });

      test('non-power-of-two', () {
        expect(log2(10), closeTo(3.321928094887362, 1e-10));
      });

      test('returns negative infinity for 0', () {
        expect(log2(0), equals(double.negativeInfinity));
      });

      test('returns nan for negative', () {
        expect(log2(-1).isNaN, isTrue);
      });
    });

    // ─── log10 ────────────────────────────────────────────────────────────────
    group('log10', () {
      test('powers of ten', () {
        expect(log10(1), closeTo(0.0, 1e-10));
        expect(log10(10), closeTo(1.0, 1e-10));
        expect(log10(100), closeTo(2.0, 1e-10));
        expect(log10(1000), closeTo(3.0, 1e-10));
      });

      test('returns negative infinity for 0', () {
        expect(log10(0), equals(double.negativeInfinity));
      });

      test('returns nan for negative', () {
        expect(log10(-1).isNaN, isTrue);
      });
    });

    // ─── trunc ────────────────────────────────────────────────────────────────
    group('trunc', () {
      test('truncates positive values toward zero', () {
        expect(trunc(3.7), equals(3.0));
        expect(trunc(3.2), equals(3.0));
        expect(trunc(3.0), equals(3.0));
      });

      test('truncates negative values toward zero', () {
        expect(trunc(-3.7), equals(-3.0));
        expect(trunc(-3.2), equals(-3.0));
        expect(trunc(-3.0), equals(-3.0));
      });

      test('handles zero', () {
        expect(trunc(0.0), equals(0.0));
      });
    });

    // ─── fmod ─────────────────────────────────────────────────────────────────
    group('fmod', () {
      test('positive dividend and divisor', () {
        expect(fmod(7.0, 3.0), closeTo(1.0, 1e-10));
        expect(fmod(10.0, 4.0), closeTo(2.0, 1e-10));
      });

      test('negative dividend: result has same sign as dividend', () {
        expect(fmod(-7.0, 3.0), closeTo(-1.0, 1e-10));
      });

      test('negative divisor', () {
        expect(fmod(7.0, -3.0), closeTo(1.0, 1e-10));
      });

      test('both negative', () {
        expect(fmod(-7.0, -3.0), closeTo(-1.0, 1e-10));
      });

      test('exact divisor returns 0', () {
        expect(fmod(9.0, 3.0), closeTo(0.0, 1e-10));
      });

      test('throws if divisor is zero', () {
        expect(() => fmod(5.0, 0), throwsArgumentError);
      });
    });

    // ─── fract ────────────────────────────────────────────────────────────────
    group('fract', () {
      test('positive values', () {
        expect(fract(3.7), closeTo(0.7, 1e-10));
        expect(fract(3.0), closeTo(0.0, 1e-10));
      });

      test('negative values retain sign', () {
        expect(fract(-3.7), closeTo(-0.7, 1e-10));
        expect(fract(-3.0), closeTo(-0.0, 1e-10));
      });

      test('zero returns zero', () {
        expect(fract(0.0), equals(0.0));
      });
    });

    // ─── copySign ─────────────────────────────────────────────────────────────
    group('copySign', () {
      test('applies positive sign', () {
        expect(copySign(-5.0, 1.0), equals(5.0));
        expect(copySign(5.0, 3.0), equals(5.0));
      });

      test('applies negative sign', () {
        expect(copySign(5.0, -1.0), equals(-5.0));
        expect(copySign(-5.0, -3.0), equals(-5.0));
      });

      test('magnitude is always absolute value', () {
        expect(copySign(-7, 2), equals(7.0));
        expect(copySign(7, -2), equals(-7.0));
      });

      test('handles negative zero sign', () {
        expect(copySign(1.0, -0.0), equals(-1.0));
      });
    });

    // ─── nearlyEqual ──────────────────────────────────────────────────────────
    group('nearlyEqual', () {
      test('identical values are equal', () {
        expect(nearlyEqual(1.0, 1.0), isTrue);
        expect(nearlyEqual(0.0, 0.0), isTrue);
      });

      test('values within default epsilon are equal', () {
        expect(nearlyEqual(1.0, 1.0 + 1e-11), isTrue);
      });

      test('values beyond default epsilon are not equal', () {
        expect(nearlyEqual(1.0, 1.1), isFalse);
      });

      test('custom epsilon', () {
        expect(nearlyEqual(1.0, 1.05, 0.1), isTrue);
        expect(nearlyEqual(1.0, 1.2, 0.1), isFalse);
      });

      test('near-zero values use absolute tolerance', () {
        expect(nearlyEqual(0.0, 1e-11), isTrue);
        expect(nearlyEqual(0.0, 1e-9), isFalse);
      });
    });

    // ─── square ───────────────────────────────────────────────────────────────
    group('square', () {
      test('squares positive numbers', () {
        expect(square(3), equals(9.0));
        expect(square(2.5), equals(6.25));
      });

      test('squares negative numbers', () {
        expect(square(-4), equals(16.0));
      });

      test('zero returns zero', () {
        expect(square(0), equals(0.0));
      });
    });

    // ─── cube ─────────────────────────────────────────────────────────────────
    group('cube', () {
      test('cubes positive numbers', () {
        expect(cube(2), equals(8.0));
        expect(cube(3), equals(27.0));
      });

      test('cubes negative numbers retain sign', () {
        expect(cube(-2), equals(-8.0));
        expect(cube(-3), equals(-27.0));
      });

      test('zero returns zero', () {
        expect(cube(0), equals(0.0));
      });
    });

    // ─── isPowerOfTwo ──────────────────────────────────────────────────────────
    group('isPowerOfTwo', () {
      test('powers of two return true', () {
        expect(isPowerOfTwo(1), isTrue);
        expect(isPowerOfTwo(2), isTrue);
        expect(isPowerOfTwo(4), isTrue);
        expect(isPowerOfTwo(8), isTrue);
        expect(isPowerOfTwo(1024), isTrue);
        expect(isPowerOfTwo(1 << 20), isTrue);
      });

      test('non-powers of two return false', () {
        expect(isPowerOfTwo(0), isFalse);
        expect(isPowerOfTwo(3), isFalse);
        expect(isPowerOfTwo(5), isFalse);
        expect(isPowerOfTwo(6), isFalse);
        expect(isPowerOfTwo(100), isFalse);
      });

      test('negative values return false', () {
        expect(isPowerOfTwo(-1), isFalse);
        expect(isPowerOfTwo(-4), isFalse);
      });
    });

    // ─── nextPowerOfTwo ───────────────────────────────────────────────────────
    group('nextPowerOfTwo', () {
      test('exact powers of two return themselves', () {
        expect(nextPowerOfTwo(1), equals(1));
        expect(nextPowerOfTwo(2), equals(2));
        expect(nextPowerOfTwo(8), equals(8));
        expect(nextPowerOfTwo(1024), equals(1024));
      });

      test('non-powers return next higher power', () {
        expect(nextPowerOfTwo(3), equals(4));
        expect(nextPowerOfTwo(5), equals(8));
        expect(nextPowerOfTwo(9), equals(16));
        expect(nextPowerOfTwo(100), equals(128));
      });

      test('zero and one return 1', () {
        expect(nextPowerOfTwo(0), equals(1));
        expect(nextPowerOfTwo(1), equals(1));
      });

      test('throws for negative input', () {
        expect(() => nextPowerOfTwo(-1), throwsArgumentError);
      });
    });
  });
}
