import 'dart:math';

import 'random/engine.dart';
import 'random/distribution.dart';

export 'random/engine.dart';
export 'random/distribution.dart';

/// A deterministic, predictable C++ style pseudo-random number generator.
///
/// Mimics C++ `<random>` library utilities by providing a stateful generator
/// that can be seeded (`seed()`), forced to discard values (`flush()`), and 
/// natively constrained within specific integer boundaries (`range()`).
/// 
/// In v0.7.0, this class has been retrofitted to wrap a core [RandomEngine],
/// allowing interchangeable backends like [MersenneTwisterEngine].
class StdRandom {
  int? _currentSeed;
  late RandomEngine _engine;

  /// Constructs a new random generator.
  /// 
  /// If [seed] is provided, it guarantees deterministic output mapping using an MT19937 engine.
  /// Otherwise, it initializes dynamically based on system time securely via the native engine.
  StdRandom([int? seed]) {
    this.seed(seed);
  }

  /// Re-seeds the internal generator precisely.
  ///
  /// Passing `null` will completely re-randomize the state from the system natively.
  void seed([int? newSeed]) {
    _currentSeed = newSeed;
    if (newSeed != null) {
      _engine = MersenneTwisterEngine(newSeed);
    } else {
      _engine = DartNativeEngine();
    }
  }

  /// Returns the current seed, if one was explicitly bound.
  int? get currentSeed => _currentSeed;

  /// Generates the next random integer from `0` to `2^32 - 1`.
  /// 
  /// Effectively mimics standard `rand()` execution behavior.
  int next() {
    return _engine.next();
  }

  /// Generates a strictly bounded random integer between [min] (inclusive) and [max] (exclusive).
  ///
  /// Maps conceptually to C++ `std::uniform_int_distribution`.
  int range(int min, int max) {
    if (min >= max) {
      throw ArgumentError('StdRandom mathematically requires min < max.');
    }
    // Note: range is exclusive of max for StdRandom's historical API,
    // whereas UniformIntDistribution is inclusive of both bounds.
    final dist = UniformIntDistribution(min, max - 1);
    return dist(_engine);
  }

  /// Generates a strictly bounded random double mathematically between 0.0 and 1.0.
  ///
  /// Maps conceptually to C++ `std::uniform_real_distribution`.
  double nextDouble() {
    final dist = UniformRealDistribution(0.0, 1.0);
    return dist(_engine);
  }

  /// Generates a random boolean explicitly modeling a coin-flip.
  ///
  /// Maps conceptually to C++ `std::bernoulli_distribution`.
  bool nextBool() {
    final dist = BernoulliDistribution(0.5);
    return dist(_engine);
  }

  /// Flushes (advances and discards) the next [count] states dynamically.
  ///
  /// This is extremely useful for explicitly burning internal generator state,
  /// matching C++ engine `.discard()` method natively.
  void flush([int count = 1]) {
    _engine.discard(count);
  }

  // ==========================================
  // Global Shared State Utilities
  // ==========================================

  static final StdRandom _global = StdRandom();

  /// A statically global, easily accessible random generator cleanly replicating
  /// global `rand()` usage without needing explicit instance allocations.
  static int globalNext() => _global.next();

  /// Statically grabs a globally bounded uniform random integer instantly.
  static int globalRange(int min, int max) => _global.range(min, max);
  
  /// Statically reseeds the globally shared `StdRandom` instance dynamically.
  static void globalSeed(int explicitSeed) => _global.seed(explicitSeed);
}
