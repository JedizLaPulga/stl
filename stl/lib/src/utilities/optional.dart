/// A container for a value that may or may not exist.
/// Using a sealed class ensures exhaustive pattern matching.
sealed class Optional<T> {
  const Optional();

  /// Creates an [Optional] containing [value].
  factory Optional.of(T value) = Some<T>;

  /// Creates an empty [Optional].
  factory Optional.none() = None<T>;

  /// Wraps a nullable value. Returns [None] if [value] is null.
  factory Optional.ofNullable(T? value) =>
      value == null ? None<T>() : Some<T>(value);

  /// Returns true if this is a [Some] instance.
  bool get isPresent => this is Some<T>;

  /// Returns true if this is a [None] instance.
  bool get isEmpty => this is None<T>;

  /// Returns the value if present, otherwise returns [fallback].
  T valueOr(T fallback) => switch (this) {
    Some(:final value) => value,
    None() => fallback,
  };

  /// Transforms the value if present using [mapper].
  Optional<R> map<R>(R Function(T value) mapper) => switch (this) {
    Some(:final value) => Some<R>(mapper(value)),
    None() => None<R>(),
  };

  /// Transforms the value using a function that returns an [Optional].
  /// Prevents nested structures like `Optional<Optional<T>>`.
  Optional<R> flatMap<R>(Optional<R> Function(T value) mapper) =>
      switch (this) {
        Some(:final value) => mapper(value),
        None() => None<R>(),
      };

  /// Reduces this [Optional] to a single value using one of two branches.
  ///
  /// [onSome] is called with the wrapped value when present; [onNone] is
  /// called when the [Optional] is empty.
  ///
  /// Example:
  /// ```dart
  /// final label = opt.fold((v) => 'Got $v', () => 'Nothing');
  /// ```
  R fold<R>(R Function(T value) onSome, R Function() onNone) => switch (this) {
    Some(:final value) => onSome(value),
    None() => onNone(),
  };

  /// Returns this [Optional] if the [predicate] holds for the contained value,
  /// otherwise returns [None].
  ///
  /// If this is already [None], it is returned unchanged.
  /// Equivalent to Haskell's `mfilter` and Java's `Optional.filter`.
  Optional<T> filter(bool Function(T value) predicate) => switch (this) {
    Some(:final value) => predicate(value) ? this : None<T>(),
    None() => this,
  };

  /// Combines this [Optional] with [other] into an `Optional` of a record.
  ///
  /// Returns `Some((value, otherValue))` only when **both** operands are [Some].
  /// Returns [None] if either operand is [None].
  ///
  /// Example:
  /// ```dart
  /// Optional.of(1).zip(Optional.of('a')); // Some((1, 'a'))
  /// Optional.of(1).zip(Optional.none());  // None
  /// ```
  Optional<(T, R)> zip<R>(Optional<R> other) => switch (this) {
    Some(:final value) => switch (other) {
      Some(value: final otherValue) => Some<(T, R)>((value, otherValue)),
      None() => None<(T, R)>(),
    },
    None() => None<(T, R)>(),
  };
}

/// Variant representing an existing value.
final class Some<T> extends Optional<T> {
  /// The value contained within.
  final T value;

  /// Creates a [Some] variant with the given [value].
  const Some(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Some<T> && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Some($value)';
}

/// Variant representing a missing value.
final class None<T> extends Optional<T> {
  /// Creates a constant [None] variant representing the absence of a value.
  const None();

  @override
  bool operator ==(Object other) => other is None<T>;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'None';
}
