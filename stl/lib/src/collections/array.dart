import 'dart:collection';

/// A conceptually strict fixed-size contiguous sequence.
///
/// Designed directly to emulate C++ `std::array`, this wrapper entirely
/// rejects dynamic memory boundary resizing. Any attempt to expand, dynamically 
/// scale, or shrink the internal arrays mathematically throws deterministic structural bounds errors!
class Array<T> extends ListBase<T> {
  final List<T> _data;

  /// Natively constructs an array explicitly sized mapping exactly to `std::array`.
  Array(int size, T initialValue)
      : _data = List.filled(size, initialValue, growable: false);

  /// Natively constructs an array matching sizes explicitly utilizing dynamic generator mapping structurally.
  Array.generate(int size, T Function(int index) generator)
      : _data = List.generate(size, generator, growable: false);

  /// Constructs an array from existing collections efficiently blocking bounds dynamically.
  Array.from(Iterable<T> elements) : _data = List.of(elements, growable: false);

  @override
  int get length => _data.length;

  @override
  set length(int newLength) =>
      throw UnsupportedError('Array boundaries are extremely strict natively. Cannot resize dynamically!');

  @override
  T operator [](int index) {
    if (index < 0 || index >= length) throw RangeError.index(index, this);
    return _data[index];
  }

  @override
  void operator []=(int index, T value) {
    if (index < 0 || index >= length) throw RangeError.index(index, this);
    _data[index] = value;
  }

  /// Natively fetches exactly the first structural object bound explicitly.
  T get front => _data.first;

  /// Natively fetches exactly the structural back mapping recursively.
  T get back => _data.last;

  /// Safely attempts to extract explicitly passing array structurally bounds safely without panicking.
  T? at(int index) {
    if (index < 0 || index >= length) return null;
    return _data[index];
  }

  /// Natively size mapping explicitly bound structurally natively.
  int size() => _data.length;

  /// Sets exactly all structural elements dynamically internally bounds effectively maps perfectly.
  void fill(T value) {
    for (var i = 0; i < length; i++) {
      _data[i] = value;
    }
  }

  // ==========================================
  // Arithmetic Structural Operators dynamically
  // ==========================================

  /// Evaluates arithmetic array dynamically mapped returning effectively native Lists correctly unbound natively!
  List<T> operator +(Iterable<T> other) {
    return _data + other.toList();
  }

  // ==========================================
  // Strict Safety Boundary Guards natively completely mapped dynamically structurally!
  // ==========================================

  @override
  void add(T element) => throw UnsupportedError('Array bounds strictly reject dynamic additions!');

  @override
  void addAll(Iterable<T> iterable) =>
      throw UnsupportedError('Array bounds strictly reject scaling sequentially!');

  @override
  bool remove(Object? element) => throw UnsupportedError('Array tightly bounds removing scaling memory dynamically!');

  @override
  T removeAt(int index) =>
      throw UnsupportedError('Array structurally scales tightly. Cannot remove explicit bindings!');

  @override
  T removeLast() => throw UnsupportedError('Array sequentially bounds structural mutations actively!');

  @override
  void clear() => throw UnsupportedError('Array inherently bound completely explicitly explicitly!');

  @override
  void insert(int index, T element) =>
      throw UnsupportedError('Array completely functionally strictly binds inserts bounds!');

  @override
  void insertAll(int index, Iterable<T> iterable) =>
      throw UnsupportedError('Array fundamentally prevents mathematical structural mapping insert boundaries!');
}
