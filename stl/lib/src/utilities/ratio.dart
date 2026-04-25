/// Exact rational fractions.
///
/// Provides the [Ratio] class mimicking C++ `<ratio>` for type-safe, exact
/// compile-time and runtime rational arithmetic. Useful for SI prefix multipliers.
library;

import '../math/number_theory.dart';

/// Represents an exact rational fraction `num / den`.
///
/// Analogous to `std::ratio` in C++.
class Ratio {
  /// The numerator of the fraction.
  final int num;

  /// The denominator of the fraction.
  final int den;

  /// Creates a [Ratio] from a numerator and denominator.
  /// Throws if denominator is zero.
  const Ratio(this.num, [this.den = 1]) : assert(den != 0, 'Denominator cannot be zero.');

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
    return Ratio(num * other.den + other.num * den, den * other.den).simplified();
  }

  /// Subtracts another [Ratio] from this one and returns a simplified [Ratio].
  Ratio operator -(Ratio other) {
    return Ratio(num * other.den - other.num * den, den * other.den).simplified();
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
  static const atto = Ratio(1, 1000000000000000000);
  /// Femto (10^-15)
  static const femto = Ratio(1, 1000000000000000);
  /// Pico (10^-12)
  static const pico = Ratio(1, 1000000000000);
  /// Nano (10^-9)
  static const nano = Ratio(1, 1000000000);
  /// Micro (10^-6)
  static const micro = Ratio(1, 1000000);
  /// Milli (10^-3)
  static const milli = Ratio(1, 1000);
  /// Centi (10^-2)
  static const centi = Ratio(1, 100);
  /// Deci (10^-1)
  static const deci = Ratio(1, 10);
  /// Deca (10^1)
  static const deca = Ratio(10, 1);
  /// Hecto (10^2)
  static const hecto = Ratio(100, 1);
  /// Kilo (10^3)
  static const kilo = Ratio(1000, 1);
  /// Mega (10^6)
  static const mega = Ratio(1000000, 1);
  /// Giga (10^9)
  static const giga = Ratio(1000000000, 1);
  /// Tera (10^12)
  static const tera = Ratio(1000000000000, 1);
  /// Peta (10^15)
  static const peta = Ratio(1000000000000000, 1);
  /// Exa (10^18)
  static const exa = Ratio(1000000000000000000, 1);
}
