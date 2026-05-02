part of 'primitives.dart';

/// A heap-allocated 8-bit unsigned integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [U8] variant, [Uint8] is strictly backed by an
/// [Uint8List], which natively bounds every write to `[0, 255]` and
/// guarantees C++-style wrapping arithmetic on all platforms.
///
extension type Uint8._(Uint8List _data) {
  /// Instantiates a [Uint8] from an existing [Uint8List].
  Uint8(this._data);

  /// Instantiates a [Uint8] from an [int], wrapping into `[0, 255]`.
  Uint8.from(int value) : _data = Uint8List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 8;

  /// The minimum value of an 8-bit unsigned integer (0).
  static final Uint8 min = Uint8.from(0);

  /// The maximum value of an 8-bit unsigned integer (255).
  static final Uint8 max = Uint8.from(255);

  /// The underlying raw [int] value, strictly clamped to `[0, 255]`.
  int get value => _data[0];

  // ── Arithmetic operators ────────────────────────────────────────────────

  /// Adds [other], wrapping on overflow.
  Uint8 operator +(Uint8 other) => Uint8.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Uint8 operator -(Uint8 other) => Uint8.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Uint8 operator *(Uint8 other) => Uint8.from(value * other.value);

  /// Integer-divides by [other].
  Uint8 operator ~/(Uint8 other) => Uint8.from(value ~/ other.value);

  /// Modulo by [other].
  Uint8 operator %(Uint8 other) => Uint8.from(value % other.value);

  // ── Bitwise operators ───────────────────────────────────────────────────

  /// Performs bitwise AND.
  Uint8 operator &(Uint8 other) => Uint8.from(value & other.value);

  /// Performs bitwise OR.
  Uint8 operator |(Uint8 other) => Uint8.from(value | other.value);

  /// Performs bitwise XOR.
  Uint8 operator ^(Uint8 other) => Uint8.from(value ^ other.value);

  /// Performs bitwise NOT.
  Uint8 operator ~() => Uint8.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Uint8 operator <<(int shiftAmount) => Uint8.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits.
  Uint8 operator >>(int shiftAmount) => Uint8.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Uint8 operator >>>(int shiftAmount) => Uint8.from(value >>> shiftAmount);

  // ── Comparison operators ────────────────────────────────────────────────

  /// Returns `true` if this is less than [other].
  bool operator <(Uint8 other) => value < other.value;

  /// Returns `true` if this is less than or equal to [other].
  bool operator <=(Uint8 other) => value <= other.value;

  /// Returns `true` if this is greater than [other].
  bool operator >(Uint8 other) => value > other.value;

  /// Returns `true` if this is greater than or equal to [other].
  bool operator >=(Uint8 other) => value >= other.value;

  // ── Checked arithmetic ──────────────────────────────────────────────────

  /// Adds [other], throwing a [StateError] on overflow.
  Uint8 addChecked(Uint8 other) {
    final result = value + other.value;
    if (result > 255) throw StateError('Uint8 addition overflow');
    return Uint8.from(result);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  Uint8 subChecked(Uint8 other) {
    if (other.value > value) throw StateError('Uint8 subtraction overflow');
    return Uint8.from(value - other.value);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  Uint8 mulChecked(Uint8 other) {
    final result = value * other.value;
    if (result > 255) throw StateError('Uint8 multiplication overflow');
    return Uint8.from(result);
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  Uint8 divChecked(Uint8 other) {
    if (other.value == 0) throw StateError('Uint8 division by zero');
    return Uint8.from(value ~/ other.value);
  }

  // ── Saturating arithmetic ───────────────────────────────────────────────

  /// Adds [other], clamping to `[0, 255]` instead of wrapping.
  Uint8 saturatingAdd(Uint8 other) {
    final result = value + other.value;
    return result > 255 ? max : Uint8.from(result);
  }

  /// Subtracts [other], clamping to `[0, 255]` instead of wrapping.
  Uint8 saturatingSub(Uint8 other) {
    final result = value - other.value;
    return result < 0 ? min : Uint8.from(result);
  }

  /// Multiplies by [other], clamping to `[0, 255]` instead of wrapping.
  Uint8 saturatingMul(Uint8 other) {
    final result = value * other.value;
    return result > 255 ? max : Uint8.from(result);
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
  Uint8 rotateLeft(int n) {
    n &= 7;
    return Uint8.from(((value << n) | (value >> (8 - n))) & 0xFF);
  }

  /// Rotates the 8-bit representation right by [n] bits (`std::rotr`).
  Uint8 rotateRight(int n) => rotateLeft(8 - (n & 7));

  /// Reverses the byte order (no-op for a single-byte type; included for API uniformity).
  Uint8 byteSwap() => Uint8.from(value);

  // ── Formatting ─────────────────────────────────────────────────────────

  /// Returns the value as a zero-padded 8-bit binary string (e.g. `Uint8.from(10)` → `"00001010"`).
  String toBinaryString() => value.toRadixString(2).padLeft(8, '0');

  /// Returns the value as a zero-padded 2-digit uppercase hex string (e.g. `Uint8.from(10)` → `"0A"`).
  String toHexString() => value.toRadixString(16).toUpperCase().padLeft(2, '0');

  // ── Cross-type conversions ──────────────────────────────────────────────

  /// Converts to [Int8], reinterpreting the bit pattern as signed.
  Int8 toInt8() => Int8.from(value);

  /// Converts to [Int16], zero-extending.
  Int16 toInt16() => Int16.from(value);

  /// Converts to [Int32], zero-extending.
  Int32 toInt32() => Int32.from(value);

  /// Converts to [Int64], zero-extending.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8] (identity).
  Uint8 toUint8() => this;

  /// Converts to [Uint16], zero-extending.
  Uint16 toUint16() => Uint16.from(value);

  /// Converts to [Uint32], zero-extending.
  Uint32 toUint32() => Uint32.from(value);

  /// Converts to [Uint64], zero-extending.
  Uint64 toUint64() => Uint64.from(value);

  // ── BigInt interop ──────────────────────────────────────────────────────

  /// Converts this value to a [BigInt].
  BigInt toBigInt() => BigInt.from(value);

  /// Constructs a [Uint8] from a [BigInt], throwing a [RangeError] if [v] is
  /// outside `[0, 255]`.
  static Uint8 fromBigInt(BigInt v) {
    if (v.isNegative || v > BigInt.from(255)) {
      throw RangeError('$v is out of range for Uint8. Must be in [0, 255].');
    }
    return Uint8.from(v.toInt());
  }

  // ── Widening arithmetic ─────────────────────────────────────────────────

  /// Multiplies this by [other], returning a [Uint16] to prevent overflow.
  Uint16 wideningMul(Uint8 other) => Uint16.from(value * other.value);
}
