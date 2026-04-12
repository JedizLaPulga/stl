/// A 64-bit unsigned integer primitive.
extension type const u64(int value) implements int {
  static const u64 min = u64(0);
  /// The maximum 64-bit unsigned integer (represents 18446744073709551615).
  static const u64 max = u64(-1);

  u64 operator +(u64 other) => u64((value + other.value).toUnsigned(64));
  u64 operator -(u64 other) => u64((value - other.value).toUnsigned(64));
  u64 operator *(u64 other) => u64((value * other.value).toUnsigned(64));
  
  // Custom division utilizing BigInt for complete 64-bit unsigned mathematical safety.
  // Native `int` division would treat upper boundaries as signed negative integers.
  u64 operator ~/(u64 other) {
    if (other.value == 0) throw UnsupportedError('Division by zero');
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return u64((bi1 ~/ bi2).toInt().toUnsigned(64));
  }

  u64 operator %(u64 other) {
    if (other.value == 0) throw UnsupportedError('Modulo by zero');
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    return u64((bi1 % bi2).toInt().toUnsigned(64));
  }

  u64 operator &(u64 other) => u64((value & other.value).toUnsigned(64));
  u64 operator |(u64 other) => u64((value | other.value).toUnsigned(64));
  u64 operator ^(u64 other) => u64((value ^ other.value).toUnsigned(64));
  u64 operator ~() => u64((~value).toUnsigned(64));
  u64 operator <<(int shiftAmount) => u64((value << shiftAmount).toUnsigned(64));
  u64 operator >>(int shiftAmount) => u64((value >>> shiftAmount).toUnsigned(64));
  u64 operator >>>(int shiftAmount) => u64((value >>> shiftAmount).toUnsigned(64));

  // Custom bitwise wrap comparison for unsigned 64-bit safety
  bool operator <(u64 other) => (value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000);
  bool operator <=(u64 other) => (value ^ 0x8000000000000000) <= (other.value ^ 0x8000000000000000);
  bool operator >(u64 other) => (value ^ 0x8000000000000000) > (other.value ^ 0x8000000000000000);
  bool operator >=(u64 other) => (value ^ 0x8000000000000000) >= (other.value ^ 0x8000000000000000);

  u64 addChecked(u64 other) {
    var result = (value + other.value).toUnsigned(64);
    if (result < value || result < other.value) {
      throw StateError('u64 addition overflow');
    }
    return u64(result);
  }

  u64 subChecked(u64 other) {
    var result = (value - other.value).toUnsigned(64);
    if (this < other) {
      throw StateError('u64 subtraction underflow');
    }
    return u64(result);
  }

  u64 mulChecked(u64 other) {
    if (value == 0 || other.value == 0) return u64(0);
    // BigInt needed to strictly verify multiplication fits cleanly without wrapping bits incorrectly.
    final bi1 = BigInt.from(value).toUnsigned(64);
    final bi2 = BigInt.from(other.value).toUnsigned(64);
    final res = bi1 * bi2;
    if (res.bitLength > 64) {
      throw StateError('u64 multiplication overflow');
    }
    return u64((value * other.value).toUnsigned(64));
  }
}
