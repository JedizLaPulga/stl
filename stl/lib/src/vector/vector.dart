/// A dynamically resizable contiguous array of elements.
///
/// In the C++ STL, this strictly aligns with `std::vector`.
class Vector<T> {
  final List<T> _data;

  /// Creates a Vector containing the given arguments.
  const Vector(List<T> arguments) : _data = arguments;

  /// Retrieves the element at the specified [index] with rigorous bounds checking.
  T operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of range');
    }
    return _data[index];
  }

  /// Returns the element at the specified index with modular wrapping.
  /// This automatically wraps around the end of the vector if the index is out of bounds.
  T at(int index) {
    if (_data.isEmpty) {
      throw RangeError('Cannot access elements in an empty vector');
    }
    final wrappedIndex = index % _data.length;
    return _data[wrappedIndex];
  }

  /// Converts the vector directly to a standard Dart [List] of a specific type [F].
  /// [F] must be a valid supertype or target type representation of [T].
  List<F> toList<F>() {
    late final List<F> result;
    if (F == T) {
      //same type, just return a copy of the list
      return List<F>.from(_data);
    } else if (F == String) {
      //convert each element to a string
      result = _data.map((e) => e.toString() as F).toList();
    } else if (F == bool) {
      //convert each element to a boolean based on its truthiness
      result = _data
          .map((e) => (e != null && e.toString().isNotEmpty) as F)
          .toList();
    } else {
      //unsupported type conversion
      throw ArgumentError('Cannot convert Vector<$T> to List<$F>');
    }

    return result;
  }

  /// Returns a new standard Dart [List] containing a copy of all internal data.
  List<T> list() {
    return List<T>.from(_data);
  }

  /// Concatenates this vector with [other], producing a new merged sequence.
  List<T> operator +(Vector<T> other) {
    return List<T>.from(_data)..addAll(other.toList<T>());
  }

  /// Performs mathematical set subtraction, removing all occurrences of elements found in [other].
  List<T> operator -(Vector<T> other) {
    final otherSet = Set<T>.from(other.toList<T>());
    return _data.where((e) => !otherSet.contains(e)).toList();
  }

  /// Performs mathematical set intersection, extracting only shared matching elements with [other].
  List<T> operator *(Vector<T> other) {
    final otherSet = Set<T>.from(other.toList<T>());
    return _data.where((e) => otherSet.contains(e)).toList();
  }

  /// Assigns [value] to the specified [index], enforcing strict memory boundary limitations.
  void operator []=(int index, T value) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of range');
    }
    _data[index] = value;
  }
}
