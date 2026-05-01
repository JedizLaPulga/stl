part of 'primitives.dart';

/// A 64-bit unsigned integer primitive.
///
/// Provides a zero-cost abstraction for 64-bit unsigned math, automatically
/// wrapping on overflow and providing C++-style boundaries. Use [U64.wrapping]
/// to construct from an arbitrary [int] with guaranteed truncation.
///
/// Note: Dart's native `int` is a 64-bit *signed* integer. `U64` stores values
/// in the same bit pattern, using sign-bit-XOR comparisons to restore unsigned
/// ordering, and BigInt for operations that would otherwise be corrupted by the
/// signed interpretation (division, modulo, checked overflow).
extension type const U64._(
  /// The strictly bounded primitive underlying value (stored as a signed 64-bit
  /// Dart `int` with the same bit pattern as the unsigned value).
  int
  value
)
    implements int {
  /// Instantiates a new [U64] with the given [value].
  ///
  /// The caller is responsible for supplying a bit pattern that represents a
  /// valid unsigned 64-bit integer. For automatic truncation use [U64.wrapping].
  const U64(this.value);

  /// Constructs a [U64] from an arbitrary [int], wrapping into 64-bit unsigned range.
  U64.wrapping(int v) : value = v.toUnsigned(64);

  /// The bit-width of this type.
  static const int bits = 64;

  /// The minimum representable value (0).
  static const U64 min = U64(0);

  /// The maximum representable value (18446744073709551615), stored as `-1` in
  /// Dart's signed `int` representation.
  static const U64 max = U64(-1);

  // ── Internal unsigned comparison helper ─────────────────────────────────

  // XOR with the sign bit converts Dart's signed ordering to unsigned ordering.
  static int _u(int v) => v ^ 0x8000000000000000;

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds another [U64] to this, wrapping around on overflow.
  U64 operator +(U64 other) => U64((value + other.value).toUnsigned(64));

  /// Subtracts another [U64] from this, wrapping around on underflow.
  U64 operator -(U64 other) => U64((value - other.value).toUnsigned(64));

  /// Multiplies this by another [U64], wrapping around on overflow.
  U64 operator *(U64 other) => U64((value * other.value).toUnsigned(64));

  /// Integer-divides this by another [U64] using unsigned semantics.
  U64 operator ~/(U64 other) {
    if (other.value == 0) throw UnsupportedError('U64 division by zero');
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return U64((bi1 ~/ bi2).toInt().toUnsigned(64));
  }

  /// Modulo of this by another [U64] using unsigned semantics.
  U64 operator %(U64 other) {
    if (other.value == 0) throw UnsupportedError('U64 modulo by zero');
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return U64((bi1 % bi2).toInt().toUnsigned(64));
  }

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  U64 operator &(U64 other) => U64((value & other.value).toUnsigned(64));

  /// Performs bitwise OR.
  U64 operator |(U64 other) => U64((value | other.value).toUnsigned(64));

  /// Performs bitwise XOR.
  U64 operator ^(U64 other) => U64((value ^ other.value).toUnsigned(64));

  /// Performs bitwise NOT.
  U64 operator ~() => U64((~value).toUnsigned(64));

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  U64 operator <<(int shiftAmount) =>
      U64((value << shiftAmount).toUnsigned(64));

  /// Right-shifts by [shiftAmount] bits (logical shift — sign bit is not extended).
  U64 operator >>(int shiftAmount) =>
      U64((value >>> shiftAmount).toUnsigned(64));

  /// Unsigned right-shifts by [shiftAmount] bits.
  U64 operator >>>(int shiftAmount) =>
      U64((value >>> shiftAmount).toUnsigned(64));

  // ── Unsigned comparison operators ───────────────────────────────────────

  /// Returns `true` if this is less than [other] under unsigned semantics.
  bool operator <(U64 other) => _u(value) < _u(other.value);

  /// Returns `true` if this is less than or equal to [other] under unsigned semantics.
  bool operator <=(U64 other) => _u(value) <= _u(other.value);

  /// Returns `true` if this is greater than [other] under unsigned semantics.
  bool operator >(U64 other) => _u(value) > _u(other.value);

  /// Returns `true` if this is greater than or equal to [other] under unsigned semantics.
  bool operator >=(U64 other) => _u(value) >= _u(other.value);

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  U64 addChecked(U64 other) {
    final result = (value + other.value).toUnsigned(64);
    if (_u(result) < _u(value)) throw StateError('U64 addition overflow');
    return U64(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  U64 subChecked(U64 other) {
    if (this < other) throw StateError('U64 subtraction underflow');
    return U64((value - other.value).toUnsigned(64));
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  U64 mulChecked(U64 other) {
    if (value == 0 || other.value == 0) return U64(0);
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    final res = bi1 * bi2;
    if (res.bitLength > 64) throw StateError('U64 multiplication overflow');
    return U64(res.toInt().toUnsigned(64));
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  U64 divChecked(U64 other) {
    if (other.value == 0) throw StateError('U64 division by zero');
    return this ~/ other;
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to [max] instead of wrapping.
  U64 saturatingAdd(U64 other) {
    final result = (value + other.value).toUnsigned(64);
    return _u(result) < _u(value) ? max : U64(result);
  }

  /// Subtracts [other], clamping to [min] (0) instead of wrapping.
  U64 saturatingSub(U64 other) =>
      this < other ? min : U64((value - other.value).toUnsigned(64));

  /// Multiplies by [other], clamping to [max] instead of wrapping.
  U64 saturatingMul(U64 other) {
    if (value == 0 || other.value == 0) return U64(0);
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    final res = bi1 * bi2;
    if (res.bitLength > 64) return max;
    return U64(res.toInt().toUnsigned(64));
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() {
    var v = value;
    var count = 0;
    for (var i = 0; i < 64; i++) {
      if ((v & 1) != 0) count++;
      v = (v >>> 1);
    }
    return count;
  }

  /// Returns the number of leading zero bits within the 64-bit representation (`std::countl_zero`).
  int countLeadingZeros() {
    if (value == 0) return 64;
    var v = value;
    // Walk from the most-significant bit
    for (var i = 63; i >= 0; i--) {
      if ((v >>> i) & 1 != 0) return 63 - i;
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
      v >>>= 1;
    }
    return n;
  }

  /// Rotates the 64-bit representation left by [n] bits (`std::rotl`).
  U64 rotateLeft(int n) {
    n &= 63;
    if (n == 0) return this;
    return U64(((value << n) | (value >>> (64 - n))).toUnsigned(64));
  }

  /// Rotates the 64-bit representation right by [n] bits (`std::rotr`).
  U64 rotateRight(int n) => rotateLeft(64 - (n & 63));

  /// Reverses the byte order of the 64-bit value (`std::byteswap`).
  U64 byteSwap() {
    var v = value;
    var result = 0;
    for (var i = 0; i < 8; i++) {
      result = (result << 8) | (v & 0xFF);
      v >>>= 8;
    }
    return U64(result.toUnsigned(64));
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 64-bit binary string.
  String toBinaryString() {
    final buf = StringBuffer();
    for (var i = 63; i >= 0; i--) {
      buf.write((value >>> i) & 1);
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

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [I8], reinterpreting the low 8 bits as signed.
  I8 toI8() => I8(value.toSigned(8));

  /// Converts to [I16], reinterpreting the low 16 bits as signed.
  I16 toI16() => I16(value.toSigned(16));

  /// Converts to [I32], reinterpreting the low 32 bits as signed.
  I32 toI32() => I32(value.toSigned(32));

  /// Converts to [I64], reinterpreting the bit pattern as signed.
  I64 toI64() => I64(value.toSigned(64));

  /// Converts to [U8], truncating to the low 8 bits.
  U8 toU8() => U8(value.toUnsigned(8));

  /// Converts to [U16], truncating to the low 16 bits.
  U16 toU16() => U16(value.toUnsigned(16));

  /// Converts to [U32], truncating to the low 32 bits.
  U32 toU32() => U32(value.toUnsigned(32));

  /// Converts to [U64] (identity).
  U64 toU64() => this;
}
