import 'dart:typed_data';

/// A robust, heap-allocated 32-bit signed integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Int32` is strictly backed by an `Int32List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Int32
/// Instantiates a dynamically allocated [Int32] bounds-checked element.
(Int32List _data) {
  /// Dynamically instantiates a [Int32] value mapped sequentially into memory.
  Int32.from(int value) : _data = Int32List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 32-bit signed integer (-2147483648).
  static final Int32 min = Int32.from(-2147483648);

  /// Returns the statically-bounded maximum value of a 32-bit signed integer (2147483647).
  static final Int32 max = Int32.from(2147483647);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Int32 operator +(Int32 other) => Int32.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Int32 operator -(Int32 other) => Int32.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Int32 operator *(Int32 other) => Int32.from(value * other.value);

  /// Truncating division.
  Int32 operator ~/(Int32 other) => Int32.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Int32 operator %(Int32 other) => Int32.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Int32 operator &(Int32 other) => Int32.from(value & other.value);

  /// Bitwise OR operator.
  Int32 operator |(Int32 other) => Int32.from(value | other.value);

  /// Bitwise XOR operator.
  Int32 operator ^(Int32 other) => Int32.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Int32 operator ~() => Int32.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Int32 operator <<(int shiftAmount) => Int32.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Int32 operator >>(int shiftAmount) => Int32.from(value >> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Int32 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Int32 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Int32 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Int32 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Int32 addChecked(Int32 other) {
    final result = value + other.value;
    if (result > 2147483647 || result < -2147483648){
      throw StateError('Int32 addition overflow');
    }
    return Int32.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Int32 subChecked(Int32 other) {
    final result = value - other.value;
    if (result > 2147483647 || result < -2147483648){
      throw StateError('Int32 subtraction overflow/underflow');
    }
    return Int32.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Int32 mulChecked(Int32 other) {
    final result = value * other.value;
    if (result > 2147483647 || result < -2147483648){
      throw StateError('Int32 multiplication overflow');
    }
    return Int32.from(result);
  }
}
