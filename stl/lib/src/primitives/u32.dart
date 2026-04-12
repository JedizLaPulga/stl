/// A 32-bit unsigned integer primitive.
extension type const U32(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  static const U32 min = U32(0);
  static const U32 max = U32(4294967295);

  U32 operator +(U32 other) => U32((value + other.value).toUnsigned(32));
  U32 operator -(U32 other) => U32((value - other.value).toUnsigned(32));
  U32 operator *(U32 other) => U32((value * other.value).toUnsigned(32));
  U32 operator ~/(U32 other) => U32((value ~/ other.value).toUnsigned(32));
  U32 operator %(U32 other) => U32((value % other.value).toUnsigned(32));
  U32 operator &(U32 other) => U32((value & other.value).toUnsigned(32));
  U32 operator |(U32 other) => U32((value | other.value).toUnsigned(32));
  U32 operator ^(U32 other) => U32((value ^ other.value).toUnsigned(32));
  U32 operator ~() => U32((~value).toUnsigned(32));
  U32 operator <<(int shiftAmount) =>
      U32((value << shiftAmount).toUnsigned(32));
  U32 operator >>(int shiftAmount) =>
      U32((value >> shiftAmount).toUnsigned(32));
  U32 operator >>>(int shiftAmount) =>
      U32((value >>> shiftAmount).toUnsigned(32));

  U32 addChecked(U32 other) {
    var result = value + other.value;
    if (result > 4294967295) {
      throw StateError('U32 addition overflow');
    }
    return U32(result);
  }

  U32 subChecked(U32 other) {
    var result = value - other.value;
    if (result < 0) {
      throw StateError('U32 subtraction underflow');
    }
    return U32(result);
  }

  U32 mulChecked(U32 other) {
    var result = value * other.value;
    if (result > 4294967295) {
      throw StateError('U32 multiplication overflow');
    }
    return U32(result);
  }
}
