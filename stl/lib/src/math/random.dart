import 'dart:math';

/// A deterministic, predictable C++ style pseudo-random number generator.
///
/// Mimics C++ `<random>` library utilities by providing a stateful generator
/// that can be seeded (`seed()`), forced to discard values (`flush()`), and 
/// natively constrained within specific integer boundaries (`range()`).
class StdRandom {
  int? _currentSeed;
  late Random _generator;

  /// Natively constructs a new random generator.
  /// 
  /// If [seed] is provided, it guarantees deterministic output mapping.
  /// Otherwise, it initializes dynamically based on system time securely.
  StdRandom([int? seed]) {
    this.seed(seed);
  }

  /// Re-seeds the internal generator precisely.
  ///
  /// Passing `null` will completely re-randomize the state from the system natively.
  void seed([int? newSeed]) {
    _currentSeed = newSeed;
    _generator = newSeed != null ? Random(newSeed) : Random();
  }

  /// Returns the current seed, if one was explicitly bound.
  int? get currentSeed => _currentSeed;

  /// Generates the next random integer from `0` to `2^32 - 1`.
  /// 
  /// Effectively mimics standard `rand()` execution behavior.
  int next() {
    return _generator.nextInt(4294967296);
  }

  /// Generates a strictly bounded random integer between [min] (inclusive) and [max] (exclusive).
  ///
  /// Maps conceptually to C++ `std::uniform_int_distribution`.
  int range(int min, int max) {
    if (min >= max) {
      throw ArgumentError('StdRandom mathematically requires min < max.');
    }
    return min + _generator.nextInt(max - min);
  }

  /// Generates a strictly bounded random double mathematically between 0.0 and 1.0.
  ///
  /// Maps conceptually to C++ `std::uniform_real_distribution`.
  double nextDouble() {
    return _generator.nextDouble();
  }

  /// Generates a random boolean explicitly modeling a coin-flip.
  ///
  /// Maps conceptually to C++ `std::bernoulli_distribution`.
  bool nextBool() {
    return _generator.nextBool();
  }

  /// Flushes (advances and discards) the next [count] states dynamically.
  ///
  /// This is extremely useful for explicitly burning internal generator state,
  /// matching C++ engine `.discard()` method natively.
  void flush([int count = 1]) {
    if (count < 0) {
      throw ArgumentError('StdRandom mathematically restricts flush to non-negative counts.');
    }
    for (var i = 0; i < count; i++) {
      _generator.nextInt(256); // Burn an arbitrary state shift natively
    }
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
