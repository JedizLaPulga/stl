import 'package:stl/stl.dart';

void main() {
  // --- 1. STRING: Formatting a name ---
  // If the value is there, it becomes uppercase. If not, it's "Guest".
  final name = Optional.of("joel");
  final noName = Optional<String>.none();

  print(name.map((s) => s.toUpperCase()).valueOr("Guest"));   // Output: JOEL
  print(noName.map((s) => s.toUpperCase()).valueOr("Guest")); // Output: Guest


  // --- 2. INT: Calculating a score ---
  // We can chain multiple math operations safely.
  final score = Optional.of(85);
  final noScore = Optional<int>.none();

  int processScore(Optional<int> opt) => opt
      .map((n) => n + 5)   // Add bonus
      .map((n) => n * 2)   // Double it
      .valueOr(0);         // Fallback to 0

  print(processScore(score));   // Output: 180
  print(processScore(noScore)); // Output: 0


  // --- 3. DOUBLE: Applying a discount ---
  // Notice how the type changes from Optional<double> to Optional<String>
  final price = Optional.of(19.99);
  
  final display = price
      .map((p) => p * 0.9) // Apply 10% discount
      .map((p) => "Sale: \$${p.toStringAsFixed(2)}"); // Format as String

  print(display.valueOr("No Price")); // Output: Sale: $17.99


  final Optional<int> score2   = Optional.none();

final display2 = switch (score2) {
  Some(value: final v) => "Score is $v",
  None()               => "No score recorded",
};

print(display2); // Output: No score recorded
}