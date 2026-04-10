import 'package:stl/stl.dart';

void main() {
  print('--- BitSet Demonstration ---');

  // Let's represent file permissions (Read, Write, Execute)
  // Index 0: Execute
  // Index 1: Write
  // Index 2: Read
  const int read = 2;
  const int write = 1;
  const int execute = 0;

  final permissions = BitSet(3);
  
  // Set read and execute permissions
  permissions.set(read);
  permissions.set(execute);

  print('Current File Permissions: $permissions'); 
  print('Can Read: ${permissions.test(read)}');
  print('Can Write: ${permissions.test(write)}');
  print('Can Execute: ${permissions.test(execute)}');

  print('\n[Adding Write Permission]');
  permissions[write] = true; // Using operator overload
  print('Has full permissions? ${permissions.all()}');
  print('Permissions representation: $permissions');

  print('\n[Processing User Preferences using 64 flags]');
  // Create a tight, incredibly small 64-bit array flag.
  final prefs = BitSet(64);
  prefs.set(8); 
  prefs.set(12, true);
  prefs.set(63);

  print('Prefs size physically mapping: ${prefs.size()} bits');
  print('Active preferences counted: ${prefs.count()} (via popcount)');
  
  prefs.flip(); 
  print('Flipped all bits! Active preferences: ${prefs.count()}');
  print('Are there any flags active? ${prefs.any()}');
}
