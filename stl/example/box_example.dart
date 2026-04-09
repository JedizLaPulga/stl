import 'package:stl/stl.dart';

void main() {
  print('--- Box<T> Demonstration ---\n');

  // Box<T> brings full power implicit operators to your wrappers
  var damage = Box<int>(50);
  var criticalMultiplier = Box<double>(1.5);

  print('Raw Box Damage output: $damage');
  
  // Mathematical operators are intrinsically integrated!
  var totalHit = damage * criticalMultiplier;
  print('Total Critical Hit evaluated securely: $totalHit');

  // Can evaluate against bare primitives as well deeply
  if (damage >= 40) {
    print('\nDamage is recognized elegantly as >= 40.');
  }
  
  var score = Box<int>(100);
  print('\nCalculating remainder mathematically from Box -> (100 % 3): ${score % 3}');

  // Equality checking evaluates structurally via Dart idioms
  var idLevel1 = Box<int>(99);
  var idLevel2 = Box<int>(99);
  
  print('\nDoes Box(99) == Box(99)? ${idLevel1 == idLevel2}');
  print('Does Box(99) == raw 99 primitive? ${idLevel1 == 99}'); 
}
