part of 'primitives.dart';

/// A heap-allocated 32-bit signed integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [I32] variant, [Int32] is strictly backed by an
/// [Int32List], which natively bounds every write to `[-2147483648, 2147483647]`
/// and guarantees C++-style wrapping arithmetic on all platforms.
extension type Int32._(Int32List _data) {
  /// Instantiates an [Int32] from an existing [Int32List].
  Int32(this._data);

  /// Instantiates an [Int32] from an [int], wrapping into `[-2147483648, 2147483647]`.
  Int32.from(int value) : _data = Int32List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 32;

  /// The minimum value of a 32-bit signed integer (-2147483648).
  static final Int32 min = Int32.from(-2147483648);

  /// The maximum value of a 32-bit signed integer (2147483647).
  static final Int32 max = Int32.from(2147483647);

  /// The underlying raw [int] value, strictly clamped to `[-2147483648, 2147483647]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Int32 operator +(Int32 other) => Int32.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Int32 operator -(Int32 other) => Int32.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Int32 operator *(Int32 other) => Int32.from(value * other.value);

  /// Integer-divides by [other].
  Int32 operator ~/(Int32 other) => Int32.from(value ~/ other.value);

  /// Modulo by [other].
  Int32 operator %(Int32 other) => Int32.from(value % other.value);

  /// Returns the negated value, wrapping on overflow.
  Int32 operator -() => Int32.from(-value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Int32 operator &(Int32 other) => Int32.from(value & other.value);

  /// Performs bitwise OR.
  Int32 operator |(Int32 other) => Int32.from(value | other.value);

  /// Performs bitwise XOR.
  Int32 operator ^(Int32 other) => Int32.from(value ^ other.value);

  /// Performs bitwise NOT.
  Int32 operator ~() => Int32.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Int32 operator <<(int shiftAmount) => Int32.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  Int32 operator >>(int shiftAmount) => Int32.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Int32 operator >>>(int shiftAmount) => Int32.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Int32 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Int32 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Int32 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Int32 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  Int32 addChecked(Int32 other) {
    final result = value + other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('Int32 addition overflow');
    }
    return Int32.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  Int32 subChecked(Int32 other) {
    final result = value - other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('Int32 subtraction overflow');
    }
    return Int32.from(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  Int32 mulChecked(Int32 other) {
    final result = value * other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('Int32 multiplication overflow');
    }
    return Int32.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`Int32(-2147483648) ~/ Int32(-1)`).
  Int32 divChecked(Int32 other) {
    if (other.value == 0) throw StateError('Int32 division by zero');
    if (value == -2147483648 && other.value == -1) {
      throw StateError('Int32 division overflow');
    }
    return Int32.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[-2147483648, 2147483647]` instead of wrapping.
  Int32 saturatingAdd(Int32 other) {
    final result = value + other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return Int32.from(result);
  }

  /// Subtracts [other], clamping to `[-2147483648, 2147483647]` instead of wrapping.
  Int32 saturatingSub(Int32 other) {
    final result = value - other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return Int32.from(result);
  }

  /// Multiplies by [other], clamping to `[-2147483648, 2147483647]` instead of wrapping.
  Int32 saturatingMul(Int32 other) {
    final result = value * other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return Int32.from(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() =>
      (value & 0xFFFFFFFF).toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 32-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    final v = value & 0xFFFFFFFF;
    if (v == 0) return 32;
    var n = 0;
    var mask = 0x80000000;
    while ((v & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 32-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    final v = value & 0xFFFFFFFF;
    if (v == 0) return 32;
    var n = 0;
    var mask = 1;
    while ((v & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 32-bit representation left by [n] bits (`std::rotl`).
  Int32 rotateLeft(int n) {
    n &= 31;
    final v = value & 0xFFFFFFFF;
    return Int32.from(((v << n) | (v >> (32 - n))) & 0xFFFFFFFF);
  }

  /// Rotates the 32-bit representation right by [n] bits (`std::rotr`).
  Int32 rotateRight(int n) => rotateLeft(32 - (n & 31));

  /// Reverses the byte order of the 32-bit value (`std::byteswap`).
  Int32 byteSwap() {
    final v = value & 0xFFFFFFFF;
    return Int32.from(
      ((v & 0xFF) << 24) |
          (((v >> 8) & 0xFF) << 16) |
          (((v >> 16) & 0xFF) << 8) |
          ((v >> 24) & 0xFF),
    );
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 32-bit binary string.
  String toBinaryString() =>
      (value & 0xFFFFFFFF).toRadixString(2).padLeft(32, '0');

  /// Returns the value as a zero-padded 8-digit uppercase hex string.
  String toHexString() =>
      (value & 0xFFFFFFFF).toRadixString(16).toUpperCase().padLeft(8, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value);

  /// Converts to [Int16], truncating to the low 16 bits.
  Int16 toInt16() => Int16.from(value);

  /// Converts to [Int32] (identity).
  Int32 toInt32() => this;

  /// Converts to [Int64], sign-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], reinterpreting the low 8 bits as unsigned.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], reinterpreting the low 16 bits as unsigned.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32], reinterpreting the bit pattern as unsigned.
  Uint32 toUint32() => Uint32.from(value & 0xFFFFFFFF);

  /// Converts to [Uint64], reinterpreting as unsigned.
  Uint64 toUint64() => Uint64.from(value);
}
