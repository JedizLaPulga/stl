/// A 16-bit signed integer primitive.
///
/// This provides a zero-cost abstraction for 16-bit signed math,
/// automatically wrapping on overflow and providing C++-style boundaries.
extension type const i16(int value) implements int {
  /// The minimum value an `i16` can hold (-32768).
  static const i16 min = i16(-32768);

  /// The maximum value an `i16` can hold (32767).
  static const i16 max = i16(32767);

  /// Adds another [i16] to this, wrapping around on overflow/underflow.
  i16 operator +(i16 other) => i16((value + other.value).toSigned(16));

  /// Subtracts another [i16] from this, wrapping around on overflow/underflow.
  i16 operator -(i16 other) => i16((value - other.value).toSigned(16));

  /// Multiplies this by another [i16], wrapping around on overflow/underflow.
  i16 operator *(i16 other) => i16((value * other.value).toSigned(16));

  /// Divides this by another [i16], wrapping around on overflow/underflow.
  i16 operator ~/(i16 other) => i16((value ~/ other.value).toSigned(16));

  /// Modulo operator, wrapping around to remain within [i16].
  i16 operator %(i16 other) => i16((value % other.value).toSigned(16));

  /// Performs bitwise AND.
  i16 operator &(i16 other) => i16((value & other.value).toSigned(16));

  /// Performs bitwise OR.
  i16 operator |(i16 other) => i16((value | other.value).toSigned(16));

  /// Performs bitwise XOR.
  i16 operator ^(i16 other) => i16((value ^ other.value).toSigned(16));

  /// Performs bitwise NOT.
  i16 operator ~() => i16((~value).toSigned(16));

  /// Left shifts by [shiftAmount] bits.
  i16 operator <<(int shiftAmount) => i16((value << shiftAmount).toSigned(16));

  /// Right shifts by [shiftAmount] bits.
  i16 operator >>(int shiftAmount) => i16((value >> shiftAmount).toSigned(16));
  
  /// Unsigned right shift.
  i16 operator >>>(int shiftAmount) => i16((value >>> shiftAmount).toSigned(16));

  /// Returns the negated value.
  i16 operator -() => i16((-value).toSigned(16));

  /// Adds another [i16] to this, throwing a [StateError] on overflow or underflow.
  i16 addChecked(i16 other) {
    var result = value + other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('i16 addition overflow');
    }
    return i16(result);
  }

  /// Subtracts another [i16] from this, throwing a [StateError] on overflow or underflow.
  i16 subChecked(i16 other) {
    var result = value - other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('i16 subtraction overflow');
    }
    return i16(result);
  }

  /// Multiplies this by another [i16], throwing a [StateError] on overflow or underflow.
  i16 mulChecked(i16 other) {
    var result = value * other.value;
    if (result > 32767 || result < -32768) {
      throw StateError('i16 multiplication overflow');
    }
    return i16(result);
  }
}
