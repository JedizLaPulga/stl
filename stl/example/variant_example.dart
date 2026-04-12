import 'package:stl/stl.dart';

void main() {
  print('--- Variant2 Demonstration ---');

  // Create a variant that can hold either an int or a String
  Variant2<int, String> result1 = Variant2.withT0(200); // 200 is OK status

  if (result1.holdsAlternative<int>()) {
    print('result1 holds an integer: ${result1.value}');
  }

  // Visit guarantees exhaustive pattern matching at compile-time!
  final mapped1 = result1.visit(
    onT0: (int code) => 'Success with status code: $code',
    onT1: (String error) => 'Failed with error: $error',
  );
  print(mapped1);

  // Now an error case
  Variant2<int, String> result2 = Variant2.withT1('Network Timeout');

  final mapped2 = result2.visit(
    onT0: (int code) => 'Success with status code: $code',
    onT1: (String error) => 'Failed with error: $error',
  );
  print(mapped2);

  print('\n--- Variant3 Demonstration ---');

  // Handling a more complex case: a UI state representation
  // T0: Loading (bool)
  // T1: Data (List<String>)
  // T2: Error (String)
  Variant3<bool, List<String>, String> uiState = Variant3.withT1([
    'Item 1',
    'Item 2',
    'Item 3',
  ]);

  final displayMessage = uiState.visit(
    onT0: (bool isLoading) => isLoading ? 'Spining loading wheel...' : 'Idle',
    onT1: (List<String> items) => 'Showing ${items.length} items',
    onT2: (String exception) => 'Alert dialog: $exception',
  );

  print('Current UI State output: $displayMessage');

  // Alternative using standard Dart 3 pattern matching (since Variant is sealed!)
  switch (uiState) {
    case Variant3Item0(:final value):
      print('Dart 3 matching: Loading = $value');
    case Variant3Item1(:final value):
      print('Dart 3 matching: Data = $value');
    case Variant3Item2(:final value):
      print('Dart 3 matching: Error = $value');
  }
}
