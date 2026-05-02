part of 'primitives.dart';

/// A 16-bit signed integer primitive.
///
/// Provides a zero-cost abstraction for 16-bit signed math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [I16.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const I16._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [I16] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[-32768, 32767]`.
  /// For automatic truncation use [I16.wrapping].
  const I16(this.value);

  /// Constructs an [I16] from an arbitrary [int], wrapping into `[-32768, 32767]`.
  I16.wrapping(int v) : value = v.toSigned(16);

  /// The bit-width of this type.
  static const int bits = 16;

  /// The minimum value an [I16] can hold (-32768).
  static const I16 min = I16(-32768);

  /// The maximum value an [I16] can hold (32767).
  static const I16 max = I16(32767);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [I16] to this, wrapping around on overflow/underflow.
  I16 operator +(I16 other) => I16((value + other.value).toSigned(16));

  /// Subtracts another [I16] from this, wrapping around on overflow/underflow.
  I16 operator -(I16 other) => I16((value - other.value).toSigned(16));

  /// Multiplies this by another [I16], wrapping around on overflow/underflow.
  I16 operator *(I16 other) => I16((value * other.value).toSigned(16));

  /// Integer-divides this by another [I16], wrapping around on overflow.
  I16 operator ~/(I16 other) => I16((value ~/ other.value).toSigned(16));

  /// Modulo operator, wrapping the result to remain within [I16] range.
  I16 operator %(I16 other) => I16((value % other.value).toSigned(16));

  /// Returns the negated value, wrapping on overflow.
  I16 operator -() => I16((-value).toSigned(16));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  I16 operator &(I16 other) => I16((value & other.value).toSigned(16));

  /// Performs bitwise OR.
  I16 operator |(I16 other) => I16((value | other.value).toSigned(16));

  /// Performs bitwise XOR.
  I16 operator ^(I16 other) => I16((value ^ other.value).toSigned(16));

  /// Performs bitwise NOT.
  I16 operator ~() => I16((~value).toSigned(16));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  I16 operator <<(int shiftAmount) => I16((value << shiftAmount).toSigned(16));

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  I16 operator >>(int shiftAmount) => I16((value >> shiftAmount).toSigned(16));

  /// Unsigned right-shifts by [shiftAmount] bits.
  I16 operator >>>(int shiftAmount) =>
      I16((value >>> shiftAmount).toSigned(16));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  I16 addChecked(I16 other) {
    final result = value + other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 addition overflow');
    }
    return I16(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  I16 subChecked(I16 other) {
    final result = value - other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 subtraction overflow');
    }
    return I16(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  I16 mulChecked(I16 other) {
    final result = value * other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 multiplication overflow');
    }
    return I16(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`I16(-32768) ~/ I16(-1)`).
  I16 divChecked(I16 other) {
    if (other.value == 0) throw StateError('I16 division by zero');
    if (value == -32768 && other.value == -1) {
      throw StateError('I16 division overflow');
    }
    return I16(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping the result to `[-32768, 32767]` instead of wrapping.
  I16 saturatingAdd(I16 other) {
    final result = value + other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return I16(result);
  }

  /// Subtracts [other], clamping the result to `[-32768, 32767]` instead of wrapping.
  I16 saturatingSub(I16 other) {
    final result = value - other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return I16(result);
  }

  /// Multiplies by [other], clamping the result to `[-32768, 32767]` instead of wrapping.
  I16 saturatingMul(I16 other) {
    final result = value * other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return I16(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() =>
      (value & 0xFFFF).toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 16-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    final v = value & 0xFFFF;
    if (v == 0) return 16;
    var n = 0;
    var mask = 0x8000;
    while ((v & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 16-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    final v = value & 0xFFFF;
    if (v == 0) return 16;
    var n = 0;
    var mask = 1;
    while ((v & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 16-bit representation left by [n] bits (`std::rotl`).
  I16 rotateLeft(int n) {
    n &= 15;
    final v = value & 0xFFFF;
    return I16(((v << n) | (v >> (16 - n))) & 0xFFFF);
  }

  /// Rotates the 16-bit representation right by [n] bits (`std::rotr`).
  I16 rotateRight(int n) => rotateLeft(16 - (n & 15));

  /// Reverses the byte order of the 16-bit value (`std::byteswap`).
  I16 byteSwap() {
    final v = value & 0xFFFF;
    return I16(((v & 0xFF) << 8) | ((v >> 8) & 0xFF));
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 16-bit binary string.
  String toBinaryString() => (value & 0xFFFF).toRadixString(2).padLeft(16, '0');

  /// Returns the value as a zero-padded 4-digit uppercase hex string.
  String toHexString() =>
      (value & 0xFFFF).toRadixString(16).toUpperCase().padLeft(4, '0');

  // ── Return-type override ────────────────────────────────────────────────

  /// Returns the absolute value as an [I16], wrapping on the edge case `I16(-32768)`.
  I16 abs() => value < 0 ? I16((-value).toSigned(16)) : this;

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], truncating to the low 8 bits.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16] (identity).
  I16 toI16() => this;

  /// Converts to [I32], sign-extending.
  I32 toI32() => I32(value.toSigned(32));

  /// Converts to [I64], sign-extending.
  I64 toI64() => I64(value.toSigned(64));

  /// Converts to [U8], reinterpreting the low 8 bits as unsigned.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], reinterpreting the bit pattern as unsigned.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32], reinterpreting as unsigned.
  U32 toU32() => U32(value.toUnsigned(32));

  /// Converts to [U64], reinterpreting as unsigned.
  U64 toU64() => U64(value.toUnsigned(64));

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs an [I16] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside `[-32768, 32767]`.
  static I16 fromBigInt(BigInt v) {
    if (v < BigInt.from(-32768) || v > BigInt.from(32767)) {
      throw RangeError(
        '$v is out of range for I16. Must be in [-32768, 32767].',
      );
    }
    return I16(v.toInt());
  }

  // ── Checked negation ────────────────────────────────────────────────────

  /// Returns the negated value, throwing a [StateError] if this is [I16.min]
  /// (the only value whose negation overflows).
  I16 negChecked() {
    if (value == -32768) {
      throw StateError('I16 negation overflow');
    }
    return I16(-value);
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning an [I32] to prevent overflow.
  I32 wideningMul(I16 other) => I32(value * other.value);
}
