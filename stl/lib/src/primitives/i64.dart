/// A 64-bit signed integer primitive.
extension type const I64(int value) implements int {
  static const I64 min = I64(-9223372036854775808);
  static const I64 max = I64(9223372036854775807);

  I64 operator +(I64 other) => I64((value + other.value).toSigned(64));
  I64 operator -(I64 other) => I64((value - other.value).toSigned(64));
  I64 operator *(I64 other) => I64((value * other.value).toSigned(64));
  I64 operator ~/(I64 other) => I64((value ~/ other.value).toSigned(64));
  I64 operator %(I64 other) => I64((value % other.value).toSigned(64));
  I64 operator &(I64 other) => I64((value & other.value).toSigned(64));
  I64 operator |(I64 other) => I64((value | other.value).toSigned(64));
  I64 operator ^(I64 other) => I64((value ^ other.value).toSigned(64));
  I64 operator ~() => I64((~value).toSigned(64));
  I64 operator <<(int shiftAmount) => I64((value << shiftAmount).toSigned(64));
  I64 operator >>(int shiftAmount) => I64((value >> shiftAmount).toSigned(64));
  I64 operator >>>(int shiftAmount) => I64((value >>> shiftAmount).toSigned(64));
  I64 operator -() => I64((-value).toSigned(64));

  bool _sameSign(int a, int b) => (a >= 0 && b >= 0) || (a < 0 && b < 0);

  I64 addChecked(I64 other) {
    var result = (value + other.value).toSigned(64);
    // Overflow occurs if both operands have the same sign, but the result has a different sign.
    if (_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('I64 addition overflow');
    }
    return I64(result);
  }
  
  I64 subChecked(I64 other) {
    var result = (value - other.value).toSigned(64);
    // Overflow occurs if operands have different signs, and result sign behaves unexpectedly.
    if (!_sameSign(value, other.value) && !_sameSign(value, result)) {
      throw StateError('I64 subtraction overflow');
    }
    return I64(result);
  }
  
  I64 mulChecked(I64 other) {
    if (value == 0 || other.value == 0) return I64(0);
    var result = (value * other.value).toSigned(64);
    if (result ~/ other.value != value) {
      throw StateError('I64 multiplication overflow');
    }
    return I64(result);
  }
}
