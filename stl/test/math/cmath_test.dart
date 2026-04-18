import 'package:stl/stl.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('cmath', () {
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

    group('hypot', () {
      test('computes 2D hypotenuse', () {
        expect(hypot(3, 4), equals(5.0));
        expect(hypot(-3, 4), equals(5.0));
        expect(hypot(3, -4), equals(5.0));
        expect(hypot(-3, -4), equals(5.0));
      });

      test('computes 3D hypotenuse', () {
        // sqrt(2*2 + 3*3 + 6*6) = sqrt(4 + 9 + 36) = sqrt(49) = 7
        expect(hypot(2, 3, 6), equals(7.0));
      });

      test('handles zeros', () {
        expect(hypot(0, 0), equals(0.0));
        expect(hypot(0, 0, 0), equals(0.0));
        expect(hypot(0, 5), equals(5.0));
      });

      test('avoids overflow', () {
        final huge = 1e160;
        // huge * huge would overflow to infinity without hypot protection
        expect(math.pow(huge, 2), equals(double.infinity));
        // But hypot computes correctly
        final result = hypot(huge, huge);
        expect(result, greaterThan(huge));
        expect(result.isInfinite, isFalse);
        expect(result, closeTo(huge * math.sqrt(2), 1e155));
      });

      test('avoids underflow', () {
        final tiny = 1e-200;
        // tiny * tiny would underflow to 0 without hypot protection
        expect(math.pow(tiny, 2), equals(0.0));
        // But hypot computes correctly
        final result = hypot(tiny, tiny);
        expect(result, greaterThan(0));
        expect(result, closeTo(tiny * math.sqrt(2), 1e-205));
      });
    });
  });
}
