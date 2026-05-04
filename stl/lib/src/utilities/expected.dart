/// A type that contains either an expected value of type [T] or an error of type [E].
///
/// `Expected<T, E>` is a powerful functional wrapper that mimics C++23's `std::expected`.
/// It allows for robust error handling without relying on throwing exceptions.
class Expected<T, E> {
  final T? _value;
  final E? _error;
  final bool _hasValue;

  /// Creates an [Expected] containing a successful value.
  const Expected.value(T value)
    : _value = value,
      _error = null,
      _hasValue = true;

  /// Creates an [Expected] containing an error.
  const Expected.error(E error)
    : _value = null,
      _error = error,
      _hasValue = false;

  /// Returns `true` if this object contains an expected value.
  bool get hasValue => _hasValue;

  /// Returns the expected value.
  ///
  /// Throws a [StateError] if this object contains an error instead of a value.
  T get value {
    if (!_hasValue) {
      throw StateError(
        'Cannot get value from an Expected containing an error: $_error',
      );
    }
    return _value as T;
  }

  /// Returns the error value.
  ///
  /// Throws a [StateError] if this object contains a value instead of an error.
  E get error {
    if (_hasValue) {
      throw StateError(
        'Cannot get error from an Expected containing a value: $_value',
      );
    }
    return _error as E;
  }

  /// Returns the expected value if it exists, otherwise returns [defaultValue].
  T valueOr(T defaultValue) {
    return _hasValue ? (_value as T) : defaultValue;
  }

  /// Transforms the expected value of type [T] into a new value of type [U]
  /// using the provided [mapper] function.
  ///
  /// If this object contains an error, the error is passed along unmodified.
  Expected<U, E> map<U>(U Function(T value) mapper) {
    if (_hasValue) {
      return Expected<U, E>.value(mapper(_value as T));
    } else {
      return Expected<U, E>.error(_error as E);
    }
  }

  /// Transforms the error value of type [E] into a new error of type [F]
  /// using the provided [mapper] function.
  ///
  /// If this object contains a value, the value is passed along unmodified.
  Expected<T, F> mapError<F>(F Function(E error) mapper) {
    if (!_hasValue) {
      return Expected<T, F>.error(mapper(_error as E));
    } else {
      return Expected<T, F>.value(_value as T);
    }
  }

  /// Chains a computation that itself returns an [Expected], short-circuiting
  /// on the first error.
  ///
  /// If this object contains a value, [mapper] is called with that value and
  /// its result is returned. If this object contains an error, the error is
  /// propagated unchanged without calling [mapper].
  ///
  /// Mirrors `std::expected::and_then` (C++23).
  ///
  /// Example:
  /// ```dart
  /// Expected<int, String> parse(String s) { ... }
  /// Expected<double, String> invert(int n) { ... }
  ///
  /// final result = parse('42').flatMap(invert);
  /// ```
  Expected<U, E> flatMap<U>(Expected<U, E> Function(T value) mapper) {
    if (_hasValue) {
      return mapper(_value as T);
    } else {
      return Expected<U, E>.error(_error as E);
    }
  }

  /// Reduces this [Expected] to a single value by applying one of two handlers.
  ///
  /// If this object contains a value, [onValue] is called with it.
  /// If this object contains an error, [onError] is called with it.
  ///
  /// Example:
  /// ```dart
  /// final msg = result.fold(
  ///   (v) => 'Got $v',
  ///   (e) => 'Error: $e',
  /// );
  /// ```
  R fold<R>(R Function(T value) onValue, R Function(E error) onError) {
    return _hasValue ? onValue(_value as T) : onError(_error as E);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Expected<T, E>) return false;

    if (_hasValue != other._hasValue) return false;
    if (_hasValue) {
      return _value == other._value;
    } else {
      return _error == other._error;
    }
  }

  @override
  int get hashCode {
    return Object.hash(_hasValue, _value, _error);
  }

  @override
  String toString() {
    if (_hasValue) {
      return 'Expected.value($_value)';
    } else {
      return 'Expected.error($_error)';
    }
  }
}
