import 'package:stl/src/primitives/i8.dart';

void main() {
  print('--- i8 Primitive Example ---');
  
  // 1. Standard creation and bounds
  i8 a = i8(100);
  i8 b = i8(50);
  print('a = \$a, b = \$b');
  print('i8.min = \${i8.min}, i8.max = \${i8.max}');

  // 2. Automatic wrap-around arithmetic
  i8 wrapped = a + b;
  print('\$a + \$b with wrap-around is \$wrapped'); // 150 -> -106

  // 3. Checked arithmetic
  try {
    i8 checked = a.addChecked(b);
    print('Checked result: \$checked');
  } on StateError catch (e) {
    print('Caught expected overflow: \$e');
  }

  // 4. Bitwise operations
  i8 c = i8(0x0F);
  i8 d = i8(0xF0);
  print('c | d = \${c | d}'); // -1 in 8-bit signed
}
