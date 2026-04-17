import 'dart:typed_data';

/// A robust, heap-allocated 8-bit unsigned integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Uint8` is strictly backed by an `Uint8List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Uint8
/// Instantiates a dynamically allocated [Uint8] bounds-checked element.
(Uint8List _data) {
  /// Dynamically instantiates a [Uint8] value mapped sequentially into memory.
  Uint8.from(int value) : _data = Uint8List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 8-bit unsigned integer (0).
  static final Uint8 min = Uint8.from(0);

  /// Returns the statically-bounded maximum value of a 8-bit unsigned integer (255).
  static final Uint8 max = Uint8.from(255);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Uint8 operator +(Uint8 other) => Uint8.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Uint8 operator -(Uint8 other) => Uint8.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Uint8 operator *(Uint8 other) => Uint8.from(value * other.value);

  /// Truncating division.
  Uint8 operator ~/(Uint8 other) => Uint8.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Uint8 operator %(Uint8 other) => Uint8.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Uint8 operator &(Uint8 other) => Uint8.from(value & other.value);

  /// Bitwise OR operator.
  Uint8 operator |(Uint8 other) => Uint8.from(value | other.value);

  /// Bitwise XOR operator.
  Uint8 operator ^(Uint8 other) => Uint8.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Uint8 operator ~() => Uint8.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Uint8 operator <<(int shiftAmount) => Uint8.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Uint8 operator >>(int shiftAmount) => Uint8.from(value >> shiftAmount);

  /// Right-shift explicitly padding zeros unconditionally.
  Uint8 operator >>>(int shiftAmount) => Uint8.from(value >>> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Uint8 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Uint8 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Uint8 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Uint8 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Uint8 addChecked(Uint8 other) {
    final result = value + other.value;
    if (result > 255 || result < 0) {
      throw StateError('Uint8 addition overflow');
    }
    return Uint8.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Uint8 subChecked(Uint8 other) {
    final result = value - other.value;
    if (result > 255 || result < 0) {
      throw StateError('Uint8 subtraction overflow/underflow');
    }
    return Uint8.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Uint8 mulChecked(Uint8 other) {
    final result = value * other.value;
    if (result > 255 || result < 0) {
      throw StateError('Uint8 multiplication overflow');
    }
    return Uint8.from(result);
  }
}
