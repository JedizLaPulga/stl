import 'package:stl/stl.dart';

void main() {
  print('--- Var<T> Demonstration ---\n');

  // 1. Wrapping a standard primitive
  final health = Var(100);
  print('Initial Health: ${health()}');

  // 2. Passing the Var reference to a "damage" function deeply nested
  // If we just passed an `int`, we couldn't mutate the caller's value globally.
  void takeDamage(Var<int> target, int amount) {
    print('... Taking $amount damage ...');
    target.update((hp) => hp - amount);
  }

  takeDamage(health, 35);
  print('Health after ambush: ${health()}');

  // 3. Simple mutating behavior inline
  health.value += 10;
  print('Health after eating an apple: ${health.value}');

  // 4. Storing strings or booleans
  final isConnecting = Var(true);
  print('\nSystem connecting state: ${isConnecting()}');

  // Update state functionally
  isConnecting.update((_) => false);
  print('System explicitly disconnected: ${isConnecting()}');
}
