import 'package:stl/stl.dart';

void main() {
  print('--- Advanced Statistical Random Module ---');

  // 1. Core Engines
  // ---------------------------------------------
  // Deterministic engine seeding: guaranteeing reproducible results.
  print('\n[Engines]');
  final mt = MersenneTwisterEngine(12345);
  final lcg = LinearCongruentialEngine.minstd(12345);

  print('Mersenne Twister (MT19937) 1st roll: \${mt.next()}');
  print('Linear Congruential (LCG) 1st roll: \${lcg.next()}');

  // 2. Statistical Distributions
  // ---------------------------------------------
  // Shaping uniform entropy into useful statistical curves.
  print('\n[Distributions]');
  
  // Uniform Int
  final d6 = UniformIntDistribution(1, 6);
  print('D6 Roll: \${d6(mt)}');

  // Uniform Real
  final perc = UniformRealDistribution(0.0, 100.0);
  print('Percentage: \${perc(mt).toStringAsFixed(2)}%');

  // Normal / Gaussian Distribution
  // Mean = 50.0, StdDev = 10.0
  final bellCurve = NormalDistribution(50.0, 10.0);
  print('Normally Distributed Score: \${bellCurve(mt).toStringAsFixed(1)}');

  // Bernoulli (Coin flip with a weighted probability)
  // 80% chance of True
  final riggedCoin = BernoulliDistribution(0.8);
  print('Rigged Coin Flip (80% True): \${riggedCoin(mt)}');

  // Poisson (Events occurring in a fixed interval)
  // Average 4 customers per hour
  final customers = PoissonDistribution(4.0);
  print('Customers arrived this hour: \${customers(mt)}');

  // 3. StdRandom Legacy API (Upgraded)
  // ---------------------------------------------
  // StdRandom now uses MT19937 under the hood for deterministic runs,
  // or DartNativeEngine for completely random system-seeded runs.
  print('\n[StdRandom Wrapper]');
  StdRandom.globalSeed(42);
  print('StdRandom Global Int: \${StdRandom.globalRange(1, 100)}');
}
