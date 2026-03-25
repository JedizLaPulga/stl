import 'package:stl/stl.dart' as stl;

void main() {
  stl.Vector<int> p = stl.Vector<int>([10, 20, 30, 40, 50]);
  final p1 = p.list();

  print(p[0]); // Output: 10
  print(p1[0]); // Output: 10
}
