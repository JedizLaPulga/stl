class Vector<T> {
  final List<T> _data;

  /// Creates a [Vector] containing the elements of the provided list.
  ///
  /// To instantiate a compile-time constant vector, pass a `const` list.
  /// For example:
  /// ```dart
  /// const myVec = Vector<int>([10, 20, 30]);
  /// final myVec2 = Vector<int>([10, 20, 30]);
  /// ```
  const Vector(this._data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vector<T>) return false;
    if (_data.length != other._data.length) return false;
    for (int i = 0; i < _data.length; i++) {
      if (_data[i] != other._data[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_data);
}
