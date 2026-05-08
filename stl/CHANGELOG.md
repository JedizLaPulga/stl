# 0.6.5

## Chrono — Time Expansion

The `chrono` module grows from a ~100-line stub to a full-featured time
library. **Five new source files** are added; the existing `chrono.dart` gains
`TimePoint` factory/conversion methods, `DurationExtension`, and two new
duration literals.

---

### New File: `chrono/calendar.dart`

Calendar types inspired by C++20 `<chrono>` and ISO 8601.

- **`isLeapYear(int year) → bool`** — Proleptic Gregorian leap-year predicate
  (divisible by 4 except centuries, unless divisible by 400).
- **`daysInYear(int year) → int`** — Returns 365 or 366.
- **`Month` enum** — `january … december` with ISO month number (`value`),
  `daysIn(year)`, wrapping `operator +` / `operator -`, and a `fromValue(int)`
  factory. Throws `RangeError` for values outside `[1, 12]`.
- **`Weekday` enum** — `monday … sunday` with `isoValue` (1–7), `isWeekend`,
  `isWeekday`, wrapping `operator +` / `operator -`, and `fromIso(int)` factory.
- **`ChronoDate`** — Validated calendar date (year, `Month`, day). Throws
  `RangeError` for invalid day-of-month (respects leap years in February).
  Provides: `weekday`, `dayOfYear`, `isLeap`, `toDateTime()`,
  `toUtcDateTime()`, `addDays`, `addMonths` (clamped), `addYears` (clamped),
  `differenceInDays`, full `Comparable<ChronoDate>` with `<`/`>`/`<=`/`>=`,
  `operator ==`, `hashCode`, and `toIso8601()` (`YYYY-MM-DD`).
- **`ChronoTime`** — Validated time-of-day (hour, minute, second, microsecond).
  Components are range-checked at construction. Provides: `midnight`/`noon`
  static getters, `totalMicroseconds`, `toDuration()`, `fromDateTime`,
  `Comparable<ChronoTime>`, `toIso8601()` (`HH:MM:SS[.uuuuuu]`).
- **`ChronoDateTime`** — Combination of `ChronoDate` and `ChronoTime`.
  `fromDateTime(DateTime)`, `now()`, `nowUtc()`, `toDateTime()`,
  `toUtcDateTime()`, `toIso8601()` (`YYYY-MM-DDTHH:MM:SS[.uuuuuu]`),
  `Comparable<ChronoDateTime>`, `operator ==`, `hashCode`.

---

### New File: `chrono/clocks.dart`

Additional clocks beyond `SystemClock` and `SteadyClock`.

- **`Clock` (abstract interface)** — Common interface with a single `now()`
  method, enabling dependency injection of any clock implementation.
- **`MockClock implements Clock`** — Manually-controlled clock for
  deterministic testing. Time advances only through `advance(Duration)` (throws
  `ArgumentError` for negative delta), `set(Duration)`, or `reset()`. Time
  never jumps backward by accident. Analogous to the test-double pattern.
- **`HiResClock`** — Highest-resolution monotonic clock available (microsecond
  precision on native Dart). Analogous to
  `std::chrono::high_resolution_clock`.
- **`UtcClock implements Clock`** — Instantiable wall-clock that always returns
  UTC time. Analogous to `std::chrono::utc_clock` (C++20).
- **`TaiClock`** — International Atomic Time. TAI is ahead of UTC by a fixed
  `taiUtcOffsetSeconds` (37 as of January 2017). Analogous to
  `std::chrono::tai_clock` (C++20).
- **`GpsClock`** — GPS time, measured from the GPS epoch (1980-01-06 UTC). GPS
  = TAI − 19 s. Analogous to `std::chrono::gps_clock` (C++20).

---

### New File: `chrono/time_interval.dart`

- **`TimeInterval`** — Half-open `[start, end)` range of `TimePoint`s.
  - Construction: `TimeInterval(start, end)` (throws `ArgumentError` if
    `end < start`) and `TimeInterval.fromDuration(start, duration)`.
  - Properties: `duration`, `isEmpty`, `isNotEmpty`.
  - Membership: `contains(TimePoint)` (half-open), `containsClosed(TimePoint)`.
  - Set operations: `overlaps`, `intersection` (returns `null` when
    non-overlapping), `hull` (convex span), `gap` (returns `null` when
    touching/overlapping).
  - `operator ==`, `hashCode`, `toString`.

---

### New File: `chrono/lap_stopwatch.dart`

- **`LapRecord`** — Immutable record of a single lap: `number` (1-based),
  `elapsed` (total time at lap), `lapTime` (split duration). Value-type
  semantics via `const` constructor.
- **`LapStopwatch`** — Enhanced stopwatch wrapping Dart's `Stopwatch`.
  - Lifecycle: `start()`, `stop()`, `reset()`, `isRunning`, `elapsed`.
  - Laps: `lap() → LapRecord`, `laps` (unmodifiable list),
    `currentLapElapsed`.
  - Statistics: `fastestLap`, `slowestLap`, `averageLap` — all return `null`
    when no laps have been recorded.

---

### New File: `chrono/timer.dart`

- **`CountdownTimer`** — Synchronous countdown tracker. Records the wall-clock
  instant when `start()` is called and computes `remaining`, `elapsed`, and
  `progress` on demand. No async required. Throws `ArgumentError` for
  non-positive total duration.
- **`Ticker`** — `Stream<Duration>`-based periodic tick source backed by
  `Stream.periodic`. Each emitted value is `interval × tickNumber` (cumulative
  elapsed). The stream is created lazily and reused. Throws `ArgumentError` for
  non-positive intervals.

---

### Enhanced: `chrono/chrono.dart`

- **`TimePoint.epoch`** — `static const TimePoint epoch = TimePoint(Duration.zero)`;
  the Unix epoch as a `TimePoint`.
- **`TimePoint.fromDateTime(DateTime)`** — Factory: creates a `TimePoint`
  whose `timeSinceEpoch` equals `dt.microsecondsSinceEpoch`.
- **`TimePoint.toDateTime()`** — Converts to a UTC `DateTime` (inverse of
  `fromDateTime`).
- **`TimePoint.toIso8601String()`** — Delegates to `toDateTime().toIso8601String()`,
  always producing a UTC ISO 8601 string ending in `Z`.
- **`ChronoIntExtension.days`** — `Duration(days: this)`.
- **`ChronoIntExtension.weeks`** — `Duration(days: this * 7)`.
- **`DurationExtension`** on `Duration` — six new methods:
  - `humanReadable()` — omits zero components, formats as e.g. `"2h 30m 5s"`.
  - `toIso8601()` — ISO 8601 duration string, e.g. `"PT2H30M5S"`,
    `"P3D"`, `"-PT5S"`, `"PT1.5S"`.
  - `floor(Duration period)` — floors toward negative infinity (matches
    `std::chrono::floor`, C++17).
  - `ceil(Duration period)` — ceils toward positive infinity (matches
    `std::chrono::ceil`).
  - `round(Duration period)` — rounds to nearest multiple, ties toward
    positive infinity (matches `std::chrono::round`).
  - `isPositive` (getter) — `true` iff `inMicroseconds > 0`.

---

### Exports

Five new exports added to `stl.dart`:
- `src/chrono/calendar.dart`
- `src/chrono/clocks.dart`
- `src/chrono/time_interval.dart`
- `src/chrono/lap_stopwatch.dart`
- `src/chrono/timer.dart`

---

### New Tests (v0.6.5 — 5 new test files)

Added **~220 new tests** across 5 new test files, raising the total suite from
**1 528** to **~1 748 passing tests** (0 failures, 0 skips):

