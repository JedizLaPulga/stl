import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('StateMonad<S, A>', () {
    // -------------------------------------------------------------------------
    // run / eval / exec
    // -------------------------------------------------------------------------
    group('run', () {
      test('returns (value, newState) record', () {
        final sm = StateMonad<int, String>((s) => ('hello', s + 1));
        final (value, state) = sm.run(0);
        expect(value, 'hello');
        expect(state, 1);
      });
    });

    group('eval', () {
      test('returns only the value', () {
        final sm = StateMonad<int, String>((s) => ('world', s + 10));
        expect(sm.eval(5), 'world');
      });
    });

    group('exec', () {
      test('returns only the final state', () {
        final sm = StateMonad<int, String>((s) => ('ignored', s + 7));
        expect(sm.exec(3), 10);
      });
    });

    // -------------------------------------------------------------------------
    // Static constructors
    // -------------------------------------------------------------------------
    group('pure', () {
      test('returns value without changing state', () {
        final sm = StateMonad.pure<int, String>('constant');
        final (value, state) = sm.run(42);
        expect(value, 'constant');
        expect(state, 42);
      });
    });

    group('get', () {
      test('returns current state as value', () {
        final sm = StateMonad.get<int>();
        final (value, state) = sm.run(99);
        expect(value, 99);
        expect(state, 99);
      });
    });

    group('put', () {
      test('replaces state and returns null', () {
        final sm = StateMonad.put<int>(100);
        final result = sm.run(0);
        expect(result.$2, 100);
      });
    });

    group('modify', () {
      test('applies function to state and returns null', () {
        final sm = StateMonad.modify<int>((s) => s * 2);
        final result = sm.run(5);
        expect(result.$2, 10);
      });
    });

    // -------------------------------------------------------------------------
    // map
    // -------------------------------------------------------------------------
    group('map', () {
      test('transforms result value, state passes through', () {
        final sm = StateMonad<int, int>((s) => (s, s + 1)).map((v) => v * 10);
        final (value, state) = sm.run(3);
        expect(value, 30);
        expect(state, 4);
      });
    });

    // -------------------------------------------------------------------------
    // flatMap (monadic bind)
    // -------------------------------------------------------------------------
    group('flatMap', () {
      test('chains two computations, threading state', () {
        final step1 = StateMonad<int, int>((s) => (s, s + 1));
        final step2 = step1.flatMap(
          (v) => StateMonad<int, int>((s) => (v + s, s + 10)),
        );
        // Initial state = 0
        // step1: value=0, state=1
        // step2(0): value=0+1=1, state=1+10=11
        final (value, state) = step2.run(0);
        expect(value, 1);
        expect(state, 11);
      });

      test('flatMap with pure short-circuits state changes', () {
        final sm = StateMonad<int, String>(
          (s) => ('hi', s + 5),
        ).flatMap((v) => StateMonad.pure<int, String>('$v world'));
        final (value, state) = sm.run(0);
        expect(value, 'hi world');
        expect(state, 5);
      });
    });

    // -------------------------------------------------------------------------
    // Composition — real-world scenario: counter
    // -------------------------------------------------------------------------
    group('counter pipeline', () {
      test('increment counter three times', () {
        final increment = StateMonad<int, void>((s) => (null, s + 1));
        final pipeline = increment
            .flatMap((_) => increment)
            .flatMap((_) => increment);
        expect(pipeline.exec(0), 3);
      });

      test('read + double pipeline', () {
        final readAndDouble = StateMonad.get<int>()
            .flatMap((s) => StateMonad.put<int>(s * 2))
            .flatMap((_) => StateMonad.get<int>());
        expect(readAndDouble.eval(7), 14);
        expect(readAndDouble.exec(7), 14);
      });
    });

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------
    group('toString', () {
      test('produces descriptive output', () {
        final sm = StateMonad<int, String>((s) => ('x', s));
        expect(sm.toString(), contains('StateMonad'));
      });
    });
  });
}
