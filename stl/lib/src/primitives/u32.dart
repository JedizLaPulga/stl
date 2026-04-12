/// A 32-bit unsigned integer primitive.
extension type const u32(int value) implements int {
  static const u32 min = u32(0);
  static const u32 max = u32(4294967295);

  u32 operator +(u32 other) => u32((value + other.value).toUnsigned(32));
  u32 operator -(u32 other) => u32((value - other.value).toUnsigned(32));
  u32 operator *(u32 other) => u32((value * other.value).toUnsigned(32));
  u32 operator ~/(u32 other) => u32((value ~/ other.value).toUnsigned(32));
  u32 operator %(u32 other) => u32((value % other.value).toUnsigned(32));
  u32 operator &(u32 other) => u32((value & other.value).toUnsigned(32));
  u32 operator |(u32 other) => u32((value | other.value).toUnsigned(32));
  u32 operator ^(u32 other) => u32((value ^ other.value).toUnsigned(32));
  u32 operator ~() => u32((~value).toUnsigned(32));
  u32 operator <<(int shiftAmount) => u32((value << shiftAmount).toUnsigned(32));
  u32 operator >>(int shiftAmount) => u32((value >> shiftAmount).toUnsigned(32));
  u32 operator >>>(int shiftAmount) => u32((value >>> shiftAmount).toUnsigned(32));

  u32 addChecked(u32 other) {
    var result = value + other.value;
    if (result > 4294967295) throw StateError('u32 addition overflow');
    return u32(result);
  }
  u32 subChecked(u32 other) {
    var result = value - other.value;
    if (result < 0) throw StateError('u32 subtraction underflow');
    return u32(result);
  }
  u32 mulChecked(u32 other) {
    var result = value * other.value;
    if (result > 4294967295) throw StateError('u32 multiplication overflow');
    return u32(result);
  }
}