| File | What is covered |
|---|---|
| `test/chrono_calendar_test.dart` | `isLeapYear`, `daysInYear`; `Month` — all 12 months, arithmetic, `daysIn` leap/non-leap, error handling; `Weekday` — ISO values, weekend/weekday, arithmetic, error handling; `ChronoDate` — construction, validation, computed properties, `addDays`, `addMonths` (clamping), `addYears` (clamping), `differenceInDays`, comparison operators, equality, hashCode, ISO formatting; `ChronoTime` — construction, validation, static getters, `totalMicroseconds`, `toDuration`, `fromDateTime`, comparison, ISO formatting; `ChronoDateTime` — construction, `fromDateTime`, `toDateTime`, comparison, equality, ISO formatting |
| `test/chrono_clocks_test.dart` | `MockClock` — initial state, `advance` (cumulative, zero, negative error), `set`, `reset`, `Clock` interface, determinism; `HiResClock` — monotonicity, elapsed growth; `UtcClock` — proximity to system time, `Clock` interface, monotonicity; `TaiClock` — TAI–UTC offset verification, constant value; `GpsClock` — GPS epoch sanity check, GPS < TAI ordering; `TimePoint.epoch`, `fromDateTime`/`toDateTime` round-trip, UTC marker |
| `test/chrono_interval_test.dart` | `TimeInterval` construction (valid, empty, inverted error); `fromDuration`; `duration`, `isEmpty`, `isNotEmpty`; `contains` (start/interior/end/outside); `containsClosed`; `overlaps` (overlapping, adjacent, disjoint, contained, identical); `intersection` (overlap, null for non-overlapping/adjacent, contained, commutativity); `hull` (disjoint, overlapping, identical, commutativity); `gap` (disjoint, null for adjacent/overlapping, commutativity); equality, hashCode, toString |
| `test/chrono_stopwatch_test.dart` | `LapRecord` field storage and `toString`; `LapStopwatch` lifecycle (`isRunning`, `start`, `stop`, `reset`, elapsed); lap recording (number sequencing, count, non-decreasing elapsed, sum of lap times, unmodifiable list, `currentLapElapsed` reset); statistics (`fastestLap`/`slowestLap`/`averageLap` null guard, single-lap identity, ordering, average in range); `toString` |
| `test/chrono_timer_test.dart` | `CountdownTimer` construction errors; pre-start state; post-start (`isStarted`, `elapsed`, `remaining`, `progress` range, expiry, `remaining`→zero, `progress`→1.0); `reset`; `toString`; `Ticker` construction errors, `tick()` type, stream reuse, interval values for first and second emissions; `DurationExtension.humanReadable` (zero, seconds, compound, days, ms, negative); `toIso8601` (zero, compound, days, negative, fractional seconds, day+time); `floor`/`ceil`/`round` (exact, positive, negative, zero-period error); `isPositive`; `ChronoIntExtension.days` and `.weeks` |

### New Example

- **`example/chrono_example.dart`** — End-to-end demonstration covering all 15
  topics: duration literals, formatting, rounding, clocks, `TimePoint`
  conversions, `MockClock` with dependency injection, specialized clocks,
  calendar enums, `ChronoDate`/`ChronoTime`/`ChronoDateTime`, `TimeInterval`
  set operations, `LapStopwatch` with statistics, `CountdownTimer`, and
  `Ticker`.

---

# 0.6.4

## Bug Fixes

- **Bug Fix: `StringView.lastIndexOf` on empty view** — Calling `lastIndexOf` on a zero-length `StringView` previously threw `Invalid argument(s): 0` deep inside `int.clamp` because the expression `(start ?? length - 1)` evaluated to `-1` when `length == 0`, which is below `clamp`'s `min` argument. Fixed by adding an early-exit guard: `if (length == 0) return -1`. Now consistently returns `-1` for any pattern on an empty view, matching the documented contract.

- **Bug Fix: `Divides<int>` throws `TypeError`** — `Divides<T>.call` used Dart's `/` operator (`(a as dynamic) / (b as dynamic)`) which always produces a `double`, even when `T` is `int`. The subsequent `as T` cast therefore threw a `TypeError` at runtime whenever `T == int`. Fixed by dispatching on the type parameter: integer types now use truncating division (`~/`) so the result stays an `int`; floating-point types continue to use `/`. Truncation toward zero matches the behaviour of C++ `std::divides<int>`.

## Test Coverage (v0.6.4 — industrial-standard test suite)

Added **337 new tests** across 9 new extended test files, raising the total suite from **1 191** to **1 528 passing tests** (0 failures, 0 skips):

| File | What is covered |
|---|---|
| `test/algorithm_extended_test.dart` | All 45+ algorithm functions not previously tested (`allOf`, `anyOf`, `noneOf`, `forEach`, `forEachN`, `count`, `countIf`, `find*`, `search*`, `mismatch`, `fill`, `generate`, `replace`, `remove`, `swapRanges`, `isSorted`, `isSortedUntil`, `stableSort`, `nthElement`, `partialSort`, `minElement`, `maxElement`, `equal`, `isPermutation`, `lexicographicalCompare`, full heap suite, `isPartitioned`, `partitionPoint`, `merge`, `inplaceMerge`, `clampRange`, `setSymmetricDifference`); plus empty-list and custom-comparator edge cases for all previously-tested functions |
| `test/string_view_extended_test.dart` | Bounds checking (`operator[]`, `substring`, constructor); empty-string behaviour; equality & `hashCode`; `split` edge cases (empty delimiter, consecutive delimiters, leading delimiter); `lastIndexOf` edge cases; `toUpperCase`/`toLowerCase`; `toString` on slices |
| `test/exceptions_extended_test.dart` | `toString` format for all 8 concrete exception classes; empty-message contract; catchability by base type (`LogicError`, `RuntimeError`, `StdException`, `Exception`); `what()` mirrors `message` verbatim |
| `test/chrono_extended_test.dart` | `TimePoint` equality, `hashCode`, negative-duration subtraction, zero subtraction, `compareTo`, `<=`/`>=` with equal values, `toString`; `ChronoIntExtension` zero/negative helpers; `SteadyClock` strict monotonicity invariant |
| `test/ratio_extended_test.dart` | `toString`; mixed-sign arithmetic (crossing zero, negative×positive, divide-by-negative); comparison across signs; chain operations `(1/2 + 1/3) × 6 = 5`; reciprocal of reciprocal; double-negate; `abs` of negate |
| `test/functional_extended_test.dart` | `Plus` identity law; `Multiplies` zero and identity; `Minus` identity and self-cancellation; `Divides` integer quotient, double result, divide-by-zero; `Modulus` edge cases; `Negate` consistency with `Minus(0,x)`; comparison complement relationships (`EqualTo`⟺`NotEqualTo`, `Greater`⟺`LessEqual`, `Less`⟺`GreaterEqual`); bitwise identities (`BitAnd(x,~x)==0`, `BitOr(x,~x)==-1`, `BitXor(x,x)==0`, `BitXor(x,0)==x`); De Morgan laws for `LogicalAnd`/`LogicalOr`/`LogicalNot`; `invoke` with named-only, mixed, and typed-result calls |
| `test/iterator_extended_test.dart` | `ReverseIterator` on empty list, single element, re-iteration (two passes), non-mutation of source; `BackInsertIterator` on empty list, `close()` no-op, `Deque` path; `FrontInsertIterator` empty list, `close()` no-op, `SList` `pushFront` path; `InsertIterator` prepend at 0, middle insert, `close()` no-op |
| `test/expected_extended_test.dart` | `toString`; monad laws (left identity, right identity, associativity — both value and error branches); same-type `T==E` value-vs-error inequality; `valueOr`; functor laws (identity, composition, error pass-through); `fold` branch exclusivity and return-type inference |
| `test/optional_extended_test.dart` | Monad laws (left identity, right identity, associativity with None short-circuit); `flatMap` on None never calls mapper; `flatMap` returning None; functor laws (identity for Some and None, composition); `filter` (always-true, always-false, None branch); all four `zip` combinations; `ofNullable` with non-null and null; `toString` (`Some(x)`, `None`); `hashCode` for equal Some, all-None, Some-vs-None; `valueOr` on Some and None |

