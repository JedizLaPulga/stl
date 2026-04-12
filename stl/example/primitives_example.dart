import 'package:stl/src/primitives/i32.dart';
import 'package:stl/src/primitives/u8.dart';
import 'package:stl/src/primitives/u64.dart';

void main() {
  print('--- Primitives Sweep Example ---');

  // i32 wrapper wrapping correctly around 2.14B boundary
  i32 a = i32(2147483647);
  i32 b = a + i32(1);
  print('i32(2147483647) + 1 = ${b.value} (wrapped correctly)');

  // u8 zero-cost auto truncation over 255
  u8 c = u8(255);
  u8 d = c + u8(1);
  print('u8(255) + 1 = ${d.value}');

  // u64 utilizing specific custom BigInt comparison boundaries natively 
  // (-1 in two's complement unsigned mapping evaluates to positive peak value)
  u64 x = u64(-1); 
  u64 y = u64(0);
  print('u64 peak unsigned > 0: ${x > y}');
}
