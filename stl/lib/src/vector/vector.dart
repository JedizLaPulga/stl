class Vector<T> {
  final List<T> _data;

  const Vector(List<T> arguments) : _data = arguments;

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
      return List<F>.from(_data);
    } else if (F == String) {
      result = _data.map((e) => e.toString() as F).toList();
    } else if (F == bool) {
      result = _data
          .map((e) => (e != null && e.toString().isNotEmpty) as F)
          .toList();
    } else {
      throw ArgumentError('Cannot convert Vector<$T> to List<$F>');
    }

    return result;
  }
}