# 0.6.3
- **Bug Fix:** Replaced `assert(den != 0, ...)` in `Ratio`'s constructor with an explicit `if (den == 0) throw ArgumentError(...)`. The previous `assert` was silently stripped in production (AOT/release) builds, allowing `Ratio(1, 0)` to be created without error. The constructor is no longer `const`; all 16 SI prefix constants (`atto` … `exa`) are now `static final` instead of `static const`.
- **Bug Fix:** Changed `Pair.swap()` from a mutating `void swap(Pair<T1,T2> other)` that exchanged contents in-place, to a pure `Pair<T2, T1> swap()` that returns a new pair with the types and values reversed. The old signature contradicted the immutable design shared by every other utility type. Existing call sites that expected mutation will need to be updated.
- **New Method:** Added `Expected<U, E> flatMap<U>(Expected<U, E> Function(T value) mapper)` to `Expected<T, E>` — chains operations that themselves return `Expected`, short-circuiting on the first error exactly like `std::expected::and_then` (C++23). Without this, chaining required manual `hasValue` checks and nesting.
- **New Method:** Added `R fold<R>(R Function(T value) onValue, R Function(E error) onError)` to `Expected<T, E>` — reduces an `Expected` to a single value by supplying handlers for both the value and error branches. Completes the standard functor/monad API alongside the existing `map` and the new `flatMap`.
- **New Feature:** Added bitwise logical operators to `BitSet` — `operator &` (AND), `operator |` (OR), `operator ^` (XOR), and `operator ~` (NOT/complement). All binary operators require both operands to have the same `size()`; a mismatched length throws `ArgumentError`. `operator ~` returns a new `BitSet` with every bit flipped (unused high bits in the final word are masked off correctly). These were the primary missing operations for a bit-manipulation container.
- **New Method:** Added three functional methods to `Optional<T>`:
  - `R fold<R>(R Function(T) onSome, R Function() onNone)` — reduces an `Optional` to a single value using one of two supplied branches, the dual of `map` for unwrapping.
  - `Optional<T> filter(bool Function(T) predicate)` — returns `None` when the predicate returns `false` for a `Some` value, leaving `None` unchanged. Equivalent to Haskell's `mfilter` / Java's `Optional.filter`.
  - `Optional<(T, R)> zip<R>(Optional<R> other)` — combines two `Optional` values into an `Optional` of a Dart 3 record; returns `None` if either operand is `None`.
- **New Method:** Added five methods to `Ratio`, completing its numeric API:
  - `int compareTo(Ratio other)` + operators `<`, `<=`, `>`, `>=` — `Ratio` now implements `Comparable<Ratio>`. Comparison is performed on simplified canonical forms by cross-multiplying numerators to avoid floating-point error.
  - `Ratio negate()` — returns `Ratio(-num, den)` in simplified form.
  - `Ratio reciprocal()` — returns `Ratio(den, num)` in simplified form. Throws `ArgumentError` if `num` is zero.
  - `Ratio abs()` — returns the absolute value in simplified form.
- **New Method:** Added five methods to `StringView`, completing its read-only string API:
  - `int compareTo(StringView other)` + operators `<`, `<=`, `>`, `>=` — `StringView` now implements `Comparable<StringView>`. Comparison uses the same lexicographic ordering as `std::string_view::compare`.
  - `int lastIndexOf(String pattern, [int? start])` — reverse linear scan returning the last position of `pattern`; returns `-1` if not found. Mirrors the existing `indexOf`.
  - `List<StringView> split(String delimiter)` — splits the view on `delimiter` and returns a list of zero-allocation `StringView` sub-views into the same backing string (no new `String` allocations).
  - `String toUpperCase()` — returns a new `String` with all characters uppercased (delegates to the Dart runtime for correct Unicode handling).
  - `String toLowerCase()` — returns a new `String` with all characters lowercased.
- **New Method:** Added two navigation methods to `Zipper<T>`:
  - `Zipper<T> moveTo(int index)` — repositions the cursor to an absolute 0-based index in O(N). Throws `RangeError` if `index` is out of bounds. More ergonomic than calling `moveLeft`/`moveRight` repeatedly when the target index is known.
  - `Zipper<T>? find(bool Function(T) predicate)` — scans forward from the current `focus` (inclusive) and returns a new `Zipper` focused on the first matching element, or `null` if no match is found. Does not wrap around.
- **API Fix:** Changed `Any.hasValue()` from a method to a getter (`bool get hasValue`). Every other utility with a presence check (`Optional.isPresent`, `Expected.hasValue`, `Validated.isValid`) exposes it as a getter; `Any` was the sole inconsistency. **Breaking change** — call sites must drop the `()`.

# 0.6.2
- **New Feature:** Added 6 Haskell-inspired functional types across three modules, expanding the library beyond C++ STL 
  - **`NonEmptyList<T>`** (`collections`) — Immutable singly-linked structure mirroring Haskell's `NonEmpty a = a :| [a]`. Guarantees at least one element at the type level, eliminating null-checks on `first`/`last`. Supports `map`, `flatMap`, `reduce`, `fold`, `prepend`, `append`, `concat`, and implements `Iterable<T>`.
  - **`NonEmptyVector<T>`** (`collections`) — Mutable non-empty wrapper over the existing `Vector<T>`. Preserves the non-empty invariant on every `removeAt` call, throwing `InvalidArgument` if removal would empty the container. `first` and `last` are always non-nullable.
  - **`FingerTree<T>`** (`collections`) — Full persistent 2-3 finger tree with O(1) amortized `prepend`/`append`, O(log n) `concat` and `splitAt`, and O(1) `length` via size annotations. Based on Hinze & Paterson (2006). Entirely immutable; all operations return new instances.
  - **`Validated<E, A>`** (`utilities`) — Error-accumulating result type sealed into `Valid<E,A>` and `Invalid<E,A>`. Unlike `Expected<T,E>` which short-circuits on the first error, `Validated.zip()` collects errors from both sides simultaneously, making it ideal for form/data validation pipelines. Provides `map`, `mapError`, `andThen`, `zip`, `valueOr`.
  - **`Zipper<T>`** (`utilities`) — Immutable cursor-based navigation over a sequence, inspired by Huet's Zipper (1997). Maintains `left` (reversed context), `focus`, and `right` lists. All navigation (`moveLeft`, `moveRight`, `replace`, `insert`, `delete`) returns a new `Zipper<T>` instance. `toList()` reconstructs the full sequence at any point.
  - **`StateMonad<S, A>`** (`functional`) — Pure stateful computation wrapper encapsulating `(A, S) Function(S)`. Supports `map`, `flatMap` for monadic chaining, and static constructors `pure`, `get`, `put`, and `modify` for common state operations. `run(s)` executes and returns a Dart 3 record `(value, state)`. Use `eval` / `exec` to extract only the value or only the final state.

