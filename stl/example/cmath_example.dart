import 'dart:math' as math;

import 'package:stl/stl.dart';

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

  // ─── Trigonometric ────────────────────────────────────────────────────────
  print('\n[23] sin/cos/tan — ISO 80000-2 trig functions');
  print('sin(pi/6)  = ${sin(math.pi / 6).toStringAsFixed(4)}');
  print('cos(pi/3)  = ${cos(math.pi / 3).toStringAsFixed(4)}');
  print('tan(pi/4)  = ${tan(math.pi / 4).toStringAsFixed(4)}');

  print('\n[24] asin/acos/atan — inverse trig functions');
  print('asin(0.5)  = ${asin(0.5).toStringAsFixed(6)} (= pi/6)');
  print('acos(0.5)  = ${acos(0.5).toStringAsFixed(6)} (= pi/3)');
  print('atan(1)    = ${atan(1).toStringAsFixed(6)} (= pi/4)');

  print('\n[25] atan2() — two-argument arc-tangent');
  print('atan2(1, 1)   = ${atan2(1, 1).toStringAsFixed(6)} (= pi/4)');
  print('atan2(1, -1)  = ${atan2(1, -1).toStringAsFixed(6)} (= 3pi/4)');
  print('atan2(-1, 0)  = ${atan2(-1, 0).toStringAsFixed(6)} (= -pi/2)');

  // ─── Hyperbolic ──────────────────────────────────────────────────────────
  print('\n[26] sinh/cosh/tanh — hyperbolic functions');
  print('sinh(1)  = ${sinh(1).toStringAsFixed(6)}');
  print('cosh(1)  = ${cosh(1).toStringAsFixed(6)}');
  print('tanh(1)  = ${tanh(1).toStringAsFixed(6)}');

  print('\n[27] asinh/acosh/atanh — inverse hyperbolic functions');
  print('asinh(sinh(1))  = ${asinh(sinh(1)).toStringAsFixed(6)} (= 1)');
  print('acosh(cosh(2))  = ${acosh(cosh(2)).toStringAsFixed(6)} (= 2)');
  print('atanh(tanh(1))  = ${atanh(tanh(1)).toStringAsFixed(6)} (= 1)');

  // ─── Exponential & Logarithmic ───────────────────────────────────────────
  print('\n[28] exp/exp2/expm1 — exponential functions');
  print('exp(1)      = ${exp(1).toStringAsFixed(6)} (= e)');
  print('exp2(8)     = ${exp2(8)}');
  print(
    'expm1(1e-8) = ${expm1(1e-8).toStringAsExponential(4)} (accurate near 0)',
  );

  print('\n[29] log/log1p — natural logarithm');
  print('log(e)      = ${log(math.e).toStringAsFixed(6)}');
  print('log1p(0)    = ${log1p(0)}');
  print('log1p(e-1)  = ${log1p(math.e - 1).toStringAsFixed(6)} (= 1)');

  // ─── Power & Root ────────────────────────────────────────────────────────
  print('\n[30] pow/sqrt — general power and square root');
  print('pow(2, 10)  = ${pow(2, 10)}');
  print('sqrt(144)   = ${sqrt(144)}');

  // ─── Rounding ────────────────────────────────────────────────────────────
  print('\n[31] floor/ceil/round/nearbyInt — rounding modes (IEC 60559)');
  for (final v in [2.3, 2.5, 2.7, -2.5]) {
    print(
      '  v=$v  floor=${floor(v)}  ceil=${ceil(v)}'
      '  round=${round(v)}  nearbyInt=${nearbyInt(v)}',
    );
  }

  // ─── Arithmetic extras ───────────────────────────────────────────────────
  print('\n[32] abs/fdim/fmax/fmin');
  print('abs(-7.5)       = ${abs(-7.5)}');
  print('fdim(5, 3)      = ${fdim(5, 3)} (positive difference)');
  print('fdim(3, 5)      = ${fdim(3, 5)} (negative → 0)');
  print('fmax(3.0, NaN)  = ${fmax(3.0, double.nan)} (NaN propagates)');
  print('fmin(-1.0, 2.0) = ${fmin(-1.0, 2.0)}');

  // ─── Floating-point decomposition ────────────────────────────────────────
  print('\n[33] remainder — IEC 60559 remainder (round-to-nearest quotient)');
  print(
    'remainder(5, 3)  = ${remainder(5, 3)} (quotient rounds to 2 → 5-6=-1)',
  );
  print(
    'remainder(7, 4)  = ${remainder(7, 4)} (quotient rounds to 2 → 7-8=-1)',
  );

  print('\n[34] scalbn/ldexp — binary scaling');
  print('scalbn(1.5, 4)  = ${scalbn(1.5, 4)} (= 1.5 × 2⁴)');
  print('ldexp(3.0, 3)   = ${ldexp(3.0, 3)} (= 3 × 2³)');

  print('\n[35] frexp — split into fraction and exponent');
  final f8 = frexp(8);
  print('frexp(8)  → fraction=${f8.fraction}, exponent=${f8.exponent}');
  final fNeg = frexp(-0.5);
  print('frexp(-0.5) → fraction=${fNeg.fraction}, exponent=${fNeg.exponent}');

  print('\n[36] modf — split into integer and fractional parts');
  final m37 = modf(3.7);
  print(
    'modf(3.7)   → intPart=${m37.intPart}, fracPart=${m37.fracPart.toStringAsFixed(1)}',
  );
  final mNeg = modf(-3.7);
  print(
    'modf(-3.7)  → intPart=${mNeg.intPart}, fracPart=${mNeg.fracPart.toStringAsFixed(1)}',
  );

  print('\n[37] ilogb/logb — unbiased base-2 exponent');
  print('ilogb(8)   = ${ilogb(8)}');
  print('logb(8)    = ${logb(8)}');
  print('logb(0)    = ${logb(0)}');
  print('logb(inf)  = ${logb(double.infinity)}');

  // ─── Classification ──────────────────────────────────────────────────────
  print('\n[38] isNaN/isFinite/isInfinite/isNormal/signBit — classification');
  print('isNaN(NaN)       = ${isNaN(double.nan)}');
  print('isFinite(inf)    = ${isFinite(double.infinity)}');
  print('isInfinite(-inf) = ${isInfinite(double.negativeInfinity)}');
  print('isNormal(0.0)    = ${isNormal(0.0)}');
  print('isNormal(1.0)    = ${isNormal(1.0)}');
  print('signBit(-0.0)    = ${signBit(-0.0)}');
  print('signBit(0.0)     = ${signBit(0.0)}');

  // ─── Error & Gamma ───────────────────────────────────────────────────────
  print('\n[39] erf/erfc — error functions');
  print('erf(0)    = ${erf(0)}');
  print('erf(1)    = ${erf(1).toStringAsFixed(6)}');
  print('erfc(1)   = ${erfc(1).toStringAsFixed(6)} (= 1 - erf(1))');
  print('erf(inf)  = ${erf(double.infinity)}');

  print('\n[40] tgamma/lgamma — gamma function');
  print('tgamma(1)    = ${tgamma(1).toStringAsFixed(6)} (= 0! = 1)');
  print('tgamma(5)    = ${tgamma(5).toStringAsFixed(4)} (= 4! = 24)');
  print('tgamma(0.5)  = ${tgamma(0.5).toStringAsFixed(6)} (= sqrt(pi))');
  print('lgamma(5)    = ${lgamma(5).toStringAsFixed(6)} (= ln(24))');

  // ─── Angle & Signal ──────────────────────────────────────────────────────
  print('\n[41] wrapAngle — wrap angle into [-pi, pi)');
  print('wrapAngle(3pi)   = ${wrapAngle(3 * math.pi).toStringAsFixed(6)}');
  print('wrapAngle(2pi)   = ${wrapAngle(2 * math.pi).toStringAsFixed(6)}');
  print('wrapAngle(-4pi)  = ${wrapAngle(-4 * math.pi).toStringAsFixed(6)}');

  print('\n[42] angleDiff — shortest signed angular difference');
  print(
    'angleDiff(0, pi/2)   = ${angleDiff(0, math.pi / 2).toStringAsFixed(6)}',
  );
  print('angleDiff(pi, 0)     = ${angleDiff(math.pi, 0).toStringAsFixed(6)}');

  print('\n[43] sinc/normalizedSinc — sinc functions');
  print('sinc(0)              = ${sinc(0)}');
  print('sinc(pi)             = ${sinc(math.pi).toStringAsExponential(3)}');
  print('normalizedSinc(0)    = ${normalizedSinc(0)}');
  print('normalizedSinc(1)    = ${normalizedSinc(1).toStringAsExponential(3)}');

  // ─── Interpolation extras ────────────────────────────────────────────────
  print('\n[44] smootherstep — C² quintic interpolation (Perlin)');
  for (final t in [0.0, 0.25, 0.5, 0.75, 1.0]) {
    print('smootherstep($t) = ${smootherstep(t).toStringAsFixed(4)}');
  }

  print('\n[45] quinticStep — quintic polynomial (no clamping)');
  for (final t in [0.0, 0.5, 1.0]) {
    print('quinticStep($t) = ${quinticStep(t).toStringAsFixed(4)}');
  }

  print('\n[46] bilerp — bilinear interpolation over a unit square');
  print('bilerp(0,1,2,3, 0.5,0.5) = ${bilerp(0, 1, 2, 3, 0.5, 0.5)}');
  print('bilerp(0,1,2,3, 0,0)     = ${bilerp(0, 1, 2, 3, 0, 0)}');
  print('bilerp(0,1,2,3, 1,1)     = ${bilerp(0, 1, 2, 3, 1, 1)}');

  print('\n[47] pingpong — triangle-wave bounce');
  for (final t in [0.0, 0.5, 1.0, 1.5, 2.0, 2.5]) {
    print('pingpong($t, 1) = ${pingpong(t, 1).toStringAsFixed(1)}');
  }

  print('\n[48] moveTowards — step toward target without overshoot');
  print('moveTowards(0, 10, 3)   = ${moveTowards(0, 10, 3)}');
  print('moveTowards(0, 5, 10)   = ${moveTowards(0, 5, 10)} (reaches target)');
  print('moveTowards(10, 0, 3)   = ${moveTowards(10, 0, 3)}');

  // ─── Combinatorial & Integer Math ────────────────────────────────────────
  print('\n[49] factorial — n!');
  for (final n in [0, 1, 5, 10, 20]) {
    print('factorial($n)  = ${factorial(n)}');
  }

  print('\n[50] fallingFactorial — x(x-1)...(x-n+1)');
  print('fallingFactorial(5, 3) = ${fallingFactorial(5, 3)} (= 5×4×3 = 60)');
  print('fallingFactorial(7, 2) = ${fallingFactorial(7, 2)} (= 7×6 = 42)');

  print('\n[51] risingFactorial — x(x+1)...(x+n-1) (Pochhammer)');
  print('risingFactorial(3, 3) = ${risingFactorial(3, 3)} (= 3×4×5 = 60)');
  print('risingFactorial(2, 4) = ${risingFactorial(2, 4)} (= 2×3×4×5 = 120)');

  print('\n[52] binomial — C(n,k)');
  print('C(5,2)   = ${binomial(5, 2)}');
  print('C(10,3)  = ${binomial(10, 3)}');
  print('C(20,10) = ${binomial(20, 10)}');

  // ─── Special Mathematical Functions ──────────────────────────────────────
  print('\n[53] beta — Euler beta function B(a,b)');
  print('B(1,1)     = ${beta(1, 1).toStringAsFixed(6)} (= 1)');
  print('B(2,2)     = ${beta(2, 2).toStringAsFixed(6)} (= 1/6)');
  print('B(0.5,0.5) = ${beta(0.5, 0.5).toStringAsFixed(6)} (= pi)');

  print('\n[54] legendre — Legendre polynomial Pn(x)');
  for (final n in [0, 1, 2, 3, 4]) {
    print('P$n(0.5) = ${legendre(n, 0.5).toStringAsFixed(6)}');
  }

  print('\n[55] assocLegendre — associated Legendre polynomial Pnm(x)');
  print('P00(0.5) = ${assocLegendre(0, 0, 0.5).toStringAsFixed(6)}');
  print('P10(0.5) = ${assocLegendre(1, 0, 0.5).toStringAsFixed(6)}');
  print('P11(0.5) = ${assocLegendre(1, 1, 0.5).toStringAsFixed(6)}');

  print('\n[56] hermite — probabilist Hermite polynomial Hn(x)');
  for (final n in [0, 1, 2, 3]) {
    print('H$n(1) = ${hermite(n, 1).toStringAsFixed(4)}');
  }

  print('\n[57] laguerre — Laguerre polynomial Ln(x)');
  for (final n in [0, 1, 2, 3]) {
    print('L$n(1) = ${laguerre(n, 1).toStringAsFixed(4)}');
  }

  print('\n[58] assocLaguerre — associated Laguerre polynomial Lnm(x)');
  print('L00(1) = ${assocLaguerre(0, 0, 1).toStringAsFixed(4)}');
  print('L10(1) = ${assocLaguerre(1, 0, 1).toStringAsFixed(4)}');
  print('L21(1) = ${assocLaguerre(2, 1, 1).toStringAsFixed(4)}');

  print('\n[59] riemannZeta — Riemann zeta function ζ(s)');
  print('ζ(2)  = ${riemannZeta(2).toStringAsFixed(6)} (≈ pi²/6 = 1.6449)');
  print('ζ(4)  = ${riemannZeta(4).toStringAsFixed(6)} (≈ pi⁴/90 = 1.0823)');
  print('ζ(0)  = ${riemannZeta(0).toStringAsFixed(6)} (= -0.5)');
  print('ζ(1)  = ${riemannZeta(1)} (pole)');

  print(
    '\n[60] sphBessel / sphNeumann — spherical Bessel functions jn(x), yn(x)',
  );
  print('j0(pi) = ${sphBessel(0, math.pi).toStringAsFixed(6)} (≈ 0)');
  print('j1(1)  = ${sphBessel(1, 1).toStringAsFixed(6)}');
  print('y0(1)  = ${sphNeumann(0, 1).toStringAsFixed(6)}');

  print('\n[61] sphLegendre — real spherical harmonic Ynm(theta, phi)');
  print(
    'Y00(0,0) = ${sphLegendre(0, 0, 0, 0).toStringAsFixed(6)} (= 1/sqrt(4pi))',
  );
  print('Y10(0,0) = ${sphLegendre(1, 0, 0, 0).toStringAsFixed(6)}');

  print('\n[62] cylBesselJ — cylindrical Bessel J (first kind)');
  print('J0(0)      = ${cylBesselJ(0, 0).toStringAsFixed(6)}');
  print(
    'J0(2.405)  = ${cylBesselJ(0, 2.4048).toStringAsFixed(6)} (≈ 0, first zero)',
  );
  print('J1(0)      = ${cylBesselJ(1, 0)}');

  print('\n[63] cylBesselI — modified cylindrical Bessel I');
  print('I0(0) = ${cylBesselI(0, 0).toStringAsFixed(6)}');
  print('I0(1) = ${cylBesselI(0, 1).toStringAsFixed(6)} (≈ 1.2661)');
  print('I1(1) = ${cylBesselI(1, 1).toStringAsFixed(6)}');

  print('\n[64] cylBesselK — modified cylindrical Bessel K');
  print('K0(1) = ${cylBesselK(0, 1).toStringAsFixed(6)}');
  print('K1(1) = ${cylBesselK(1, 1).toStringAsFixed(6)}');

  print('\n[65] cylNeumann — cylindrical Neumann Y (second kind)');
  print('Y0(1) = ${cylNeumann(0, 1).toStringAsFixed(6)}');
  print('Y1(1) = ${cylNeumann(1, 1).toStringAsFixed(6)}');

  print('\n[66] expInt — exponential integral Ei(x)');
  print('Ei(1)  = ${expInt(1).toStringAsFixed(6)} (≈ 1.8951)');
  print('Ei(0)  = ${expInt(0)} (= -inf)');
  print('Ei(2)  = ${expInt(2).toStringAsFixed(6)}');

  print(
    '\n[67] compEllint1/2/3 — complete elliptic integrals K(k), E(k), Pi(n,k)',
  );
  print('K(0)     = ${compEllint1(0).toStringAsFixed(6)} (= pi/2)');
  print('K(0.5)   = ${compEllint1(0.5).toStringAsFixed(6)}');
  print('E(0)     = ${compEllint2(0).toStringAsFixed(6)} (= pi/2)');
  print('E(1)     = ${compEllint2(1).toStringAsFixed(6)} (= 1)');
  print('Pi(0,0)  = ${compEllint3(0, 0).toStringAsFixed(6)} (= pi/2)');

  print(
    '\n[68] ellint1/2/3 — incomplete elliptic integrals F(phi,k), E(phi,k), Pi(n,phi,k)',
  );
  print('F(pi/4, 0.5) = ${ellint1(math.pi / 4, 0.5).toStringAsFixed(6)}');
  print('E(pi/4, 0.5) = ${ellint2(math.pi / 4, 0.5).toStringAsFixed(6)}');
  print(
    'Pi(0.5, pi/4, 0.3) = ${ellint3(0.5, math.pi / 4, 0.3).toStringAsFixed(6)}',
  );
}
