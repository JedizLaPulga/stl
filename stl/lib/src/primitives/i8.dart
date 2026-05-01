part of 'primitives.dart';

/// An 8-bit signed integer primitive.
///
/// Provides a zero-cost abstraction for 8-bit signed math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [I8.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const I8._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [I8] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[-128, 127]`.
  /// For automatic truncation use [I8.wrapping].
  const I8(this.value);

  /// Constructs an [I8] from an arbitrary [int], wrapping into `[-128, 127]`.
  I8.wrapping(int v) : value = v.toSigned(8);

  /// The bit-width of this type.
  static const int bits = 8;

  /// The minimum value an [I8] can hold (-128).
  static const I8 min = I8(-128);

  /// The maximum value an [I8] can hold (127).
  static const I8 max = I8(127);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [I8] to this, wrapping around on overflow/underflow.
  I8 operator +(I8 other) => I8((value + other.value).toSigned(8));

  /// Subtracts another [I8] from this, wrapping around on overflow/underflow.
  I8 operator -(I8 other) => I8((value - other.value).toSigned(8));

  /// Multiplies this by another [I8], wrapping around on overflow/underflow.
  I8 operator *(I8 other) => I8((value * other.value).toSigned(8));

  /// Integer-divides this by another [I8], wrapping around on overflow.
  I8 operator ~/(I8 other) => I8((value ~/ other.value).toSigned(8));

  /// Modulo operator, wrapping the result to remain within [I8] range.
  I8 operator %(I8 other) => I8((value % other.value).toSigned(8));

  /// Returns the negated value, wrapping on overflow.
  I8 operator -() => I8((-value).toSigned(8));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  I8 operator &(I8 other) => I8((value & other.value).toSigned(8));

  /// Performs bitwise OR.
  I8 operator |(I8 other) => I8((value | other.value).toSigned(8));

  /// Performs bitwise XOR.
  I8 operator ^(I8 other) => I8((value ^ other.value).toSigned(8));

  /// Performs bitwise NOT.
  I8 operator ~() => I8((~value).toSigned(8));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  I8 operator <<(int shiftAmount) => I8((value << shiftAmount).toSigned(8));

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  I8 operator >>(int shiftAmount) => I8((value >> shiftAmount).toSigned(8));

  /// Unsigned right-shifts by [shiftAmount] bits.
  I8 operator >>>(int shiftAmount) => I8((value >>> shiftAmount).toSigned(8));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  I8 addChecked(I8 other) {
    final result = value + other.value;
    if (result > 127 || result < -128) throw StateError('I8 addition overflow');
    return I8(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  I8 subChecked(I8 other) {
    final result = value - other.value;
    if (result > 127 || result < -128) {
      throw StateError('I8 subtraction overflow');
    }
    return I8(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  I8 mulChecked(I8 other) {
    final result = value * other.value;
    if (result > 127 || result < -128) {
      throw StateError('I8 multiplication overflow');
    }
    return I8(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`I8(-128) ~/ I8(-1)`).
  I8 divChecked(I8 other) {
    if (other.value == 0) throw StateError('I8 division by zero');
    if (value == -128 && other.value == -1) {
      throw StateError('I8 division overflow');
    }
    return I8(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping the result to `[-128, 127]` instead of wrapping.
  I8 saturatingAdd(I8 other) {
    final result = value + other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return I8(result);
  }

  /// Subtracts [other], clamping the result to `[-128, 127]` instead of wrapping.
  I8 saturatingSub(I8 other) {
    final result = value - other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return I8(result);
  }

  /// Multiplies by [other], clamping the result to `[-128, 127]` instead of wrapping.
  I8 saturatingMul(I8 other) {
    final result = value * other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return I8(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() =>
      (value & 0xFF).toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 8-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    final v = value & 0xFF;
    if (v == 0) return 8;
    var n = 0;
    var mask = 0x80;
    while ((v & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 8-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    final v = value & 0xFF;
    if (v == 0) return 8;
    var n = 0;
    var mask = 1;
    while ((v & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 8-bit representation left by [n] bits (`std::rotl`).
  I8 rotateLeft(int n) {
    n &= 7;
    final v = value & 0xFF;
    return I8(((v << n) | (v >> (8 - n))) & 0xFF);
  }

  /// Rotates the 8-bit representation right by [n] bits (`std::rotr`).
  I8 rotateRight(int n) => rotateLeft(8 - (n & 7));

  /// Reverses the byte order (no-op for a single-byte type; included for API uniformity).
  I8 byteSwap() => this;

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 8-bit binary string (e.g. `I8(10)` → `"00001010"`).
  String toBinaryString() => (value & 0xFF).toRadixString(2).padLeft(8, '0');

  /// Returns the value as a zero-padded 2-digit uppercase hex string (e.g. `I8(10)` → `"0A"`).
  String toHexString() =>
      (value & 0xFF).toRadixString(16).toUpperCase().padLeft(2, '0');

  // ── Return-type override ────────────────────────────────────────────────

  /// Returns the absolute value as an [I8], wrapping on the edge case `I8(-128)`.
  I8 abs() => value < 0 ? I8((-value).toSigned(8)) : this;

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8] (identity).
  I8 toI8() => this;

  /// Converts to [I16], sign-extending.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32], sign-extending.
  I32 toI32() => I32(value.toSigned(32));

  /// Converts to [I64], sign-extending.
  I64 toI64() => I64(value.toSigned(64));

  /// Converts to [U8], reinterpreting the bit pattern as unsigned.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], reinterpreting as unsigned.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32], reinterpreting as unsigned.
  U32 toU32() => U32(value.toUnsigned(32));

  /// Converts to [U64], reinterpreting as unsigned.
  U64 toU64() => U64(value.toUnsigned(64));
}
