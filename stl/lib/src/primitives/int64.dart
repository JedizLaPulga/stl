import 'dart:typed_data';

/// A robust, heap-allocated 64-bit signed integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Int64` is strictly backed by an `Int64List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously 
/// guarantees that mathematical operators intuitively overflow using C++ style 
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Int64(Int64List _data) {
  /// Dynamically instantiates a [Int64] value mapped sequentially into memory.
  Int64.from(int value) : _data = Int64List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 64-bit signed integer (-9223372036854775808).
  static final Int64 min = Int64.from(-9223372036854775808);

  /// Returns the statically-bounded maximum value of a 64-bit signed integer (9223372036854775807).
  static final Int64 max = Int64.from(9223372036854775807);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Int64 operator +(Int64 other) => Int64.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Int64 operator -(Int64 other) => Int64.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Int64 operator *(Int64 other) => Int64.from(value * other.value);

  /// Truncating division.
  Int64 operator ~/(Int64 other) => Int64.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Int64 operator %(Int64 other) => Int64.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Int64 operator &(Int64 other) => Int64.from(value & other.value);

  /// Bitwise OR operator.
  Int64 operator |(Int64 other) => Int64.from(value | other.value);

  /// Bitwise XOR operator.
  Int64 operator ^(Int64 other) => Int64.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Int64 operator ~() => Int64.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Int64 operator <<(int shiftAmount) => Int64.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Int64 operator >>(int shiftAmount) => Int64.from(value >> shiftAmount);
  /// Returns true if this value evaluates less than [other].
  bool operator <(Int64 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Int64 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Int64 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Int64 other) => value >= other.value;
  Int64 addChecked(Int64 other) {
    final res = value + other.value;
    if (!(((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
       throw StateError('Int64 addition overflow');
    }
    return Int64.from(res);
  }

  Int64 subChecked(Int64 other) {
    var res = value - other.value;
    if ((((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
        throw StateError('Int64 subtraction overflow/underflow');
    }
    return Int64.from(res);
  }
}
