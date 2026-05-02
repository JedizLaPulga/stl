part of 'primitives.dart';

/// A heap-allocated 16-bit signed integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [I16] variant, [Int16] is strictly backed by an
/// [Int16List], which natively bounds every write to `[-32768, 32767]` and
/// guarantees C++-style wrapping arithmetic on all platforms.
extension type Int16._(Int16List _data) {
  /// Instantiates an [Int16] from an existing [Int16List].
  Int16(this._data);

  /// Instantiates an [Int16] from an [int], wrapping into `[-32768, 32767]`.
  Int16.from(int value) : _data = Int16List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 16;

  /// The minimum value of a 16-bit signed integer (-32768).
  static final Int16 min = Int16.from(-32768);

  /// The maximum value of a 16-bit signed integer (32767).
  static final Int16 max = Int16.from(32767);

  /// The underlying raw [int] value, strictly clamped to `[-32768, 32767]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Int16 operator +(Int16 other) => Int16.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Int16 operator -(Int16 other) => Int16.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Int16 operator *(Int16 other) => Int16.from(value * other.value);

  /// Integer-divides by [other].
  Int16 operator ~/(Int16 other) => Int16.from(value ~/ other.value);

  /// Modulo by [other].
  Int16 operator %(Int16 other) => Int16.from(value % other.value);

  /// Returns the negated value, wrapping on overflow.
  Int16 operator -() => Int16.from(-value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Int16 operator &(Int16 other) => Int16.from(value & other.value);

  /// Performs bitwise OR.
  Int16 operator |(Int16 other) => Int16.from(value | other.value);

  /// Performs bitwise XOR.
  Int16 operator ^(Int16 other) => Int16.from(value ^ other.value);

  /// Performs bitwise NOT.
  Int16 operator ~() => Int16.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Int16 operator <<(int shiftAmount) => Int16.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  Int16 operator >>(int shiftAmount) => Int16.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Int16 operator >>>(int shiftAmount) => Int16.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Int16 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Int16 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Int16 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Int16 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  Int16 addChecked(Int16 other) {
    final result = value + other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('Int16 addition overflow');
    }
    return Int16.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  Int16 subChecked(Int16 other) {
    final result = value - other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('Int16 subtraction overflow');
    }
    return Int16.from(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  Int16 mulChecked(Int16 other) {
    final result = value * other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('Int16 multiplication overflow');
    }
    return Int16.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`Int16(-32768) ~/ Int16(-1)`).
  Int16 divChecked(Int16 other) {
    if (other.value == 0) throw StateError('Int16 division by zero');
    if (value == -32768 && other.value == -1) {
      throw StateError('Int16 division overflow');
    }
    return Int16.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[-32768, 32767]` instead of wrapping.
  Int16 saturatingAdd(Int16 other) {
    final result = value + other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return Int16.from(result);
  }

  /// Subtracts [other], clamping to `[-32768, 32767]` instead of wrapping.
  Int16 saturatingSub(Int16 other) {
    final result = value - other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return Int16.from(result);
  }

  /// Multiplies by [other], clamping to `[-32768, 32767]` instead of wrapping.
  Int16 saturatingMul(Int16 other) {
    final result = value * other.value;
    if (result > 32767) return max;
    if (result < -32768) return min;
    return Int16.from(result);
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
  Int16 rotateLeft(int n) {
    n &= 15;
    final v = value & 0xFFFF;
    return Int16.from(((v << n) | (v >> (16 - n))) & 0xFFFF);
  }

  /// Rotates the 16-bit representation right by [n] bits (`std::rotr`).
  Int16 rotateRight(int n) => rotateLeft(16 - (n & 15));

  /// Reverses the byte order of the 16-bit value (`std::byteswap`).
  Int16 byteSwap() {
    final v = value & 0xFFFF;
    return Int16.from(((v & 0xFF) << 8) | ((v >> 8) & 0xFF));
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 16-bit binary string.
  String toBinaryString() => (value & 0xFFFF).toRadixString(2).padLeft(16, '0');

  /// Returns the value as a zero-padded 4-digit uppercase hex string.
  String toHexString() =>
      (value & 0xFFFF).toRadixString(16).toUpperCase().padLeft(4, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value);

  /// Converts to [Int16] (identity).
  Int16 toInt16() => this;

  /// Converts to [Int32], sign-extending.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64], sign-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], reinterpreting the low 8 bits as unsigned.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], reinterpreting the bit pattern as unsigned.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32], reinterpreting as unsigned.
  Uint32 toUint32() => Uint32.from(value & 0xFFFFFFFF);

  /// Converts to [Uint64], reinterpreting as unsigned.
  Uint64 toUint64() => Uint64.from(value);

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs an [Int16] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside `[-32768, 32767]`.
  static Int16 fromBigInt(BigInt v) {
    if (v < BigInt.from(-32768) || v > BigInt.from(32767)) {
      throw RangeError(
        '$v is out of range for Int16. Must be in [-32768, 32767].',
      );
    }
    return Int16.from(v.toInt());
  }

  // ── Checked negation ────────────────────────────────────────────────────

  /// Returns the negated value, throwing a [StateError] if this is [Int16.min]
  /// (the only value whose negation overflows).
  Int16 negChecked() {
    if (value == -32768) throw StateError('Int16 negation overflow');
    return Int16.from(-value);
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning an [Int32] to prevent overflow.
  Int32 wideningMul(Int16 other) => Int32.from(value * other.value);
}
