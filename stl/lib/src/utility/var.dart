/// A simple mutable wrapper for holding and updating a value.
/// 
/// `Var<T>` is useful when you need to pass a primitive (like an `int` or `bool`)
/// by reference to a callback or closure, allowing its state to be mutated cleanly.
class Var<T> {
  /// The underlying value held by this variable.
  T value;

  /// Creates a new `Var` holding the given [value].
  Var(this.value);

  /// Utility functionally updating the value safely.
  void update(T Function(T current) updater) {
    value = updater(value);
  }

  /// Returns the current value implicitly when called as a function.
  T call() => value;

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Var<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
