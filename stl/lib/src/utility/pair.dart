/// A class that stores a pair of values.
///
/// In the C++ STL, `std::pair` is defined in `<utility>`.
/// It provides a way to store two heterogeneous objects as a single unit.
class Pair<T1, T2> {
  T1 first;
  T2 second;

  Pair(this.first, this.second);

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
Pair<T1, T2> makePair<T1, T2>(T1 first, T2 second) => Pair<T1, T2>(first, second);
