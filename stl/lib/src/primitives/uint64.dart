part of 'primitives.dart';

/// A heap-allocated 64-bit unsigned integer backed by `dart:typed_data`.
///
/// Unlike the zero-cost [U64] variant, [Uint64] is strictly backed by an
/// [Uint64List], which natively bounds every write to the 64-bit unsigned range.
/// Signed Dart `int` values are reinterpreted as two's-complement unsigned values;
/// use [BigInt] arithmetic where full unsigned precision is required.
extension type Uint64._(Uint64List _data) {
  /// Instantiates a [Uint64] from an existing [Uint64List].
  Uint64(this._data);

  /// Instantiates a [Uint64] from an [int], reinterpreting the bits as unsigned.
  Uint64.from(int value) : _data = Uint64List(1)..[0] = value;

  /// The bit-width of this type.
  static const int bits = 64;

  /// The minimum value (0).
  static final Uint64 min = Uint64.from(0);

  /// The maximum value (2^64 - 1, stored as the bit-pattern -1).
  static final Uint64 max = Uint64.from(-1);

  /// The underlying raw [int] value (two's-complement bit pattern).
  int get value => _data[0];

  // Internal helper: flip sign bit for unsigned comparisons.
  static int _u(int v) => v ^ 0x8000000000000000;

  // -- Arithmetic operators ------------------------------------------------

  /// Adds [other], wrapping on overflow.
  Uint64 operator +(Uint64 other) => Uint64.from(value + other.value);

  /// Subtracts [other], wrapping on underflow.
  Uint64 operator -(Uint64 other) => Uint64.from(value - other.value);

  /// Multiplies by [other], wrapping on overflow.
  Uint64 operator *(Uint64 other) {
    final result =
        BigInt.from(value).toUnsigned(64) *
        BigInt.from(other.value).toUnsigned(64);
    return Uint64.from(result.toUnsigned(64).toSigned(64).toInt());
  }

  /// Integer-divides by [other] using unsigned semantics.
  Uint64 operator ~/(Uint64 other) {
    final q =
        BigInt.from(value).toUnsigned(64) ~/
        BigInt.from(other.value).toUnsigned(64);
    return Uint64.from(q.toSigned(64).toInt());
  }

  /// Modulo by [other] using unsigned semantics.
  Uint64 operator %(Uint64 other) {
    final r =
        BigInt.from(value).toUnsigned(64) %
        BigInt.from(other.value).toUnsigned(64);
    return Uint64.from(r.toSigned(64).toInt());
  }

  // -- Bitwise operators ---------------------------------------------------

  /// Performs bitwise AND.
  Uint64 operator &(Uint64 other) => Uint64.from(value & other.value);

  /// Performs bitwise OR.
  Uint64 operator |(Uint64 other) => Uint64.from(value | other.value);

  /// Performs bitwise XOR.
  Uint64 operator ^(Uint64 other) => Uint64.from(value ^ other.value);

  /// Performs bitwise NOT.
  Uint64 operator ~() => Uint64.from(~value);

  /// Left-shifts by [shiftAmount] bits, wrapping into range.
  Uint64 operator <<(int shiftAmount) => Uint64.from(value << shiftAmount);

  /// Right-shifts by [shiftAmount] bits.
  Uint64 operator >>(int shiftAmount) => Uint64.from(value >> shiftAmount);

  /// Unsigned right-shifts by [shiftAmount] bits.
  Uint64 operator >>>(int shiftAmount) => Uint64.from(value >>> shiftAmount);

  // -- Comparison operators ------------------------------------------------

  /// Returns `true` if this is less than [other] (unsigned comparison).
  bool operator <(Uint64 other) => _u(value) < _u(other.value);

  /// Returns `true` if this is less than or equal to [other] (unsigned comparison).
  bool operator <=(Uint64 other) => _u(value) <= _u(other.value);

  /// Returns `true` if this is greater than [other] (unsigned comparison).
  bool operator >(Uint64 other) => _u(value) > _u(other.value);

  /// Returns `true` if this is greater than or equal to [other] (unsigned comparison).
  bool operator >=(Uint64 other) => _u(value) >= _u(other.value);

  // -- Checked arithmetic --------------------------------------------------

  /// Adds [other], throwing a [StateError] on overflow.
  Uint64 addChecked(Uint64 other) {
    final res = value + other.value;
    if (_u(res) < _u(value)) throw StateError('Uint64 addition overflow');
    return Uint64.from(res);
  }

