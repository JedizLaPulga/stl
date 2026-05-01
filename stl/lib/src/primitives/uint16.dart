part of 'primitives.dart';

/// A heap-allocated 16-bit unsigned integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [U16] variant, [Uint16] is strictly backed by an
/// [Uint16List], which natively bounds every write to `[0, 65535]` and
/// guarantees C++-style wrapping arithmetic on all platforms.
extension type Uint16._(Uint16List _data) {
  /// Instantiates a [Uint16] from an existing [Uint16List].
  Uint16(this._data);

  /// Instantiates a [Uint16] from an [int], wrapping into `[0, 65535]`.
  Uint16.from(int value) : _data = Uint16List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 16;

  /// The minimum value of a 16-bit unsigned integer (0).
  static final Uint16 min = Uint16.from(0);

  /// The maximum value of a 16-bit unsigned integer (65535).
  static final Uint16 max = Uint16.from(65535);

  /// The underlying raw [int] value, strictly clamped to `[0, 65535]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Uint16 operator +(Uint16 other) => Uint16.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Uint16 operator -(Uint16 other) => Uint16.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Uint16 operator *(Uint16 other) => Uint16.from(value * other.value);

  /// Integer-divides by [other].
  Uint16 operator ~/(Uint16 other) => Uint16.from(value ~/ other.value);

  /// Modulo by [other].
  Uint16 operator %(Uint16 other) => Uint16.from(value % other.value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Uint16 operator &(Uint16 other) => Uint16.from(value & other.value);

  /// Performs bitwise OR.
  Uint16 operator |(Uint16 other) => Uint16.from(value | other.value);

  /// Performs bitwise XOR.
  Uint16 operator ^(Uint16 other) => Uint16.from(value ^ other.value);

  /// Performs bitwise NOT.
  Uint16 operator ~() => Uint16.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Uint16 operator <<(int shiftAmount) => Uint16.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits.
  Uint16 operator >>(int shiftAmount) => Uint16.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Uint16 operator >>>(int shiftAmount) => Uint16.from(value >>> shiftAmount);

  // ── Comparison operators ───────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Uint16 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Uint16 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Uint16 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Uint16 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  Uint16 addChecked(Uint16 other) {
    final result = value + other.value;
    if (result > 65535) throw StateError('Uint16 addition overflow');
    return Uint16.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  Uint16 subChecked(Uint16 other) {
    if (other.value > value) throw StateError('Uint16 subtraction overflow');
    return Uint16.from(value - other.value);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  Uint16 mulChecked(Uint16 other) {
    final result = value * other.value;
    if (result > 65535) throw StateError('Uint16 multiplication overflow');
    return Uint16.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  Uint16 divChecked(Uint16 other) {
    if (other.value == 0) throw StateError('Uint16 division by zero');
    return Uint16.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 65535]` instead of wrapping.
  Uint16 saturatingAdd(Uint16 other) {
    final result = value + other.value;
    return result > 65535 ? max : Uint16.from(result);
  }

  /// Subtracts [other], clamping to `[0, 65535]` instead of wrapping.
  Uint16 saturatingSub(Uint16 other) {
    final result = value - other.value;
    return result < 0 ? min : Uint16.from(result);
  }

  /// Multiplies by [other], clamping to `[0, 65535]` instead of wrapping.
  Uint16 saturatingMul(Uint16 other) {
    final result = value * other.value;
    return result > 65535 ? max : Uint16.from(result);
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
  Uint16 rotateLeft(int n) {
    n &= 15;
    return Uint16.from(((value << n) | (value >> (16 - n))) & 0xFFFF);
  }

  /// Rotates the 16-bit representation right by [n] bits (`std::rotr`).
  Uint16 rotateRight(int n) => rotateLeft(16 - (n & 15));

  /// Reverses the byte order of the 16-bit value (`std::byteswap`).
  Uint16 byteSwap() =>
      Uint16.from(((value & 0xFF) << 8) | ((value >> 8) & 0xFF));

  // ── Formatting ──────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 16-bit binary string.
  String toBinaryString() => value.toRadixString(2).padLeft(16, '0');

  /// Returns the value as a zero-padded 4-digit uppercase hex string.
  String toHexString() => value.toRadixString(16).toUpperCase().padLeft(4, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value);

  /// Converts to [Int16], reinterpreting the bit pattern as signed.
  Int16 toInt16() => Int16.from(value);

  /// Converts to [Int32], zero-extending.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64], zero-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], truncating to the low 8 bits.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16] (identity).
  Uint16 toUint16() => this;

  /// Converts to [Uint32], zero-extending.
  Uint32 toUint32() => Uint32.from(value);

  /// Converts to [Uint64], zero-extending.
  Uint64 toUint64() => Uint64.from(value);
}
