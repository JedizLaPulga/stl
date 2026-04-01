## 0.0.1

- Initial release and project structure.
- Reserving the `stl` package name.

## 0.1.0

### Added
- Introduced the core `Vector<T>` class to provide a list-backed data structure with extended operations.
- Added standard element access and mutation using `operator []` and `operator []=` with range bounds checking.
- Added `at(int index)` method for boundary-safe element access with wrap-around (modulo) indexing.
- Added type-conversion utility `toList<F>()` with current support for mapping elements to `String` and `bool` representations.
- Added `list()` method to easily extract a standard Dart `List<T>` copy of the underlying vector data.
- Added mathematical/set-like operator overloads for vectors:
  - `operator +` for vector concatenation.
  - `operator -` for vector difference (removing overlapping elements).
  - `operator *` for vector intersection (keeping only overlapping elements).



