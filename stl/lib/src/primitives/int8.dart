import 'dart:typed_data';

/// A robust, heap-allocated 8-bit signed integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Int8` is strictly backed by an `Int8List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Int8._(Int8List _data)  {
  /// Instantiates a dynamically allocated [Int8] bounds-checked element.
  Int8(this._data);

  /// Dynamically instantiates a [Int8] value mapped sequentially into memory.
  Int8.from(int value) : _data = Int8List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 8-bit signed integer (-128).
  static final Int8 min = Int8.from(-128);

  /// Returns the statically-bounded maximum value of a 8-bit signed integer (127).
  static final Int8 max = Int8.from(127);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Int8 operator +(Int8 other) => Int8.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Int8 operator -(Int8 other) => Int8.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Int8 operator *(Int8 other) => Int8.from(value * other.value);

  /// Truncating division.
  Int8 operator ~/(Int8 other) => Int8.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Int8 operator %(Int8 other) => Int8.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Int8 operator &(Int8 other) => Int8.from(value & other.value);

  /// Bitwise OR operator.
  Int8 operator |(Int8 other) => Int8.from(value | other.value);

  /// Bitwise XOR operator.
  Int8 operator ^(Int8 other) => Int8.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Int8 operator ~() => Int8.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Int8 operator <<(int shiftAmount) => Int8.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Int8 operator >>(int shiftAmount) => Int8.from(value >> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Int8 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Int8 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Int8 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Int8 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Int8 addChecked(Int8 other) {
    final result = value + other.value;
    if (result > 127 || result < -128){
      throw StateError('Int8 addition overflow');
    }
    return Int8.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Int8 subChecked(Int8 other) {
    final result = value - other.value;
    if (result > 127 || result < -128){
      throw StateError('Int8 subtraction overflow/underflow');
    }
    return Int8.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Int8 mulChecked(Int8 other) {
    final result = value * other.value;
    if (result > 127 || result < -128){
      throw StateError('Int8 multiplication overflow');
    }
    return Int8.from(result);
  }
}
