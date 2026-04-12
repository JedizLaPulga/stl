import 'dart:typed_data';

/// A robust, heap-allocated 32-bit unsigned integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Uint32` is strictly backed by an `Uint32List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Uint32(Uint32List _data) {
  /// Dynamically instantiates a [Uint32] value mapped sequentially into memory.
  Uint32.from(int value) : _data = Uint32List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 32-bit unsigned integer (0).
  static final Uint32 min = Uint32.from(0);

  /// Returns the statically-bounded maximum value of a 32-bit unsigned integer (4294967295).
  static final Uint32 max = Uint32.from(4294967295);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Uint32 operator +(Uint32 other) => Uint32.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Uint32 operator -(Uint32 other) => Uint32.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Uint32 operator *(Uint32 other) => Uint32.from(value * other.value);

  /// Truncating division.
  Uint32 operator ~/(Uint32 other) => Uint32.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Uint32 operator %(Uint32 other) => Uint32.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Uint32 operator &(Uint32 other) => Uint32.from(value & other.value);

  /// Bitwise OR operator.
  Uint32 operator |(Uint32 other) => Uint32.from(value | other.value);

  /// Bitwise XOR operator.
  Uint32 operator ^(Uint32 other) => Uint32.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Uint32 operator ~() => Uint32.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Uint32 operator <<(int shiftAmount) => Uint32.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Uint32 operator >>(int shiftAmount) => Uint32.from(value >> shiftAmount);

  /// Right-shift explicitly padding zeros unconditionally.
  Uint32 operator >>>(int shiftAmount) => Uint32.from(value >>> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Uint32 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Uint32 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Uint32 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Uint32 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Uint32 addChecked(Uint32 other) {
    final result = value + other.value;
    if (result > 4294967295 || result < 0) {
      throw StateError('Uint32 addition overflow');
    }
    return Uint32.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Uint32 subChecked(Uint32 other) {
    final result = value - other.value;
    if (result > 4294967295 || result < 0) {
      throw StateError('Uint32 subtraction overflow/underflow');
    }
    return Uint32.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Uint32 mulChecked(Uint32 other) {
    final result = value * other.value;
    if (result > 4294967295 || result < 0) {
      throw StateError('Uint32 multiplication overflow');
    }
    return Uint32.from(result);
  }
}