# 0.6.1
- **New Method:** Added `toBigInt()` to all 16 primitive types — converts the typed primitive to a [BigInt]. For `U64` and `Uint64`, uses `.toUnsigned(64)` to correctly reinterpret the signed bit-pattern as an unsigned value (e.g. `U64(-1).toBigInt()` returns `18446744073709551615`).
- **New Method:** Added `static T fromBigInt(BigInt v)` to all 16 primitive types — constructs a typed primitive from a [BigInt], throwing a [RangeError] if the value falls outside the type's representable range. `U64.fromBigInt` and `Uint64.fromBigInt` accept the full `[0, 2^64)` range and correctly handle values that straddle the signed boundary.
- **New Method:** Added `negChecked()` to all 8 signed primitive types (`I8`, `I16`, `I32`, `I64`, `Int8`, `Int16`, `Int32`, `Int64`) — returns the negated value or throws a [StateError] if this equals the type's minimum value (the only value whose negation overflows; e.g. `I8(-128).negChecked()` throws, `I8(-127).negChecked()` returns `I8(127)`). Unsigned types deliberately omit this method since they have no unary negation operator.
- **New Method:** Added `wideningMul(T other)` to all 16 primitive types — multiplies two values of the same type and returns the result in the next wider type to prevent overflow. The signed chain is `I8 × I8 → I16`, `I16 × I16 → I32`, `I32 × I32 → I64`, `I64 × I64 → BigInt`; the unsigned chain mirrors it as `U8 × U8 → U16`, …, `U64 × U64 → BigInt`. The heap-allocated family follows the same chain (`Int8 → Int16 → … → BigInt`, `Uint8 → Uint16 → … → BigInt`). The 64-bit types return `BigInt` since no 128-bit primitive exists.

# 0.6.0
- **Bug Fix:** Fixed `Uint64.mulChecked` returning a native Dart `int` multiplication result after BigInt validation — the final return now uses the BigInt-derived value to prevent silent silent truncation discrepancies.
- **Bug Fix:** Fixed `Uint64.addChecked` using a signed Dart `int` comparison (`result < value`) which fails for values near $2^{63}$; now uses the same XOR-based unsigned comparison already used by the `<`/`<=`/`>`/`>=` operators.
- **Bug Fix:** Added missing `mulChecked` to `Int64` — the heap-allocated variant had `addChecked` and `subChecked` but `mulChecked` was entirely absent.
- **Missing Operator:** Added unsigned right-shift `operator >>>` to all heap-allocated signed variants (`Int8`, `Int16`, `Int32`, `Int64`) to match parity with the zero-cost signed types.
- **Missing Operator:** Added unary negation `operator -()` to all heap-allocated signed variants (`Int8`, `Int16`, `Int32`, `Int64`) — only the zero-cost signed types had it.
- **Missing Method:** Added `divChecked` to all 16 primitive types — guards against division by zero and the signed-overflow edge case (`I8(-128) ~/ I8(-1)` wraps silently without it).
- **Missing Feature:** Added saturating arithmetic to all 16 primitive types — `saturatingAdd`, `saturatingSub`, `saturatingMul` — clamping to `[min, max]` instead of wrapping or throwing, matching C++ SIMD intrinsics and Rust's saturating integer API.
- **Missing Feature:** Added C++20/23 bit-manipulation intrinsics to all 16 primitive types — `countOneBits()` (popcount / `std::popcount`), `countLeadingZeros()` (`std::countl_zero`), `countTrailingZeros()` (`std::countr_zero`), `rotateLeft(int n)` / `rotateRight(int n)` (`std::rotl` / `std::rotr`), and `byteSwap()` (`std::byteswap` C++23).
- **Missing Feature:** Added cross-type conversion methods to all 16 primitive types — `toI8()`, `toI16()`, `toI32()`, `toI64()`, `toU8()`, `toU16()`, `toU32()`, `toU64()` on the zero-cost family; and `toInt8()`, `toInt16()`, `toInt32()`, `toInt64()`, `toUint8()`, `toUint16()`, `toUint32()`, `toUint64()` on the heap family.
- **Missing Utility:** Added `toBinaryString()` and `toHexString()` to all 16 primitive types — `toBinaryString()` returns the value zero-padded to its type width (e.g. `I8(10)` → `"00001010"`); `toHexString()` returns the uppercase zero-padded hex representation (e.g. `I8(10)` → `"0A"`).
- **Missing Constant:** Added `static const int bits` to all 16 primitive types — exposes the bit-width as a first-class constant (`I8.bits == 8`, `U32.bits == 32`, etc.) enabling generic and self-documenting code.
- **Return-Type Bug:** Overrode `abs()` on all zero-cost signed types (`I8`, `I16`, `I32`, `I64`) — because they `implements int`, the inherited `abs()` returns `int`, not the typed primitive. Each now returns the correct narrowed type.
- **API Footgun:** Added `I8.wrapping(int)`, `I16.wrapping(int)`, `I32.wrapping(int)`, `I64.wrapping(int)` (and unsigned equivalents) named constructors on all zero-cost types — the primary constructor does not truncate, so `I8(200)` silently holds an out-of-range value; the `.wrapping()` constructor applies the appropriate `.toSigned(N)` / `.toUnsigned(N)` on entry.
- **Inconsistency Fix:** Standardised overflow error messages across all 16 types — all `addChecked` errors now read `"T addition overflow"`, `subChecked` errors read `"T subtraction underflow"` (unsigned) or `"T subtraction overflow"` (signed), and `mulChecked` errors read `"T multiplication overflow"`, eliminating the mixed `"overflow/underflow"` phrasing.
- **Inconsistency Fix:** Added missing class-level API doc comments to `I32` and `I64`; added missing operator-level doc comments to `I32`, `I64`, `U8`, `U16`, `U32`, and `U64` to bring documentation coverage to parity with `I8` and `I16`.

