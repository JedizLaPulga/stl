/// A class that stores a pair of values.
///
/// In the C++ STL, `std::pair` is defined in `<utility>`.
/// It provides a way to store two heterogeneous objects as a single unit.
class Pair<T1, T2> {
  T1 first;
  T2 second;

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

  /// Exchanges the contents of this pair with those of [other].
  void swap(Pair<T1, T2> other) {
    final tempFirst = first;
    final tempSecond = second;
    first = other.first;
    second = other.second;
    other.first = tempFirst;
    other.second = tempSecond;
  }

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
