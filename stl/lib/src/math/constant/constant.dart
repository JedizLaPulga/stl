/// ISO 80000-2 mathematical constants.
///
/// All constants follow ISO 80000-2 naming conventions and are provided as
/// `double` values with full IEEE 754 double-precision accuracy.
library;

// ─── Fundamental constants ───────────────────────────────────────────────────

/// The ratio of a circle's circumference to its diameter (π).
///
/// ISO 80000-2 symbol: **π**
/// Value: 3.141 592 653 589 793 238 46…
const double pi = 3.141592653589793238462643383279502884197;

/// The full-circle constant, equal to 2π (τ).
///
/// ISO 80000-2 symbol: **τ**
/// Value: 6.283 185 307 179 586 476 92…
const double tau = 6.283185307179586476925286766559005768394;

/// Euler's number; the base of the natural logarithm (e).
///
/// ISO 80000-2 symbol: **e**
/// Value: 2.718 281 828 459 045 235 36…
const double e = 2.718281828459045235360287471352662497757;

/// The golden ratio (φ), positive root of x² − x − 1 = 0.
///
/// ISO 80000-2 symbol: **φ**
/// Value: 1.618 033 988 749 894 848 20…
const double phi = 1.618033988749894848204586834365638117720;

/// The Euler–Mascheroni constant (γ).
///
/// Limit of (Hₙ − ln n) as n → ∞, where Hₙ is the n-th harmonic number.
///
/// ISO 80000-2 symbol: **γ**
/// Value: 0.577 215 664 901 532 860 60…
const double eulerMascheroni = 0.577215664901532860606512090082402431042;

// ─── Square roots ────────────────────────────────────────────────────────────

/// Square root of 2 (√2).
///
/// ISO 80000-2 symbol: **√2**
/// Value: 1.414 213 562 373 095 048 80…
const double sqrt2 = 1.414213562373095048801688724209698078569;

/// Square root of 3 (√3).
///
/// ISO 80000-2 symbol: **√3**
/// Value: 1.732 050 807 568 877 293 52…
const double sqrt3 = 1.732050807568877293527446341505872366942;

/// Square root of 5 (√5).
///
/// ISO 80000-2 symbol: **√5**
/// Value: 2.236 067 977 499 789 696 40…
const double sqrt5 = 2.236067977499789696409173668731276235440;

/// Reciprocal of the square root of 2 (1 / √2 = √2 / 2).
///
/// ISO 80000-2 symbol: **1/√2**
/// Value: 0.707 106 781 186 547 524 40…
const double sqrt1Over2 = 0.707106781186547524400844362104849039284;

/// Square root of π (√π).
///
/// Value: 1.772 453 850 905 516 027 29…
const double sqrtPi = 1.772453850905516027298167483341145182797;

// ─── Logarithms ──────────────────────────────────────────────────────────────

/// Natural logarithm of 2 (ln 2).
///
/// ISO 80000-2 symbol: **ln 2**
/// Value: 0.693 147 180 559 945 309 41…
const double ln2 = 0.693147180559945309417232121458176568075;

/// Natural logarithm of 10 (ln 10).
///
/// ISO 80000-2 symbol: **ln 10**
/// Value: 2.302 585 092 994 045 684 01…
const double ln10 = 2.302585092994045684017991454684364207601;

/// Base-2 logarithm of e (log₂ e).
///
/// ISO 80000-2 symbol: **log₂ e**
/// Value: 1.442 695 040 888 963 407 35…
const double log2e = 1.442695040888963407359924681001892137426;

/// Base-10 logarithm of e (log₁₀ e).
///
/// ISO 80000-2 symbol: **log₁₀ e**
/// Value: 0.434 294 481 903 251 827 65…
const double log10e = 0.434294481903251827651128918916605082294;

/// Base-2 logarithm of 10 (log₂ 10).
///
/// Value: 3.321 928 094 887 362 347 87…
const double log2_10 = 3.321928094887362347870319429489390175864;

/// Base-10 logarithm of 2 (log₁₀ 2).
///
/// Value: 0.301 029 995 663 981 195 21…
const double log10_2 = 0.301029995663981195213738894724493026768;

// ─── Reciprocals & fractions of π ────────────────────────────────────────────

/// Reciprocal of π (1 / π).
///
/// ISO 80000-2 symbol: **1/π**
/// Value: 0.318 309 886 183 790 671 53…
const double invPi = 0.318309886183790671537767526745028724068;

/// Two divided by π (2 / π).
///
/// ISO 80000-2 symbol: **2/π**
/// Value: 0.636 619 772 367 581 343 07…
const double twoDivPi = 0.636619772367581343075535053490057448137;

/// Two divided by the square root of π (2 / √π).
///
/// ISO 80000-2 symbol: **2/√π**
/// Value: 1.128 379 167 095 512 573 89…
const double twoDivSqrtPi = 1.128379167095512573896158903121545171688;

// ─── Other well-known constants ───────────────────────────────────────────────

/// Apéry's constant ζ(3); value of the Riemann zeta function at 3.
///
/// ISO 80000-2 symbol: **ζ(3)**
/// Value: 1.202 056 903 159 594 285 39…
const double apery = 1.202056903159594285399738161511449990764;

/// Catalan's constant (G).
///
/// Sum of (−1)ⁿ / (2n+1)² for n = 0 to ∞.
///
/// Value: 0.915 965 594 177 219 015 05…
const double catalan = 0.915965594177219015054603514932384110774;

/// The Khinchin constant (K₀).
///
/// Geometric mean of continued-fraction coefficients for almost all reals.
///
/// Value: 2.685 452 001 065 306 445 30…
const double khinchin = 2.685452001065306445309714835481795693820;

/// The natural logarithm of the golden ratio (ln φ).
///
/// Value: 0.481 211 825 059 603 447 49…
const double lnPhi = 0.481211825059603447497758913424368423135;

// ─── IEEE 754 special values ──────────────────────────────────────────────────

/// Positive infinity (IEEE 754).
const double infinity = double.infinity;

/// Negative infinity (IEEE 754).
const double negativeInfinity = double.negativeInfinity;

/// Not-a-Number sentinel (IEEE 754).
const double nan = double.nan;

/// The largest finite representable double (≈ 1.798 × 10³⁰⁸).
const double maxFinite = double.maxFinite;

/// The smallest positive non-zero double (≈ 5 × 10⁻³²⁴).
const double minPositive = double.minPositive;
