import 'package:stl/stl.dart';

void main() {
  print('--- Number Theory Utilities Example ---\n');

  // GCD & LCM
  final a = 12;
  final b = 18;
  print('gcd($a, $b) = ${gcd(a, b)}');
  print('lcm($a, $b) = ${lcm(a, b)}\n');

  // Midpoint safely without overflow
  final MAX_INT = 9223372036854775807; 
  final nearlyMax = MAX_INT - 2;
  print('midpoint($nearlyMax, $MAX_INT) = ${midpoint(nearlyMax, MAX_INT)}\n');

  // Prime Checking
  final p1 = 997;
  final p2 = 1000;
  print('isPrime($p1) = ${isPrime(p1)}');
  print('isPrime($p2) = ${isPrime(p2)}\n');

  // Prime Factorization
  final composite = 315;
  print('primeFactorization($composite) = ${primeFactorization(composite)}');
  // Proof: 3 * 3 * 5 * 7 = 315
}
