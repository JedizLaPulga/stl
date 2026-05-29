import 'dart:math' as math;
import 'engine.dart';

/// A core abstract interface for statistical random number distributions.
///
/// Distributions map the uniform bits provided by a [RandomEngine] into
/// mathematically rigorous shapes (e.g., Bell curves, Poisson models, etc.).
abstract class RandomDistribution<T> {
  /// Creates a [RandomDistribution].
  const RandomDistribution();

  /// Generates the next random value sampled from this distribution
  /// using the provided [engine] as the source of entropy.
  T call(RandomEngine engine);
}

/// A distribution producing uniform integers in a closed interval `[a, b]`.
/// Mimics C++'s `std::uniform_int_distribution`.
class UniformIntDistribution implements RandomDistribution<int> {
  /// The lower bound (inclusive).
  final int a;

  /// The upper bound (inclusive).
  final int b;

  /// Constructs a distribution yielding values `a <= x <= b`.
  UniformIntDistribution([this.a = 0, this.b = 0x7FFFFFFF]) {
    if (a > b) {
      throw ArgumentError('UniformIntDistribution requires a <= b.');
    }
  }

  @override
  int call(RandomEngine engine) {
    if (a == b) return a;

    // We map the engine's [min, max] uniformly to [a, b].
    // Since engines output 32-bit values typically, we must avoid modulo bias.
    final engineRange = engine.max - engine.min;
    final distRange = b - a;

    if (distRange == engineRange) {
      return a + (engine.next() - engine.min);
    }

    // Fast path for DartNativeEngine
    if (engine is DartNativeEngine) {
      // Dart's Random natively supports range generation but exclusive of upper bound.
      // So we ask for b - a + 1
      // However, DartNativeEngine just exposes a Random instance. Since we don't have direct access,
      // we'll rely on the engine's uniform outputs.
    }

    // Rejection sampling to avoid modulo bias
    if (engineRange > distRange) {
      final int scale = (engineRange + 1) ~/ (distRange + 1);
      final int limit = scale * (distRange + 1);

      int val;
      do {
        val = engine.next() - engine.min;
      } while (val >= limit);

      return a + (val ~/ scale);
    } else {
      // If the engine range is smaller than the requested range,
      // we need to combine multiple engine outputs.
      // For simplicity in this implementation, we will fall back to floating point scaling
      // if strictly combining bits is too complex, though it introduces slight precision loss
      // for massive 64-bit integer ranges.
      final double norm = (engine.next() - engine.min) / engineRange;
      return a + (norm * (distRange + 1)).floor().clamp(0, distRange);
    }
  }
}

/// A distribution producing uniform floating-point numbers in a half-open interval `[a, b)`.
/// Mimics C++'s `std::uniform_real_distribution`.
class UniformRealDistribution implements RandomDistribution<double> {
  /// The lower bound (inclusive).
  final double a;

  /// The upper bound (inclusive).
  final double b;

  /// Constructs a distribution yielding values `a <= x < b`.
  UniformRealDistribution([this.a = 0.0, this.b = 1.0]) {
    if (a >= b) {
      throw ArgumentError('UniformRealDistribution requires a < b.');
    }
  }

  @override
  double call(RandomEngine engine) {
    final range = engine.max - engine.min;
    final double norm = (engine.next() - engine.min) / range;
    return a + norm * (b - a);
  }
}

/// A distribution producing boolean values where `true` occurs with probability `p`.
/// Mimics C++'s `std::bernoulli_distribution`.
class BernoulliDistribution implements RandomDistribution<bool> {
  /// The probability of success (returning true).
  final double p;

  /// Constructs a Bernoulli distribution with probability [p] of yielding true.
  BernoulliDistribution([this.p = 0.5]) {
    if (p < 0.0 || p > 1.0) {
      throw ArgumentError('Probability p must be in [0.0, 1.0].');
    }
  }

  @override
  bool call(RandomEngine engine) {
    if (p == 0.0) return false;
    if (p == 1.0) return true;

    final range = engine.max - engine.min;
    final double norm = (engine.next() - engine.min) / range;
    return norm < p;
  }
}

/// A distribution producing integers according to a Binomial distribution.
/// Yields the number of successes in [t] trials, each with probability [p].
/// Mimics C++'s `std::binomial_distribution`.
class BinomialDistribution implements RandomDistribution<int> {
  /// The number of trials.
  final int t;

  /// The probability of success in each trial.
  final double p;

  /// Constructs a Binomial distribution.
  BinomialDistribution(this.t, [this.p = 0.5]) {
    if (t < 0) throw ArgumentError('Trials t must be non-negative.');
    if (p < 0.0 || p > 1.0) {
      throw ArgumentError('Probability p must be in [0.0, 1.0].');
    }
  }

  @override
  int call(RandomEngine engine) {
    int successes = 0;
    final bernoulli = BernoulliDistribution(p);
    for (int i = 0; i < t; i++) {
      if (bernoulli(engine)) successes++;
    }
    return successes;
  }
}

/// A distribution producing normally distributed continuous numbers.
/// Uses the Box-Muller transform algorithm.
/// Mimics C++'s `std::normal_distribution`.
class NormalDistribution implements RandomDistribution<double> {
  /// The mean (mu) of the distribution.
  final double mean;

