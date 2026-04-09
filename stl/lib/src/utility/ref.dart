/// A mutable reference wrapper for binding and managing a value.
///
/// Inspired by C++ `std::reference_wrapper`, `Ref<T>` serves as an explicit
/// wrapper signifying that the held element is a reference that can be fetched,
/// rebound, and mutated.
class Ref<T> {
  T _value;

  /// Creates a new reference bound to the provided [value].
  Ref(this._value);

  /// Retrieves the currently bound value.
  T get() => _value;

  /// Rebinds the reference to a completely new [value].
  void set(T value) {
    _value = value;
  }
  
  /// Rebinds this reference to point to the exact same value as [other].
  void rebind(Ref<T> other) {
    _value = other.get();
  }

  /// Evaluates and retrieves the bound value implicitly.
  T call() => _value;

  @override
  String toString() => _value.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ref<T> && other.get() == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}
