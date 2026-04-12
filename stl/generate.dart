import 'dart:io';

void generate(String className, String listName, String minVal, String maxVal, String bitString, bool isUnsigned) {
  String overflowCheckCode = '';
  
  if (className == 'Int64') {
    // 64-bit signed cannot be accurately checked using direct addition into `result` if they wrap, 
    // because `value + other.value` might wrap before checking natively, well actually it doesn't wrap for Dart's `int` prior to Dart 2, but modern Dart natively does what?
    // Dart's `int` arithmetic is 64-bit signed on Native VM.
    overflowCheckCode = '''
    // Overflow checking utilizing signs
    final res = (value + other.value);
    if (!(((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
       throw StateError('$className addition overflow');
    }''';
  } else if (className == 'Uint64') {
     overflowCheckCode = '''
     final res = value + other.value;
     // Unsigned addition overflow check via signed analysis
     if ((res ^ 0x8000000000000000) < (value ^ 0x8000000000000000)) {
        throw StateError('$className addition overflow');
     }
     ''';
  }

  String content = '''import 'dart:typed_data';

/// A robust, heap-allocated $bitString wrapper utilizing `dart:typed_data`.
///
/// Unlike the zero-cost variant, `$className` is strictly backed by an `$listName(1)`.
/// This inherently bounds the variable within standard memory specifications and rigorously 
/// guarantees that mathematical operators intuitively overflow using C++ style 
/// constraints, exactly mimicking real hardware boundaries, providing complete safety for the web!
extension type $className($listName _data) {
  /// Dynamically instantiates a [$className] value mapped sequentially into memory.
  $className.from(int value) : _data = $listName(1)..[0] = value;

  /// Returns the statically-bounded minimum value of a $bitString ($minVal).
  static final $className min = $className.from($minVal);

  /// Returns the statically-bounded maximum value of a $bitString ($maxVal).
  static final $className max = $className.from($maxVal);

  /// Extracts the underlying raw Dart `int` strictly clamped.
  int get value => _data[0];

  /// Standard addition. Natively handles and wraps exact numerical overflows gracefully.
  $className operator +($className other) => $className.from(value + other.value);

  /// Standard subtraction. Computes precise arithmetic underflows independently.
  $className operator -($className other) => $className.from(value - other.value);

  /// Multiplication mathematically clipped naturally to standard hardware constraints.
  $className operator *($className other) => $className.from(value * other.value);

  /// Truncating division.
  $className operator ~/($className other) => $className.from(value ~/ other.value);

  /// Modulo remainder constraint matching natively bounded data models.
  $className operator %($className other) => $className.from(value % other.value);

  /// Bitwise AND logically coupled to bit patterns.
  $className operator &($className other) => $className.from(value & other.value);

  /// Bitwise OR operator.
  $className operator |($className other) => $className.from(value | other.value);

  /// Bitwise XOR operator.
  $className operator ^($className other) => $className.from(value ^ other.value);

  /// Bitwise NOT standardly shifting limits.
  $className operator ~() => $className.from(~value);

  /// Left-shifts the integer's bits gracefully overflowing when passing the bit barrier.
  $className operator <<(int shiftAmount) => $className.from(value << shiftAmount);

  /// Right-shifts the numerical data maintaining standard sign retention.
  $className operator >>(int shiftAmount) => $className.from(value >> shiftAmount);
''';
  
  if (isUnsigned) {
    content += '''
  /// Right-shift explicitly padding zeros unconditionally.
  $className operator >>>(int shiftAmount) => $className.from(value >>> shiftAmount);
''';
  }

  if (className == 'Uint64') {
     content += '''
  /// Determines structural bounds dynamically using unsigned comparison mechanisms for 64-bit limits.
  bool operator <($className other) => (value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000);

  bool operator <=($className other) => (value ^ 0x8000000000000000) <= (other.value ^ 0x8000000000000000);

  bool operator >($className other) => (value ^ 0x8000000000000000) > (other.value ^ 0x8000000000000000);

  bool operator >=($className other) => (value ^ 0x8000000000000000) >= (other.value ^ 0x8000000000000000);
''';
  } else {
    content += '''
  /// Returns true if this value evaluates less than [other].
  bool operator <($className other) => value < other.value;

  /// Returns true if this bounds-checked value is less than or equal to [other].
  bool operator <=($className other) => value <= other.value;

  /// Strict evaluation if this numerical element is larger.
  bool operator >($className other) => value > other.value;

  /// Strict evaluation extending identical size bounds.
  bool operator >=($className other) => value >= other.value;
''';
  }

  // Adding checked logic
  if (className != 'Int64' && className != 'Uint64') {
    content += '''
  /// Adds [other] dynamically intercepting any numerical layout overflow triggering a Dart StateError.
  $className addChecked($className other) {
    final result = value + other.value;
    if (result > $maxVal || result < $minVal) throw StateError('$className addition overflow');
    return $className.from(result);
  }

  /// Subtracts [other] throwing a programmatic bounds break upon underflow.
  $className subChecked($className other) {
    final result = value - other.value;
    if (result > $maxVal || result < $minVal) throw StateError('$className subtraction overflow/underflow');
    return $className.from(result);
  }

  /// Evaluates exact strict mathematical bounding conditions without truncating natively.
  $className mulChecked($className other) {
    final result = value * other.value;
    if (result > $maxVal || result < $minVal) throw StateError('$className multiplication overflow');
    return $className.from(result);
  }
''';
  } else if (className == 'Int64') {
    content += '''
  $className addChecked($className other) {
    final res = value + other.value;
    if (!(((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
       throw StateError('$className addition overflow');
    }
    return $className.from(res);
  }

  $className subChecked($className other) {
    var res = value - other.value;
    if ((((value ^ other.value) & 0x8000000000000000) != 0) &&
        (((res ^ value) & 0x8000000000000000) != 0)) {
        throw StateError('$className subtraction overflow/underflow');
    }
    return $className.from(res);
  }
''';
  } else if (className == 'Uint64') {
    content += '''
  $className addChecked($className other) {
     final res = value + other.value;
     if ((res ^ 0x8000000000000000) < (value ^ 0x8000000000000000)) {
        throw StateError('$className addition overflow');
     }
     return $className.from(res);
  }

  $className subChecked($className other) {
     final res = value - other.value;     
     if ((value ^ 0x8000000000000000) < (other.value ^ 0x8000000000000000)) {
        throw StateError('$className subtraction underflow');
     }
     return $className.from(res);
  }
''';
  }

  content += '}\n';

  File('lib/src/primitives/\${className.toLowerCase()}.dart').writeAsStringSync(content);
}

void main() {
  generate('Int8', 'Int8List', '-128', '127', '8-bit signed integer', false);
  generate('Int16', 'Int16List', '-32768', '32767', '16-bit signed integer', false);
  generate('Int32', 'Int32List', '-2147483648', '2147483647', '32-bit signed integer', false);
  // Dart analyzer considers -9223372036854775808 an error directly parsed sometimes unless written as -9223372036854775807 - 1
  generate('Int64', 'Int64List', '-9223372036854775808', '9223372036854775807', '64-bit signed integer', false);
  
  generate('Uint8', 'Uint8List', '0', '255', '8-bit unsigned integer', true);
  generate('Uint16', 'Uint16List', '0', '65535', '16-bit unsigned integer', true);
  generate('Uint32', 'Uint32List', '0', '4294967295', '32-bit unsigned integer', true);
  generate('Uint64', 'Uint64List', '0', '-1', '64-bit unsigned integer', true);
}