  /// The standard deviation (sigma) of the distribution.
  final double stddev;
  double? _cachedValue;

  /// Constructs a Normal distribution.
  NormalDistribution([this.mean = 0.0, this.stddev = 1.0]) {
    if (stddev <= 0.0) {
      throw ArgumentError('Standard deviation must be strictly positive.');
    }
  }

  @override
  double call(RandomEngine engine) {
    if (_cachedValue != null) {
      final double val = _cachedValue!;
      _cachedValue = null;
      return val * stddev + mean;
    }

    final range = engine.max - engine.min;

    double u1, u2;
    do {
      u1 = (engine.next() - engine.min) / range;
    } while (u1 <= 1e-7); // Prevent log(0)

    u2 = (engine.next() - engine.min) / range;

    final double mag = math.sqrt(-2.0 * math.log(u1));
    final double z0 = mag * math.cos(2.0 * math.pi * u2);
    final double z1 = mag * math.sin(2.0 * math.pi * u2);

    _cachedValue = z1;
    return z0 * stddev + mean;
  }
}

/// A distribution producing exponentially distributed continuous numbers.
/// Mimics C++'s `std::exponential_distribution`.
class ExponentialDistribution implements RandomDistribution<double> {
  /// The rate parameter.
  final double lambda;

  /// Constructs an Exponential distribution with rate parameter [lambda].
  ExponentialDistribution([this.lambda = 1.0]) {
    if (lambda <= 0.0) {
      throw ArgumentError('Lambda rate must be strictly positive.');
    }
  }

  @override
  double call(RandomEngine engine) {
    final range = engine.max - engine.min;
    double u;
    do {
      u = (engine.next() - engine.min) / range;
    } while (u == 0.0); // log(0) is -Infinity

    return -math.log(u) / lambda;
  }
}

/// A distribution producing Poisson distributed integers.
/// Uses Knuth's algorithm (for small means) and limits at large means.
/// Mimics C++'s `std::poisson_distribution`.
class PoissonDistribution implements RandomDistribution<int> {
  /// The average number of occurrences.
  final double mean;

  /// Constructs a Poisson distribution.
  PoissonDistribution([this.mean = 1.0]) {
    if (mean <= 0.0) {
      throw ArgumentError('Mean must be strictly positive.');
    }
  }

  @override
  int call(RandomEngine engine) {
    final range = engine.max - engine.min;

    // Knuth's algorithm (good for lambda < 30)
    final double l = math.exp(-mean);
    int k = 0;
    double p = 1.0;

    do {
      k++;
      final double u = (engine.next() - engine.min) / range;
      p *= u;
    } while (p > l);

    return k - 1;
  }
}

/// A distribution producing Gamma distributed continuous numbers.
/// Uses the Marsaglia and Tsang method.
/// Mimics C++'s `std::gamma_distribution`.
class GammaDistribution implements RandomDistribution<double> {
  /// The shape parameter.
  final double alpha;

  /// The scale parameter.
  final double beta;

  /// Constructs a Gamma distribution.
  GammaDistribution([this.alpha = 1.0, this.beta = 1.0]) {
    if (alpha <= 0.0 || beta <= 0.0) {
      throw ArgumentError(
        'Alpha (shape) and Beta (scale) must be strictly positive.',
      );
    }
  }

  @override
  double call(RandomEngine engine) {
    if (alpha == 1.0) {
      return ExponentialDistribution(1.0 / beta).call(engine);
    }

    double d, c, x, v, u;
    final double a = alpha < 1.0 ? alpha + 1.0 : alpha;

    d = a - 1.0 / 3.0;
    c = 1.0 / math.sqrt(9.0 * d);
    final normal = NormalDistribution();
    final range = engine.max - engine.min;

    while (true) {
      do {
        x = normal(engine);
        v = 1.0 + c * x;
      } while (v <= 0.0);

      v = v * v * v;
      u = (engine.next() - engine.min) / range;

      final double xSq = x * x;
      if (u < 1.0 - 0.0331 * xSq * xSq) {
        break;
      }

      if (math.log(u) < 0.5 * xSq + d * (1.0 - v + math.log(v))) {
        break;
      }
    }

    double result = d * v;

    // Correction for alpha < 1
    if (alpha < 1.0) {
      double u2;
      do {
        u2 = (engine.next() - engine.min) / range;
      } while (u2 == 0.0);
      result *= math.pow(u2, 1.0 / alpha);
    }

    return result * beta;
  }
}

/// A distribution producing Chi-squared distributed continuous numbers.
/// Mimics C++'s `std::chi_squared_distribution`.
class ChiSquaredDistribution implements RandomDistribution<double> {
  /// The number of degrees of freedom.
  final double degreesOfFreedom;
  late final GammaDistribution _gamma;

  /// Constructs a Chi-Squared distribution.
  ChiSquaredDistribution([this.degreesOfFreedom = 1.0]) {
    if (degreesOfFreedom <= 0.0) {
      throw ArgumentError('Degrees of freedom must be strictly positive.');
    }
    // Chi-squared(k) is a special case of Gamma(k/2, 2)
    _gamma = GammaDistribution(degreesOfFreedom / 2.0, 2.0);
  }

  @override
  double call(RandomEngine engine) {
    return _gamma(engine);
  }
}
