part of 'primitives.dart';

/// An 8-bit unsigned integer primitive.
///
/// Provides a zero-cost abstraction for 8-bit unsigned math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [U8.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
extension type const U8._(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// Instantiates a new [U8] with the given [value].
  ///
  /// The caller is responsible for ensuring [value] is in `[0, 255]`.
  /// For automatic truncation use [U8.wrapping].
  const U8(this.value);

  /// Constructs a [U8] from an arbitrary [int], wrapping into `[0, 255]`.
  U8.wrapping(int v) : value = v.toUnsigned(8);

  /// The bit-width of this type.
  static const int bits = 8;

  /// The minimum representable value (0).
  static const U8 min = U8(0);

  /// The maximum representable value (255).
  static const U8 max = U8(255);

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [U8] to this, wrapping around on overflow.
  U8 operator +(U8 other) => U8((value + other.value).toUnsigned(8));

  /// Subtracts another [U8] from this, wrapping around on underflow.
  U8 operator -(U8 other) => U8((value - other.value).toUnsigned(8));

  /// Multiplies this by another [U8], wrapping around on overflow.
  U8 operator *(U8 other) => U8((value * other.value).toUnsigned(8));

  /// Integer-divides this by another [U8].
  U8 operator ~/(U8 other) => U8((value ~/ other.value).toUnsigned(8));

  /// Modulo operator, wrapping the result to remain within [U8] range.
  U8 operator %(U8 other) => U8((value % other.value).toUnsigned(8));

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  U8 operator &(U8 other) => U8((value & other.value).toUnsigned(8));

  /// Performs bitwise OR.
  U8 operator |(U8 other) => U8((value | other.value).toUnsigned(8));

  /// Performs bitwise XOR.
  U8 operator ^(U8 other) => U8((value ^ other.value).toUnsigned(8));

  /// Performs bitwise NOT.
  U8 operator ~() => U8((~value).toUnsigned(8));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  U8 operator <<(int shiftAmount) => U8((value << shiftAmount).toUnsigned(8));

  /// Right-shifts by [shiftAmount] bits.
  U8 operator >>(int shiftAmount) => U8((value >> shiftAmount).toUnsigned(8));

  /// Unsigned right-shifts by [shiftAmount] bits.
  U8 operator >>>(int shiftAmount) => U8((value >>> shiftAmount).toUnsigned(8));

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  U8 addChecked(U8 other) {
    final result = value + other.value;
    if (result > 255) throw StateError('U8 addition overflow');
    return U8(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  U8 subChecked(U8 other) {
    final result = value - other.value;
    if (result < 0) throw StateError('U8 subtraction underflow');
    return U8(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  U8 mulChecked(U8 other) {
    final result = value * other.value;
    if (result > 255) throw StateError('U8 multiplication overflow');
    return U8(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  U8 divChecked(U8 other) {
    if (other.value == 0) throw StateError('U8 division by zero');
    return U8(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 255]` instead of wrapping.
  U8 saturatingAdd(U8 other) {
    final result = value + other.value;
    return result > 255 ? max : U8(result);
  }

  /// Subtracts [other], clamping to `[0, 255]` instead of wrapping.
  U8 saturatingSub(U8 other) {
    final result = value - other.value;
    return result < 0 ? min : U8(result);
  }

  /// Multiplies by [other], clamping to `[0, 255]` instead of wrapping.
  U8 saturatingMul(U8 other) {
    final result = value * other.value;
    return result > 255 ? max : U8(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() => value.toRadixString(2).replaceAll('0', '').length;

  /// Returns the number of leading zero bits within the 8-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    if (value == 0) return 8;
    var n = 0;
    var mask = 0x80;
    while ((value & mask) == 0) {
      n++;
      mask >>= 1;
    }
    return n;
  }

  /// Returns the number of trailing zero bits within the 8-bit representation (`std::countr_zero`).
  int countTrailingZeros() {
    if (value == 0) return 8;
    var n = 0;
    var mask = 1;
    while ((value & mask) == 0) {
      n++;
      mask <<= 1;
    }
    return n;
  }

  /// Rotates the 8-bit representation left by [n] bits (`std::rotl`).
  U8 rotateLeft(int n) {
    n &= 7;
    return U8(((value << n) | (value >> (8 - n))) & 0xFF);
  }

  /// Rotates the 8-bit representation right by [n] bits (`std::rotr`).
  U8 rotateRight(int n) => rotateLeft(8 - (n & 7));

  /// Reverses the byte order (no-op for a single-byte type; included for API uniformity).
  U8 byteSwap() => this;

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 8-bit binary string (e.g. `U8(10)` → `"00001010"`).
  String toBinaryString() => value.toRadixString(2).padLeft(8, '0');

  /// Returns the value as a zero-padded 2-digit uppercase hex string (e.g. `U8(10)` → `"0A"`).
  String toHexString() => value.toRadixString(16).toUpperCase().padLeft(2, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], reinterpreting the bit pattern as signed.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], zero-extending.
  I16 toI16() => I16(value);

  /// Converts to [I32], zero-extending.
  I32 toI32() => I32(value);

  /// Converts to [I64], zero-extending.
  I64 toI64() => I64(value);

  /// Converts to [U8] (identity).
  U8 toU8() => this;

  /// Converts to [U16], zero-extending.
  U16 toU16() => U16(value);

  /// Converts to [U32], zero-extending.
  U32 toU32() => U32(value);

  /// Converts to [U64], zero-extending.
  U64 toU64() => U64(value);

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs a [U8] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside `[0, 255]`.
  static U8 fromBigInt(BigInt v) {
    if (v.isNegative || v > BigInt.from(255)) {
      throw RangeError('$v is out of range for U8. Must be in [0, 255].');
    }
    return U8(v.toInt());
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning a [U16] to prevent overflow.
  U16 wideningMul(U8 other) => U16(value * other.value);
}
