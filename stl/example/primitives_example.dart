import 'package:stl/src/primitives/i32.dart';
import 'package:stl/src/primitives/u8.dart';
import 'package:stl/src/primitives/u64.dart';

void main() {
  print('--- Primitives Sweep Example ---');

  // I32 wrapper wrapping correctly around 2.14B boundary
  I32 a = I32(2147483647);
  I32 b = a + I32(1);
  print('I32(2147483647) + 1 = ${b.value} (wrapped correctly)');

  // U8 zero-cost auto truncation over 255
  U8 c = U8(255);
  U8 d = c + U8(1);
  print('U8(255) + 1 = ${d.value}');

  // U64 utilizing specific custom BigInt comparison boundaries natively
  // (-1 in two's complement unsigned mapping evaluates to positive peak value)
  U64 x = U64(-1);
  U64 y = U64(0);
  print('U64 peak unsigned > 0: ${x > y}');
}
