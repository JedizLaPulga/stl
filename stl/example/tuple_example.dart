/// A complete example demonstrating the powerful capabilities of the new `Tuple` utilities.
///
/// Showcases `makeTupleX()` construction, deep value-based equality, Dart 3 Record
/// interoperability, and dynamic collection conversion.
library;

import 'package:stl/stl.dart';

/// The main entry point showcasing the usage of `Tuple` classes.
void main() {
  print('--- Tuple Examples ---\n');

  // 1. Creating Tuples mimicking C++ std::make_tuple
  final serverConfig = makeTuple3('192.168.1.1', 8080, true);
  print('Created Tuple3: $serverConfig');

  // Accessing values dynamically
  print('IP Address: ${serverConfig.item1}');
  print('Port: ${serverConfig.item2}');
  print('Is Active: ${serverConfig.item3}\n');

  // 2. Deep equality matching (Value Semantics)
  final otherConfig = Tuple3<String, int, bool>('192.168.1.1', 8080, true);
  print('Configs hold identical data: ${serverConfig == otherConfig}\n');

  // 3. Dart 3 Record Destructuring Integration
  final playerStats = makeTuple4('Warrior', 99, 14500.5, 'Fire Sword');
  
  // Extract into a Dart Record perfectly
  final (characterClass, level, xp, weapon) = playerStats.record;
  print('Destructured Tuple4 -> Class: $characterClass, Level: $level, Weapon: $weapon\n');

  // 4. Constructing dynamically from a Dart Record
  final rawRecord = (404, 'Not Found', 'Server Error', 'HTTP', 1.1);
  final errorTuple = Tuple5.fromRecord(rawRecord);
  print('Tuple5 generated securely from native Record: $errorTuple\n');

  // 5. Converting to generic Lists
  final hugeDataRow = makeTuple7(1, 2, 3, 4, 5, 6, 7);
  final asList = hugeDataRow.toList();
  print('Tuple7 converted seamlessly to Dart List: $asList');
}
