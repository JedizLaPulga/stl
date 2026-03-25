import 'package:stl/stl.dart' as stl;

void main() {
  final p = stl.Vector<int>([10, 20, 30, 40, 50]);
  final list = p.list();
  print(list);
  print(p);
}
