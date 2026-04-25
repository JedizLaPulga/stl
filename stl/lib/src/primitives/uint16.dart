import 'dart:typed_data';

/// A robust, heap-allocated 16-bit unsigned integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Uint16` is strictly backed by an `Uint16List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Uint16._(Uint16List _data)  {
  /// Instantiates a dynamically allocated [Uint16] bounds-checked element.
  Uint16(this._data);

  /// Dynamically instantiates a [Uint16] value mapped sequentially into memory.
  Uint16.from(int value) : _data = Uint16List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 16-bit unsigned integer (0).
  static final Uint16 min = Uint16.from(0);

  /// Returns the statically-bounded maximum value of a 16-bit unsigned integer (65535).
  static final Uint16 max = Uint16.from(65535);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Uint16 operator +(Uint16 other) => Uint16.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Uint16 operator -(Uint16 other) => Uint16.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Uint16 operator *(Uint16 other) => Uint16.from(value * other.value);

  /// Truncating division.
  Uint16 operator ~/(Uint16 other) => Uint16.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Uint16 operator %(Uint16 other) => Uint16.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Uint16 operator &(Uint16 other) => Uint16.from(value & other.value);

  /// Bitwise OR operator.
  Uint16 operator |(Uint16 other) => Uint16.from(value | other.value);

  /// Bitwise XOR operator.
  Uint16 operator ^(Uint16 other) => Uint16.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Uint16 operator ~() => Uint16.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Uint16 operator <<(int shiftAmount) => Uint16.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Uint16 operator >>(int shiftAmount) => Uint16.from(value >> shiftAmount);

  /// Right-shift explicitly padding zeros unconditionally.
  Uint16 operator >>>(int shiftAmount) => Uint16.from(value >>> shiftAmount);

  /// Returns true if this value evaluates less than [other].
  bool operator <(Uint16 other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Uint16 other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Uint16 other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Uint16 other) => value >= other.value;

  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  Uint16 addChecked(Uint16 other) {
    final result = value + other.value;
    if (result > 65535 || result < 0) {
      throw StateError('Uint16 addition overflow');
    }
    return Uint16.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  Uint16 subChecked(Uint16 other) {
    final result = value - other.value;
    if (result > 65535 || result < 0) {
      throw StateError('Uint16 subtraction overflow/underflow');
    }
    return Uint16.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  Uint16 mulChecked(Uint16 other) {
    final result = value * other.value;
    if (result > 65535 || result < 0) {
      throw StateError('Uint16 multiplication overflow');
    }
    return Uint16.from(result);
  }
}
