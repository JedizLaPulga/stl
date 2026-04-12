/// A 16-bit unsigned integer primitive.
extension type const u16(int value) implements int {
  static const u16 min = u16(0);
  static const u16 max = u16(65535);

  u16 operator +(u16 other) => u16((value + other.value).toUnsigned(16));
  u16 operator -(u16 other) => u16((value - other.value).toUnsigned(16));
  u16 operator *(u16 other) => u16((value * other.value).toUnsigned(16));
  u16 operator ~/(u16 other) => u16((value ~/ other.value).toUnsigned(16));
  u16 operator %(u16 other) => u16((value % other.value).toUnsigned(16));
  u16 operator &(u16 other) => u16((value & other.value).toUnsigned(16));
  u16 operator |(u16 other) => u16((value | other.value).toUnsigned(16));
  u16 operator ^(u16 other) => u16((value ^ other.value).toUnsigned(16));
  u16 operator ~() => u16((~value).toUnsigned(16));
  u16 operator <<(int shiftAmount) => u16((value << shiftAmount).toUnsigned(16));
  u16 operator >>(int shiftAmount) => u16((value >> shiftAmount).toUnsigned(16));
  u16 operator >>>(int shiftAmount) => u16((value >>> shiftAmount).toUnsigned(16));

  u16 addChecked(u16 other) {
    var result = value + other.value;
    if (result > 65535) throw StateError('u16 addition overflow');
    return u16(result);
  }
  u16 subChecked(u16 other) {
    var result = value - other.value;
    if (result < 0) throw StateError('u16 subtraction underflow');
    return u16(result);
  }
  u16 mulChecked(u16 other) {
    var result = value * other.value;
    if (result > 65535) throw StateError('u16 multiplication overflow');
    return u16(result);
  }
}