# 0.5.9
- **New Feature:** Massively expanded `geometry` module into a **full-featured computational geometry and linear algebra library**, going far beyond the C++ standard to rival CGAL and GLM. The module now covers 2D shapes, 3D primitives, linear algebra, and computational geometry algorithms — the flagship non-C++ feature of the package.
  - **Enriched 2D Primitives:**
    - **`Point<T>`** — added `midpointTo()`, `angleTo()`, `normalize()`, `cross()` (2D scalar cross product $x_1 y_2 - y_1 x_2$), `lerp()`, `operator/`
    - **`Triangle`** — added `circumcenter`, `incenter`, `circumradius`, `inradius`, `isAcute`, `isRight`, `isObtuse`, `isEquilateral`, `isIsoceles`, `isScalene`, `angleA`, `angleB`, `angleC`
    - **`Circle`** — added `containsPoint()`, `intersectsCircle()`, `tangentLength()`, `circumference` alias
    - **`Polygon`** — added `isConvex`, `containsPoint()` (ray-casting algorithm), area-weighted proper centroid
    - **`Rectangle`** — added `containsPoint()`, `intersects()`, `corners` getter (all 4 vertices)
  - **New 2D Structures:**
    - **`Ray2D`** — semi-infinite ray with `origin`, `direction`, `at(t)`, `intersectSegment()`, `intersectCircle()`
    - **`Capsule`** — stadium/discorectangle shape via a `LineSegment` spine + radius; `area`, `perimeter`, `containsPoint()`
    - **`Arc`** — circular arc sector via `center`, `radius`, `startAngle`, `endAngle`; `arcLength`, `chordLength`, `containsAngle()`
    - **`QuadraticBezier`** — degree-2 Bézier curve: `evaluate(t)`, `derivative(t)`, `arcLength(segments)`, `splitAt(t)`
    - **`CubicBezier`** — degree-3 Bézier curve: `evaluate(t)`, `derivative(t)`, `arcLength(segments)`, `splitAt(t)`
  - **New 3D Primitives:**
    - **`Point3D`** — full 3D vector: `+`, `-`, `*`, `/`, `dot()`, `cross()`, `magnitude`, `normalize()`, `distanceTo()`, `lerp()`, `midpointTo()`, `angleTo()`
    - **`Sphere3D`** — `center`, `radius`, `volume` ($\frac{4}{3}\pi r^3$), `surfaceArea` ($4\pi r^2$), `containsPoint()`, `intersectsSphere()`
    - **`Plane3D`** — defined by `normal` + `distance`; `distanceTo(Point3D)`, `containsPoint()`, `reflect()`, `project()`
    - **`Ray3D`** — 3D semi-infinite ray: `origin`, `direction`, `at(t)`, `intersectSphere()`, `intersectPlane()`
    - **`Triangle3D`** — 3D triangle: `normal`, `area`, `centroid`, `containsPoint()` (barycentric test), `toTriangle()`
  - **New Linear Algebra:**
    - **`Matrix2x2`** — 2×2 matrix: `+`, `*` (matrix & scalar), `determinant`, `inverse`, `transpose`, `identity()`, `rotation(angle)`
    - **`Matrix3x3`** — 3×3 matrix: full arithmetic, `determinant`, `inverse` (cofactor expansion), `transpose`, `identity()`, `rotationX/Y/Z(angle)`
    - **`Matrix4x4`** — 4×4 homogeneous matrix: `identity()`, `translation()`, `scale()`, `rotationX/Y/Z()`, `perspective()`, `multiply()`, `transform(Point3D)`
    - **`Quaternion`** — unit quaternion for 3D rotation: `*`, `conjugate`, `inverse`, `normalize`, `dot()`, `slerp()`, `fromAxisAngle()`, `toMatrix3x3()`, `toEulerAngles()`
  - **New Computational Geometry Algorithms (`geometry_algorithms.dart`):**
    - **`convexHull(List<Point>)`** — Graham scan — $O(n \log n)$
    - **`closestPairOfPoints(List<Point>)`** — divide-and-conquer — $O(n \log n)$, returns `Pair<Point, Point>`
    - **`segmentIntersection(LineSegment, LineSegment)`** — parametric intersection test, returns `Point?`
    - **`pointInPolygon(Point, Polygon)`** — ray-casting algorithm — $O(n)$
    - **`triangulate(Polygon)`** — ear-clipping triangulation — $O(n^2)$, returns `List<Triangle>`
- **New Example:** `example/geometry_example.dart` — end-to-end showcase covering 2D/3D shapes, Bézier evaluation, quaternion rotation, convex hull, ray–sphere intersection, and a full 3D matrix transform pipeline.
- **Documentation:** Perfect API documentation coverage for all new and enriched APIs, covering every public member across all 14 new files and 5 enriched files.

# 0.5.8
- **New Feature:** Expanded `<ranges>` module with **6 new C++20/23 range views**, completing the core `std::views` surface alongside the existing 16 range adapters. All view names and semantics follow ISO/IEC 14882:2023 and the `range-v3` reference implementation.
  - **`IotaRange`** — `std::views::iota`: yields a lazy integer sequence `[start, end]`. When `end` is omitted the range is infinite. Throws `ArgumentError` if `end` is less than `start`.
  - **`SingleRange<T>`** — `std::views::single`: wraps exactly one value as a one-element range. Composes cleanly with every other range adapter.
  - **`SplitRange<T>`** — `std::views::split`: splits an iterable on a delimiter element, yielding each segment as a `List<T>`. Consecutive delimiters produce empty lists; a trailing delimiter produces a final empty list.
  - **`ChunkByRange<T>`** — `std::views::chunk_by`: groups consecutive elements into `List<T>` chunks as long as a binary predicate `pred(prev, curr)` holds, breaking into a new chunk when it fails.
  - **`KeysRange<K, V>`** — `std::views::keys`: extracts the key from each `Pair<K, V>` in an iterable, composing naturally with `HashMap`, `SortedMap`, and `MultiMap`.
  - **`ValuesRange<K, V>`** — `std::views::values`: extracts the value from each `Pair<K, V>` in an iterable, the dual complement of `KeysRange`.
- **Documentation:** Perfect API documentation coverage for all 6 new views with C++23 standard cross-references, covering every public member (class, constructor, fields, methods, and `iterator` getter).

# 0.5.7
- **New Feature:** Expanded `<ranges>` module with **6 new C++20/23 range views**, completing the core `std::views` surface alongside the existing 10 range adapters. All view names and semantics follow ISO/IEC 14882:2023 and the `range-v3` reference implementation.
  - **`EnumerateRange<T>`** — `std::views::enumerate`: yields index–element `Pair<int, T>` tuples (0-based) for any iterable, eliminating manual counter variables.
  - **`StrideRange<T>`** — `std::views::stride`: yields every Nth element of an iterable. Throws `ArgumentError` on non-positive stride.
  - **`SlideRange<T>`** — `std::views::slide`: yields overlapping windows of size N as `List<T>`. Produces no output when the source has fewer elements than the window size.
  - **`PairwiseRange<T>`** — `std::views::pairwise` / `std::views::adjacent<2>`: yields consecutive element pairs as `Pair<T, T>`, the typed specialisation of `SlideRange` for N = 2.
  - **`ReverseRange<T>`** — `std::views::reverse`: yields elements of any iterable in reverse order.
  - **`CycleRange<T>`** — `std::views::cycle` (range-v3 / C++23 proposed): repeats an iterable indefinitely, or for an optional fixed number of full cycles. Throws `ArgumentError` on an empty source iterable.
- **Documentation:** Perfect API documentation coverage for all 6 new views with C++23 standard cross-references.

# 0.5.6
- **New Feature:** Massively expanded `<algorithm>` module from 13 to **60+ functions**, implementing the near-complete C++23 `<algorithm>` standard surface. All function names and semantics follow ISO/IEC 14882:2023. New additions:
  - **Non-modifying Sequence Operations:** `allOf`, `anyOf`, `noneOf` (universal/existential quantifiers); `forEach`, `forEachN` (element-wise application); `count`, `countIf` (element counting); `mismatch` (range divergence); `find`, `findIf`, `findIfNot` (element search); `findEnd` (last subsequence occurrence); `findFirstOf` (first element from a target set); `adjacentFind` (consecutive-duplicate search); `search`, `searchN` (subsequence and run-of-N search)
  - **Modifying Sequence Operations:** `copy`, `copyIf`, `copyN`, `copyBackward` (copy variants); `fill`, `fillN` (range filling); `transform`, `transformBinary` (unary and binary element transformation); `generate`, `generateN` (generator-based filling); `replace`, `replaceIf`, `replaceCopy`, `replaceCopyIf` (replacement variants); `remove`, `removeIf`, `removeCopy`, `removeCopyIf` (removal and compaction); `shuffle` (Fisher-Yates in-place shuffle); `sample` (reservoir sampling — selects N random elements); `swapRanges` (swap two equal-length ranges)
  - **Sorting Operations:** `isSorted`, `isSortedUntil` (sorted-order inspection); `stableSort` (order-preserving merge sort — $O(N \log^2 N)$); `nthElement` (quickselect — $O(N)$ average); `partialSort` (smallest-N in sorted order)
  - **Min / Max Operations:** `minElement`, `maxElement`, `minMaxElement` (single-pass min, max, and both via `Pair`)
  - **Comparison Operations:** `equal` (element-wise range equality); `isPermutation` (multiset equivalence check); `lexicographicalCompare` (three-way lexicographic ordering)
  - **Heap Operations:** `makeHeap` (build max-heap in-place); `pushHeap` (sift-up insert); `popHeap` (swap-top-to-end + sift-down); `sortHeap` (heapsort); `isHeap`, `isHeapUntil` (heap property inspection)
  - **Partition Utilities:** `isPartitioned` (partition predicate check); `partitionCopy` (split into two lists via `Pair`); `partitionPoint` (binary-search partition boundary — $O(\log N)$)
  - **Additional Set Operations:** `setSymmetricDifference` (elements in either but not both sorted ranges)
  - **Merge Operations:** `merge` (merge two sorted ranges keeping all duplicates); `inplaceMerge` (merge two consecutive sorted sub-ranges in-place)
  - **Utility:** `clampRange` (clamps every element of a list into `[low, high]`)
