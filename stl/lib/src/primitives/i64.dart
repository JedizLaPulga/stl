/// A 64-bit signed integer primitive.
extension type const i64(int value) implements int {
  static const i64 min = i64(-9223372036854775808);
  static const i64 max = i64(9223372036854775807);

  i64 operator +(i64 other) => i64((value + other.value).toSigned(64));
  i64 operator -(i64 other) => i64((value - other.value).toSigned(64));
  i64 operator *(i64 other) => i64((value * other.value).toSigned(64));
  i64 operator ~/(i64 other) => i64((value ~/ other.value).toSigned(64));
  i64 operator %(i64 other) => i64((value % other.value).toSigned(64));
  i64 operator &(i64 other) => i64((value & other.value).toSigned(64));
  i64 operator |(i64 other) => i64((value | other.value).toSigned(64));
  i64 operator ^(i64 other) => i64((value ^ other.value).toSigned(64));
  i64 operator ~() => i64((~value).toSigned(64));
  i64 operator <<(int shiftAmount) => i64((value << shiftAmount).toSigned(64));
  i64 operator >>(int shiftAmount) => i64((value >> shiftAmount).toSigned(64));
  i64 operator >>>(int shiftAmount) => i64((value >>> shiftAmount).toSigned(64));
  i64 operator -() => i64((-value).toSigned(64));

  bool _sameSign(int a, int b) => (a >= 0 && b >= 0) || (a < 0 && b < 0);

  i64 addChecked(i64 other) {
    var result = (value + other.value).toSigned(64);
    // Overflow occurs if both operands have the same sign, but the result has a different sign.
    if (_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('i64 addition overflow');
    }
    return i64(result);
  }
  
  i64 subChecked(i64 other) {
    var result = (value - other.value).toSigned(64);
    // Overflow occurs if operands have different signs, and result sign behaves unexpectedly.
    if (!_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('i64 subtraction overflow');
    }
    return i64(result);
  }
  
  i64 mulChecked(i64 other) {
    if (value == 0 || other.value == 0) return i64(0);
    var result = (value * other.value).toSigned(64);
    if (result ~/ other.value != value) {
      throw StateError('i64 multiplication overflow');
    }
    return i64(result);
  }
}
