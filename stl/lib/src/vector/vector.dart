class Vector<T> {
  final List<T> _data;

  const Vector(List<T> arguments) : this._data = arguments;

  operator [](int index) => _data[index];
}
