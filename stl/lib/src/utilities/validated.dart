import '../exceptions/exceptions.dart';

/// An error-accumulating result type sealed into [Valid] and [Invalid].
///
/// Unlike [Expected] which short-circuits on the first error, [Validated]
/// collects **all** errors from a pipeline. This makes it ideal for
/// form or data validation where you want to report every problem at once
/// rather than stopping at the first failure.
///
/// The key operation is [zip], which combines two [Validated] values:
/// - Both valid → `Valid` containing a [Pair] of both values.
/// - Any invalid → `Invalid` containing the **union** of all errors.
///
/// ```dart
/// Validated<String, int> age = Validated.valid(25);
/// Validated<String, String> name = Validated.valid('Alice');
/// final combined = age.zip(name); // Valid((25, 'Alice'))
///
/// Validated<String, int> bad1 = Validated.invalid('Age must be positive');
/// Validated<String, int> bad2 = Validated.invalid('Age too large');
/// final both = bad1.zip(bad2); // Invalid(['Age must be positive', 'Age too large'])
/// ```
sealed class Validated<E, A> {
  const Validated();

  /// Creates a [Valid] result containing [value].
  factory Validated.valid(A value) = Valid<E, A>;

  /// Creates an [Invalid] result with a single error [error].
  factory Validated.invalid(E error) => Invalid<E, A>([error]);

  /// Creates an [Invalid] result with multiple [errors].
  ///
  /// Throws [InvalidArgument] if [errors] is empty.
  factory Validated.invalidAll(List<E> errors) {
    if (errors.isEmpty) {
      throw InvalidArgument('InvalidAll requires at least one error.');
    }
    return Invalid<E, A>(List.unmodifiable(errors));
  }

  /// Returns `true` if this is a [Valid] instance.
  bool get isValid => this is Valid<E, A>;

  /// Returns `true` if this is an [Invalid] instance.
  bool get isInvalid => this is Invalid<E, A>;

  /// Returns the value if [Valid], otherwise returns [fallback].
  A valueOr(A fallback) => switch (this) {
    Valid(:final value) => value,
    Invalid() => fallback,
  };

  /// Transforms the [Valid] value using [mapper].
  ///
  /// If [Invalid], the errors are passed through unchanged.
  Validated<E, B> map<B>(B Function(A value) mapper) => switch (this) {
    Valid(:final value) => Valid<E, B>(mapper(value)),
    Invalid(:final errors) => Invalid<E, B>(errors),
  };

  /// Transforms each error in [Invalid] using [mapper].
  ///
  /// If [Valid], the value is passed through unchanged.
  Validated<F, A> mapError<F>(F Function(E error) mapper) => switch (this) {
    Valid(:final value) => Valid<F, A>(value),
    Invalid(:final errors) => Invalid<F, A>(
      errors.map(mapper).toList(growable: false),
    ),
  };

  /// Chains a validation step. If [Valid], applies [mapper] to the value.
  /// If [mapper] returns [Invalid], errors accumulate.
  ///
  /// Short-circuits on [Invalid] (unlike [zip]).
  Validated<E, B> andThen<B>(Validated<E, B> Function(A value) mapper) =>
      switch (this) {
        Valid(:final value) => mapper(value),
        Invalid(:final errors) => Invalid<E, B>(errors),
      };

  /// Combines this [Validated] with [other], accumulating errors from both.
  ///
  /// - Both valid → `Valid` containing a record `(A, B)`.
  /// - Any invalid → `Invalid` with the union of all errors from both sides.
  Validated<E, (A, B)> zip<B>(Validated<E, B> other) {
    return switch ((this, other)) {
      (Valid(:final value), Valid(value: final otherValue)) => Valid<E, (A, B)>(
        (value, otherValue),
      ),
      (Invalid(:final errors), Valid()) => Invalid<E, (A, B)>(errors),
      (Valid(), Invalid(:final errors)) => Invalid<E, (A, B)>(errors),
      (Invalid(:final errors), Invalid(errors: final otherErrors)) =>
        Invalid<E, (A, B)>([...errors, ...otherErrors]),
    };
  }

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Variant representing a successful result containing [value].
final class Valid<E, A> extends Validated<E, A> {
  /// The successful value.
  final A value;

  /// Creates a [Valid] instance holding [value].
  const Valid(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Valid<E, A> && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Valid($value)';
}

/// Variant representing a failed result holding one or more [errors].
final class Invalid<E, A> extends Validated<E, A> {
  /// The accumulated list of errors. Always contains at least one element.
  final List<E> errors;

  /// Creates an [Invalid] instance with [errors].
  const Invalid(this.errors);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Invalid<E, A>) return false;
    if (errors.length != other.errors.length) return false;
    for (var i = 0; i < errors.length; i++) {
      if (errors[i] != other.errors[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(errors);

  @override
  String toString() => 'Invalid($errors)';
}
