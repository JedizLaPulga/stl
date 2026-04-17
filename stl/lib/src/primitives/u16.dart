/// A 16-bit unsigned integer primitive.
extension type const U16
/// Instantiates a new [U16] spanning a strictly bounded 16-bit unsigned value.
(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// The minimum representable value.
  static const U16 min = U16(0);
  /// The maximum representable value.
  static const U16 max = U16(65535);

  U16 operator +(U16 other) => U16((value + other.value).toUnsigned(16));
  U16 operator -(U16 other) => U16((value - other.value).toUnsigned(16));
  U16 operator *(U16 other) => U16((value * other.value).toUnsigned(16));
  U16 operator ~/(U16 other) => U16((value ~/ other.value).toUnsigned(16));
  U16 operator %(U16 other) => U16((value % other.value).toUnsigned(16));
  U16 operator &(U16 other) => U16((value & other.value).toUnsigned(16));
  U16 operator |(U16 other) => U16((value | other.value).toUnsigned(16));
  U16 operator ^(U16 other) => U16((value ^ other.value).toUnsigned(16));
  U16 operator ~() => U16((~value).toUnsigned(16));
  U16 operator <<(int shiftAmount) =>
      U16((value << shiftAmount).toUnsigned(16));
  U16 operator >>(int shiftAmount) =>
      U16((value >> shiftAmount).toUnsigned(16));
  U16 operator >>>(int shiftAmount) =>
      U16((value >>> shiftAmount).toUnsigned(16));

  /// Adds [other] catching overflow.
  U16 addChecked(U16 other) {
    var result = value + other.value;
    if (result > 65535) {
      throw StateError('U16 addition overflow');
    }
    return U16(result);
  }

  /// Subtracts [other] catching underflow.
  U16 subChecked(U16 other) {
    var result = value - other.value;
    if (result < 0) {
      throw StateError('U16 subtraction underflow');
    }
    return U16(result);
  }

  /// Multiplies by [other] catching overflow.
  U16 mulChecked(U16 other) {
    var result = value * other.value;
    if (result > 65535) {
      throw StateError('U16 multiplication overflow');
    }
    return U16(result);
  }
}
