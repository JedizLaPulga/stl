import 'package:stl/stl.dart';

void main() {
  print('--- StateMonad<S, A> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Basic run / eval / exec
  // -----------------------------------------------------------------------
  print('Basic run / eval / exec:');
  final counter = StateMonad<int, String>((s) => ('value=$s', s + 1));
  final (value, state) = counter.run(0);
  print('  run(0)  → value: $value, state: $state');
  print('  eval(5) → ${counter.eval(5)}');
  print('  exec(5) → ${counter.exec(5)}');

  // -----------------------------------------------------------------------
  // Static constructors
  // -----------------------------------------------------------------------
  print('\nStatic constructors:');

  final pureVal = StateMonad.pure<int, String>('constant');
  print('  pure("constant").run(42) → ${pureVal.run(42)}');

  final getState = StateMonad.get<int>();
  print('  get().run(99)            → ${getState.run(99)}');

  final putState = StateMonad.put<int>(100);
  print('  put(100).run(0)          → ${putState.run(0)}');

  final modState = StateMonad.modify<int>((s) => s * 3);
  print('  modify(s*3).run(4)       → ${modState.run(4)}');

  // -----------------------------------------------------------------------
  // map
  // -----------------------------------------------------------------------
  print('\nmap:');
  final mapped = StateMonad<int, int>(
    (s) => (s, s + 1),
  ).map((v) => 'result is $v');
  print('  run(10) → ${mapped.run(10)}');

  // -----------------------------------------------------------------------
  // flatMap (monadic bind)
  // -----------------------------------------------------------------------
  print('\nflatMap chaining:');
  final pipeline =
      StateMonad<int, int>((s) => (s, s + 1)) // read state
          .flatMap(
            (v) =>
                StateMonad<int, String>((s) => ('got $v at state $s', s + 1)),
          );
  print('  run(0) → ${pipeline.run(0)}');
  print('  run(5) → ${pipeline.run(5)}');

  // -----------------------------------------------------------------------
  // Real-world scenario: simple stack machine
  // -----------------------------------------------------------------------
  print('\nStack machine (state = List<int>):');

  // Push a value onto the stack
  StateMonad<List<int>, void> push(int v) =>
      StateMonad<List<int>, void>((stack) => (null, [...stack, v]));

  // Pop from the stack and return the value
  final pop = StateMonad<List<int>, int>((stack) {
    if (stack.isEmpty) throw StateError('Stack underflow');
    return (stack.last, stack.sublist(0, stack.length - 1));
  });

  // Program: push 3, push 4, pop twice and sum the results
  final program = push(3)
      .flatMap((_) => push(4))
      .flatMap((_) => pop)
      .flatMap(
        (a) => pop.flatMap((b) => StateMonad.pure<List<int>, int>(a + b)),
      );

  final (result, finalStack) = program.run([]);
  print(
    '  push(3), push(4), pop, pop, sum → result: $result, stack: $finalStack',
  );

  // -----------------------------------------------------------------------
  // Real-world scenario: ID generator
  // -----------------------------------------------------------------------
  print('\nID generator (state = next ID int):');

  StateMonad<int, String> newId(String prefix) =>
      StateMonad<int, String>((id) => ('$prefix-$id', id + 1));

  final ids = newId('user').flatMap(
    (id1) => newId(
      'user',
    ).flatMap((id2) => newId('user').map((id3) => [id1, id2, id3])),
  );

  final (generatedIds, nextId) = ids.run(1);
  print('  Generated IDs: $generatedIds');
  print('  Next available ID: $nextId');
}
