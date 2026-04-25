/// An 8-bit unsigned integer primitive.
extension type const U8._(/// The strictly bounded primitive underlying value.
  int
  value) implements int  {
  /// Instantiates a new [U8] spanning a strictly bounded primitive value.
  const U8(this.value);

  /// The minimum representable value.
  static const U8 min = U8(0);
  /// The maximum representable value.
  static const U8 max = U8(255);

  U8 operator +(U8 other) => U8((value + other.value).toUnsigned(8));
  U8 operator -(U8 other) => U8((value - other.value).toUnsigned(8));
  U8 operator *(U8 other) => U8((value * other.value).toUnsigned(8));
  U8 operator ~/(U8 other) => U8((value ~/ other.value).toUnsigned(8));
  U8 operator %(U8 other) => U8((value % other.value).toUnsigned(8));
  U8 operator &(U8 other) => U8((value & other.value).toUnsigned(8));
  U8 operator |(U8 other) => U8((value | other.value).toUnsigned(8));
  U8 operator ^(U8 other) => U8((value ^ other.value).toUnsigned(8));
  U8 operator ~() => U8((~value).toUnsigned(8));
  U8 operator <<(int shiftAmount) => U8((value << shiftAmount).toUnsigned(8));
  U8 operator >>(int shiftAmount) => U8((value >> shiftAmount).toUnsigned(8));
  U8 operator >>>(int shiftAmount) => U8((value >>> shiftAmount).toUnsigned(8));

  /// Adds [other] catching overflow.
  U8 addChecked(U8 other) {
    var result = value + other.value;
    if (result > 255) {
      throw StateError('U8 addition overflow');
    }
    return U8(result);
  }

  /// Subtracts [other] catching underflow.
  U8 subChecked(U8 other) {
    var result = value - other.value;
    if (result < 0) {
      throw StateError('U8 subtraction underflow');
    }
    return U8(result);
  }

  /// Multiplies by [other] catching overflow.
  U8 mulChecked(U8 other) {
    var result = value * other.value;
    if (result > 255) {
      throw StateError('U8 multiplication overflow');
    }
    return U8(result);
  }
}
