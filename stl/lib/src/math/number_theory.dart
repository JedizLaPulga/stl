/// Common number theory algorithms and utilities.
///
/// Provides fundamental integer math inspired by C++ `<numeric>` and mathematical
/// conventions:
/// - [gcd] — greatest common divisor
/// - [lcm] — least common multiple
/// - [midpoint] — overflow-safe midpoint
/// - [isPrime] — primality test
/// - [primeFactorization] — prime factor list
library;

/// Returns the greatest common divisor of [a] and [b].
/// Uses the highly optimized Euclidean algorithm.
int gcd(int a, int b) {
  a = a.abs();
  b = b.abs();
  while (b != 0) {
    int t = b;
    b = a % b;
    a = t;
  }
  return a;
}

/// Returns the least common multiple of [a] and [b].
///
/// Computed as `|a| / gcd(a, b) * |b|` to avoid intermediate overflow.
/// Returns `0` if both [a] and [b] are zero.
int lcm(int a, int b) {
  if (a == 0 && b == 0) return 0;
  return (a.abs() ~/ gcd(a, b)) * b.abs();
}

/// Finds the midpoint of two numbers `(a + b) / 2` safely without overflow.
///
/// Corresponds to `std::midpoint` from C++20.
/// Properly handles the rounding direction and correctly differentiates between integer
/// truncation and floating point division.
T midpoint<T extends num>(T a, T b) {
  if (a is int && b is int) {
    // Integer overflow safe midpoint
    if ((a < 0) == (b < 0)) {
      // Same sign
      if (a <= b) {
        return (a + ((b - a) ~/ 2)) as T;
      } else {
        return (a - ((a - b) ~/ 2)) as T;
      }
    } else {
      // Differing signs cannot overflow addition
      return ((a + b) ~/ 2) as T;
    }
  } else {
    // Floating point math. Subtraction reduces precision loss compared to (a+b)/2
    return (a + (b - a) / 2.0) as T;
  }
}

/// Checks if a given number [n] is prime.
///
/// Uses an optimized 6k +/- 1 check algorithm.
bool isPrime(int n) {
  if (n <= 1) return false;
  if (n <= 3) return true;
  if (n % 2 == 0 || n % 3 == 0) return false;

  for (int i = 5; i * i <= n; i += 6) {
    if (n % i == 0 || n % (i + 2) == 0) return false;
  }
  return true;
}

/// Returns the prime factorization of [n] as a list of prime factors in ascending order.
///
/// Uses trial division optimized with 2, 3, and then 6k ± 1 candidates.
/// Returns an empty list if [n] is less than or equal to 1.
/// Example: `primeFactorization(12)` returns `[2, 2, 3]`.
List<int> primeFactorization(int n) {
  final factors = <int>[];
  if (n <= 1) return factors;

  while (n % 2 == 0) {
    factors.add(2);
    n ~/= 2;
  }
  while (n % 3 == 0) {
    factors.add(3);
    n ~/= 3;
  }

  for (int i = 5; i * i <= n; i += 6) {
    while (n % i == 0) {
      factors.add(i);
      n ~/= i;
    }
    while (n % (i + 2) == 0) {
      factors.add(i + 2);
      n ~/= (i + 2);
    }
  }

  if (n > 3) {
    factors.add(n);
  }
  return factors;
}
