/// A set of classes that store multiple heterogeneous values.
///
/// In the C++ STL, `std::tuple` is defined in `<tuple>` and is variadic.
/// Since Dart does not support variadic generics, we provide fixed-size tuples
/// (`Tuple3` through `Tuple7`) that seamlessly interoperate with modern
/// Dart 3 Records. For 2 elements, use `Pair<T1, T2>`.
library;

/// A tuple of 3 elements.
class Tuple3<T1, T2, T3> {
  /// The first element of the tuple.
  T1 item1;
  /// The second element of the tuple.
  T2 item2;
  /// The third element of the tuple.
  T3 item3;

  /// Creates a [Tuple3] grouping the three values dynamically.
  Tuple3(this.item1, this.item2, this.item3);

  /// Creates a Tuple3 from a modern Dart 3 Record.
  Tuple3.fromRecord((T1, T2, T3) record)
      : item1 = record.$1,
        item2 = record.$2,
        item3 = record.$3;

  /// Returns the tuple as a modern Dart 3 Record.
  (T1, T2, T3) get record => (item1, item2, item3);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() => [item1, item2, item3];

  /// Creates a shallow clone.
  Tuple3<T1, T2, T3> clone() => Tuple3<T1, T2, T3>(item1, item2, item3);

  @override
  int get hashCode => Object.hash(item1, item2, item3);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tuple3<T1, T2, T3>) return false;
    return item1 == other.item1 &&
        item2 == other.item2 &&
        item3 == other.item3;
  }

  @override
  String toString() => '($item1, $item2, $item3)';
}

/// A tuple of 4 elements.
class Tuple4<T1, T2, T3, T4> {
  /// The first element of the tuple.
  T1 item1;
  /// The second element of the tuple.
  T2 item2;
  /// The third element of the tuple.
  T3 item3;
  /// The fourth element of the tuple.
  T4 item4;

  /// Creates a [Tuple4] grouping the four values dynamically.
  Tuple4(this.item1, this.item2, this.item3, this.item4);

  /// Creates a Tuple4 from a modern Dart 3 Record.
  Tuple4.fromRecord((T1, T2, T3, T4) record)
      : item1 = record.$1,
        item2 = record.$2,
        item3 = record.$3,
        item4 = record.$4;

  /// Returns the tuple as a modern Dart 3 Record.
  (T1, T2, T3, T4) get record => (item1, item2, item3, item4);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() => [item1, item2, item3, item4];

  /// Creates a shallow clone.
  Tuple4<T1, T2, T3, T4> clone() =>
      Tuple4<T1, T2, T3, T4>(item1, item2, item3, item4);

  @override
  int get hashCode => Object.hash(item1, item2, item3, item4);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tuple4<T1, T2, T3, T4>) return false;
    return item1 == other.item1 &&
        item2 == other.item2 &&
        item3 == other.item3 &&
        item4 == other.item4;
  }

  @override
  String toString() => '($item1, $item2, $item3, $item4)';
}

/// A tuple of 5 elements.
class Tuple5<T1, T2, T3, T4, T5> {
  /// The first element of the tuple.
  T1 item1;
  /// The second element of the tuple.
  T2 item2;
  /// The third element of the tuple.
  T3 item3;
  /// The fourth element of the tuple.
  T4 item4;
  /// The fifth element of the tuple.
  T5 item5;

  /// Creates a [Tuple5] grouping the five values dynamically.
  Tuple5(this.item1, this.item2, this.item3, this.item4, this.item5);

  /// Creates a Tuple5 from a modern Dart 3 Record.
  Tuple5.fromRecord((T1, T2, T3, T4, T5) record)
      : item1 = record.$1,
        item2 = record.$2,
        item3 = record.$3,
        item4 = record.$4,
        item5 = record.$5;

  /// Returns the tuple as a modern Dart 3 Record.
  (T1, T2, T3, T4, T5) get record => (item1, item2, item3, item4, item5);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() => [item1, item2, item3, item4, item5];

  /// Creates a shallow clone.
  Tuple5<T1, T2, T3, T4, T5> clone() =>
      Tuple5<T1, T2, T3, T4, T5>(item1, item2, item3, item4, item5);

  @override
  int get hashCode => Object.hash(item1, item2, item3, item4, item5);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tuple5<T1, T2, T3, T4, T5>) return false;
    return item1 == other.item1 &&
        item2 == other.item2 &&
        item3 == other.item3 &&
        item4 == other.item4 &&
        item5 == other.item5;
  }

  @override
  String toString() => '($item1, $item2, $item3, $item4, $item5)';
}

/// A tuple of 6 elements.
class Tuple6<T1, T2, T3, T4, T5, T6> {
  /// The first element of the tuple.
  T1 item1;
  /// The second element of the tuple.
  T2 item2;
  /// The third element of the tuple.
  T3 item3;
  /// The fourth element of the tuple.
  T4 item4;
  /// The fifth element of the tuple.
  T5 item5;
  /// The sixth element of the tuple.
  T6 item6;

