part of 'primitives.dart';

/// A heap-allocated 32-bit unsigned integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [U32] variant, [Uint32] is strictly backed by an
/// [Uint32List], which natively bounds every write to `[0, 4294967295]` and
/// guarantees C++-style wrapping arithmetic on all platforms.
extension type Uint32._(Uint32List _data) {
  /// Instantiates a [Uint32] from an existing [Uint32List].
  Uint32(this._data);

  /// Instantiates a [Uint32] from an [int], wrapping into `[0, 4294967295]`.
  Uint32.from(int value) : _data = Uint32List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 32;

  /// The minimum value of a 32-bit unsigned integer (0).
  static final Uint32 min = Uint32.from(0);

  /// The maximum value of a 32-bit unsigned integer (4294967295).
  static final Uint32 max = Uint32.from(4294967295);

  /// The underlying raw [int] value, strictly clamped to `[0, 4294967295]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Uint32 operator +(Uint32 other) => Uint32.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Uint32 operator -(Uint32 other) => Uint32.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Uint32 operator *(Uint32 other) => Uint32.from(value * other.value);

  /// Integer-divides by [other].
  Uint32 operator ~/(Uint32 other) => Uint32.from(value ~/ other.value);

  /// Modulo by [other].
  Uint32 operator %(Uint32 other) => Uint32.from(value % other.value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Uint32 operator &(Uint32 other) => Uint32.from(value & other.value);

  /// Performs bitwise OR.
  Uint32 operator |(Uint32 other) => Uint32.from(value | other.value);

  /// Performs bitwise XOR.
  Uint32 operator ^(Uint32 other) => Uint32.from(value ^ other.value);

  /// Performs bitwise NOT.
  Uint32 operator ~() => Uint32.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Uint32 operator <<(int shiftAmount) => Uint32.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits.
  Uint32 operator >>(int shiftAmount) => Uint32.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Uint32 operator >>>(int shiftAmount) => Uint32.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Uint32 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Uint32 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Uint32 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Uint32 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  Uint32 addChecked(Uint32 other) {
    final result = value + other.value;
    if (result > 4294967295) throw StateError('Uint32 addition overflow');
    return Uint32.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  Uint32 subChecked(Uint32 other) {
    if (other.value > value) throw StateError('Uint32 subtraction overflow');
    return Uint32.from(value - other.value);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  Uint32 mulChecked(Uint32 other) {
    final result = value * other.value;
    if (result > 4294967295) throw StateError('Uint32 multiplication overflow');
    return Uint32.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  Uint32 divChecked(Uint32 other) {
    if (other.value == 0) throw StateError('Uint32 division by zero');
    return Uint32.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 4294967295]` instead of wrapping.
  Uint32 saturatingAdd(Uint32 other) {
    final result = value + other.value;
    return result > 4294967295 ? max : Uint32.from(result);
  }

  /// Subtracts [other], clamping to `[0, 4294967295]` instead of wrapping.
  Uint32 saturatingSub(Uint32 other) {
    final result = value - other.value;
    return result < 0 ? min : Uint32.from(result);
  }

  /// Multiplies by [other], clamping to `[0, 4294967295]` instead of wrapping.
  Uint32 saturatingMul(Uint32 other) {
    final result = value * other.value;
    return result > 4294967295 ? max : Uint32.from(result);
  }

  // ── Bit-manipulation intrinsics (C++20/23) ──────────────────────────────

  /// Returns the number of set bits (popcount / `std::popcount`).
  int countOneBits() => value.toRadixString(2).replaceAll('0', '').length;

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
  Uint32 rotateLeft(int n) {
    n &= 31;
    return Uint32.from(((value << n) | (value >> (32 - n))) & 0xFFFFFFFF);
  }

  /// Rotates the 32-bit representation right by [n] bits (`std::rotr`).
  Uint32 rotateRight(int n) => rotateLeft(32 - (n & 31));

  /// Reverses the byte order of the 32-bit value (`std::byteswap`).
  Uint32 byteSwap() {
    return Uint32.from(
      ((value & 0xFF) << 24) |
          (((value >> 8) & 0xFF) << 16) |
          (((value >> 16) & 0xFF) << 8) |
          ((value >> 24) & 0xFF),
    );
  }

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 32-bit binary string.
  String toBinaryString() => value.toRadixString(2).padLeft(32, '0');

  /// Returns the value as a zero-padded 8-digit uppercase hex string.
  String toHexString() => value.toRadixString(16).toUpperCase().padLeft(8, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value & 0xFF);

  /// Converts to [Int16], truncating to the low 16 bits.
  Int16 toInt16() => Int16.from(value & 0xFFFF);

  /// Converts to [Int32], reinterpreting the bit pattern as signed.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64], zero-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], truncating to the low 8 bits.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], truncating to the low 16 bits.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32] (identity).
  Uint32 toUint32() => this;

  /// Converts to [Uint64], zero-extending.
  Uint64 toUint64() => Uint64.from(value);
}
