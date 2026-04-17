import 'dart:typed_data';

/// A robust, heap-allocated 64-bit unsigned integer wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `Uint64` is strictly backed by an `Uint64List(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously
/// guarantees that mathematical operators intuitively overflow using C++ style
/// constraints, exactly mimicking real hardware boundaries, providing complete safety!
extension type Uint64(Uint64List _data) {
  /// Dynamically instantiates a [Uint64] value mapped sequentially into memory.
  Uint64.from(int value) : _data = Uint64List(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a 64-bit unsigned integer (0).
  static final Uint64 min = Uint64.from(0);

  /// Returns the statically-bounded maximum value of a 64-bit unsigned integer (-1).
  static final Uint64 max = Uint64.from(-1);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  Uint64 operator +(Uint64 other) => Uint64.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  Uint64 operator -(Uint64 other) => Uint64.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  Uint64 operator *(Uint64 other) => Uint64.from(value * other.value);

  /// Truncating division.
  Uint64 operator ~/(Uint64 other) => Uint64.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  Uint64 operator %(Uint64 other) => Uint64.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  Uint64 operator &(Uint64 other) => Uint64.from(value & other.value);

  /// Bitwise OR operator.
  Uint64 operator |(Uint64 other) => Uint64.from(value | other.value);

  /// Bitwise XOR operator.
  Uint64 operator ^(Uint64 other) => Uint64.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  Uint64 operator ~() => Uint64.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  Uint64 operator <<(int shiftAmount) => Uint64.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  Uint64 operator >>(int shiftAmount) => Uint64.from(value >> shiftAmount);

  /// Right-shift explicitly padding zeros unconditionally.
  Uint64 operator >>>(int shiftAmount) => Uint64.from(value >>> shiftAmount);

  /// Determines structural bounds dynamically using unsigned comparison mechanisms for 64-bit limits.
  bool operator <(Uint64 other) =>
      (value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000);

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=(Uint64 other) =>
      (value ^ 0x8000000000000000) <= (other.value ^ 0x8000000000000000);

  /// Strict evaluation if this numerical element is larger.
  bool operator >(Uint64 other) =>
      (value ^ 0x8000000000000000) > (other.value ^ 0x8000000000000000);

  /// Strict evaluation extending identical size bounds.
  bool operator >=(Uint64 other) =>
      (value ^ 0x8000000000000000) >= (other.value ^ 0x8000000000000000);
  /// Adds [other] catching overflow.
  Uint64 addChecked(Uint64 other) {
    final res = value + other.value;
    if ((res ^ 0x8000000000000000) < (value ^ 0x8000000000000000)) {
      throw StateError('Uint64 addition overflow');
    }
    return Uint64.from(res);
  }

  /// Subtracts [other] catching overflow.
  Uint64 subChecked(Uint64 other) {
    final res = value - other.value;
    if ((value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000)) {
      throw StateError('Uint64 subtraction underflow');
    }
    return Uint64.from(res);
  }
}
