part of 'primitives.dart';

/// A 64-bit signed integer primitive.
///
/// Provides a zero-cost abstraction for 64-bit signed math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [I64.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const I64._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [I64] with the given [value].
  ///
  /// For automatic truncation use [I64.wrapping].
  const I64(this.value);

  /// Constructs an [I64] from an arbitrary [int], wrapping into 64-bit signed range.
  I64.wrapping(int v) : value = v.toSigned(64);

  /// The bit-width of this type.
  static const int bits = 64;

  /// The minimum representable value (-9223372036854775808).
  static const I64 min = I64(-9223372036854775808);

  /// The maximum representable value (9223372036854775807).
  static const I64 max = I64(9223372036854775807);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [I64] to this, wrapping around on overflow/underflow.
  I64 operator +(I64 other) => I64((value + other.value).toSigned(64));

  /// Subtracts another [I64] from this, wrapping around on overflow/underflow.
  I64 operator -(I64 other) => I64((value - other.value).toSigned(64));

  /// Multiplies this by another [I64], wrapping around on overflow/underflow.
  I64 operator *(I64 other) => I64((value * other.value).toSigned(64));

  /// Integer-divides this by another [I64], wrapping around on overflow.
  I64 operator ~/(I64 other) => I64((value ~/ other.value).toSigned(64));

  /// Modulo operator, wrapping the result to remain within [I64] range.
  I64 operator %(I64 other) => I64((value % other.value).toSigned(64));

  /// Returns the negated value, wrapping on overflow.
  I64 operator -() => I64((-value).toSigned(64));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  I64 operator &(I64 other) => I64((value & other.value).toSigned(64));

  /// Performs bitwise OR.
  I64 operator |(I64 other) => I64((value | other.value).toSigned(64));

  /// Performs bitwise XOR.
  I64 operator ^(I64 other) => I64((value ^ other.value).toSigned(64));

  /// Performs bitwise NOT.
  I64 operator ~() => I64((~value).toSigned(64));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  I64 operator <<(int shiftAmount) => I64((value << shiftAmount).toSigned(64));

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  I64 operator >>(int shiftAmount) => I64((value >> shiftAmount).toSigned(64));

  /// Unsigned right-shifts by [shiftAmount] bits.
  I64 operator >>>(int shiftAmount) =>
      I64((value >>> shiftAmount).toSigned(64));

  // ── Internal helper ─────────────────────────────────────────────────────

  bool _sameSign(int a, int b) => (a >= 0 && b >= 0) || (a < 0 && b < 0);

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  I64 addChecked(I64 other) {
    final result = (value + other.value).toSigned(64);
    if (_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('I64 addition overflow');
    }
    return I64(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  I64 subChecked(I64 other) {
    final result = (value - other.value).toSigned(64);
    if (!_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('I64 subtraction overflow');
    }
    return I64(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  I64 mulChecked(I64 other) {
    if (value == 0 || other.value == 0) return I64(0);
    final result = (value * other.value).toSigned(64);
    if (result ~/ other.value != value) {
      throw StateError('I64 multiplication overflow');
    }
    return I64(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`I64(min) ~/ I64(-1)`).
  I64 divChecked(I64 other) {
    if (other.value == 0) throw StateError('I64 division by zero');
    if (value == -9223372036854775808 && other.value == -1) {
      throw StateError('I64 division overflow');
    }
    return I64(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[min, max]` instead of wrapping.
  I64 saturatingAdd(I64 other) {
    final result = (value + other.value).toSigned(64);
    if (_sameSign(value, other.value) && !_sameSign(value, result)) {
      return value >= 0 ? max : min;
    }
    return I64(result);
  }

  /// Subtracts [other], clamping to `[min, max]` instead of wrapping.
  I64 saturatingSub(I64 other) {
    final result = (value - other.value).toSigned(64);
    if (!_sameSign(value, other.value) && !_sameSign(value, result)) {
      return value >= 0 ? max : min;
    }
    return I64(result);
  }

  /// Multiplies by [other], clamping to `[min, max]` instead of wrapping.
  I64 saturatingMul(I64 other) {
    if (value == 0 || other.value == 0) return I64(0);
    final result = (value * other.value).toSigned(64);
    if (result ~/ other.value != value) {
      final positive = (value > 0) == (other.value > 0);
      return positive ? max : min;
    }
    return I64(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() {
    var v = value;
    var count = 0;
    for (var i = 0; i < 64; i++) {
      if ((v & 1) != 0) count++;
      v >>= 1;
    }
    return count;
  }

  /// Returns the number of leading zero bits within the 64-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    if (value == 0) return 64;
    var v = value;
    if (v > 0) {
      v = -v;
    } // adjust for sign bit
    // Use bit scanning on the magnitude
    var mask = 0x8000000000000000;
    for (var i = 0; i < 64; i++) {
      if ((value & mask) != 0) return i;
      mask = (mask >> 1) & 0x7FFFFFFFFFFFFFFF;
    }
    return 64;
  }

  /// Returns the number of trailing zero bits within the 64-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    if (value == 0) return 64;
    var n = 0;
    var v = value;
    while ((v & 1) == 0) {
      n++;
      v >>= 1;
    }
    return n;
  }

  /// Rotates the 64-bit representation left by [n] bits (`std::rotl`).
  I64 rotateLeft(int n) {
    n &= 63;
    if (n == 0) return this;
    return I64(((value << n) | (value >>> (64 - n))).toSigned(64));
  }

  /// Rotates the 64-bit representation right by [n] bits (`std::rotr`).
  I64 rotateRight(int n) => rotateLeft(64 - (n & 63));

  /// Reverses the byte order of the 64-bit value (`std::byteswap`).
  I64 byteSwap() {
    var v = value;
    var result = 0;
    for (var i = 0; i < 8; i++) {
      result = (result << 8) | (v & 0xFF);
      v >>= 8;
    }
    return I64(result.toSigned(64));
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 64-bit binary string.
  String toBinaryString() {
    final buf = StringBuffer();
    var v = value;
    for (var i = 63; i >= 0; i--) {
      buf.write((v >>> i) & 1);
    }
    return buf.toString();
  }

  /// Returns the value as a zero-padded 16-digit uppercase hex string.
  String toHexString() {
    final lo = value & 0xFFFFFFFF;
    final hi = (value >>> 32) & 0xFFFFFFFF;
    return hi.toRadixString(16).toUpperCase().padLeft(8, '0') +
        lo.toRadixString(16).toUpperCase().padLeft(8, '0');
  }

  // ── Return-type override ────────────────────────────────────────────────

  /// Returns the absolute value as an [I64], wrapping on the edge case [I64.min].
  I64 abs() => value < 0 ? I64((-value).toSigned(64)) : this;

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], truncating to the low 8 bits.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], truncating to the low 16 bits.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32], truncating to the low 32 bits.
  I32 toI32() => I32(value.toSigned(32));

  /// Converts to [I64] (identity).
  I64 toI64() => this;

  /// Converts to [U8], reinterpreting the low 8 bits as unsigned.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], reinterpreting the low 16 bits as unsigned.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32], reinterpreting the low 32 bits as unsigned.
  U32 toU32() => U32(value.toUnsigned(32));

  /// Converts to [U64], reinterpreting the bit pattern as unsigned.
  U64 toU64() => U64(value.toUnsigned(64));

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs an [I64] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside the 64-bit signed range `[-2^63, 2^63-1]`.
  static I64 fromBigInt(BigInt v) {
    if (v < -(BigInt.one << 63) || v > (BigInt.one << 63) - BigInt.one) {
      throw RangeError(
        '$v is out of range for I64. Must be in [-2^63, 2^63-1].',
      );
    }
    return I64(v.toInt());
  }

  // ── Checked negation ────────────────────────────────────────────────────

  /// Returns the negated value, throwing a [StateError] if this is [I64.min]
  /// (the only value whose negation overflows).
  I64 negChecked() {
    if (value == -9223372036854775808) {
      throw StateError('I64 negation overflow');
    }
    return I64(-value);
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning a [BigInt] to prevent overflow.
  BigInt wideningMul(I64 other) =>
      BigInt.from(value) * BigInt.from(other.value);
}
