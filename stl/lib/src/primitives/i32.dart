/// A 32-bit signed integer primitive.
extension type const i32(int value) implements int {
  static const i32 min = i32(-2147483648);
  static const i32 max = i32(2147483647);

  i32 operator +(i32 other) => i32((value + other.value).toSigned(32));
  i32 operator -(i32 other) => i32((value - other.value).toSigned(32));
  i32 operator *(i32 other) => i32((value * other.value).toSigned(32));
  i32 operator ~/(i32 other) => i32((value ~/ other.value).toSigned(32));
  i32 operator %(i32 other) => i32((value % other.value).toSigned(32));
  i32 operator &(i32 other) => i32((value & other.value).toSigned(32));
  i32 operator |(i32 other) => i32((value | other.value).toSigned(32));
  i32 operator ^(i32 other) => i32((value ^ other.value).toSigned(32));
  i32 operator ~() => i32((~value).toSigned(32));
  i32 operator <<(int shiftAmount) => i32((value << shiftAmount).toSigned(32));
  i32 operator >>(int shiftAmount) => i32((value >> shiftAmount).toSigned(32));
  i32 operator >>>(int shiftAmount) => i32((value >>> shiftAmount).toSigned(32));
  i32 operator -() => i32((-value).toSigned(32));

  i32 addChecked(i32 other) {
    var result = value + other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('i32 addition overflow');
    return i32(result);
  }
  i32 subChecked(i32 other) {
    var result = value - other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('i32 subtraction overflow');
    return i32(result);
  }
  i32 mulChecked(i32 other) {
    var result = value * other.value;
    if (result > 2147483647 || result < -2147483648) throw StateError('i32 multiplication overflow');
    return i32(result);
  }
}
