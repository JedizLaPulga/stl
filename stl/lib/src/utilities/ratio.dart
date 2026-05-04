/// Exact rational fractions.
///
/// Provides the [Ratio] class mimicking C++ `<ratio>` for type-safe, exact
/// compile-time and runtime rational arithmetic. Useful for SI prefix multipliers.
library;

import '../math/number_theory.dart';

/// Represents an exact rational fraction `num / den`.
///
/// Analogous to `std::ratio` in C++. All arithmetic operations return simplified
/// results. `Ratio` implements [Comparable] so instances may be compared with
/// `<`, `<=`, `>`, `>=`, and [compareTo].
class Ratio implements Comparable<Ratio> {
  /// The numerator of the fraction.
  final int num;

  /// The denominator of the fraction.
  final int den;

  /// Creates a [Ratio] from a numerator and [den] denominator (default `1`).
  ///
  /// Throws [ArgumentError] if [den] is zero.
  Ratio(this.num, [this.den = 1]) {
    if (den == 0) throw ArgumentError('Denominator cannot be zero.');
  }

  /// Returns a new simplified [Ratio] by dividing both [num] and [den] by their greatest common divisor.
  Ratio simplified() {
    int g = gcd(num, den);
    int n = num ~/ g;
    int d = den ~/ g;
    // Keep the denominator positive
    if (d < 0) {
      n = -n;
      d = -d;
    }
    return Ratio(n, d);
  }

  /// Adds another [Ratio] to this one and returns a simplified [Ratio].
  Ratio operator +(Ratio other) {
    return Ratio(
      num * other.den + other.num * den,
      den * other.den,
    ).simplified();
  }

  /// Subtracts another [Ratio] from this one and returns a simplified [Ratio].
  Ratio operator -(Ratio other) {
    return Ratio(
      num * other.den - other.num * den,
      den * other.den,
    ).simplified();
  }

  /// Multiplies this [Ratio] by another and returns a simplified [Ratio].
  Ratio operator *(Ratio other) {
    return Ratio(num * other.num, den * other.den).simplified();
  }

  /// Divides this [Ratio] by another and returns a simplified [Ratio].
  Ratio operator /(Ratio other) {
    return Ratio(num * other.den, den * other.num).simplified();
  }

  /// Returns the double precision floating-point representation of this ratio.
  double toDouble() => num / den;

  /// Compares this ratio with [other] using cross-multiplication to avoid
  /// floating-point error.
  ///
  /// Returns a negative integer, zero, or a positive integer when this ratio
  /// is less than, equal to, or greater than [other], respectively.
  @override
  int compareTo(Ratio other) {
    final s1 = simplified();
    final s2 = other.simplified();
    // Cross-multiply: a/b vs c/d  →  a*d vs c*b
    final lhs = s1.num * s2.den;
    final rhs = s2.num * s1.den;
    return lhs.compareTo(rhs);
  }

  /// Returns `true` if this ratio is less than [other].
  bool operator <(Ratio other) => compareTo(other) < 0;

  /// Returns `true` if this ratio is less than or equal to [other].
  bool operator <=(Ratio other) => compareTo(other) <= 0;

  /// Returns `true` if this ratio is greater than [other].
  bool operator >(Ratio other) => compareTo(other) > 0;

  /// Returns `true` if this ratio is greater than or equal to [other].
  bool operator >=(Ratio other) => compareTo(other) >= 0;

  /// Returns the negation of this ratio as a simplified [Ratio].
  ///
  /// Example: `Ratio(3, 4).negate()` → `Ratio(-3, 4)`.
  Ratio negate() => Ratio(-num, den).simplified();

  /// Returns the reciprocal (multiplicative inverse) of this ratio as a simplified [Ratio].
  ///
  /// Throws [ArgumentError] if the numerator is zero (reciprocal of zero is undefined).
  Ratio reciprocal() {
    if (num == 0) throw ArgumentError('Reciprocal of zero is undefined.');
    return Ratio(den, num).simplified();
  }

  /// Returns the absolute value of this ratio as a simplified [Ratio].
  ///
  /// Example: `Ratio(-3, 4).abs()` → `Ratio(3, 4)`.
  Ratio abs() => Ratio(num.abs(), den).simplified();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Ratio) return false;
    final s1 = simplified();
    final s2 = other.simplified();
    return s1.num == s2.num && s1.den == s2.den;
  }

  @override
  int get hashCode {
    final s = simplified();
    return s.num.hashCode ^ s.den.hashCode;
  }

  @override
  String toString() => '$num/$den';

  /// Atto (10^-18)
  static final atto = Ratio(1, 1000000000000000000);

  /// Femto (10^-15)
  static final femto = Ratio(1, 1000000000000000);

  /// Pico (10^-12)
  static final pico = Ratio(1, 1000000000000);

  /// Nano (10^-9)
  static final nano = Ratio(1, 1000000000);

  /// Micro (10^-6)
  static final micro = Ratio(1, 1000000);

  /// Milli (10^-3)
  static final milli = Ratio(1, 1000);

  /// Centi (10^-2)
  static final centi = Ratio(1, 100);

  /// Deci (10^-1)
  static final deci = Ratio(1, 10);

  /// Deca (10^1)
  static final deca = Ratio(10, 1);

  /// Hecto (10^2)
  static final hecto = Ratio(100, 1);

  /// Kilo (10^3)
  static final kilo = Ratio(1000, 1);

  /// Mega (10^6)
  static final mega = Ratio(1000000, 1);

  /// Giga (10^9)
  static final giga = Ratio(1000000000, 1);

  /// Tera (10^12)
  static final tera = Ratio(1000000000000, 1);

  /// Peta (10^15)
  static final peta = Ratio(1000000000000000, 1);

  /// Exa (10^18)
  static final exa = Ratio(1000000000000000000, 1);
}
