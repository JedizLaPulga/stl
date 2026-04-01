class Vector<T extends Comparable<dynamic>> {
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
  //Dart usually handles != by just reversing whatever your == operator returns.

  /// Lexicographically compares this vector to [other].
  int compareTo(Vector<T> other) {
    int len = _data.length < other._data.length ? _data.length : other._data.length;
    for (int i = 0; i < len; i++) {
      int comparison = _data[i].compareTo(other._data[i]);
      if (comparison != 0) {
        return comparison;
      }
    }
    return _data.length.compareTo(other._data.length);
  }

  bool operator <(Vector<T> other) => compareTo(other) < 0;
  bool operator <=(Vector<T> other) => compareTo(other) <= 0;
  bool operator >(Vector<T> other) => compareTo(other) > 0;
  bool operator >=(Vector<T> other) => compareTo(other) >= 0;

  @override
  int get hashCode => Object.hashAll(_data);
}
