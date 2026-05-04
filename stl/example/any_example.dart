import 'package:stl/stl.dart';

void main() {
  print('--- Any Demonstration ---\n');

  // Let's create an Any box initialized empty.
  var mysteriousBox = Any.empty();
  print('Does the system contain data? ${mysteriousBox.hasValue}');

  // Load a string into the Box dynamically
  mysteriousBox.set('System Configuration Vector');
  print('\n[Uploaded String Object]');
  print('Current Data Type explicitly verified: ${mysteriousBox.type()}');
  print(
    'Value successfully extracted cleanly: ${mysteriousBox.cast<String>()}',
  );

  // Overwrite the same Any box directly with an integer
  mysteriousBox.set(9001);
  print('\n[Overwritten with Integer]');
  print('Data Type shifted: ${mysteriousBox.type()}');
  print('Int cast passes safely automatically: ${mysteriousBox.cast<int>()}');

  // Try extracting the wrong type deliberately to assert safety
  print('\n[Attempting illegal unboxing operation]');
  try {
    mysteriousBox.cast<bool>();
  } catch (e) {
    print(
      'Strict Safety Guard Triggered! Could not blindly cast integer into boolean natively.',
    );
  }

  // Wiping the Box entirely
  mysteriousBox.reset();
  print('\nState wiped natively. Has value? ${mysteriousBox.hasValue}');
}
