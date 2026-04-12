/// An 8-bit unsigned integer primitive.
extension type const u8(int value) implements int {
  static const u8 min = u8(0);
  static const u8 max = u8(255);

  u8 operator +(u8 other) => u8((value + other.value).toUnsigned(8));
  u8 operator -(u8 other) => u8((value - other.value).toUnsigned(8));
  u8 operator *(u8 other) => u8((value * other.value).toUnsigned(8));
  u8 operator ~/(u8 other) => u8((value ~/ other.value).toUnsigned(8));
  u8 operator %(u8 other) => u8((value % other.value).toUnsigned(8));
  u8 operator &(u8 other) => u8((value & other.value).toUnsigned(8));
  u8 operator |(u8 other) => u8((value | other.value).toUnsigned(8));
  u8 operator ^(u8 other) => u8((value ^ other.value).toUnsigned(8));
  u8 operator ~() => u8((~value).toUnsigned(8));
  u8 operator <<(int shiftAmount) => u8((value << shiftAmount).toUnsigned(8));
  u8 operator >>(int shiftAmount) => u8((value >> shiftAmount).toUnsigned(8));
  u8 operator >>>(int shiftAmount) => u8((value >>> shiftAmount).toUnsigned(8));

  u8 addChecked(u8 other) {
    var result = value + other.value;
    if (result > 255) throw StateError('u8 addition overflow');
    return u8(result);
  }
  u8 subChecked(u8 other) {
    var result = value - other.value;
    if (result < 0) throw StateError('u8 subtraction underflow');
    return u8(result);
  }
  u8 mulChecked(u8 other) {
    var result = value * other.value;
    if (result > 255) throw StateError('u8 multiplication overflow');
    return u8(result);
  }
}
