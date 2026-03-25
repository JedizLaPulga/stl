import 'package:stl/stl.dart' as stl;

typedef Vec<T> = stl.Vector<T>;

void main() {
  Vec<int> p = Vec<int>([10, 20, 30, 40, 50]);
  Vec<int> q = Vec<int>([30, 40, 50, 60, 70]);

  p = q;
  p[0] = 90;
  print(q[0]);
}
