import 'package:stl/stl.dart';
import 'dart:math' as math;

void main() {
  print('─── <cmath> Module Examples ───\n');

  // ─── clamp ──────────────────────────────────────────────────────────────────
  print('[1] clamp() — bound a value between lo and hi');
  print('clamp(5, 0, 10)    = ${clamp(5, 0, 10)}');
  print('clamp(-5, 0, 10)   = ${clamp(-5, 0, 10)}');
  print('clamp(15, 0, 10)   = ${clamp(15, 0, 10)}');
  print('clamp(3.14, 0, 3)  = ${clamp(3.14, 0.0, 3.0)}');

  // ─── lerp ───────────────────────────────────────────────────────────────────
  print('\n[2] lerp() — linear interpolation');
  print('lerp(0, 10, 0.5)      = ${lerp(0, 10, 0.5)}');
  print('lerp(100, 200, 0.25)  = ${lerp(100, 200, 0.25)}');
  print('lerp(0, 10, 1.5)      = ${lerp(0, 10, 1.5)} (extrapolation)');

  // ─── hypot ──────────────────────────────────────────────────────────────────
  print('\n[3] hypot() — overflow-safe Euclidean distance');
  print('hypot(3, 4)     = ${hypot(3, 4)}');
  print('hypot(2, 3, 6)  = ${hypot(2, 3, 6)}');

  // ─── sign ───────────────────────────────────────────────────────────────────
  print('\n[4] sign() — signum: -1, 0, or 1');
  print('sign(42)    = ${sign(42)}');
  print('sign(-7)    = ${sign(-7)}');
  print('sign(0)     = ${sign(0)}');
  print('sign(3.14)  = ${sign(3.14)}');
  print('sign(-0.5)  = ${sign(-0.5)}');

  // ─── degrees / radians ──────────────────────────────────────────────────────
  print('\n[5] degrees() / radians() — angle unit conversion');
  print('degrees(pi)     = ${degrees(math.pi)}');
  print('degrees(pi/2)   = ${degrees(math.pi / 2)}');
  print('radians(180)    = ${radians(180)}');
  print('radians(90)     = ${radians(90)}');

  // ─── fma ────────────────────────────────────────────────────────────────────
  print('\n[6] fma() — fused multiply-add: a*b + c');
  print('fma(2, 3, 4)       = ${fma(2, 3, 4)}'); // 2*3 + 4 = 10
  print('fma(1.5, 2.0, 0.5) = ${fma(1.5, 2.0, 0.5)}'); // 3.0 + 0.5 = 3.5

  // ─── smoothstep ─────────────────────────────────────────────────────────────
  print('\n[7] smoothstep() — cubic Hermite S-curve interpolation');
  for (final t in [0.0, 0.25, 0.5, 0.75, 1.0]) {
    print('smoothstep(0, 1, $t) = ${smoothstep(0, 1, t).toStringAsFixed(4)}');
  }

  // ─── remap ──────────────────────────────────────────────────────────────────
  print('\n[8] remap() — map value from one range to another');
  print('remap(5, 0, 10, 0, 100)   = ${remap(5, 0, 10, 0, 100)}'); // 50
  print('remap(0, -1, 1, 0, 100)   = ${remap(0, -1, 1, 0, 100)}'); // 50
  print(
    'remap(15, 0, 10, 0, 100)  = ${remap(15, 0, 10, 0, 100)}',
  ); // 150 (extrapolation)

  // ─── saturate ───────────────────────────────────────────────────────────────
  print('\n[9] saturate() — clamp to [0, 1]');
  print('saturate(0.4)   = ${saturate(0.4)}');
  print('saturate(-0.3)  = ${saturate(-0.3)}');
  print('saturate(1.7)   = ${saturate(1.7)}');

  // ─── step ───────────────────────────────────────────────────────────────────
  print('\n[10] step() — Heaviside step function');
  print('step(5, 3)   = ${step(5, 3)}'); // 0.0 (x < edge)
  print('step(5, 5)   = ${step(5, 5)}'); // 1.0 (x == edge)
  print('step(5, 10)  = ${step(5, 10)}'); // 1.0 (x > edge)

  // ─── cbrt ───────────────────────────────────────────────────────────────────
  print('\n[11] cbrt() — real cube root');
  print('cbrt(8)    = ${cbrt(8)}');
  print('cbrt(27)   = ${cbrt(27)}');
  print('cbrt(-8)   = ${cbrt(-8)}');
  print('cbrt(2)    = ${cbrt(2).toStringAsFixed(6)}');

  // ─── log2 ───────────────────────────────────────────────────────────────────
  print('\n[12] log2() — base-2 logarithm');
  print('log2(1)     = ${log2(1)}');
  print('log2(2)     = ${log2(2)}');
  print('log2(1024)  = ${log2(1024)}');
  print('log2(10)    = ${log2(10).toStringAsFixed(6)}');

  // ─── log10 ──────────────────────────────────────────────────────────────────
  print('\n[13] log10() — base-10 logarithm');
  print('log10(1)     = ${log10(1)}');
  print('log10(10)    = ${log10(10)}');
  print('log10(1000)  = ${log10(1000)}');

  // ─── trunc ──────────────────────────────────────────────────────────────────
  print('\n[14] trunc() — truncate toward zero');
  print('trunc(3.7)   = ${trunc(3.7)}');
  print('trunc(-3.7)  = ${trunc(-3.7)}');
  print('trunc(3.0)   = ${trunc(3.0)}');

  // ─── fmod ───────────────────────────────────────────────────────────────────
  print('\n[15] fmod() — floating-point remainder (sign matches dividend)');
  print('fmod(7, 3)     = ${fmod(7, 3)}');
  print('fmod(-7, 3)    = ${fmod(-7, 3)}'); // -1.0 (sign of -7)
  print('fmod(7, -3)    = ${fmod(7, -3)}'); //  1.0 (sign of 7)

  // ─── fract ──────────────────────────────────────────────────────────────────
  print('\n[16] fract() — fractional part');
  print('fract(3.7)   = ${fract(3.7).toStringAsFixed(2)}');
  print('fract(-3.7)  = ${fract(-3.7).toStringAsFixed(2)}');
  print('fract(5.0)   = ${fract(5.0)}');

  // ─── copySign ───────────────────────────────────────────────────────────────
  print('\n[17] copySign() — apply sign of one value to another');
  print('copySign(-5, 1)    = ${copySign(-5, 1)}');
  print('copySign(5, -1)    = ${copySign(5, -1)}');
  print('copySign(7, -3)    = ${copySign(7, -3)}');

  // ─── nearlyEqual ────────────────────────────────────────────────────────────
  print('\n[18] nearlyEqual() — epsilon-based approximate equality');
  print('nearlyEqual(1.0, 1.0 + 1e-11)  = ${nearlyEqual(1.0, 1.0 + 1e-11)}');
  print('nearlyEqual(1.0, 1.1)           = ${nearlyEqual(1.0, 1.1)}');
  print('nearlyEqual(1.0, 1.05, 0.1)     = ${nearlyEqual(1.0, 1.05, 0.1)}');

  // ─── square / cube ──────────────────────────────────────────────────────────
  print('\n[19] square() — x²');
  print('square(3)    = ${square(3)}');
  print('square(-4)   = ${square(-4)}');
  print('square(2.5)  = ${square(2.5)}');

  print('\n[20] cube() — x³');
  print('cube(2)    = ${cube(2)}');
  print('cube(-3)   = ${cube(-3)}');
  print('cube(1.5)  = ${cube(1.5)}');

  // ─── isPowerOfTwo / nextPowerOfTwo ──────────────────────────────────────────
  print('\n[21] isPowerOfTwo() — bit-level power-of-two test');
  for (final n in [0, 1, 2, 3, 4, 6, 8, 16, 100, 128]) {
    print('isPowerOfTwo($n)  = ${isPowerOfTwo(n)}');
  }

  print('\n[22] nextPowerOfTwo() — smallest power of two >= n');
  for (final n in [0, 1, 3, 5, 9, 100, 128, 129]) {
    print('nextPowerOfTwo($n)  = ${nextPowerOfTwo(n)}');
  }
}
