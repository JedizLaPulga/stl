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
