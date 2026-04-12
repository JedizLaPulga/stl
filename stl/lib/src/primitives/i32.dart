/// A 32-bit signed integer primitive.
extension type const I32(int value) implements int {
  static const I32 min = I32(-2147483648);
  static const I32 max = I32(2147483647);

  I32 operator +(I32 other) => I32((value + other.value).toSigned(32));
  I32 operator -(I32 other) => I32((value - other.value).toSigned(32));
  I32 operator *(I32 other) => I32((value * other.value).toSigned(32));
  I32 operator ~/(I32 other) => I32((value ~/ other.value).toSigned(32));
  I32 operator %(I32 other) => I32((value % other.value).toSigned(32));
  I32 operator &(I32 other) => I32((value & other.value).toSigned(32));
  I32 operator |(I32 other) => I32((value | other.value).toSigned(32));
  I32 operator ^(I32 other) => I32((value ^ other.value).toSigned(32));
  I32 operator ~() => I32((~value).toSigned(32));
  I32 operator <<(int shiftAmount) => I32((value << shiftAmount).toSigned(32));
  I32 operator >>(int shiftAmount) => I32((value >> shiftAmount).toSigned(32));
  I32 operator >>>(int shiftAmount) => I32((value >>> shiftAmount).toSigned(32));
  I32 operator -() => I32((-value).toSigned(32));

  I32 addChecked(I32 other) {
    var result = value + other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('I32 addition overflow');
    return I32(result);
  }
  I32 subChecked(I32 other) {
    var result = value - other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('I32 subtraction overflow');
    return I32(result);
  }
  I32 mulChecked(I32 other) {
    var result = value * other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('I32 multiplication overflow');
    return I32(result);
  }
}
