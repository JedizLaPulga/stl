part of 'primitives.dart';

/// A 32-bit signed integer primitive.
///
/// Provides a zero-cost abstraction for 32-bit signed math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [I32.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const I32._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [I32] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[-2147483648, 2147483647]`.
  /// For automatic truncation use [I32.wrapping].
  const I32(this.value);

  /// Constructs an [I32] from an arbitrary [int], wrapping into `[-2147483648, 2147483647]`.
  I32.wrapping(int v) : value = v.toSigned(32);

  /// The bit-width of this type.
  static const int bits = 32;

  /// The minimum representable value (-2147483648).
  static const I32 min = I32(-2147483648);

  /// The maximum representable value (2147483647).
  static const I32 max = I32(2147483647);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [I32] to this, wrapping around on overflow/underflow.
  I32 operator +(I32 other) => I32((value + other.value).toSigned(32));

  /// Subtracts another [I32] from this, wrapping around on overflow/underflow.
  I32 operator -(I32 other) => I32((value - other.value).toSigned(32));

  /// Multiplies this by another [I32], wrapping around on overflow/underflow.
  I32 operator *(I32 other) => I32((value * other.value).toSigned(32));

  /// Integer-divides this by another [I32], wrapping around on overflow.
  I32 operator ~/(I32 other) => I32((value ~/ other.value).toSigned(32));

  /// Modulo operator, wrapping the result to remain within [I32] range.
  I32 operator %(I32 other) => I32((value % other.value).toSigned(32));

  /// Returns the negated value, wrapping on overflow.
  I32 operator -() => I32((-value).toSigned(32));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  I32 operator &(I32 other) => I32((value & other.value).toSigned(32));

  /// Performs bitwise OR.
  I32 operator |(I32 other) => I32((value | other.value).toSigned(32));

  /// Performs bitwise XOR.
  I32 operator ^(I32 other) => I32((value ^ other.value).toSigned(32));

  /// Performs bitwise NOT.
  I32 operator ~() => I32((~value).toSigned(32));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  I32 operator <<(int shiftAmount) => I32((value << shiftAmount).toSigned(32));

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  I32 operator >>(int shiftAmount) => I32((value >> shiftAmount).toSigned(32));

  /// Unsigned right-shifts by [shiftAmount] bits.
  I32 operator >>>(int shiftAmount) =>
      I32((value >>> shiftAmount).toSigned(32));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  I32 addChecked(I32 other) {
    final result = value + other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('I32 addition overflow');
    }
    return I32(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  I32 subChecked(I32 other) {
    final result = value - other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('I32 subtraction overflow');
    }
    return I32(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  I32 mulChecked(I32 other) {
    final result = value * other.value;
    if (result > 2147483647 || result < -2147483648) {
      throw StateError('I32 multiplication overflow');
    }
    return I32(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`I32(-2147483648) ~/ I32(-1)`).
  I32 divChecked(I32 other) {
    if (other.value == 0) throw StateError('I32 division by zero');
    if (value == -2147483648 && other.value == -1) {
      throw StateError('I32 division overflow');
    }
    return I32(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping the result to `[-2147483648, 2147483647]` instead of wrapping.
  I32 saturatingAdd(I32 other) {
    final result = value + other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return I32(result);
  }

  /// Subtracts [other], clamping the result to `[-2147483648, 2147483647]` instead of wrapping.
  I32 saturatingSub(I32 other) {
    final result = value - other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return I32(result);
  }

  /// Multiplies by [other], clamping the result to `[-2147483648, 2147483647]` instead of wrapping.
  I32 saturatingMul(I32 other) {
    final result = value * other.value;
    if (result > 2147483647) return max;
    if (result < -2147483648) return min;
    return I32(result);
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
  I32 rotateLeft(int n) {
    n &= 31;
    final v = value & 0xFFFFFFFF;
    return I32(((v << n) | (v >> (32 - n))) & 0xFFFFFFFF);
  }

  /// Rotates the 32-bit representation right by [n] bits (`std::rotr`).
  I32 rotateRight(int n) => rotateLeft(32 - (n & 31));

  /// Reverses the byte order of the 32-bit value (`std::byteswap`).
  I32 byteSwap() {
    final v = value & 0xFFFFFFFF;
    return I32(
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

  // ── Return-type override ────────────────────────────────────────────────

  /// Returns the absolute value as an [I32], wrapping on the edge case `I32(-2147483648)`.
  I32 abs() => value < 0 ? I32((-value).toSigned(32)) : this;

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], truncating to the low 8 bits.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], truncating to the low 16 bits.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32] (identity).
  I32 toI32() => this;

  /// Converts to [I64], sign-extending.
  I64 toI64() => I64(value.toSigned(64));

  /// Converts to [U8], reinterpreting the low 8 bits as unsigned.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], reinterpreting the low 16 bits as unsigned.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32], reinterpreting the bit pattern as unsigned.
  U32 toU32() => U32(value.toUnsigned(32));

  /// Converts to [U64], reinterpreting as unsigned.
  U64 toU64() => U64(value.toUnsigned(64));
}
