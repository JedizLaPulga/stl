// ignore_for_file: unused_local_variable, unused_catch_clause
import 'package:stl/src/primitives/i8.dart';

void main() {
  print('--- I8 Primitive Example ---');

  // 1. Standard creation and bounds
  I8 a = I8(100);
  I8 b = I8(50);
  print('a = \$a, b = \$b');
  print('I8.min = \${I8.min}, I8.max = \${I8.max}');

  // 2. Automatic wrap-around arithmetic
  I8 wrapped = a + b;
  print('\$a + \$b with wrap-around is \$wrapped'); // 150 -> -106

  // 3. Checked arithmetic
  try {
    I8 checked = a.addChecked(b);
    print('Checked result: \$checked');
  } on StateError {
    print('Caught expected overflow: \$e');
  }

  // 4. Bitwise operations
  I8 c = I8(0x0F);
  I8 d = I8(0xF0);
  print('c | d = \${c | d}'); // -1 in 8-bit signed
}