- **New Example:** `example/algo.dart` — end-to-end showcase of algorithm + collections interplay covering search, sort, heap, partition, set ops, transform, and merge.
- **Documentation:** Achieved perfect API documentation coverage for all 60+ functions, with C++23 standard cross-references and $O$ complexity annotations on every algorithm.

# 0.5.5
- **New Feature:** Massively expanded `<cmath>` module from 20 to **100 functions**, covering the full C++23 `<cmath>` surface and ISO/IEC 29124 special mathematical functions. All function names and semantics follow ISO 80000-2 and IEC 60559. New additions:
  - **Trigonometric (ISO 80000-2):** `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`
  - **Hyperbolic (ISO 80000-2):** `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`
  - **Exponential & Logarithmic:** `exp`, `exp2`, `expm1`, `log`, `log1p`
  - **Power & Root:** `pow`, `sqrt`
  - **Rounding (IEC 60559):** `floor`, `ceil`, `round`, `nearbyInt`
  - **Arithmetic:** `abs`, `fdim`, `fmax`, `fmin`
  - **Floating-Point Decomposition:** `remainder`, `scalbn`, `ldexp`, `frexp`, `modf`, `ilogb`, `logb`
  - **Floating-Point Classification (IEC 60559):** `isNaN`, `isFinite`, `isInfinite`, `isNormal`, `signBit`
  - **Error & Gamma Functions:** `erf`, `erfc`, `tgamma`, `lgamma`
  - **Interpolation Extras:** `smootherstep`, `quinticStep`, `bilerp`, `pingpong`, `moveTowards`
  - **Angle & Signal Utilities:** `wrapAngle`, `angleDiff`, `sinc`, `normalizedSinc`
  - **Combinatorial & Integer Math:** `factorial`, `fallingFactorial`, `risingFactorial`, `binomial`
  - **Special Mathematical Functions (ISO/IEC 29124 / C++17):** `beta`, `legendre`, `assocLegendre`, `hermite`, `laguerre`, `assocLaguerre`, `riemannZeta`, `sphBessel`, `sphNeumann`, `sphLegendre`, `cylBesselJ`, `cylBesselI`, `cylBesselK`, `cylNeumann`, `expInt`, `compEllint1`, `compEllint2`, `compEllint3`, `ellint1`, `ellint2`, `ellint3`
- **Documentation:** Achieved perfect API documentation coverage for all 100 functions with ISO/C++ standard cross-references.

# 0.5.4
- **New Feature:** Massively expanded `<cmath>` module with 20 new functions: `sign`, `degrees`, `radians`, `fma`, `smoothstep`, `remap`, `saturate`, `step`, `cbrt`, `log2`, `log10`, `trunc`, `fmod`, `fract`, `copySign`, `nearlyEqual`, `square`, `cube`, `isPowerOfTwo`, and `nextPowerOfTwo`. Full API documentation, test coverage, and example coverage for all additions.
- **Documentation:** Achieved perfect API documentation coverage for all newly implemented functions.


# 0.5.3
- **New Feature:** Implemented `<chrono>` module providing highly portable, C++-style `SystemClock` and `SteadyClock` APIs for time tracking and precise benchmarking across Native and Web platforms.
- **New Feature:** Implemented `<ratio>` module via `Ratio` class providing exact rational arithmetic (`num`/`den`) and standard SI prefix constants (`milli`, `micro`, `nano`, etc.) for type-safe time duration computations.
- **New Feature:** Implemented `<iterator>` module introducing C++-inspired iterator adapters: `ReverseIterator`, `InsertIterator`, `BackInsertIterator`, and `FrontInsertIterator` bridging seamlessly with `Vector` and `Deque`.
- **Documentation:** Achieved perfect API documentation coverage for all newly implemented structures.

# 0.5.2
- **New Feature:** Implemented `<random>` module providing a native `StdRandom` class for C++-style random number generation. Features support for deterministic seeding (`seed()`), bounded integer ranges (`range()`), and state advancement (`flush()`).
- **Documentation:** Achieved perfect 100.0% API documentation coverage (1184 out of 1184 API elements fully documented).

# 0.5.1
- **New Feature:** Implemented `<functional>` module containing C++ standard function objects (`Plus`, `Minus`, `EqualTo`, `LogicalAnd`, `BitAnd`, etc.) and `invoke` utility.
- **New Feature:** Implemented `<stdexcept>` module providing native Dart mapping for C++ standard exceptions (`LogicError`, `RuntimeError`, `InvalidArgument`, `OutOfRange`, etc.).

# 0.5.0
- **New Feature:** Expanded the `utilities` module with `Tuple`, a native adapter mimicking C++ `std::tuple`. Seamlessly bridges heterogeneous records and collections using Dart 3.
- Added missing API docs


# 0.4.9
- **New Feature:** Implemented `Expected<T, E>` functional wrapper representing either an expected value `T` or an error `E`. Mimics C++23 `<expected>` for robust error handling without exceptions.
- **Refactor:** Renamed `utility` module to `utilities` to better reflect standard naming conventions across the package ecosystem.

# 0.4.8
- **Technical Documentation Update:** Completely redesigned the `README.md` to beautifully showcase the massive capabilities of `stl` in a unified, visually categorized layout utilizing intuitive colored badges.

# 0.4.7
- Expanded the `geometry` module with an advanced Curiously Recurring Template Pattern (CRTP) type system: `Shape<T extends Shape<T>>`.
- Added beautiful affine transformations (`translate`, `scale`, `rotate`) to all geometric shapes natively via the type system.
- Enhanced `Point` with core vector mathematics (`+`, `-`, `*`, `magnitude`, `dotProduct`).
- Added new highly-mathematical structures: `Polygon` (Shoelace formula), `Ellipse` (Ramanujan perimeter approximation), and `LineSegment`.
- Redesigned `Triangle` internally to be strictly coordinate-based via `Point` vertices to natively support translations and rotational space.
- Fixed `pubspec.yaml` description length validation.

# 0.4.6
- Added `SortedMap<K, V>`: A strictly sorted associative container mapping keys to values (equivalent to C++ `std::map`).
- Added `MultiMap<K, V>`: An associative container mapping keys to multiple values while maintaining sorted key order (equivalent to C++ `std::multimap`).
- Added `SList<T>`: A high-performance doubly-linked list enabling $O(1)$ bidirectional manipulations (equivalent to C++ `std::list`).
- Added `StringView`: A non-owning string reference utility for zero-allocation substring and text-processing operations (equivalent to C++ `std::string_view`).
- Extensively expanded example coverage and full dartdoc api documentation.

# 0.4.5
- Implemented the `<algorithm>` module, bringing powerful C++ standard algorithms to Dart iterables.
- Features:
    - **Binary Search / Bounds:** `lowerBound`, `upperBound`, `binarySearch`, `equalRange`.
    - **Permutations:** `nextPermutation`, `prevPermutation`.
    - **Set Operations:** `setUnion`, `setIntersection`, `setDifference`.
    - **Mutations:** `rotate`, `reverse`, `unique`, `partition`, `stablePartition`.

