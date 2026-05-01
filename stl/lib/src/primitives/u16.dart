part of 'primitives.dart';

/// A 16-bit unsigned integer primitive.
///
/// Provides a zero-cost abstraction for 16-bit unsigned math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [U16.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const U16._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [U16] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[0, 65535]`.
  /// For automatic truncation use [U16.wrapping].
  const U16(this.value);

  /// Constructs a [U16] from an arbitrary [int], wrapping into `[0, 65535]`.
  U16.wrapping(int v) : value = v.toUnsigned(16);

  /// The bit-width of this type.
  static const int bits = 16;

  /// The minimum representable value (0).
  static const U16 min = U16(0);

  /// The maximum representable value (65535).
  static const U16 max = U16(65535);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [U16] to this, wrapping around on overflow.
  U16 operator +(U16 other) => U16((value + other.value).toUnsigned(16));

  /// Subtracts another [U16] from this, wrapping around on underflow.
  U16 operator -(U16 other) => U16((value - other.value).toUnsigned(16));

  /// Multiplies this by another [U16], wrapping around on overflow.
  U16 operator *(U16 other) => U16((value * other.value).toUnsigned(16));

  /// Integer-divides this by another [U16].
  U16 operator ~/(U16 other) => U16((value ~/ other.value).toUnsigned(16));

  /// Modulo operator, wrapping the result to remain within [U16] range.
  U16 operator %(U16 other) => U16((value % other.value).toUnsigned(16));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  U16 operator &(U16 other) => U16((value & other.value).toUnsigned(16));

  /// Performs bitwise OR.
  U16 operator |(U16 other) => U16((value | other.value).toUnsigned(16));

  /// Performs bitwise XOR.
  U16 operator ^(U16 other) => U16((value ^ other.value).toUnsigned(16));

  /// Performs bitwise NOT.
  U16 operator ~() => U16((~value).toUnsigned(16));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  U16 operator <<(int shiftAmount) =>
      U16((value << shiftAmount).toUnsigned(16));

  /// Right-shifts by [shiftAmount] bits.
  U16 operator >>(int shiftAmount) =>
      U16((value >> shiftAmount).toUnsigned(16));

  /// Unsigned right-shifts by [shiftAmount] bits.
  U16 operator >>>(int shiftAmount) =>
      U16((value >>> shiftAmount).toUnsigned(16));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  U16 addChecked(U16 other) {
    final result = value + other.value;
    if (result > 65535) throw StateError('U16 addition overflow');
    return U16(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  U16 subChecked(U16 other) {
    final result = value - other.value;
    if (result < 0) throw StateError('U16 subtraction underflow');
    return U16(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  U16 mulChecked(U16 other) {
    final result = value * other.value;
    if (result > 65535) throw StateError('U16 multiplication overflow');
    return U16(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  U16 divChecked(U16 other) {
    if (other.value == 0) throw StateError('U16 division by zero');
    return U16(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 65535]` instead of wrapping.
  U16 saturatingAdd(U16 other) {
    final result = value + other.value;
    return result > 65535 ? max : U16(result);
  }

  /// Subtracts [other], clamping to `[0, 65535]` instead of wrapping.
  U16 saturatingSub(U16 other) {
    final result = value - other.value;
    return result < 0 ? min : U16(result);
  }

  /// Multiplies by [other], clamping to `[0, 65535]` instead of wrapping.
  U16 saturatingMul(U16 other) {
    final result = value * other.value;
    return result > 65535 ? max : U16(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() => value.toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 16-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    if (value == 0) return 16;
    var n = 0;
    var mask = 0x8000;
    while ((value & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 16-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    if (value == 0) return 16;
    var n = 0;
    var mask = 1;
    while ((value & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 16-bit representation left by [n] bits (`std::rotl`).
  U16 rotateLeft(int n) {
    n &= 15;
    return U16(((value << n) | (value >> (16 - n))) & 0xFFFF);
  }

  /// Rotates the 16-bit representation right by [n] bits (`std::rotr`).
  U16 rotateRight(int n) => rotateLeft(16 - (n & 15));

  /// Reverses the byte order of the 16-bit value (`std::byteswap`).
  U16 byteSwap() => U16(((value & 0xFF) << 8) | ((value >> 8) & 0xFF));

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 16-bit binary string.
  String toBinaryString() => value.toRadixString(2).padLeft(16, '0');

  /// Returns the value as a zero-padded 4-digit uppercase hex string.
  String toHexString() => value.toRadixString(16).toUpperCase().padLeft(4, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], reinterpreting the low 8 bits as signed.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], reinterpreting the bit pattern as signed.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32], zero-extending.
  I32 toI32() => I32(value);

  /// Converts to [I64], zero-extending.
  I64 toI64() => I64(value);

  /// Converts to [U8], truncating to the low 8 bits.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16] (identity).
  U16 toU16() => this;

  /// Converts to [U32], zero-extending.
  U32 toU32() => U32(value);

  /// Converts to [U64], zero-extending.
  U64 toU64() => U64(value);
}
