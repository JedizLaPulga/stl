/// The `<stdexcept>` module providing C++ standard exceptions natively in Dart.
library;

/// Base class for all STL standard exceptions.
///
/// Mimics C++ `std::exception`.
abstract class StdException implements Exception {
  /// A message describing the error.
  final String message;
  
  /// Creates an exception with the given [message].
  const StdException(this.message);

  /// Returns the explanatory string (analogous to `what()` in C++).
  String what() => message;

  @override
  String toString() => '$runtimeType: $message';
}

// ==========================================
// Base Error Types
// ==========================================

/// Base class for errors that can be detected before the program executes.
///
/// Mimics C++ `std::logic_error`.
class LogicError extends StdException {
  /// Creates a [LogicError] with the given [message].
  const LogicError(super.message);
}

/// Base class for errors that occur during program execution.
///
/// Mimics C++ `std::runtime_error`.
class RuntimeError extends StdException {
  /// Creates a [RuntimeError] with the given [message].
  const RuntimeError(super.message);
}

// ==========================================
// Logic Errors
// ==========================================

/// Thrown when an invalid argument is passed to a function.
///
/// Mimics C++ `std::invalid_argument`.
class InvalidArgument extends LogicError {
  /// Creates an [InvalidArgument] error with the given [message].
  const InvalidArgument(super.message);
}

/// Thrown when a mathematical function is evaluated outside its defined domain.
///
/// Mimics C++ `std::domain_error`.
class DomainError extends LogicError {
  /// Creates a [DomainError] with the given [message].
  const DomainError(super.message);
}

/// Thrown when an object would exceed its maximum permitted length.
///
/// Mimics C++ `std::length_error`.
class LengthError extends LogicError {
  /// Creates a [LengthError] with the given [message].
  const LengthError(super.message);
}

/// Thrown when an index or value is out of the valid range.
///
/// Mimics C++ `std::out_of_range`.
class OutOfRange extends LogicError {
  /// Creates an [OutOfRange] error with the given [message].
  const OutOfRange(super.message);
}

// ==========================================
// Runtime Errors
// ==========================================

/// Thrown when a mathematical computation produces a result that exceeds the representable range.
///
/// Mimics C++ `std::range_error`.
/// Named `StdRangeError` to avoid collision with Dart's native `RangeError`.
class StdRangeError extends RuntimeError {
  /// Creates a [StdRangeError] with the given [message].
  const StdRangeError(super.message);
}

/// Thrown when a mathematical computation causes an arithmetic overflow.
///
/// Mimics C++ `std::overflow_error`.
class OverflowError extends RuntimeError {
  /// Creates an [OverflowError] with the given [message].
  const OverflowError(super.message);
}

/// Thrown when a mathematical computation causes an arithmetic underflow.
///
/// Mimics C++ `std::underflow_error`.
class UnderflowError extends RuntimeError {
  /// Creates an [UnderflowError] with the given [message].
  const UnderflowError(super.message);
}
