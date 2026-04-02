import 'dart:collection';

class Vector<T extends Comparable<dynamic>> with IterableMixin<T> {
  final List<T> _data;

  /// Exposes the iterator from the underlying list.
  /// This allows the Vector to be used in standard Dart `for (var x in vec)` loops.
  @override
  Iterator<T> get iterator => _data.iterator;

  /// Returns the number of elements in the vector (O(1) time).
  @override
  int get length => _data.length;

  /// Creates a [Vector] containing the elements of the provided list.
  ///
  /// To instantiate a compile-time constant vector, pass a `const` list.
  /// For example:
  /// ```dart
  /// const myVec = Vector<int>([10, 20, 30]);
  /// final myVec2 = Vector<int>([10, 20, 30]);
  /// ```
  const Vector(this._data);

  /// Retrieves the element at the specified [index].
  ///
  /// Guarantees memory safety by throwing a [RangeError] if [index] is out of bounds.
  T operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of bounds');
    }
    return _data[index];
  }

  /// Sets the element at the specified [index] to [value].
  ///
  /// Guarantees memory safety by throwing a [RangeError] if [index] is out of bounds.
  void operator []=(int index, T value) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of bounds');
    }
    _data[index] = value;
  }

  /// Adds an element to the end of the vector.
  void push_back(T value) {
    _data.add(value);
  }

  /// Removes the last element from the vector.
  ///
  /// Guarantees memory safety by throwing a [StateError] if the vector is empty.
  void pop_back() {
    if (_data.isEmpty) {
      throw StateError('Cannot pop_back from an empty vector');
    }
    _data.removeLast();
  }

  /// Removes all elements from the vector.
  void clear() {
    _data.clear();
  }

  /// Inserts [value] at the specified [index].
  ///
  /// Guarantees memory safety by allowing [index] strictly between `0` and `length` (inclusive).
  void insert(int index, T value) {
    if (index < 0 || index > _data.length) {
      throw RangeError.index(index, _data, 'Index out of bounds for insertion');
    }
    _data.insert(index, value);
  }

  @override String toString() => _data.toString();
  @override int get hashCode => Object.hashAll(_data);

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


  /// Concatenates two vectors.
  /// Guarantees memory safety by creating a new vector with the combined elements.
  Vector<T> operator +(Vector<T> other) {
    final newList = List<T>.from(_data)..addAll(other._data);
    return Vector<T>(newList);
  }

  ///You can overload the multiplication operator to take an int and return a new Vector repeated n times 
  ///(similar to Python's [1, 2] * 3 == [1, 2, 1, 2, 1, 2]).
  Vector<T> operator *(int times) {
    if (times < 0) throw ArgumentError('Cannot multiply vector by negative number');
    final newList = <T>[];
    for (int i = 0; i < times; i++) {
      newList.addAll(_data);
    }
    return Vector<T>(newList);
  }


 
}
