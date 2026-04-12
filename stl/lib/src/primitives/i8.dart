/// An 8-bit signed integer primitive.
///
/// This provides a zero-cost abstraction for 8-bit signed math,
/// automatically wrapping on overflow and providing C++-style boundaries.
extension type const i8(int value) implements int {
  /// The minimum value an `i8` can hold (-128).
  static const i8 min = i8(-128);

  /// The maximum value an `i8` can hold (127).
  static const i8 max = i8(127);

  /// Adds another [i8] to this, wrapping around on overflow/underflow.
  i8 operator +(i8 other) => i8((value + other.value).toSigned(8));

  /// Subtracts another [i8] from this, wrapping around on overflow/underflow.
  i8 operator -(i8 other) => i8((value - other.value).toSigned(8));

  /// Multiplies this by another [i8], wrapping around on overflow/underflow.
  i8 operator *(i8 other) => i8((value * other.value).toSigned(8));

  /// Divides this by another [i8], wrapping around on overflow/underflow.
  i8 operator ~/(i8 other) => i8((value ~/ other.value).toSigned(8));

  /// Modulo operator, wrapping around to remain within [i8].
  i8 operator %(i8 other) => i8((value % other.value).toSigned(8));

  /// Performs bitwise AND.
  i8 operator &(i8 other) => i8((value & other.value).toSigned(8));

  /// Performs bitwise OR.
  i8 operator |(i8 other) => i8((value | other.value).toSigned(8));

  /// Performs bitwise XOR.
  i8 operator ^(i8 other) => i8((value ^ other.value).toSigned(8));

  /// Performs bitwise NOT.
  i8 operator ~() => i8((~value).toSigned(8));

  /// Left shifts by [shiftAmount] bits.
  i8 operator <<(int shiftAmount) => i8((value << shiftAmount).toSigned(8));

  /// Right shifts by [shiftAmount] bits.
  i8 operator >>(int shiftAmount) => i8((value >> shiftAmount).toSigned(8));
  
  /// Unsigned right shift.
  i8 operator >>>(int shiftAmount) => i8((value >>> shiftAmount).toSigned(8));

  /// Returns the negated value.
  i8 operator -() => i8((-value).toSigned(8));

  /// Adds another [i8] to this, throwing a [StateError] on overflow or underflow.
  i8 addChecked(i8 other) {
    var result = value + other.value;
    if (result > 127 || result < -128) {
      throw StateError('i8 addition overflow');
    }
    return i8(result);
  }

  /// Subtracts another [i8] from this, throwing a [StateError] on overflow or underflow.
  i8 subChecked(i8 other) {
    var result = value - other.value;
    if (result > 127 || result < -128) {
      throw StateError('i8 subtraction overflow');
    }
    return i8(result);
  }

  /// Multiplies this by another [i8], throwing a [StateError] on overflow or underflow.
  i8 mulChecked(i8 other) {
    var result = value * other.value;
    if (result > 127 || result < -128) {
      throw StateError('i8 multiplication overflow');
    }
    return i8(result);
  }
}
