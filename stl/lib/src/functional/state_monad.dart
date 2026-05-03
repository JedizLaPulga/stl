/// A pure stateful computation wrapper, inspired by Haskell's `State` monad.
///
/// A [StateMonad] encapsulates a function `S → (A, S)` that takes an initial
/// state, performs a computation, and returns both a **result value** and a
/// **new state** — without any mutable variables. Computations are composed
/// via [map] and [flatMap] (monadic bind), keeping each step pure and testable.
///
/// The result record `(A, S)` uses Dart 3's native record type:
/// - First field (positional `$1`) is the computed value of type [A].
/// - Second field (positional `$2`) is the new state of type [S].
///
/// **Common usage:**
/// ```dart
/// // A counter that increments and returns the old count
/// final increment = StateMonad<int, int>((s) => (s, s + 1));
///
/// // Chain with flatMap
/// final doubled = increment.flatMap((n) =>
///     StateMonad<int, int>((s) => (n * 2, s)));
///
/// print(doubled.run(0)); // (0, 1)  → value: 0*2=0, state: 1
/// print(doubled.run(5)); // (10, 6) → value: 5*2=10, state: 6
/// ```
final class StateMonad<S, A> {
  final (A, S) Function(S state) _run;

  /// Creates a [StateMonad] from a raw state-transformation function.
  const StateMonad(this._run);

  // ---------------------------------------------------------------------------
  // Static constructors (common state operations)
  // ---------------------------------------------------------------------------

  /// Returns [value] without modifying the state.
  ///
  /// Equivalent to Haskell's `return` / `pure`.
  static StateMonad<S, A> pure<S, A>(A value) =>
      StateMonad<S, A>((s) => (value, s));

  /// Returns the current state as the result value without modifying it.
  ///
  /// Equivalent to Haskell's `get`.
  static StateMonad<S, S> get<S>() => StateMonad<S, S>((s) => (s, s));

  /// Replaces the state with [newState] and returns `null` as the value.
  ///
  /// Equivalent to Haskell's `put`.
  static StateMonad<S, void> put<S>(S newState) =>
      StateMonad<S, void>((s) => (null, newState));

  /// Applies [f] to the current state and returns `null` as the value.
  ///
  /// Equivalent to Haskell's `modify`.
  static StateMonad<S, void> modify<S>(S Function(S state) f) =>
      StateMonad<S, void>((s) => (null, f(s)));

  // ---------------------------------------------------------------------------
  // Execution
  // ---------------------------------------------------------------------------

  /// Executes the computation with [initialState], returning a record
  /// `(value, newState)`.
  (A, S) run(S initialState) => _run(initialState);

  /// Executes the computation and returns only the **value**, discarding the state.
  A eval(S initialState) => _run(initialState).$1;

  /// Executes the computation and returns only the **final state**, discarding
  /// the value.
  S exec(S initialState) => _run(initialState).$2;

  // ---------------------------------------------------------------------------
  // Functor / Monad operations
  // ---------------------------------------------------------------------------

  /// Transforms the result value using [mapper] without affecting the state flow.
  StateMonad<S, B> map<B>(B Function(A value) mapper) => StateMonad<S, B>((s) {
    final (a, s2) = _run(s);
    return (mapper(a), s2);
  });

  /// Chains this computation with a function that produces the next computation.
  ///
  /// The state output of this computation becomes the state input of the next,
  /// threading state through the pipeline without mutation.
  ///
  /// Equivalent to Haskell's `>>=` (bind).
  StateMonad<S, B> flatMap<B>(StateMonad<S, B> Function(A value) next) =>
      StateMonad<S, B>((s) {
        final (a, s2) = _run(s);
        return next(a).run(s2);
      });

  @override
  String toString() => 'StateMonad<$S, $A>';
}
