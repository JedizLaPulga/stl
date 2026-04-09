import 'package:stl/stl.dart';

void main() {
  print('--- BitSet Demonstration ---');

  // Let's represent file permissions (Read, Write, Execute)
  // Index 0: Execute
  // Index 1: Write
  // Index 2: Read
  final int READ = 2;
  final int WRITE = 1;
  final int EXECUTE = 0;

  final permissions = BitSet(3);
  
  // Set read and execute permissions
  permissions.set(READ);
  permissions.set(EXECUTE);

  print('Current File Permissions: $permissions'); 
  print('Can Read: ${permissions.test(READ)}');
  print('Can Write: ${permissions.test(WRITE)}');
  print('Can Execute: ${permissions.test(EXECUTE)}');

  print('\n[Adding Write Permission]');
  permissions[WRITE] = true; // Using operator overload
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
