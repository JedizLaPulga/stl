/// A mutable wrapper designed to hold and update values.
///
/// Unlike `Var<T>` or `Ref<T>`, `Box<T>` is intensely overloaded, mimicking 
/// the robust flexibility of idiomatic Dart. If `Box<T>` holds a numeric type (`int` or `double`), 
/// you can mathematically interact with the `Box` natively without unboxing it explicitly.
class Box<T> {
  /// The underlying value held inside the box.
  T value;

  /// Creates a Box encapsulating the provided [value].
  Box(this.value);

  /// Unboxes the value implicitly when called functionally.
  T call() => value;

  // ==========================================
  // Idiomatic Dart Operator Overloads
  // ==========================================

  dynamic _extract(dynamic other) => other is Box ? other.value : other;

  /// Adds a value or another box algebraically. 
  dynamic operator +(dynamic other) => (value as dynamic) + _extract(other);

  /// Subtracts a value or another box algebraically.
  dynamic operator -(dynamic other) => (value as dynamic) - _extract(other);

  /// Multiplies a value or another box algebraically.
  dynamic operator *(dynamic other) => (value as dynamic) * _extract(other);

  /// Divides a value or another box algebraically.
  dynamic operator /(dynamic other) => (value as dynamic) / _extract(other);

  /// Integer Division operator.
  dynamic operator ~/(dynamic other) => (value as dynamic) ~/ _extract(other);

  /// Modulo operator.
  dynamic operator %(dynamic other) => (value as dynamic) % _extract(other);

  /// Less than comparison.
  bool operator <(dynamic other) => (value as dynamic) < _extract(other);

  /// Greater than comparison.
  bool operator >(dynamic other) => (value as dynamic) > _extract(other);

  /// Less than or equal comparison.
  bool operator <=(dynamic other) => (value as dynamic) <= _extract(other);

  /// Greater than or equal comparison.
  bool operator >=(dynamic other) => (value as dynamic) >= _extract(other);

  /// Standard equivalence checking.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Box) return value == other.value;
    return value == other;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
