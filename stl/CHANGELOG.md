## 0.0.1

- Initial release and project structure.
- Reserving the `stl` package name.

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


## 0.1.1
* Documentation update: Fixed installation instructions in README.


## 0.1.2

### Added
- Added `operator +` for vector concatenation.
- Added `operator *` for vector multiplication with an integer.
- Added `operator -` for vector subtraction.
- Added `~` for conversion to List.

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

## 0.1.4
- Added `stl.collections` for more collection types.
- Moved `Vector` to `stl.collections`.
- Removed `stl_base.dart`.

## 0.1.5
- Cleaned up duplicate `vector.dart` source file.

## 0.1.6
- Added `Deque` collection.


## 0.1.7
- Added `Deque` example showcase.

## 0.1.8
- Added `Stack` collection.
- Added unit tests for `Stack` collection.
- Added unit test for `Vector` collection.
- Added unit test for `Deque` collection.
- Removed `stl_test.dart`.
- Added `ForwardList` collection.

## 0.1.9
- Updated `Readme.md `
- Added test for `ForwardList` collection.

## 0.2.0

### Added
- Expanded `Vector<T>` with strictly identical C++ style operations: `assign()`, `resize()`, `insertAll()`, and `swap()`.
- Enhanced `Deque<T>` by natively mixing in `IterableMixin<T>`, enabling dozens of standard iterable operations.
- Appended missing C++ aliases to `Deque<T>` (`push_back()`, `push_front()`, `pop_back()`, `pop_front()`, `front()`, `back()`).
- Added index-based random access array functionality (`operator []`, `operator []=`, `at()`) and `swap()` method to `Deque<T>`.
- Greatly expanded `ForwardList<T>` singly-linked manipulation algorithms: `remove()`, `remove_if()`, `insert_after()`, `erase_after()`, and `unique()`.
- Implemented state `swap()` adapter for `Stack<T>`.

## 0.2.1

### Added
- Created new `ranges` sub-module for generating standard ranges.
- Implemented `NumberLine<T extends num>` to cleanly mimic iterable sequences of numbers with customized `start`, `end`, and `step` properties.
- `NumberLine` supports generic types, making it easy to generate ranges of both `int` and `double` seamlessly.
- Mixed in `IterableBase<T>` giving `NumberLine` out-of-the-box support for `for-in` blocks and list extensions like `.map`, `.reduce` and `.where`.

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

## 0.2.3

### Changed
- Major documentation optimization: the API `README.md` has been completely revitalized to document the new `camelCase` infrastructure, properly highlight the new `Stack` modifiers, and beautifully showcase `Pair<T1, T2>`.


## 0.2.4
- Added ZipRange - Mimics C++23 `std::views::zip`.
- Added ChunkRange - Mimics C++23 `std::views::chunk`.
- Added RepeatRange - Mimics C++23 `std::views::repeat`.
- Added  CartesianRange - Mimics C++23 `std::views::cartesian_product`.
- updated README.md
- Removed unnecessary_non_null_assertion

## 0.2.5

### Changed
- Updated `README.md` to include new ranges examples.


## 0.2.6
- Added Queue 
- Added PriorityQueue
- Added Set
- Added HashSet
- Added SortedSet
- Standardized deep-value equality matching (`operator ==` and `hashCode`) universally across older containers (`Deque`, `PriorityQueue`, `ForwardList`).
- Overridden `toString()` reliably for all non-compliant collections to drastically improve console debugging experience and format.
- Added missing `swap()` API specifically to `ForwardList<T>`.
