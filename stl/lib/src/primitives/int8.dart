part of 'primitives.dart';

/// A heap-allocated 8-bit signed integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [I8] variant, [Int8] is strictly backed by an
/// [Int8List], which natively bounds every write to `[-128, 127]` and
/// guarantees C++-style wrapping arithmetic on all platforms.
extension type Int8._(Int8List _data) {
  /// Instantiates an [Int8] from an existing [Int8List].
  Int8(this._data);

  /// Instantiates an [Int8] from an [int], wrapping into `[-128, 127]`.
  Int8.from(int value) : _data = Int8List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 8;

  /// The minimum value of an 8-bit signed integer (-128).
  static final Int8 min = Int8.from(-128);

  /// The maximum value of an 8-bit signed integer (127).
  static final Int8 max = Int8.from(127);

  /// The underlying raw [int] value, strictly clamped to `[-128, 127]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Int8 operator +(Int8 other) => Int8.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Int8 operator -(Int8 other) => Int8.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Int8 operator *(Int8 other) => Int8.from(value * other.value);

  /// Integer-divides by [other].
  Int8 operator ~/(Int8 other) => Int8.from(value ~/ other.value);

  /// Modulo by [other].
  Int8 operator %(Int8 other) => Int8.from(value % other.value);

  /// Returns the negated value, wrapping on overflow.
  Int8 operator -() => Int8.from(-value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Int8 operator &(Int8 other) => Int8.from(value & other.value);

  /// Performs bitwise OR.
  Int8 operator |(Int8 other) => Int8.from(value | other.value);

  /// Performs bitwise XOR.
  Int8 operator ^(Int8 other) => Int8.from(value ^ other.value);

  /// Performs bitwise NOT.
  Int8 operator ~() => Int8.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Int8 operator <<(int shiftAmount) => Int8.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits, preserving the sign.
  Int8 operator >>(int shiftAmount) => Int8.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Int8 operator >>>(int shiftAmount) => Int8.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Int8 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Int8 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Int8 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Int8 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow or underflow.
  Int8 addChecked(Int8 other) {
    final result = value + other.value;
    if (result > 127 || result < -128) {
      throw StateError('Int8 addition overflow');
    }
    return Int8.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on overflow or underflow.
  Int8 subChecked(Int8 other) {
    final result = value - other.value;
    if (result > 127 || result < -128) {
      throw StateError('Int8 subtraction overflow');
    }
    return Int8.from(result);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow or underflow.
  Int8 mulChecked(Int8 other) {
    final result = value * other.value;
    if (result > 127 || result < -128) {
      throw StateError('Int8 multiplication overflow');
    }
    return Int8.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero
  /// or the signed-overflow edge case (`Int8(-128) ~/ Int8(-1)`).
  Int8 divChecked(Int8 other) {
    if (other.value == 0) throw StateError('Int8 division by zero');
    if (value == -128 && other.value == -1) {
      throw StateError('Int8 division overflow');
    }
    return Int8.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[-128, 127]` instead of wrapping.
  Int8 saturatingAdd(Int8 other) {
    final result = value + other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return Int8.from(result);
  }

  /// Subtracts [other], clamping to `[-128, 127]` instead of wrapping.
  Int8 saturatingSub(Int8 other) {
    final result = value - other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return Int8.from(result);
  }

  /// Multiplies by [other], clamping to `[-128, 127]` instead of wrapping.
  Int8 saturatingMul(Int8 other) {
    final result = value * other.value;
    if (result > 127) return max;
    if (result < -128) return min;
    return Int8.from(result);
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
  Int8 rotateLeft(int n) {
    n &= 7;
    final v = value & 0xFF;
    return Int8.from(((v << n) | (v >> (8 - n))) & 0xFF);
  }

  /// Rotates the 8-bit representation right by [n] bits (`std::rotr`).
  Int8 rotateRight(int n) => rotateLeft(8 - (n & 7));

  /// Reverses the byte order (no-op for a single-byte type; included for API uniformity).
  Int8 byteSwap() => Int8.from(value);

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 8-bit binary string (e.g. `Int8.from(10)` → `"00001010"`).
  String toBinaryString() => (value & 0xFF).toRadixString(2).padLeft(8, '0');

  /// Returns the value as a zero-padded 2-digit uppercase hex string (e.g. `Int8.from(10)` → `"0A"`).
  String toHexString() =>
      (value & 0xFF).toRadixString(16).toUpperCase().padLeft(2, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8] (identity).
  Int8 toInt8() => this;

  /// Converts to [Int16], sign-extending.
  Int16 toInt16() => Int16.from(value);

  /// Converts to [Int32], sign-extending.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64], sign-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], reinterpreting the bit pattern as unsigned.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], reinterpreting as unsigned.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32], reinterpreting as unsigned.
  Uint32 toUint32() => Uint32.from(value & 0xFFFFFFFF);

  /// Converts to [Uint64], reinterpreting as unsigned.
  Uint64 toUint64() => Uint64.from(value);
}