  /// Creates a [Tuple6] grouping the six values dynamically.
  Tuple6(
      this.item1, this.item2, this.item3, this.item4, this.item5, this.item6);

  /// Creates a Tuple6 from a modern Dart 3 Record.
  Tuple6.fromRecord((T1, T2, T3, T4, T5, T6) record)
      : item1 = record.$1,
        item2 = record.$2,
        item3 = record.$3,
        item4 = record.$4,
        item5 = record.$5,
        item6 = record.$6;

  /// Returns the tuple as a modern Dart 3 Record.
  (T1, T2, T3, T4, T5, T6) get record =>
      (item1, item2, item3, item4, item5, item6);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() => [item1, item2, item3, item4, item5, item6];

  /// Creates a shallow clone.
  Tuple6<T1, T2, T3, T4, T5, T6> clone() => Tuple6<T1, T2, T3, T4, T5, T6>(
      item1, item2, item3, item4, item5, item6);

  @override
  int get hashCode => Object.hash(item1, item2, item3, item4, item5, item6);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tuple6<T1, T2, T3, T4, T5, T6>) return false;
    return item1 == other.item1 &&
        item2 == other.item2 &&
        item3 == other.item3 &&
        item4 == other.item4 &&
        item5 == other.item5 &&
        item6 == other.item6;
  }

  @override
  String toString() => '($item1, $item2, $item3, $item4, $item5, $item6)';
}

/// A tuple of 7 elements.
class Tuple7<T1, T2, T3, T4, T5, T6, T7> {
  /// The first element of the tuple.
  T1 item1;
  /// The second element of the tuple.
  T2 item2;
  /// The third element of the tuple.
  T3 item3;
  /// The fourth element of the tuple.
  T4 item4;
  /// The fifth element of the tuple.
  T5 item5;
  /// The sixth element of the tuple.
  T6 item6;
  /// The seventh element of the tuple.
  T7 item7;

  /// Creates a [Tuple7] grouping the seven values dynamically.
  Tuple7(this.item1, this.item2, this.item3, this.item4, this.item5, this.item6,
      this.item7);

  /// Creates a Tuple7 from a modern Dart 3 Record.
  Tuple7.fromRecord((T1, T2, T3, T4, T5, T6, T7) record)
      : item1 = record.$1,
        item2 = record.$2,
        item3 = record.$3,
        item4 = record.$4,
        item5 = record.$5,
        item6 = record.$6,
        item7 = record.$7;

  /// Returns the tuple as a modern Dart 3 Record.
  (T1, T2, T3, T4, T5, T6, T7) get record =>
      (item1, item2, item3, item4, item5, item6, item7);

  /// Returns the elements as a standard Dart List.
  List<dynamic> toList() =>
      [item1, item2, item3, item4, item5, item6, item7];

  /// Creates a shallow clone.
  Tuple7<T1, T2, T3, T4, T5, T6, T7> clone() =>
      Tuple7<T1, T2, T3, T4, T5, T6, T7>(
          item1, item2, item3, item4, item5, item6, item7);

  @override
  int get hashCode => Object.hash(item1, item2, item3, item4, item5, item6, item7);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tuple7<T1, T2, T3, T4, T5, T6, T7>) return false;
    return item1 == other.item1 &&
        item2 == other.item2 &&
        item3 == other.item3 &&
        item4 == other.item4 &&
        item5 == other.item5 &&
        item6 == other.item6 &&
        item7 == other.item7;
  }

  @override
  String toString() =>
      '($item1, $item2, $item3, $item4, $item5, $item6, $item7)';
}

/// A convenience function to create a [Tuple3], mimicking C++ `std::make_tuple`.
Tuple3<T1, T2, T3> makeTuple3<T1, T2, T3>(T1 item1, T2 item2, T3 item3) =>
    Tuple3(item1, item2, item3);

/// A convenience function to create a [Tuple4], mimicking C++ `std::make_tuple`.
Tuple4<T1, T2, T3, T4> makeTuple4<T1, T2, T3, T4>(
        T1 item1, T2 item2, T3 item3, T4 item4) =>
    Tuple4(item1, item2, item3, item4);

/// A convenience function to create a [Tuple5], mimicking C++ `std::make_tuple`.
Tuple5<T1, T2, T3, T4, T5> makeTuple5<T1, T2, T3, T4, T5>(
        T1 item1, T2 item2, T3 item3, T4 item4, T5 item5) =>
    Tuple5(item1, item2, item3, item4, item5);

/// A convenience function to create a [Tuple6], mimicking C++ `std::make_tuple`.
Tuple6<T1, T2, T3, T4, T5, T6> makeTuple6<T1, T2, T3, T4, T5, T6>(
        T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6) =>
    Tuple6(item1, item2, item3, item4, item5, item6);

/// A convenience function to create a [Tuple7], mimicking C++ `std::make_tuple`.
Tuple7<T1, T2, T3, T4, T5, T6, T7> makeTuple7<T1, T2, T3, T4, T5, T6, T7>(
        T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7) =>
    Tuple7(item1, item2, item3, item4, item5, item6, item7);
