import 'package:stl/stl.dart';

void main() {
  print('========================================================');
  print('           STL: Primitive Numbers Demonstration         ');
  print('========================================================\n');

  print('--- 1. Zero-Cost Abstractions (I8, I16... U64) ---');
  // I8 is incredibly fast because it evaporates into a raw native int at runtime.
  final I8 a = I8(120);
  final I8 b = I8(10);
  
  print('Value A: ${a.value} | Value B: ${b.value}');
  
  // Natively mathematically wrapped
  final I8 c = a + b;
  print('I8(120) + I8(10) normally wraps beautifully to: ${c.value}');

  // We can strictly catch boundary breaks!
  try {
    a.addChecked(b);
  } catch (e) {
    print('Caught expected bounds failure: $e');
  }

  final U64 huge = U64.max;
  final U64 small = U64(1);
  print('U64 Max evaluates native Dart signed limit strictly naturally: ${huge.value}');
  print('Adding 1 to U64 Max wraps cleanly to: ${(huge + small).value}\n');

  print('--- 2. TypedData Bounded Abstractions (Int8... Uint64) ---');
  // Int8 internally uses dart:typed_data (Int8List). It forces strict hardware layouts
  // making it profoundly safe and unbreakable on both Desktop and Web deployments.
  
  final Int8 typedA = Int8.from(120);
  final Int8 typedB = Int8.from(10);
  
  // Hardware-level overflowing Native to the array!
  final Int8 typedC = typedA + typedB;
  print('Int8(120) + Int8(10) via Hardware memory layout: ${typedC.value}');

  // Bitwise capabilities mimicking C++ perfectly
  final Uint16 flag = Uint16.from(0x00FF);
  final Uint16 mask = Uint16.from(0xFF00);
  final Uint16 shifted = flag << 8;
  
  print('Uint16 hex bitwise shift (0x00FF << 8) = ${shifted.value} (Matches Mask: ${shifted.value == mask.value})\n');

  print('--- 3. Exploring Limits Programmatically ---');
  print('I32 Boundaries: Min = ${I32.min.value}, Max = ${I32.max.value}');
  print('Int64 Boundaries: Min = ${Int64.min.value}, Max = ${Int64.max.value}');
  
  // Demonstration of exact Unsigned logic resolution (signed negative evaluation bypass)
  final Uint8 uZero = Uint8.from(0);
  final Uint8 uMax = Uint8.max; // 255
  print('Unsigned Operator Logic: Is Uint8(255) literally > Uint8(0)? ${uMax > uZero}');

  print('\n========================================================');
  print('                 Execution Complete                     ');
  print('========================================================');
}
