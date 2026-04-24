/// The `<functional>` module providing C++ standard function objects.
library;

/// Invokes the [callable] with the provided [args].
///
/// Mimics C++ `std::invoke`.
dynamic invoke(
  Function callable, {
  List<dynamic> positional = const [],
  Map<Symbol, dynamic> named = const {},
}) {
  return Function.apply(callable, positional, named);
}

// ==========================================
// Arithmetic Operations
// ==========================================

/// A functor that returns the sum of two arguments.
///
/// Mimics C++ `std::plus`.
class Plus<T> {
  /// Creates a [Plus] functor.
  const Plus();
  
  /// Computes `a + b`.
  T call(T a, T b) => ((a as dynamic) + (b as dynamic)) as T;
}

/// A functor that returns the difference of two arguments.
///
/// Mimics C++ `std::minus`.
class Minus<T> {
  /// Creates a [Minus] functor.
  const Minus();
  
  /// Computes `a - b`.
  T call(T a, T b) => ((a as dynamic) - (b as dynamic)) as T;
}

/// A functor that returns the product of two arguments.
///
/// Mimics C++ `std::multiplies`.
class Multiplies<T> {
  /// Creates a [Multiplies] functor.
  const Multiplies();
  
  /// Computes `a * b`.
  T call(T a, T b) => ((a as dynamic) * (b as dynamic)) as T;
}

/// A functor that returns the quotient of two arguments.
///
/// Mimics C++ `std::divides`.
class Divides<T> {
  /// Creates a [Divides] functor.
  const Divides();
  
  /// Computes `a / b`.
  T call(T a, T b) => ((a as dynamic) / (b as dynamic)) as T;
}

/// A functor that returns the remainder of two arguments.
///
/// Mimics C++ `std::modulus`.
class Modulus<T> {
  /// Creates a [Modulus] functor.
  const Modulus();
  
  /// Computes `a % b`.
  T call(T a, T b) => ((a as dynamic) % (b as dynamic)) as T;
}

/// A functor that returns the negation of its argument.
///
/// Mimics C++ `std::negate`.
class Negate<T> {
  /// Creates a [Negate] functor.
  const Negate();
  
  /// Computes `-a`.
  T call(T a) => (-(a as dynamic)) as T;
}

// ==========================================
// Comparisons
// ==========================================

/// A functor that checks if two arguments are equal.
///
/// Mimics C++ `std::equal_to`.
class EqualTo<T> {
  /// Creates an [EqualTo] functor.
  const EqualTo();
  
  /// Checks if `a == b`.
  bool call(T a, T b) => a == b;
}

/// A functor that checks if two arguments are not equal.
///
/// Mimics C++ `std::not_equal_to`.
class NotEqualTo<T> {
  /// Creates a [NotEqualTo] functor.
  const NotEqualTo();
  
  /// Checks if `a != b`.
  bool call(T a, T b) => a != b;
}

/// A functor that checks if the first argument is strictly greater than the second.
///
/// Mimics C++ `std::greater`.
class Greater<T> {
  /// Creates a [Greater] functor.
  const Greater();
  
  /// Checks if `a > b`.
  bool call(T a, T b) {
    if (a is Comparable && b is Comparable) {
      return a.compareTo(b) > 0;
    }
    return (a as dynamic) > (b as dynamic);
  }
}

/// A functor that checks if the first argument is strictly less than the second.
///
/// Mimics C++ `std::less`.
class Less<T> {
  /// Creates a [Less] functor.
  const Less();
  
  /// Checks if `a < b`.
  bool call(T a, T b) {
    if (a is Comparable && b is Comparable) {
      return a.compareTo(b) < 0;
    }
    return (a as dynamic) < (b as dynamic);
  }
}

/// A functor that checks if the first argument is greater than or equal to the second.
///
/// Mimics C++ `std::greater_equal`.
class GreaterEqual<T> {
  /// Creates a [GreaterEqual] functor.
  const GreaterEqual();
  
  /// Checks if `a >= b`.
  bool call(T a, T b) {
    if (a is Comparable && b is Comparable) {
      return a.compareTo(b) >= 0;
    }
    return (a as dynamic) >= (b as dynamic);
  }
}

/// A functor that checks if the first argument is less than or equal to the second.
///
/// Mimics C++ `std::less_equal`.
class LessEqual<T> {
  /// Creates a [LessEqual] functor.
  const LessEqual();
  
  /// Checks if `a <= b`.
  bool call(T a, T b) {
    if (a is Comparable && b is Comparable) {
      return a.compareTo(b) <= 0;
    }
    return (a as dynamic) <= (b as dynamic);
  }
}

// ==========================================
// Logical Operations
// ==========================================

/// A functor that computes the logical AND of two arguments.
///
/// Mimics C++ `std::logical_and`.
class LogicalAnd<T> {
  /// Creates a [LogicalAnd] functor.
  const LogicalAnd();
  
  /// Computes `a && b`.
  bool call(T a, T b) => (a as dynamic) && (b as dynamic);
}

/// A functor that computes the logical OR of two arguments.
///
/// Mimics C++ `std::logical_or`.
class LogicalOr<T> {
  /// Creates a [LogicalOr] functor.
  const LogicalOr();
  
  /// Computes `a || b`.
  bool call(T a, T b) => (a as dynamic) || (b as dynamic);
}

/// A functor that computes the logical NOT of its argument.
///
/// Mimics C++ `std::logical_not`.
class LogicalNot<T> {
  /// Creates a [LogicalNot] functor.
  const LogicalNot();
  
  /// Computes `!a`.
  bool call(T a) => !(a as dynamic);
}

// ==========================================
// Bitwise Operations
// ==========================================

/// A functor that computes the bitwise AND of two arguments.
///
/// Mimics C++ `std::bit_and`.
class BitAnd<T> {
  /// Creates a [BitAnd] functor.
  const BitAnd();
  
  /// Computes `a & b`.
  T call(T a, T b) => ((a as dynamic) & (b as dynamic)) as T;
}

/// A functor that computes the bitwise OR of two arguments.
///
/// Mimics C++ `std::bit_or`.
class BitOr<T> {
  /// Creates a [BitOr] functor.
  const BitOr();
  
  /// Computes `a | b`.
  T call(T a, T b) => ((a as dynamic) | (b as dynamic)) as T;
}

/// A functor that computes the bitwise XOR of two arguments.
///
/// Mimics C++ `std::bit_xor`.
class BitXor<T> {
  /// Creates a [BitXor] functor.
  const BitXor();
  
  /// Computes `a ^ b`.
  T call(T a, T b) => ((a as dynamic) ^ (b as dynamic)) as T;
}

/// A functor that computes the bitwise NOT of its argument.
///
/// Mimics C++ `std::bit_not`.
class BitNot<T> {
  /// Creates a [BitNot] functor.
  const BitNot();
  
  /// Computes `~a`.
  T call(T a) => (~(a as dynamic)) as T;
}