# 0.4.4
- Implemented `MultiSet` and `HashMap` in `collections` module.
- `HashMap<K, V>`: An unordered collection of key-value pairs utilizing a fast hash table under the hood (equivalent to C++ `std::unordered_map`). Allows seamless iteration yielding `<utility>` `Pair<K, V>` instances.
- `MultiSet<T>`: An ordered collection that allows duplicate elements (equivalent to C++ `std::multiset`). Implemented natively over an O(log N) tree structure.

# 0.4.3
- Implemented the Euclidean `geometry` module containing fundamental 2D shapes managed via strict `{required}` named parameters.
- Features:
    - `Point`: Exact 2D coordinate `(x, y)` computing Euclidean geometry intelligently.
    - `Shape`: Abstract base component enforcing polymorphic `area` and `perimeter` properties.
    - `Circle`: Evaluates pi-bound area and circumference.
    - `Rectangle`: Standard rectangular dimensions logic.
    - `Triangle`: Enforces Triangle Inequality Theorem natively preventing mathematically impossible geometries while solving area via Heron's Formula.

# 0.4.2
- Implemented C++ `<cmath>` inspired mathematical utilities via `cmath.dart`.
- Features:
    - `clamp`: Binds a value between a lower and upper limit (C++17).
    - `lerp`: Linear interpolation between two values (C++20).
    - `hypot`: Computes the hypotenuse robustly without overflow or underflow (C++17).

# 0.4.1
- Comprehensive documentation coverage: Added missing API doc comments to iterables, numbers, mathematical variants, and heavily used primitive structures. Library now yields zero `public_member_api_docs` analyzer warnings, over 100 issues resolved,  (98.0 %) have documentation comments

# 0.4.0
- Improved documentation across all math modules (`complex.dart`, `number_theory.dart`, `numeric.dart`).

## 0.3.9
- Implement C++ <numeric> algorithms for collections.
- Features: 
    - accumulate: Sums up / folds elements.
    - reduce: Similar to accumulate, but with potentially different semantics (parallelizable if ever needed, or just standard fold).
    - inner_product: Computes the inner product (dot product) of two ranges.
    - adjacent_difference: Computes the differences between adjacent elements.
    - partial_sum: Computes the prefix sums.
    - iota: Fills a range with successively increasing values.
- A complete, high-performance C++-style Complex number class.
    - Features: 
        - Real and imaginary parts (real(), imag()).
        - Arithmetic operator overloading (+, -, *, /).
        - Complex functions: abs() (magnitude), arg() (phase), conj() (conjugate), norm() (squared magnitude).
        - Polar representation constructors.

- Description: Common number theory algorithms.
    - Features: 
        - gcd: Greatest Common Divisor (highly optimized).
        - lcm: Least Common Multiple.
        - midpoint: Find midpoint (a + b)/2 safely without overflow.
        - is_prime: Check if a number is prime.
        - prime_factorization: Get the prime factors of a number.

## 0.3.8
- Created `lib/src/math/constant/constant.dart` with 26 constants across these groups, all named per ISO 80000-2 conventions

## 0.3.7
- Added small improvement to already existing features and increase documentation
- No need feature- improve examples

## 0.3.6
- Renamed primitive type wrappers (`i8`, `i16`, `i32`, `i64`, `u8`, `u16`, `u32`, `u64`) to their capitalized equivalents (`I8`, `I16`, `I32`, `I64`, `U8`, `U16`, `U32`, `U64`) to align with Dart conventions.
- Added `Int8`, `Int16`, `Int32`, `Int64`, `Uint8`, `Uint16`, `Uint32`, and `Uint64` structured explicitly around `dart:typed_data`. These variants guarantee deep C++ matching arithmetic wrapping natively via memory boundaries, flawlessly bridging stable 64-bit precision boundaries correctly across Javascript/Web targets dynamically.

## 0.3.5
- Implemented `i8` zero-cost primitive type extension with auto-wrapping arithmetic and checked bounds.
- Implemented `i16` zero-cost primitive type extension with auto-wrapping arithmetic and checked bounds.
- Implemented `i32` zero-cost primitive type extension with auto-wrapping arithmetic and checked bounds.
- Implemented `i64` zero-cost primitive type extension with auto-wrapping arithmetic, checked bounds, and strict two's complement sign management.
- Implemented `u8` zero-cost unsigned primitive type extension.
- Implemented `u16` zero-cost unsigned primitive type extension.
- Implemented `u32` zero-cost unsigned primitive type extension.
- Implemented `u64` zero-cost unsigned primitive type extension utilizing native bitwise overrides and BigInt scaling for deep divisions.

## 0.3.4
- Make improvement to the `NumberLine` class.
- Added `operator ==` and `hashCode` to `NumberLine` class.
- Added `toString()` to `NumberLine` class.
- Added `reset()` method to `NumberLine` class.
- Added `empty()` method to `NumberLine` class.
- Added `hasValue()` method to `NumberLine` class.
- Added `type()` method to `NumberLine` class.
- Added `cast<T>()` method to `NumberLine` class.
- Added `set()` method to `NumberLine` class.
- Added `get()` method to `NumberLine` class.
- Added `operator []` to `NumberLine` class.
- Added `operator []=` to `NumberLine` class.
- Added `operator +` to `NumberLine` class.
- Added `operator -` to `NumberLine` class.
- Added `operator *` to `NumberLine` class.
- Added `operator /` to `NumberLine` class.
- Added `operator %` to `NumberLine` class.
- Added `operator <` to `NumberLine` class.
- Added `operator >` to `NumberLine` class.
- Added `operator <=` to `NumberLine` class.
- Added `operator >=` to `NumberLine` class.

## 0.3.3
- Added TakeRange (std::views::take)
- Added DropRange (std::views::drop)
- Added FilterRange (std::views::filter)
- Added TransformRange (std::views::transform)
- Added JoinRange (std::views::join)
- Added documentation to all the range classes.
- Added documentation to the ranges.

## 0.3.2
- Fix upload issue to-RELATED to project
- applied the @override annotation to the operator + method in array.dart
- Other minor fixes related to dart analyzer test

## 0.3.1
- Added `operator ==` and `hashCode` to `Any` class.
- Added `toString()` to `Any` class.
- Added `reset()` method to `Any` class.
- Added `empty()` method to `Any` class.
- Added `hasValue()` method to `Any` class.
- Added `type()` method to `Any` class.
- Added `cast<T>()` method to `Any` class.
- Added `set()` method to `Any` class.
- Added `get()` method to `Any` class.
- Added `operator []` to `Any` class.
- Added `operator []=` to `Any` class.
- Added `operator +` to `Any` class.
- Added `operator -` to `Any` class.
- Added `operator *` to `Any` class.
- Added `operator /` to `Any` class.
- Added `operator %` to `Any` class.
- Added `operator <` to `Any` class.
- Added `operator >` to `Any` class.
- Added `operator <=` to `Any` class.
- Added `operator >=` to `Any` class.
- Added `operator ==` to `Array` class.
- Added `operator !=` to `Array` class.
- Added `operator +` to `Array` class.
- Added `operator -` to `Array` class.
- Added `operator *` to `Array` class.
- Added `operator /` to `Array` class.
- Added `operator %` to `Array` class.
- Added `operator <` to `Array` class.
- Added `operator >` to `Array` class.
- Added `operator <=` to `Array` class.
- Added `operator >=` to `Array` class.

## 0.3.0
- Added `Array<T>`: A strict, fixed-size contiguous collection conceptually mapping directly to C++ `std::array`. All expanding/shrinking mutations fiercely throw errors. Integrates extremely well using overloads `operator +` and `operator ==` logically against dynamic iterables without altering boundaries natively.

