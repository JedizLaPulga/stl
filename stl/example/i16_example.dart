import 'package:stl/src/primitives/i16.dart';

void main() {
  print('--- I16 Primitive Example ---');

  I16 a = I16(30000);
  I16 b = I16(5000);
  print('a = ${a.value}, b = ${b.value}');
  print('I16.min = ${I16.min.value}, I16.max = ${I16.max.value}');

  I16 wrapped = a + b;
  print('${a.value} + ${b.value} with wrap-around is ${wrapped.value}');

  try {
    I16 checked = a.addChecked(b);
    print('Checked result: ${checked.value}');
  } on StateError catch (e) {
    print('Caught expected overflow: \$e');
  }
}
