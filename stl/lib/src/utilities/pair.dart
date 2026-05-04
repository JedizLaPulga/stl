/// A class that stores a pair of values.
///
/// In the C++ STL, `std::pair` is defined in `<utility>`.
/// It provides a way to store two heterogeneous objects as a single unit.
class Pair<T1, T2> {
  /// The first element of the pair.
  T1 first;

  /// The second element of the pair.
  T2 second;

  /// Creates a [Pair] grouping the [first] and [second] values dynamically.
  Pair(this.first, this.second);

  /// Creates a Pair from a modern Dart 3 Record.
  Pair.fromRecord((T1, T2) record) : first = record.$1, second = record.$2;

  /// Returns the pair as a modern Dart 3 Record for easy destructuring.
  /// Example: `var (a, b) = myPair.record;`
  (T1, T2) get record => (first, second);

  /// Creates a Pair from a [MapEntry].
  Pair.fromMapEntry(MapEntry<T1, T2> entry)
    : first = entry.key,
      second = entry.value;

  /// Returns the pair as a [MapEntry], making it perfectly compatible with Dart Maps.
  MapEntry<T1, T2> toMapEntry() => MapEntry(first, second);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() => [first, second];

  /// Creates a shallow clone of the Pair.
  Pair<T1, T2> clone() => Pair<T1, T2>(first, second);

  /// Returns a new [Pair] with the first and second elements exchanged.
  ///
  /// Unlike a mutating swap, this returns a new instance, preserving the
  /// immutability contract shared by the other utility types. The returned
  /// type is `Pair<T2, T1>` — the type parameters are reversed to match the
  /// swapped values.
  Pair<T2, T1> swap() => Pair<T2, T1>(second, first);

  /// Transforms both elements and returns a new [Pair].
  ///
  /// [mapFirst] is applied to [first]; [mapSecond] is applied to [second].
  /// Both results are combined into a `Pair<R, S>`.
  Pair<R, S> map<R, S>(R Function(T1) mapFirst, S Function(T2) mapSecond) =>
      Pair<R, S>(mapFirst(first), mapSecond(second));

  /// Transforms only the [first] element and returns a new `Pair<R, T2>`.
  Pair<R, T2> mapFirst<R>(R Function(T1) f) => Pair<R, T2>(f(first), second);

  /// Transforms only the [second] element and returns a new `Pair<T1, R>`.
  Pair<T1, R> mapSecond<R>(R Function(T2) f) => Pair<T1, R>(first, f(second));

  /// Reduces the pair to a single value by applying [f] to both elements.
  ///
  /// Example:
  /// ```dart
  /// final pair = Pair('hello', 5);
  /// final result = pair.fold((s, n) => s.substring(0, n)); // 'hello'
  /// ```
  R fold<R>(R Function(T1, T2) f) => f(first, second);

  @override
  int get hashCode => Object.hash(first, second);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Pair<T1, T2>) return false;
    return first == other.first && second == other.second;
  }

  @override
  String toString() => '($first, $second)';
}

/// A convenience function to create a [Pair], mimicking C++ `std::make_pair`.
Pair<T1, T2> makePair<T1, T2>(T1 first, T2 second) =>
    Pair<T1, T2>(first, second);

/// Adds C++ `<utility>` relational operators securely without sacrificing generic safety.
/// These operators (`<`, `<=`, `>`, `>=`, `compareTo`) automatically unlock
/// when both `T1` and `T2` happen to extend `Comparable`.
extension ComparablePair<
  T1 extends Comparable<dynamic>,
  T2 extends Comparable<dynamic>
>
    on Pair<T1, T2> {
  /// Compares this pair lexicographically with [other].
  ///
  /// It first compares the `first` elements. If they are equal, it compares
  /// the `second` elements.
  int compareTo(Pair<T1, T2> other) {
    int firstComparison = first.compareTo(other.first);
    if (firstComparison != 0) return firstComparison;
    return second.compareTo(other.second);
  }

  /// Returns whether this pair is lexicographically less than [other].
  bool operator <(Pair<T1, T2> other) => compareTo(other) < 0;

  /// Returns whether this pair is lexicographically less than or equal to [other].
  bool operator <=(Pair<T1, T2> other) => compareTo(other) <= 0;

  /// Returns whether this pair is lexicographically greater than [other].
  bool operator >(Pair<T1, T2> other) => compareTo(other) > 0;

  /// Returns whether this pair is lexicographically greater than or equal to [other].
  bool operator >=(Pair<T1, T2> other) => compareTo(other) >= 0;
}