## 0.2.9
- Added `BitSet`: A space-efficient set implementation for managing boolean flags.
- Added `Var<T>`: A mutable variable wrapper for holding and updating values.
- Added `Variant<T1, T2, ...>`: A type-safe discriminated union (sum type) that can hold values of multiple different types.
- Added `Ref<T>`: A mutable reference wrapper for holding and updating values.
- Added `Box<T>`: A mutable reference wrapper for holding and updating values.
- Added `Any`: A type-safe wrapper for holding values of any type.

## 0.2.8
- Added `Optional<T>`: A functional wrapper representing possibly-absent values with methods like `valueOr` and `map`.

## 0.2.7
- Turn the stl_example.dart into a massive "Table of Contents" or complete showcase file. Import everything.

## 0.2.6
- Added Queue
- Added PriorityQueue
- Added Set
- Added HashSet
- Added SortedSet
- Standardized deep-value equality matching (`operator ==` and `hashCode`) universally across older containers (`Deque`, `PriorityQueue`, `ForwardList`).
- Overridden `toString()` reliably for all non-compliant collections to drastically improve console debugging experience and format.
- Added missing `swap()` API specifically to `ForwardList<T>`.

## 0.2.5

### Changed
- Updated `README.md` to include new ranges examples.

## 0.2.4
- Added ZipRange - Mimics C++23 `std::views::zip`.
- Added ChunkRange - Mimics C++23 `std::views::chunk`.
- Added RepeatRange - Mimics C++23 `std::views::repeat`.
- Added  CartesianRange - Mimics C++23 `std::views::cartesian_product`.
- updated README.md
- Removed unnecessary_non_null_assertion

## 0.2.3

### Changed
- Major documentation optimization: the API `README.md` has been completely revitalized to document the new `camelCase` infrastructure, properly highlight the new `Stack` modifiers, and beautifully showcase `Pair<T1, T2>`.

## 0.2.2

### Changed
- **Major API Refactor**: Transitioned all C++ STL style `snake_case` method and property names (e.g., `push_back`, `remove_if`) to standard Dart `lowerCamelCase` (`pushBack`, `removeIf`) to seamlessly integrate with Dart's tooling, ecosystem, and linter rules, enabling a perfect 160/160 pub.dev score.
- Mixed in `IterableMixin<T>` into `Stack<T>`, allowing deep iteration from top-to-bottom without consuming the stack elements.
- Updated `Stack<T>.pop()` to return the removed element instead of `void`, providing a significantly improved and Dart-idiomatic developer experience.
- Implemented value-based deep equality (`operator ==` and `hashCode`) for `Stack<T>`, enabling strict state comparisons.
- Inherited and verified standard search utilities (`contains`, `elementAt`, etc.) for `Stack<T>` via Iterable mixins natively.
- Developed `Pair<T1, T2>` (mimicking C++ `<utility>` `std::pair`) to cleanly store and exchange heterogeneous objects as a single unit, complete with deep equality checks and a lovely `makePair` global function helper.
- Added Dart 3 Record interoperability to `Pair<T1, T2>` via `.record` destructuring property and `Pair.fromRecord()` constructor.
- Added seamless Map translations (`Pair.fromMapEntry` and `toMapEntry()`) to bridge `<utility>` pairs flawlessly with standard Dart Maps.
- Implemented `ComparablePair` extension, magically unlocking `std::pair` lexicographical comparison operators (`<`, `>`, `<=`, `>=`) only when type-safe.
- Added utility converters `.toList()` and deep `.clone()` behavior to `Pair`.

## 0.2.1

### Added
- Created new `ranges` sub-module for generating standard ranges.
- Implemented `NumberLine<T extends num>` to cleanly mimic iterable sequences of numbers with customized `start`, `end`, and `step` properties.
- `NumberLine` supports generic types, making it easy to generate ranges of both `int` and `double` seamlessly.
- Mixed in `IterableBase<T>` giving `NumberLine` out-of-the-box support for `for-in` blocks and list extensions like `.map`, `.reduce` and `.where`.

## 0.2.0

### Added
- Expanded `Vector<T>` with strictly identical C++ style operations: `assign()`, `resize()`, `insertAll()`, and `swap()`.
- Enhanced `Deque<T>` by natively mixing in `IterableMixin<T>`, enabling dozens of standard iterable operations.
- Appended missing C++ aliases to `Deque<T>` (`push_back()`, `push_front()`, `pop_back()`, `pop_front()`, `front()`, `back()`).
- Added index-based random access array functionality (`operator []`, `operator []=`, `at()`) and `swap()` method to `Deque<T>`.
- Greatly expanded `ForwardList<T>` singly-linked manipulation algorithms: `remove()`, `remove_if()`, `insert_after()`, `erase_after()`, and `unique()`.
- Implemented state `swap()` adapter for `Stack<T>`.

## 0.1.9
- Updated `Readme.md `
- Added test for `ForwardList` collection.

## 0.1.8
- Added `Stack` collection.
- Added unit tests for `Stack` collection.
- Added unit test for `Vector` collection.
- Added unit test for `Deque` collection.
- Removed `stl_test.dart`.
- Added `ForwardList` collection.

## 0.1.7
- Added `Deque` example showcase.

## 0.1.6
- Added `Deque` collection.

## 0.1.5
- Cleaned up duplicate `vector.dart` source file.

## 0.1.4
- Added `stl.collections` for more collection types.
- Moved `Vector` to `stl.collections`.
- Removed `stl_base.dart`.

## 0.1.3
- Added `at()` method for safe random access with bounds checking.
- Added `front()` method for accessing the first element with bounds checking.
- Added `back()` method for accessing the last element with bounds checking.
- Added `empty()` method for checking if the vector is empty.
- Added `size()` method for getting the size of the vector.
- Added `sort()` method for sorting the vector.
- Added `reverse()` method for reversing the vector.
- Added `shuffle()` method for shuffling the vector.
- Added `contains()` method for checking if the vector contains an element.
- Added `indexOf()` method for getting the index of an element.
- Added `remove()` method for removing an element.
- Added `removeAt()` method for removing an element at a specific index.
- Added `removeLast()` method for removing the last element.
- Added `removeRange()` method for removing a range of elements.
- Added `removeWhere()` method for removing elements that satisfy a condition.
- Added `retainWhere()` method for retaining elements that satisfy a condition.

## 0.1.2

### Added
- Added `operator +` for vector concatenation.
- Added `operator *` for vector multiplication with an integer.
- Added `operator -` for vector subtraction.
- Added `~` for conversion to List.

## 0.1.1
* Documentation update: Fixed installation instructions in README.

## 0.1.0

### Added
- Introduced the core `Vector<T>` class.
- Overloaded `operator ==` and `hashCode` for deep value-based equality matching instead of default reference equality.
- Implemented C++ STL-style lexicographical comparison operators (`<`, `<=`, `>`, `>=`) and `compareTo` by enforcing `T extends Comparable`.
- Re-added random element access (`operator []` and `operator []=`) with strict memory safety and bounds checking.
- Overridden `toString()` for beautifully formatted array-like console output.
- Implemented core container modifiers (`push_back`, `pop_back`, `clear`, `insert`) with underlying bounds validation.
- Made the `Vector` completely compatible with Dart standard iterables by introducing `IterableMixin`, granting dozens of built-in loop operations (`.map`, `.where`, `reduce`, `for-in` blocks).

### Changed
- Completely rewrote `Vector<T>` to establish a clean slate and focus on strict `const` and `final` list initialization semantics.
- Temporarily removed all extended operations (`+`, `-`, `*`, `at()`, `toList()`, etc.) for architectural redesign.

## 0.0.1

- Initial release and project structure.
- Reserving the `stl` package name.
