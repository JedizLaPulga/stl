class Vector<T> {
  final List<T> _data;

  const Vector(List<T> arguments) : _data = List<T>.from(arguments);

  T operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of range');
    }
    return _data[index];
  }

  //at: Return the element at the specifiled index with wrapping
  // around the end of the vector if the index is out of bounds.
  T at(int index) {
    if (_data.isEmpty) {
      throw RangeError('Cannot access elements in an empty vector');
    }
    final wrappedIndex = index % _data.length;
    return _data[wrappedIndex];
  }

  //toList<F> : Convert the vector to a list of type F,
  //where F is a supertype of T.
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

  List<T> list() {
    return List<T>.from(_data);
  }

  List<T> operator +(Vector<T> other) {
    return List<T>.from(_data)..addAll(other.toList<T>());
  }

  List<T> operator -(Vector<T> other) {
    final otherSet = Set<T>.from(other.toList<T>());
    return _data.where((e) => !otherSet.contains(e)).toList();
  }

  List<T> operator *(Vector<T> other) {
    final otherSet = Set<T>.from(other.toList<T>());
    return _data.where((e) => otherSet.contains(e)).toList();
  }

  void operator []=(int index, T value) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, _data, 'Index out of range');
    }
    _data[index] = value;
  }
}
