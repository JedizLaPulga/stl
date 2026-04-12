/// A 64-bit unsigned integer primitive.
extension type const U64(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  static const U64 min = U64(0);

  /// The maximum 64-bit unsigned integer (represents 18446744073709551615).
  static const U64 max = U64(-1);

  U64 operator +(U64 other) => U64((value + other.value).toUnsigned(64));
  U64 operator -(U64 other) => U64((value - other.value).toUnsigned(64));
  U64 operator *(U64 other) => U64((value * other.value).toUnsigned(64));

  // Custom division utilizing BigInt for complete 64-bit unsigned mathematical safety.
  // Native `int` division would treat upper boundaries as signed negative integers.
  U64 operator ~/(U64 other) {
    if (other.value == 0) {
      throw UnsupportedError('Division by zero');
    }
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return U64((bi1 ~/ bi2).toInt().toUnsigned(64));
  }

  U64 operator %(U64 other) {
    if (other.value == 0) {
      throw UnsupportedError('Modulo by zero');
    }
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return U64((bi1 % bi2).toInt().toUnsigned(64));
  }

  U64 operator &(U64 other) => U64((value & other.value).toUnsigned(64));
  U64 operator |(U64 other) => U64((value | other.value).toUnsigned(64));
  U64 operator ^(U64 other) => U64((value ^ other.value).toUnsigned(64));
  U64 operator ~() => U64((~value).toUnsigned(64));
  U64 operator <<(int shiftAmount) =>
      U64((value << shiftAmount).toUnsigned(64));
  U64 operator >>(int shiftAmount) =>
      U64((value >>> shiftAmount).toUnsigned(64));
  U64 operator >>>(int shiftAmount) =>
      U64((value >>> shiftAmount).toUnsigned(64));

  // Custom bitwise wrap comparison for unsigned 64-bit safety
  bool operator <(U64 other) =>
      (value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000);
  bool operator <=(U64 other) =>
      (value ^ 0x8000000000000000) <= (other.value ^ 0x8000000000000000);
  bool operator >(U64 other) =>
      (value ^ 0x8000000000000000) > (other.value ^ 0x8000000000000000);
  bool operator >=(U64 other) =>
      (value ^ 0x8000000000000000) >= (other.value ^ 0x8000000000000000);

  U64 addChecked(U64 other) {
    var result = (value + other.value).toUnsigned(64);
    if (result < value || result < other.value) {
      throw StateError('U64 addition overflow');
    }
    return U64(result);
  }

  U64 subChecked(U64 other) {
    var result = (value - other.value).toUnsigned(64);
    if (this < other) {
      throw StateError('U64 subtraction underflow');
    }
    return U64(result);
  }

  U64 mulChecked(U64 other) {
    if (value == 0 || other.value == 0) return U64(0);
    // BigInt needed to strictly verify multiplication fits cleanly without wrapping bits incorrectly.
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    final res = bi1 * bi2;
    if (res.bitLength > 64) {
      throw StateError('U64 multiplication overflow');
    }
    return U64((value * other.value).toUnsigned(64));
  }
}
