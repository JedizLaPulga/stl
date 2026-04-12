import 'package:stl/stl.dart';

void main() {
  final userIds = [101, 102, 103, 104];
  final userNames = ['Alice', 'Bob', 'Charlie']; // Notice lengths differ!

  print('--- ZipRange Example ---');
  // Combine users strictly until one list is exhausted (shortest wins)
  final zipped = ZipRange(userIds, userNames);

  for (final pair in zipped) {
    print('ID: ${pair.first} -> Name: ${pair.second}');
  }

  // Destructure pairs powerfully because of Pair's Dart 3 mapping
  print('\n-- Zipping dynamically with Maps --');
  final roles = ['Admin', 'Editor', 'Viewer'];
  final zippedRoles = ZipRange(userNames, roles);

  final roleMap = Map.fromEntries(zippedRoles.map((pair) => pair.toMapEntry()));
  print(roleMap);
}
