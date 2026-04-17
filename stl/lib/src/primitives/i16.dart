/// A 16-bit signed integer primitive.
///
/// This provides a zero-cost abstraction for 16-bit signed math,
/// automatically wrapping on overflow and providing C++-style boundaries.
extension type const I16
/// Instantiates a new [I16] spanning a strictly bounded 16-bit value.
(
  /// The strictly bounded primitive underlying value.
  int
  value
)
    implements int {
  /// The minimum value an `I16` can hold (-32768).
  static const I16 min = I16(-32768);

  /// The maximum value an `I16` can hold (32767).
  static const I16 max = I16(32767);

  /// Adds another [I16] to this, wrapping around on overflow/underflow.
  I16 operator +(I16 other) => I16((value + other.value).toSigned(16));

  /// Subtracts another [I16] from this, wrapping around on overflow/underflow.
  I16 operator -(I16 other) => I16((value - other.value).toSigned(16));

  /// Multiplies this by another [I16], wrapping around on overflow/underflow.
  I16 operator *(I16 other) => I16((value * other.value).toSigned(16));

  /// Divides this by another [I16], wrapping around on overflow/underflow.
  I16 operator ~/(I16 other) => I16((value ~/ other.value).toSigned(16));

  /// Modulo operator, wrapping around to remain within [I16].
  I16 operator %(I16 other) => I16((value % other.value).toSigned(16));

  /// Performs bitwise AND.
  I16 operator &(I16 other) => I16((value & other.value).toSigned(16));

  /// Performs bitwise OR.
  I16 operator |(I16 other) => I16((value | other.value).toSigned(16));

  /// Performs bitwise XOR.
  I16 operator ^(I16 other) => I16((value ^ other.value).toSigned(16));

  /// Performs bitwise NOT.
  I16 operator ~() => I16((~value).toSigned(16));

  /// Left shifts by [shiftAmount] bits.
  I16 operator <<(int shiftAmount) => I16((value << shiftAmount).toSigned(16));

  /// Right shifts by [shiftAmount] bits.
  I16 operator >>(int shiftAmount) => I16((value >> shiftAmount).toSigned(16));

  /// Unsigned right shift.
  I16 operator >>>(int shiftAmount) =>
      I16((value >>> shiftAmount).toSigned(16));

  /// Returns the negated value.
  I16 operator -() => I16((-value).toSigned(16));

  /// Adds another [I16] to this, throwing a [StateError] on overflow or underflow.
  I16 addChecked(I16 other) {
    var result = value + other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 addition overflow');
    }
    return I16(result);
  }

  /// Subtracts another [I16] from this, throwing a [StateError] on overflow or underflow.
  I16 subChecked(I16 other) {
    var result = value - other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 subtraction overflow');
    }
    return I16(result);
  }

  /// Multiplies this by another [I16], throwing a [StateError] on overflow or underflow.
  I16 mulChecked(I16 other) {
    var result = value * other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('I16 multiplication overflow');
    }
    return I16(result);
  }
}
