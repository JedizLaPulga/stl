/// A type-safe container for single values of literally any type.
///
/// Designed meticulously to emulate C++ `std::any`, this structure holds an arbitrary
/// object while actively enforcing strict type boundaries during extraction attempts
/// via the `.cast<T>()` command.
class Any {
  Object? _value;
  bool _hasValue;

  /// Encapsulates a tangible [value] strictly inside the container.
  Any(Object value)
      : _value = value,
        _hasValue = true;

  /// Creates an empty container holding exactly no memory state natively.
  Any.empty()
      : _value = null,
        _hasValue = false;

  /// Swaps its internal pointer gracefully with another value dynamically.
  void set(Object value) {
    _value = value;
    _hasValue = true;
  }

  /// Destroys the active internal state natively, wiping the object entirely.
  void reset() {
    _value = null;
    _hasValue = false;
  }

  /// Determines whether the internal box state currently holds an active value natively.
  bool hasValue() => _hasValue;

  /// Fetches exactly the strict runtime type of the dynamically wrapped inner memory state.
  /// Throws natively if empty.
  Type type() {
    if (!_hasValue) throw StateError('Any is empty natively! Cannot fetch type.');
    return _value.runtimeType;
  }

  /// Safely extracts the wrapped pointer back to its real object securely validating type [T].
  /// Extremely robust and strictly type-safe natively.
  T cast<T>() {
    if (!_hasValue) {
      throw StateError('Cannot deeply cast an absolutely empty Any object.');
    }
    if (_value is! T) {
      throw TypeError();
    }
    return _value as T;
  }

  @override
  String toString() {
    if (!_hasValue) return 'Any(Empty)';
    return 'Any($_value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Any || _hasValue != other._hasValue) return false;
    if (!_hasValue && !other._hasValue) return true;
    return _value == other._value;
  }

  @override
  int get hashCode => _hasValue ? _value.hashCode : 0;
}
