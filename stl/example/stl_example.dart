import 'package:stl/stl.dart' as stl;

void main() {
  const vec = stl.Vector([10, 20, 30, 40, 50]);
  const vec2 = stl.Vector<int>([60, 70, 80]);
  final p = vec.toList<int>();
  final pp = vec.list();
  print(p);
  print(pp);
}
