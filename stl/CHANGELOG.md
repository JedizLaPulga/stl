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
