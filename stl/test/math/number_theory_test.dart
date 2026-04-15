import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Number Theory', () {
    test('gcd', () {
      expect(gcd(12, 8), equals(4));
      expect(gcd(12, -8), equals(4));
      expect(gcd(0, 5), equals(5));
      expect(gcd(5, 0), equals(5));
      expect(gcd(13, 17), equals(1)); // coprime
      expect(gcd(0, 0), equals(0));
    });

    test('lcm', () {
      expect(lcm(4, 6), equals(12));
      expect(lcm(4, -6), equals(12));
      expect(lcm(0, 5), equals(0)); // LCM with 0 is 0
      expect(lcm(13, 17), equals(221)); // prime product
      expect(lcm(0, 0), equals(0));
    });

    test('midpoint', () {
      // Int midpoint
      expect(midpoint(0, 4), equals(2));
      expect(midpoint(1, 4), equals(2)); // Round towards 1
      expect(midpoint(4, 1), equals(3)); // Round towards 4
      
      expect(midpoint(-10, -20), equals(-15)); // Differing signs
      expect(midpoint(-10, 10), equals(0));
      // Max int overflow test (logic correctly limits)
      expect(midpoint(9223372036854775806, 9223372036854775807), equals(9223372036854775806));
      
      // Double midpoint
      expect(midpoint(1.0, 4.0), equals(2.5));
      expect(midpoint(0.0, 5.5), equals(2.75));
    });

    test('isPrime', () {
      expect(isPrime(-5), isFalse);
      expect(isPrime(0), isFalse);
      expect(isPrime(1), isFalse);
      expect(isPrime(2), isTrue);
      expect(isPrime(3), isTrue);
      expect(isPrime(4), isFalse);
      expect(isPrime(5), isTrue);
      expect(isPrime(17), isTrue);
      expect(isPrime(100), isFalse);
      expect(isPrime(997), isTrue); // large prime
    });

    test('primeFactorization', () {
      expect(primeFactorization(1), equals([]));
      expect(primeFactorization(2), equals([2]));
      expect(primeFactorization(12), equals([2, 2, 3]));
      expect(primeFactorization(30), equals([2, 3, 5]));
      expect(primeFactorization(100), equals([2, 2, 5, 5]));
      expect(primeFactorization(997), equals([997])); // prime factorization of prime is itself
      expect(primeFactorization(997 * 17), equals([17, 997]));
    });
  });
}
