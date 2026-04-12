Type _typeOf<T>() => T;

/// A type-safe discriminated union holding either [T0] or [T1].
sealed class Variant2<T0, T1> {
  const Variant2();

  /// Creates a variant holding a [T0] value.
  factory Variant2.withT0(T0 value) = Variant2Item0<T0, T1>;

  /// Creates a variant holding a [T1] value.
  factory Variant2.withT1(T1 value) = Variant2Item1<T0, T1>;

  /// Visits the underlying value with exhaustive matching.
  R visit<R>({required R Function(T0) onT0, required R Function(T1) onT1});

  /// Checks if the variant currently holds the specified type alternative.
  bool holdsAlternative<T>();

  /// Gets the current active value dynamically.
  Object? get value;

  /// Gets the 0-based index of the active alternative.
  int get index;
}

final class Variant2Item0<T0, T1> extends Variant2<T0, T1> {
  @override
  final T0 value;

  const Variant2Item0(this.value);

  @override
  R visit<R>({required R Function(T0) onT0, required R Function(T1) onT1}) =>
      onT0(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T0>();

  @override
  int get index => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant2Item0<T0, T1> && other.value == value);

  @override
  int get hashCode => value.hashCode ^ 0.hashCode;

  @override
  String toString() => 'Variant2.withT0($value)';
}

final class Variant2Item1<T0, T1> extends Variant2<T0, T1> {
  @override
  final T1 value;

  const Variant2Item1(this.value);

  @override
  R visit<R>({required R Function(T0) onT0, required R Function(T1) onT1}) =>
      onT1(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T1>();

  @override
  int get index => 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant2Item1<T0, T1> && other.value == value);

  @override
  int get hashCode => value.hashCode ^ 1.hashCode;

  @override
  String toString() => 'Variant2.withT1($value)';
}

/// A type-safe discriminated union holding either [T0], [T1], or [T2].
sealed class Variant3<T0, T1, T2> {
  const Variant3();

  /// Creates a variant holding a [T0] value.
  factory Variant3.withT0(T0 value) = Variant3Item0<T0, T1, T2>;

  /// Creates a variant holding a [T1] value.
  factory Variant3.withT1(T1 value) = Variant3Item1<T0, T1, T2>;

  /// Creates a variant holding a [T2] value.
  factory Variant3.withT2(T2 value) = Variant3Item2<T0, T1, T2>;

  /// Visits the underlying value with exhaustive matching.
  R visit<R>({
    required R Function(T0) onT0,
    required R Function(T1) onT1,
    required R Function(T2) onT2,
  });

  /// Checks if the variant currently holds the specified type alternative.
  bool holdsAlternative<T>();

  /// Gets the current active value dynamically.
  Object? get value;

  /// Gets the 0-based index of the active alternative.
  int get index;
}

final class Variant3Item0<T0, T1, T2> extends Variant3<T0, T1, T2> {
  @override
  final T0 value;

  const Variant3Item0(this.value);

  @override
  R visit<R>({
    required R Function(T0) onT0,
    required R Function(T1) onT1,
    required R Function(T2) onT2,
  }) => onT0(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T0>();

  @override
  int get index => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant3Item0<T0, T1, T2> && other.value == value);

  @override
  int get hashCode => value.hashCode ^ 0.hashCode;

  @override
  String toString() => 'Variant3.withT0($value)';
}

final class Variant3Item1<T0, T1, T2> extends Variant3<T0, T1, T2> {
  @override
  final T1 value;

  const Variant3Item1(this.value);

  @override
  R visit<R>({
    required R Function(T0) onT0,
    required R Function(T1) onT1,
    required R Function(T2) onT2,
  }) => onT1(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T1>();

  @override
  int get index => 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant3Item1<T0, T1, T2> && other.value == value);

  @override
  int get hashCode => value.hashCode ^ 1.hashCode;

  @override
  String toString() => 'Variant3.withT1($value)';
}

final class Variant3Item2<T0, T1, T2> extends Variant3<T0, T1, T2> {
  @override
  final T2 value;

  const Variant3Item2(this.value);

  @override
  R visit<R>({
    required R Function(T0) onT0,
    required R Function(T1) onT1,
    required R Function(T2) onT2,
  }) => onT2(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T2>();

  @override
  int get index => 2;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant3Item2<T0, T1, T2> && other.value == value);

  @override
  int get hashCode => value.hashCode ^ 2.hashCode;

  @override
  String toString() => 'Variant3.withT2($value)';
}