  /// Subtracts [other], throwing a [StateError] on underflow.
  Uint64 subChecked(Uint64 other) {
    if (_u(value) < _u(other.value)) {
      throw StateError('Uint64 subtraction overflow');
    }
    return Uint64.from(value - other.value);
  }

  /// Multiplies by [other], throwing a [StateError] on overflow.
  Uint64 mulChecked(Uint64 other) {
    final a = BigInt.from(value).toUnsigned(64);
    final b = BigInt.from(other.value).toUnsigned(64);
    final result = a * b;
    if (result.bitLength > 64) {
      throw StateError('Uint64 multiplication overflow');
    }
    return Uint64.from(result.toSigned(64).toInt());
  }

  /// Integer-divides by [other], throwing a [StateError] on division by zero.
  Uint64 divChecked(Uint64 other) {
    if (other.value == 0) throw StateError('Uint64 division by zero');
    return this ~/ other;
  }

  // -- Saturating arithmetic -----------------------------------------------

  /// Adds [other], clamping to [0, 2^64-1] instead of wrapping.
  Uint64 saturatingAdd(Uint64 other) {
    final res = value + other.value;
    return _u(res) < _u(value) ? max : Uint64.from(res);
  }

  /// Subtracts [other], clamping to [0, 2^64-1] instead of wrapping.
  Uint64 saturatingSub(Uint64 other) {
    return _u(value) < _u(other.value) ? min : Uint64.from(value - other.value);
  }

  /// Multiplies by [other], clamping to [0, 2^64-1] instead of wrapping.
  Uint64 saturatingMul(Uint64 other) {
    final a = BigInt.from(value).toUnsigned(64);
    final b = BigInt.from(other.value).toUnsigned(64);
    final result = a * b;
    if (result.bitLength > 64) return max;
    return Uint64.from(result.toSigned(64).toInt());
  }

  // -- Bit-manipulation intrinsics -----------------------------------------

  /// Returns the number of set bits (popcount / std::popcount).
  int countOneBits() {
    var v = value;
    var count = 0;
    for (var i = 0; i < 64; i++) {
      if ((v & 1) != 0) count++;
      v = v >>> 1;
    }
    return count;
  }

  /// Returns the number of leading zero bits (std::countl_zero).
  int countLeadingZeros() {
    if (value == 0) return 64;
    for (var i = 63; i >= 0; i--) {
      if ((value >>> i) & 1 != 0) return 63 - i;
    }
    return 64;
  }

  /// Returns the number of trailing zero bits (std::countr_zero).
  int countTrailingZeros() {
    if (value == 0) return 64;
    var n = 0;
    var v = value;
    while ((v & 1) == 0) {
      n++;
      v = v >>> 1;
    }
    return n;
  }

  /// Rotates the 64-bit representation left by [n] bits (std::rotl).
  Uint64 rotateLeft(int n) {
    n &= 63;
    if (n == 0) return this;
    return Uint64.from((value << n) | (value >>> (64 - n)));
  }

  /// Rotates the 64-bit representation right by [n] bits (std::rotr).
  Uint64 rotateRight(int n) => rotateLeft(64 - (n & 63));

  /// Reverses the byte order of the 64-bit value (std::byteswap).
  Uint64 byteSwap() {
    var v = value;
    var result = 0;
    for (var i = 0; i < 8; i++) {
      result = (result << 8) | (v & 0xFF);
      v = v >>> 8;
    }
    return Uint64.from(result);
  }

  // -- Formatting ----------------------------------------------------------

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

  // -- Cross-type conversions ----------------------------------------------

  /// Converts to [Int8], truncating to the low 8 bits.
  Int8 toInt8() => Int8.from(value & 0xFF);

  /// Converts to [Int16], truncating to the low 16 bits.
  Int16 toInt16() => Int16.from(value & 0xFFFF);

  /// Converts to [Int32], truncating to the low 32 bits.
  Int32 toInt32() => Int32.from(value & 0xFFFFFFFF);

  /// Converts to [Int64], reinterpreting the bit pattern as signed.
  Int64 toInt64() => Int64.from(value);

  /// Converts to [Uint8], truncating to the low 8 bits.
  Uint8 toUint8() => Uint8.from(value & 0xFF);

  /// Converts to [Uint16], truncating to the low 16 bits.
  Uint16 toUint16() => Uint16.from(value & 0xFFFF);

  /// Converts to [Uint32], truncating to the low 32 bits.
  Uint32 toUint32() => Uint32.from(value & 0xFFFFFFFF);

  /// Converts to [Uint64] (identity).
  Uint64 toUint64() => this;
}
