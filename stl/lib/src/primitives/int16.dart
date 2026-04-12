import 'dart:typed_data';

/// A robust, heap-allocated 16-bit signed integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Int16` is strictly backed by an `Int16List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Int16(Int16List _data) {
  /// Dynamically instantiates a [Int16] value mapped sequentially into memory.
  Int16.from(int value) : _data = Int16List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 16-bit signed integer (-32768).
  static final Int16 min = Int16.from(-32768);

  /// Returns the statically-bounded maximum value of a 16-bit signed integer (32767).
  static final Int16 max = Int16.from(32767);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Int16 operator +(Int16 other) => Int16.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Int16 operator -(Int16 other) => Int16.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Int16 operator *(Int16 other) => Int16.from(value * other.value);

  /// Truncating division.
  Int16 operator ~/(Int16 other) => Int16.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Int16 operator %(Int16 other) => Int16.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Int16 operator &(Int16 other) => Int16.from(value & other.value);

  /// Bitwise OR operator.
  Int16 operator |(Int16 other) => Int16.from(value | other.value);

  /// Bitwise XOR operator.
  Int16 operator ^(Int16 other) => Int16.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Int16 operator ~() => Int16.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Int16 operator <<(int shiftAmount) => Int16.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Int16 operator >>(int shiftAmount) => Int16.from(value >> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Int16 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Int16 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Int16 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Int16 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Int16 addChecked(Int16 other) {
    final result = value + other.value;
    if (result > 32767 || result < -32768){
      throw StateError('Int16 addition overflow');
    }
    return Int16.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Int16 subChecked(Int16 other) {
    final result = value - other.value;
    if (result > 32767 || result < -32768){
      throw StateError('Int16 subtraction overflow/underflow');
    }
    return Int16.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Int16 mulChecked(Int16 other) {
    final result = value * other.value;
    if (result > 32767 || result < -32768){
      throw StateError('Int16 multiplication overflow');
    }
    return Int16.from(result);
  }
}
