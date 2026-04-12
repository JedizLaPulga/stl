import 'package:stl/src/primitives/i16.dart';

void main() {
  print('--- i16 Primitive Example ---');
  
  i16 a = i16(30000);
  i16 b = i16(5000);
  print('a = ${a.value}, b = ${b.value}');
  print('i16.min = ${i16.min.value}, i16.max = ${i16.max.value}');

  i16 wrapped = a + b;
  print('${a.value} + ${b.value} with wrap-around is ${wrapped.value}'); 

  try {
    i16 checked = a.addChecked(b);
    print('Checked result: ${checked.value}');

  } on StateError catch (e) {
    print('Caught expected overflow: \$e');
  }
}
