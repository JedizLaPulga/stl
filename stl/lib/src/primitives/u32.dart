part of 'primitives.dart';

/// A 32-bit unsigned integer primitive.
///
/// Provides a zero-cost abstraction for 32-bit unsigned math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [U32.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const U32._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [U32] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[0, 4294967295]`.
  /// For automatic truncation use [U32.wrapping].
  const U32(this.value);

  /// Constructs a [U32] from an arbitrary [int], wrapping into `[0, 4294967295]`.
  U32.wrapping(int v) : value = v.toUnsigned(32);

  /// The bit-width of this type.
  static const int bits = 32;

  /// The minimum representable value (0).
  static const U32 min = U32(0);

  /// The maximum representable value (4294967295).
  static const U32 max = U32(4294967295);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [U32] to this, wrapping around on overflow.
  U32 operator +(U32 other) => U32((value + other.value).toUnsigned(32));

  /// Subtracts another [U32] from this, wrapping around on underflow.
  U32 operator -(U32 other) => U32((value - other.value).toUnsigned(32));

  /// Multiplies this by another [U32], wrapping around on overflow.
  U32 operator *(U32 other) => U32((value * other.value).toUnsigned(32));

  /// Integer-divides this by another [U32].
  U32 operator ~/(U32 other) => U32((value ~/ other.value).toUnsigned(32));

  /// Modulo operator, wrapping the result to remain within [U32] range.
  U32 operator %(U32 other) => U32((value % other.value).toUnsigned(32));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  U32 operator &(U32 other) => U32((value & other.value).toUnsigned(32));

  /// Performs bitwise OR.
  U32 operator |(U32 other) => U32((value | other.value).toUnsigned(32));

  /// Performs bitwise XOR.
  U32 operator ^(U32 other) => U32((value ^ other.value).toUnsigned(32));

  /// Performs bitwise NOT.
  U32 operator ~() => U32((~value).toUnsigned(32));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  U32 operator <<(int shiftAmount) =>
      U32((value << shiftAmount).toUnsigned(32));

  /// Right-shifts by [shiftAmount] bits.
  U32 operator >>(int shiftAmount) =>
      U32((value >> shiftAmount).toUnsigned(32));

  /// Unsigned right-shifts by [shiftAmount] bits.
  U32 operator >>>(int shiftAmount) =>
      U32((value >>> shiftAmount).toUnsigned(32));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  U32 addChecked(U32 other) {
    final result = value + other.value;
    if (result > 4294967295) throw StateError('U32 addition overflow');
    return U32(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  U32 subChecked(U32 other) {
    final result = value - other.value;
    if (result < 0) throw StateError('U32 subtraction underflow');
    return U32(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  U32 mulChecked(U32 other) {
    final result = value * other.value;
    if (result > 4294967295) throw StateError('U32 multiplication overflow');
    return U32(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  U32 divChecked(U32 other) {
    if (other.value == 0) throw StateError('U32 division by zero');
    return U32(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 4294967295]` instead of wrapping.
  U32 saturatingAdd(U32 other) {
    final result = value + other.value;
    return result > 4294967295 ? max : U32(result);
  }

  /// Subtracts [other], clamping to `[0, 4294967295]` instead of wrapping.
  U32 saturatingSub(U32 other) {
    final result = value - other.value;
    return result < 0 ? min : U32(result);
  }

  /// Multiplies by [other], clamping to `[0, 4294967295]` instead of wrapping.
  U32 saturatingMul(U32 other) {
    final result = value * other.value;
    return result > 4294967295 ? max : U32(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() =>
      (value & 0xFFFFFFFF).toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 32-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    if (value == 0) return 32;
    var n = 0;
    var mask = 0x80000000;
    while ((value & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 32-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    if (value == 0) return 32;
    var n = 0;
    var mask = 1;
    while ((value & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 32-bit representation left by [n] bits (`std::rotl`).
  U32 rotateLeft(int n) {
    n &= 31;
    final v = value & 0xFFFFFFFF;
    return U32(((v << n) | (v >> (32 - n))) & 0xFFFFFFFF);
  }

  /// Rotates the 32-bit representation right by [n] bits (`std::rotr`).
  U32 rotateRight(int n) => rotateLeft(32 - (n & 31));

  /// Reverses the byte order of the 32-bit value (`std::byteswap`).
  U32 byteSwap() {
    final v = value & 0xFFFFFFFF;
    return U32(
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

  /// Converts to [I8], reinterpreting the low 8 bits as signed.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], reinterpreting the low 16 bits as signed.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32], reinterpreting the bit pattern as signed.
  I32 toI32() => I32(value.toSigned(32));

  /// Converts to [I64], zero-extending.
  I64 toI64() => I64(value);

  /// Converts to [U8], truncating to the low 8 bits.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], truncating to the low 16 bits.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32] (identity).
  U32 toU32() => this;

  /// Converts to [U64], zero-extending.
  U64 toU64() => U64(value);
}
