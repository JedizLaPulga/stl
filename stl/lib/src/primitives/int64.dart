part of 'primitives.dart';

/// A heap-allocated 64-bit signed integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [I64] variant, [Int64] is strictly backed by an
/// [Int64List], which natively bounds every write to the 64-bit signed range
/// and guarantees C++-style wrapping arithmetic on all platforms.
extension type Int64._(Int64List _data) {
  /// Instantiates an [Int64] from an existing [Int64List].
  Int64(this._data);

  /// Instantiates an [Int64] from an [int], wrapping into 64-bit signed range.
  Int64.from(int value) : _data = Int64List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 64;

  /// The minimum value of a 64-bit signed integer (-9223372036854775808).
  static final Int64 min = Int64.from(-9223372036854775808);

  /// The maximum value of a 64-bit signed integer (9223372036854775807).
  static final Int64 max = Int64.from(9223372036854775807);

  /// The underlying raw [int] value.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Int64 operator +(Int64 other) => Int64.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Int64 operator -(Int64 other) => Int64.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Int64 operator *(Int64 other) => Int64.from(value * other.value);

  /// Integer-divides by [other].
  Int64 operator ~/(Int64 other) => Int64.from(value ~/ other.value);

  /// Modulo by [other].
  Int64 operator %(Int64 other) => Int64.from(value % other.value);

  /// Returns the negated value, wrapping on overflow.
  Int64 operator -() => Int64.from(-value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Int64 operator &(Int64 other) => Int64.from(value & other.value);

  /// Performs bitwise OR.
  Int64 operator |(Int64 other) => Int64.from(value | other.value);

  /// Performs bitwise XOR.
  Int64 operator ^(Int64 other) => Int64.from(value ^ other.value);

  /// Performs bitwise NOT.
  Int64 operator ~() => Int64.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Int64 operator <<(int shiftAmount) => Int64.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  Int64 operator >>(int shiftAmount) => Int64.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Int64 operator >>>(int shiftAmount) => Int64.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Int64 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Int64 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Int64 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Int64 other) => value >= other.value;

  // ── Internal helper ─────────────────────────────────────────────────────

  bool _sameSign(int a, int b) => (a >= 0 && b >= 0) || (a < 0 && b < 0);

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  Int64 addChecked(Int64 other) {
    final res = value + other.value;
    if (!(((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
      throw StateError('Int64 addition overflow');
    }
    return Int64.from(res);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  Int64 subChecked(Int64 other) {
    final res = value - other.value;
    if ((((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
      throw StateError('Int64 subtraction overflow');
    }
    return Int64.from(res);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  Int64 mulChecked(Int64 other) {
    if (value == 0 || other.value == 0) return Int64.from(0);
    final result = value * other.value;
    if (_sameSign(value, other.value) != (result >= 0)) {
      throw StateError('Int64 multiplication overflow');
    }
    return Int64.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`Int64(min) ~/ Int64(-1)`).
  Int64 divChecked(Int64 other) {
    if (other.value == 0) {
      throw StateError('Int64 division by zero');
    }
    if (value == -9223372036854775808 && other.value == -1) {
      throw StateError('Int64 division overflow');
    }

    return Int64.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[min, max]` instead of wrapping.
  Int64 saturatingAdd(Int64 other) {
    final res = value + other.value;
    if (_sameSign(value, other.value) && !_sameSign(value, res)) {
      return value >= 0 ? max : min;
    }
    return Int64.from(res);
  }

  /// Subtracts [other], clamping to `[min, max]` instead of wrapping.
  Int64 saturatingSub(Int64 other) {
    final res = value - other.value;
    if (!_sameSign(value, other.value) && !_sameSign(value, res)) {
      return value >= 0 ? max : min;
    }
    return Int64.from(res);
  }

  /// Multiplies by [other], clamping to `[min, max]` instead of wrapping.
  Int64 saturatingMul(Int64 other) {
    if (value == 0 || other.value == 0) return Int64.from(0);
    final result = value * other.value;
    if (_sameSign(value, other.value) != (result >= 0)) {
      final positive = (value > 0) == (other.value > 0);
      return positive ? max : min;
    }
    return Int64.from(result);
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
    for (var i = 63; i >= 0; i--) {
      if ((value >>> i) & 1 != 0) return 63 - i;
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
  Int64 rotateLeft(int n) {
    n &= 63;
    if (n == 0) return this;
    return Int64.from(((value << n) | (value >>> (64 - n))).toSigned(64));
  }

  /// Rotates the 64-bit representation right by [n] bits (`std::rotr`).
  Int64 rotateRight(int n) => rotateLeft(64 - (n & 63));

  /// Reverses the byte order of the 64-bit value (`std::byteswap`).
  Int64 byteSwap() {
    var v = value;
    var result = 0;
    for (var i = 0; i < 8; i++) {
      result = (result << 8) | (v & 0xFF);
      v >>= 8;
    }
    return Int64.from(result.toSigned(64));
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

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value);

  /// Converts to [Int16], truncating to the low 16 bits.
  Int16 toInt16() => Int16.from(value);

  /// Converts to [Int32], truncating to the low 32 bits.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64] (identity).
  Int64 toInt64() => this;

  /// Converts to [Uint8], reinterpreting the low 8 bits as unsigned.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], reinterpreting the low 16 bits as unsigned.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32], reinterpreting the low 32 bits as unsigned.
  Uint32 toUint32() => Uint32.from(value & 0xFFFFFFFF);

  /// Converts to [Uint64], reinterpreting the bit pattern as unsigned.
  Uint64 toUint64() => Uint64.from(value);

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs an [Int64] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside the 64-bit signed range `[-2^63, 2^63-1]`.
  static Int64 fromBigInt(BigInt v) {
    if (v < -(BigInt.one << 63) || v > (BigInt.one << 63) - BigInt.one) {
      throw RangeError(
        '$v is out of range for Int64. Must be in [-2^63, 2^63-1].',
      );
    }
    return Int64.from(v.toInt());
  }

  // ── Checked negation ────────────────────────────────────────────────────

  /// Returns the negated value, throwing a [StateError] if this is [Int64.min]
  /// (the only value whose negation overflows).
  Int64 negChecked() {
    if (value == -9223372036854775808) {
      throw StateError('Int64 negation overflow');
    }
    return Int64.from(-value);
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning a [BigInt] to prevent overflow.
  BigInt wideningMul(Int64 other) =>
      BigInt.from(value) * BigInt.from(other.value);
}
