/// An 8-bit signed integer primitive.
///
/// This provides a zero-cost abstraction for 8-bit signed math,
/// automatically wrapping on overflow and providing C++-style boundaries.
extension type const I8(int value) implements int {
  /// The minimum value an `I8` can hold (-128).
  static const I8 min = I8(-128);

  /// The maximum value an `I8` can hold (127).
  static const I8 max = I8(127);

  /// Adds another [I8] to this, wrapping around on overflow/underflow.
  I8 operator +(I8 other) => I8((value + other.value).toSigned(8));

  /// Subtracts another [I8] from this, wrapping around on overflow/underflow.
  I8 operator -(I8 other) => I8((value - other.value).toSigned(8));

  /// Multiplies this by another [I8], wrapping around on overflow/underflow.
  I8 operator *(I8 other) => I8((value * other.value).toSigned(8));

  /// Divides this by another [I8], wrapping around on overflow/underflow.
  I8 operator ~/(I8 other) => I8((value ~/ other.value).toSigned(8));

  /// Modulo operator, wrapping around to remain within [I8].
  I8 operator %(I8 other) => I8((value % other.value).toSigned(8));

  /// Performs bitwise AND.
  I8 operator &(I8 other) => I8((value & other.value).toSigned(8));

  /// Performs bitwise OR.
  I8 operator |(I8 other) => I8((value | other.value).toSigned(8));

  /// Performs bitwise XOR.
  I8 operator ^(I8 other) => I8((value ^ other.value).toSigned(8));

  /// Performs bitwise NOT.
  I8 operator ~() => I8((~value).toSigned(8));

  /// Left shifts by [shiftAmount] bits.
  I8 operator <<(int shiftAmount) => I8((value << shiftAmount).toSigned(8));

  /// Right shifts by [shiftAmount] bits.
  I8 operator >>(int shiftAmount) => I8((value >> shiftAmount).toSigned(8));
  
  /// Unsigned right shift.
  I8 operator >>>(int shiftAmount) => I8((value >>> shiftAmount).toSigned(8));

  /// Returns the negated value.
  I8 operator -() => I8((-value).toSigned(8));

  /// Adds another [I8] to this, throwing a [StateError] on overflow or underflow.
  I8 addChecked(I8 other) {
    var result = value + other.value;
    if (result > 127 || result < -128) {
      throw StateError('I8 addition overflow');
    }
    return I8(result);
  }

  /// Subtracts another [I8] from this, throwing a [StateError] on overflow or underflow.
  I8 subChecked(I8 other) {
    var result = value - other.value;
    if (result > 127 || result < -128) {
      throw StateError('I8 subtraction overflow');
    }
    return I8(result);
  }

  /// Multiplies this by another [I8], throwing a [StateError] on overflow or underflow.
  I8 mulChecked(I8 other) {
    var result = value * other.value;
    if (result > 127 || result < -128) {
      throw StateError('I8 multiplication overflow');
    }
    return I8(result);
  }
}
