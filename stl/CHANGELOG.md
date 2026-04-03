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
- Added `Deque` example showcase.

