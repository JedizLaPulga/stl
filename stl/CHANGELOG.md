# 0.7.6

## `RedBlackTree<K, V>` & True $O(\log n)$ Sorted Containers

### Backend Replacement: `collections/red_black_tree.dart`

Introduced a strictly balanced, memory-efficient **Red-Black Tree** to power the library's sorted containers. 

Previously, `SortedMap` and `SortedSet` were backed by `dart:collection`'s `SplayTreeMap` and `SplayTreeSet`. While Splay trees provide amortised $O(\log n)$ performance, they mutate their structure on every read access to move the queried node to the root. This read-mutation breaks cache-friendliness and makes read-heavy operations unnecessarily unstable.

By replacing the backend with a pure `RedBlackTree`, `SortedMap` and `SortedSet` now perfectly match the algorithmic complexity and performance contract of C++'s `std::map` and `std::set` — providing guaranteed strict worst-case $O(\log n)$ bounds for `insert`, `erase`, and `find` without modifying the tree during lookups. 

#### Changes:
- **`RedBlackTree<K, V>`**: A core implementation of the Cormen/Tarjan Red-Black Tree algorithms.
- **`SortedMap<K, V>`**: Backend replaced with `RedBlackTree`. Exact same public API, structurally stable reads.
- **`SortedSet<T>`**: Backend replaced with `RedBlackTree`. Exact same public API, structurally stable reads.
- **Tests**: Added comprehensive verification of mathematical red-black invariants alongside 100% backwards compatibility for existing collection tests.

---

# 0.7.5

## `ImmutableSet<T>` — Persistent Immutable Set

### New Feature: `collections/immutable_set.dart`

Completes the persistent-collection trilogy alongside `ImmutableList` and `ImmutableMap`. Every operation returns a **new** `ImmutableSet` — the original is never modified. Backed by `LinkedHashSet` (insertion-order iteration, $O(1)$ amortised membership). Implements `Iterable<T>` and integrates seamlessly with the range pipeline.

| Constructor | Description |
|---|---|
| `ImmutableSet.empty()` | Returns an empty set. |
| `ImmutableSet.of(Iterable<T>)` | Copies elements, discarding duplicates. |
| `ImmutableSet.generate(int, T Function(int))` | Builds elements from an index function. |

| Method | Returns | Description |
|---|---|---|
| `add(T)` | `ImmutableSet<T>` | Add element (no-op if already present). |
| `addAll(Iterable<T>)` | `ImmutableSet<T>` | Add multiple elements. |
| `remove(T)` | `ImmutableSet<T>` | Remove element (no-op if absent). |
| `clear()` | `ImmutableSet<T>` | Return empty set. |
| `union(ImmutableSet<T>)` | `ImmutableSet<T>` | $A \cup B$ |
| `intersection(ImmutableSet<T>)` | `ImmutableSet<T>` | $A \cap B$ |
| `difference(ImmutableSet<T>)` | `ImmutableSet<T>` | $A \setminus B$ |
| `symmetricDifference(ImmutableSet<T>)` | `ImmutableSet<T>` | $A \triangle B$ |
| `isSubsetOf / isSupersetOf` | `bool` | Subset / superset test. |
| `isDisjointFrom` | `bool` | No common elements. |
| `map<U>(U Function(T))` | `ImmutableSet<U>` | Transform all elements. |
| `where(bool Function(T))` | `ImmutableSet<T>` | Filter elements. |

---

## `FlatSet<T>` & `FlatMap<K,V>` — C++23 Array-Backed Sorted Containers

### New Feature: `collections/flat_collections.dart`

Ports C++23 `std::flat_set` and `std::flat_map`. Both store their data in contiguous sorted `List`s, giving **cache-friendly $O(\log n)$ binary-search lookups** at the cost of $O(n)$ insertions and erasures. Prefer these over tree-based containers for small-to-medium read-heavy workloads.

#### `FlatSet<T>`

| Operation | Complexity | Notes |
|---|:---:|---|
| `contains(T)` | $O(\log n)$ | Binary search. |
| `lowerBound(T)` | $O(\log n)$ | First index `>= value`. |
| `upperBound(T)` | $O(\log n)$ | First index `> value`. |
| `insert(T)` | $O(n)$ | Binary search + shift. |
| `erase(T)` | $O(n)$ | Binary search + shift. |
| `union / intersection / difference` | $O(n + k)$ | Merge-style set algebra. |

#### `FlatMap<K, V>`

| Operation | Complexity | Notes |
|---|:---:|---|
| `operator [](K)` | $O(\log n)$ | Returns `null` if absent. |
| `at(K)` | $O(\log n)$ | Throws `OutOfRange` if absent. |
| `containsKey(K)` | $O(\log n)$ | |
| `lowerBound / upperBound(K)` | $O(\log n)$ | Key-space navigation. |
| `insert(K, V)` | $O(n)$ | Returns `true` if new key inserted. |
| `operator []=(K, V)` | $O(n)$ | Alias for `insert`. |
| `erase(K)` | $O(n)$ | Returns `true` if removed. |

Iteration over `FlatMap` yields `FlatMapEntry<K, V>` objects in sorted-key order.

---

## C++23 Range Algorithm Extensions

### New functions in `algorithm/algorithm.dart`

Nine new top-level functions porting the remaining C++23 `std::ranges` algorithms.

#### Fold Operations

| Function | Signature | Description |
|---|---|---|
| `foldLeft` | `foldLeft<T,R>(Iterable<T>, R, R Function(R,T))` | Left-fold with initial value. Equivalent to `std::ranges::fold_left`. |
| `foldRight` | `foldRight<T,R>(Iterable<T>, R, R Function(T,R))` | Right-fold with initial value. Equivalent to `std::ranges::fold_right`. |
| `foldLeftFirst` | `foldLeftFirst<T>(Iterable<T>, T Function(T,T))` | Left-fold using first element as init; throws on empty. Equivalent to `std::ranges::fold_left_first`. |

#### Membership

| Function | Description |
|---|---|
| `contains<T>(Iterable<T>, T)` | `true` if any element equals value. $O(N)$. Equivalent to `std::ranges::contains`. |
| `containsSubrange<T>(List<T>, List<T>)` | `true` if sub appears contiguously. $O(N \cdot K)$. Equivalent to `std::ranges::contains_subrange`. |

#### Prefix / Suffix Matching

| Function | Description |
|---|---|
| `startsWith<T>(List<T>, List<T>)` | `true` if list begins with prefix. $O(K)$. Equivalent to `std::ranges::starts_with`. |
| `endsWith<T>(List<T>, List<T>)` | `true` if list ends with suffix. $O(K)$. Equivalent to `std::ranges::ends_with`. |

#### Reverse Search

| Function | Description |
|---|---|
| `findLast<T>(List<T>, T)` | Index of last equal element; `-1` if absent. $O(N)$. Equivalent to `std::ranges::find_last`. |
| `findLastIf<T>(List<T>, bool Function(T))` | Index of last element satisfying predicate. $O(N)$. Equivalent to `std::ranges::find_last_if`. |
| `findLastIfNot<T>(List<T>, bool Function(T))` | Index of last element not satisfying predicate. $O(N)$. Equivalent to `std::ranges::find_last_if_not`. |

---

# 0.7.4

## `ImmutableList<T>` & `ImmutableMap<K, V>` — Persistent Immutable Collections

### New Features: `collections/immutable_list.dart`, `collections/immutable_map.dart`

Introduced two persistent, copy-on-write collection types that complement the existing mutable containers. Every operation that would normally mutate state returns a **new** instance — the original is never modified. Both types implement `Iterable`, making them first-class citizens of the range pipeline.

#### `ImmutableList<T>`

A persistent random-access list. Backed by `List.unmodifiable`; all index-based reads are $O(1)$ and structural write operations are $O(n)$ (copy-on-write).

| Constructor | Description |
|---|---|
| `ImmutableList.empty()` | Returns an empty list. |
| `ImmutableList.of(Iterable<T>)` | Copies elements from any iterable. |
| `ImmutableList.filled(int, T)` | Fills `n` slots with a constant value. |
| `ImmutableList.generate(int, T Function(int))` | Builds elements from an index function. |

| Method | Returns | Complexity |
|---|---|:---:|
| `add(T)` | `ImmutableList<T>` | $O(n)$ |
| `addAll(Iterable<T>)` | `ImmutableList<T>` | $O(n)$ |
| `insert(int, T)` | `ImmutableList<T>` | $O(n)$ |
| `set(int, T)` | `ImmutableList<T>` | $O(n)$ |
| `removeAt(int)` | `ImmutableList<T>` | $O(n)$ |
| `remove(T)` | `ImmutableList<T>` | $O(n)$ |
| `clear()` | `ImmutableList<T>` | $O(1)$ |
| `sorted([Comparator])` | `ImmutableList<T>` | $O(n \log n)$ |
| `reversed()` | `ImmutableList<T>` | $O(n)$ |
| `take(int)` | `ImmutableList<T>` | $O(n)$ |
| `drop(int)` | `ImmutableList<T>` | $O(n)$ |
| `sublist(int, [int?])` | `ImmutableList<T>` | $O(n)$ |
| `concat(ImmutableList<T>)` | `ImmutableList<T>` | $O(n)$ |
| `map<U>(U Function(T))` | `ImmutableList<U>` | $O(n)$ |
| `where(bool Function(T))` | `ImmutableList<T>` | $O(n)$ |
| `expand<U>(Iterable<U> Function(T))` | `ImmutableList<U>` | $O(n)$ |

#### `ImmutableMap<K, V>`

A persistent associative container with insertion-order iteration (backed by `LinkedHashMap`). All single-key operations are amortised $O(1)$; structural bulk operations are $O(n)$.

| Constructor | Description |
|---|---|
| `ImmutableMap.empty()` | Returns an empty map. |
| `ImmutableMap.of(Map<K,V>)` | Copies entries from a Dart `Map`. |
| `ImmutableMap.fromPairs(Iterable<Pair<K,V>>)` | Builds from `Pair` entries. |
| `ImmutableMap.fromEntries(Iterable<MapEntry<K,V>>)` | Builds from `MapEntry` entries. |

| Method | Returns | Description |
|---|---|---|
| `put(K, V)` | `ImmutableMap<K,V>` | Add / replace entry. |
| `putAll(Map<K,V>)` | `ImmutableMap<K,V>` | Merge a Dart map. |
| `remove(K)` | `ImmutableMap<K,V>` | Drop entry by key. |
| `update(K, V Function(V))` | `ImmutableMap<K,V>` | Transform existing value; throws if absent. |
| `updateOrInsert(K, V Function(V), V Function())` | `ImmutableMap<K,V>` | Transform or insert. |
| `clear()` | `ImmutableMap<K,V>` | Return empty map. |
| `mapValues<W>(W Function(V))` | `ImmutableMap<K,W>` | Transform all values. |
| `mapEntries<K2,V2>(…)` | `ImmutableMap<K2,V2>` | Transform keys and values. |
| `where(bool Function(K,V))` | `ImmutableMap<K,V>` | Filter by key+value predicate. |
| `whereKey / whereValue` | `ImmutableMap<K,V>` | Filter by key or value alone. |
| `merge(ImmutableMap, {resolve?})` | `ImmutableMap<K,V>` | Union with optional conflict resolver. |

---

## `AsyncRange<T>` — Lazy Composable Async Range (`ranges/async_range.dart`)

Introduced `AsyncRange<T>`, the async counterpart to the library's synchronous range views. It wraps a `Stream<T>` and exposes a fluent, composable API for transforming and consuming asynchronous sequences — inspired by C++23 async generators while remaining idiomatic Dart.

All transformation methods are **lazy**: they return a new `AsyncRange<T>` backed by a transformed stream. No work is performed until a terminal operation is called.

#### Constructors

| Constructor | Description |
|---|---|
| `AsyncRange.fromStream(Stream<T>)` | Wraps an existing stream. |
| `AsyncRange.fromIterable(Iterable<T>)` | Lifts a synchronous iterable into an async range. |
| `AsyncRange.generate(int, Future<T> Function(int))` | Sequentially awaits an async producer. |
| `AsyncRange.periodic(Duration, T Function(int), {int? count})` | Emits on a timer; optional element cap. |
| `AsyncRange.fromFutures(Iterable<Future<T>>)` | Awaits each future in order. |

#### Lazy transformations

| Method | Description |
|---|---|
| `map<U>(U Function(T))` | Synchronous per-element transform. |
| `asyncMap<U>(Future<U> Function(T))` | Async per-element transform. |
| `where(bool Function(T))` / `filter(…)` | Keep elements satisfying predicate. |
| `expand<U>(Iterable<U> Function(T))` | One-to-many flattening. |
| `take(int)` | Emit at most `n` elements. |
| `drop(int)` | Skip first `n` elements. |
| `takeWhile(bool Function(T))` | Emit while predicate holds. |
| `dropWhile(bool Function(T))` | Skip while predicate holds. |
| `distinct()` | Suppress consecutive duplicates. |
| `followedBy(AsyncRange<T>)` | Sequential concatenation. |
| `debounce(Duration)` | Emit only after a quiet period. |

#### Terminal operations (return `Future<…>` or `Stream<T>`)

`toList()`, `toStream()`, `forEach()`, `first`, `last`, `single`, `elementAt()`, `any()`, `every()`, `isEmpty`, `length`, `reduce()`, `fold()`

---

# 0.7.3


## `Span<T>` — Non-Owning Contiguous View (`<span>`)

### New Feature: `utilities/span.dart`
Introduced `Span<T>`, a non-owning, zero-allocation view over a contiguous `List<T>`. Directly mirrors C++20 `std::span` and serves as the general-element companion to the existing `StringView`. A `Span` holds no data of its own — it references a window `[offset, offset + length)` into a backing `List<T>`. All slicing operations are $O(1)$ and return new `Span` instances that point into the same backing list without copying.

`Span<T>` implements `Iterable<T>`, making it a first-class citizen of the library's range pipeline — it composes directly with `FilterRange`, `TransformRange`, `ZipRange`, and every other range adapter.

#### Constructors

| Constructor | Description |
|---|---|
| `Span(List<T> source)` | View over the entire list. |
| `Span.subspan(List<T> source, int offset, int count)` | View over a `[offset, offset + count)` window. Throws `RangeError` on invalid bounds. |

#### Properties

| Member | C++ equivalent | Complexity |
|---|---|:---:|
| `int length` | `size()` | $O(1)$ |
| `bool isEmpty` | `empty()` | $O(1)$ |
| `bool isNotEmpty` | `!empty()` | $O(1)$ |

#### Element Access

| Member | C++ equivalent | Complexity |
|---|---|:---:|
| `T operator[](int index)` | `operator[]` | $O(1)$ |
| `T get first` | `front()` | $O(1)$ |
| `T get last` | `back()` | $O(1)$ |

`operator[]`, `first`, and `last` all throw on out-of-bounds or empty access.

#### Slicing

| Method | C++ equivalent | Complexity |
|---|---|:---:|
| `Span<T> firstSpan(int count)` | `first(n)` | $O(1)$ |
| `Span<T> lastSpan(int count)` | `last(n)` | $O(1)$ |
| `Span<T> subspan(int offset, [int? count])` | `subspan(offset[, count])` | $O(1)$ |

All three slicing methods return a new `Span<T>` pointing into the same backing list — no elements are copied. Omitting `count` in `subspan` extends the view to the end of the current span.

#### Search

| Method | Complexity |
|---|:---:|
| `bool contains(Object? element)` | $O(n)$ |
| `int indexOf(T element, [int start = 0])` | $O(n)$ |

`indexOf` returns `-1` when the element is not found. All indices are relative to the start of the span, not the backing list.

#### Conversion & Iteration

| Member | Description |
|---|---|
| `List<T> toList({bool growable})` | Copies elements into a new independent list. |
| `Iterator<T> get iterator` | Forward iterator over the span window. |
| `==`, `hashCode` | Element-wise value equality. |
| `toString()` | `Span[e0, e1, ...]` format. |

#### Zero-copy guarantee

Mutations to the backing `List<T>` after the span is created are immediately visible through the span. `subspan`, `firstSpan`, and `lastSpan` always share the same backing source — chaining multiple slices never allocates intermediate storage.

```dart
final data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
final view = Span(data);

// Element access
print(view[3]);             // 40
print(view.first);          // 10
print(view.last);           // 100

// Slicing — all O(1), zero-copy
final head  = view.firstSpan(3);       // Span[10, 20, 30]
final tail  = view.lastSpan(2);        // Span[90, 100]
final mid   = view.subspan(2, 5);      // Span[30, 40, 50, 60, 70]

// Chained slicing — still zero-copy
final chain = view.subspan(1).firstSpan(6).subspan(1, 4);
print(chain.toList());      // [30, 40, 50, 60]

// Search
print(mid.contains(50));    // true
print(mid.indexOf(60));     // 3

// Iterable integration
final evens = Span([1, 2, 3, 4, 5, 6]).where((e) => e.isEven).toList();
print(evens);               // [2, 4, 6]

// Zero-copy: mutating the source is visible through the span
data[0] = 999;
print(view.first);          // 999
```

### New files
- `lib/src/utilities/span.dart` — `Span<T>` and `_SpanIterator<T>` with full dartdoc coverage.
- `test/span_test.dart` — 63 tests covering all constructors, accessors, slicing, search, iteration, equality, zero-copy semantics, and error paths.
- `example/span_example.dart` — End-to-end demonstration of all major features.

- All 2157 tests pass

---

# 0.7.2

## Linear Algebra Module (`<linalg>`)

### New Feature: `math/linalg/` module
Introduced a comprehensive C++26 `<linalg>`-inspired general linear algebra module, extending the fixed-size geometry matrices into a full M×N linear algebra engine with BLAS-level operations, matrix decompositions, and eigenvalue solvers.

#### `Vec` — mathematical vector (`math/linalg/vec.dart`)
A general-purpose, immutable $n$-dimensional real vector, distinct from the collection `Vector<T>`.

- **Constructors:** `Vec(List<double>)`, `Vec.zeros(n)`, `Vec.ones(n)`, `Vec.filled(n, v)`, `Vec.basis(n, i)` (standard basis $e_i$).
- **Properties:** `length` (dimension), `[]` element access, `isEmpty`.
- **Arithmetic:** `+`, `-`, unary `-`, `*` (scalar), `/` (scalar). All return new `Vec` instances (immutable).
- **Products:** `dot(Vec)` — inner product $\mathbf{x} \cdot \mathbf{y}$; `cross(Vec)` — $\mathbb{R}^3$ cross product $\mathbf{x} \times \mathbf{y}$ (throws `ArgumentError` for non-3D inputs); `outer(Vec)` → `Mat` — rank-1 outer product $\mathbf{x}\mathbf{y}^\top$.
- **Norms:** `norm([int p = 2])` — $L^1$, $L^2$, $L^\infty$ norms; `normalize()` — unit vector (throws `StateError` for zero vector).
- **Utilities:** `toList()`, `==`, `hashCode`, `toString`.

#### `Mat` — general M×N matrix (`math/linalg/matrix.dart`)
A row-major, immutable real matrix of arbitrary dimensions.

- **Constructors:** `Mat(List<List<double>>)`, `Mat.zeros(r,c)`, `Mat.identity(n)`, `Mat.filled(r,c,v)`, `Mat.diagonal(List<double>)`, `Mat.fromColumns(List<Vec>)`, `Mat.fromRows(List<Vec>)`.
- **Properties:** `rows`, `cols`, `isSquare`, `isSymmetric`, `isDiagonal`.
- **Access:** `[]` (row as `List<double>`), `at(r,c)`, `row(i) → Vec`, `col(j) → Vec`.
- **Arithmetic:** `+`, `-`, unary `-`, `*` (Mat×Mat — validated dimensions), `scaled(double)` (scalar multiply), `divided(double)` (scalar divide).
- **Transformations:** `transpose()`, `submatrix(r,c,rows,cols)`.
- **Reductions:** `trace()` — $\sum_i a_{ii}$; `frobenius()` — $\|A\|_F = \sqrt{\sum_{ij} a_{ij}^2}$.
- **Derived:** `determinant()` — via LU factorisation; `inverse()` — via LU factorisation (throws `StateError` for singular matrices).
- **Utilities:** `toList()`, `==`, `hashCode`, `toString`.

#### Decompositions (`math/linalg/decomposition.dart`)
Three standard matrix factorisations for solving linear systems and computing matrix properties.

- **`LUDecomposition(Mat a)`** — Crout's algorithm with partial pivoting. Decomposes $A = P \cdot L \cdot U$.
  - Getters: `l` (unit lower triangular), `u` (upper triangular), `p` (permutation matrix), `pivots` (`List<int>`).
  - `solve(Vec b) → Vec` — solves $Ax = b$ via forward and back substitution. $O(n^2)$.
  - `determinant() → double` — $\det(A) = \text{sign}(P) \cdot \prod_i u_{ii}$.
  - `inverse() → Mat` — solves $A X = I$ column by column.
  - Throws `StateError` when the matrix is singular (a diagonal entry of $U$ is zero within tolerance).

- **`QRDecomposition(Mat a)`** — Householder reflections for full rectangular M×N matrices ($M \geq N$). Decomposes $A = Q \cdot R$.
  - Getters: `q` (orthogonal $M \times M$), `r` (upper trapezoidal $M \times N$).
  - `solve(Vec b) → Vec` — least-squares solution via $R x = Q^\top b$. $O(n^2)$ for square systems.

- **`CholeskyDecomposition(Mat a)`** — Cholesky–Banachiewicz algorithm for symmetric positive-definite matrices. Decomposes $A = L \cdot L^\top$.
  - Getter: `l` (lower triangular with positive diagonal).
  - `solve(Vec b) → Vec` — solves $Ax = b$ via forward/back substitution through $L$ and $L^\top$.
  - Throws `ArgumentError` if the input matrix is not square or symmetric (within tolerance), and `StateError` if a diagonal entry becomes non-positive during factorisation (matrix not positive-definite).

#### BLAS-level free functions (`math/linalg/blas.dart`)
Stateless, allocation-minimal kernels mirroring the BLAS interface and `std::linalg` (C++26 P1673).

**Level 1 — vector/vector operations:**

| Function | Semantics |
|---|---|
| `dot(Vec x, Vec y) → double` | Inner product $\mathbf{x} \cdot \mathbf{y}$ |
| `nrm2(Vec x) → double` | Euclidean norm $\|\mathbf{x}\|_2$ |
| `asum(Vec x) → double` | Absolute sum $\|\mathbf{x}\|_1$ |
| `iamax(Vec x) → int` | Index of $\arg\max_i \|x_i\|$ |
| `axpy(double α, Vec x, Vec y) → Vec` | $\mathbf{y} + \alpha\mathbf{x}$ |
| `scal(double α, Vec x) → Vec` | $\alpha \mathbf{x}$ |

**Level 2 — matrix/vector operations:**

| Function | Semantics |
|---|---|
| `gemv(Mat A, Vec x, {double alpha, double beta, Vec? y}) → Vec` | $\alpha A\mathbf{x} + \beta\mathbf{y}$ |
| `ger(Vec x, Vec y, {double alpha}) → Mat` | Rank-1 update $\alpha \mathbf{x}\mathbf{y}^\top$ |

**Level 3 — matrix/matrix operations:**

| Function | Semantics |
|---|---|
| `gemm(Mat A, Mat B, {double alpha, double beta, Mat? C}) → Mat` | $\alpha AB + \beta C$ |
| `trmm(Mat A, Mat B, {bool upper, double alpha}) → Mat` | Triangular matrix multiply |

#### Eigenvalue solvers (`math/linalg/eigen.dart`)

- **`EigenResult`** — Value type holding `eigenvalues (List<double>)` and `eigenvectors (Mat)` (columns).
- **`powerIteration(Mat a, {int maxIter, double tol}) → (double, Vec)`** — Finds the dominant eigenvalue and corresponding eigenvector. $O(k \cdot n^2)$ where $k$ is the number of iterations.
- **`symmetricEigen(Mat a, {int maxIter, double tol}) → EigenResult`** — Classical Jacobi method for all eigenvalues/eigenvectors of a real symmetric matrix. $O(k \cdot n^2)$. Throws `ArgumentError` for non-symmetric input.
- **`qrEigen(Mat a, {int maxIter, double tol}) → EigenResult`** — QR algorithm with Wilkinson shifts for all eigenvalues of a general real matrix. $O(k \cdot n^3)$.

### New files
- `lib/src/math/linalg/vec.dart` — `Vec` implementation with full dartdoc coverage.
- `lib/src/math/linalg/matrix.dart` — `Mat` implementation with full dartdoc coverage.
- `lib/src/math/linalg/decomposition.dart` — `LUDecomposition`, `QRDecomposition`, `CholeskyDecomposition`.
- `lib/src/math/linalg/blas.dart` — BLAS Level 1/2/3 free functions.
- `lib/src/math/linalg/eigen.dart` — `EigenResult`, `powerIteration`, `symmetricEigen`, `qrEigen`.
- `lib/src/math/linalg/linalg.dart` — Barrel re-export.
- `test/linalg_vec_test.dart` — ~70 tests covering all `Vec` API.
- `test/linalg_matrix_test.dart` — ~80 tests covering all `Mat` API.
- `test/linalg_decomposition_test.dart` — ~60 tests covering reconstruction and `solve` correctness.
- `test/linalg_blas_test.dart` — ~50 tests covering every BLAS kernel.
- `test/linalg_eigen_test.dart` — ~40 tests covering convergence and known eigenvalue results.
- `example/linalg_example.dart` — End-to-end demonstration.

- All 2094 tests pass

---

# 0.7.1

## Graph Module (`<graph>`)

### New Feature: `collections/graph.dart`
Introduced a full-featured weighted graph container mirroring C++26 `<graph>` and the Boost.Graph library. Supports both directed and undirected graphs with a rich set of traversal and optimization algorithms.

#### `Edge<V>`
- **`Edge(source, destination, {weight = 1.0})`**: Immutable, value-typed edge connecting two vertices with an optional floating-point weight.
- Full `==`, `hashCode`, and `toString` support.

#### `Graph<V>` — container
- **Vertex operations**: `addVertex`, `removeVertex`, `hasVertex`, `vertices`, `vertexCount`.
- **Edge operations**: `addEdge`, `removeEdge`, `hasEdge`, `edges`, `neighborsOf`, `degreeOf`, `edgeCount`.
- **Utilities**: `empty`, `clear`, `directed`, `iterator` (via `IterableMixin<V>`), `toString`.
- Undirected graphs automatically maintain symmetric adjacency and deduplicate edges in `edges`.

#### Traversal algorithms
- **`bfs(V start)`** — Breadth-first search returning a level-order `List<V>`. $O(V + E)$.
- **`dfs(V start)`** — Depth-first search using an explicit stack returning a `List<V>`. $O(V + E)$.

#### Shortest-path algorithms
- **`dijkstra(V start)`** — Single-source shortest paths for non-negative weights via an inline binary min-heap. Returns `Map<V, double>`. $O((V + E) \log V)$.
- **`bellmanFord(V start)`** — Handles negative edge weights via edge relaxation. Returns `null` on detection of a negative-weight cycle. $O(V \cdot E)$.

#### Topological ordering
- **`topologicalSort()`** — Kahn's algorithm (in-degree BFS) for directed acyclic graphs. Returns `null` if the graph contains a cycle. $O(V + E)$.

#### Minimum spanning tree
- **`prim([V? start])`** — Greedy MST via inline binary min-heap. Returns `List<Edge<V>>`. $O((V + E) \log V)$.
- **`kruskal()`** — Greedy MST via Union-Find with path compression and union-by-rank. Returns `List<Edge<V>>`. $O(E \log E)$.

#### Graph property queries
- **`isConnected`** — Undirected: BFS reachability; directed: double-BFS strong connectivity check using graph transpose. $O(V + E)$.
- **`isAcyclic`** — Directed: DFS white/grey/black colouring; undirected: parent-tracking DFS. $O(V + E)$.

### New files
- `lib/src/collections/graph.dart` — full implementation with complete dartdoc coverage.
- `test/graph_test.dart` — comprehensive test suite covering all public API.
- `example/graph_example.dart` — runnable end-to-end demonstration.

- All 1896 tests pass

---

# 0.7.0


## Advanced Statistical Random Module (`<random>`)

### New Feature: `math/random` module
Introduced a powerful C++11-inspired statistical random number generation module to upgrade Dart's native pseudo-random capabilities.

#### `engine.dart`
- **`RandomEngine`**: A core interface for deterministic random number engines generating uniformly distributed integers.
- **`MersenneTwisterEngine`**: Implements the legendary `std::mt19937` algorithm natively in Dart, guaranteeing an enormous period of $2^{19937}-1$.
- **`LinearCongruentialEngine`**: Implements the classic LCG algorithm, perfectly matching `std::minstd_rand` and `std::minstd_rand0`.
- **`DartNativeEngine`**: A fallback engine wrapping `dart:math`'s `Random` for maximum performance when system-level seeding is sufficient.

#### `distribution.dart`
- **`RandomDistribution<T>`**: Interface for mapping uniform bits into mathematical shapes.
- **`UniformIntDistribution` & `UniformRealDistribution`**: Flat probabilities bounded within strict numeric intervals.
- **`BernoulliDistribution` & `BinomialDistribution`**: Rigged coin flips and multi-trial success probabilities.
- **`NormalDistribution`**: Bell curve continuous distributions using the Box-Muller transform.
- **`ExponentialDistribution` & `PoissonDistribution`**: Wait times and event occurrence rates.
- **`GammaDistribution` & `ChiSquaredDistribution`**: Advanced continuous distributions leveraging the Marsaglia and Tsang method.

#### Upgraded: `StdRandom`
- The `StdRandom` wrapper class is now completely retrofitted to wrap a core `RandomEngine` directly. It supports interchangeable backends and cleanly mimics standard `rand()` execution behavior natively.

---

# 0.6.9

## Advanced String Algorithms (`<string>` / `<regex>`)

### New Feature: `string` module
Introduced a powerful C++-inspired text processing module to complement Dart's native string capabilities.

#### `regex.dart`
- **`Regex`**: A powerful, object-oriented wrapper around Dart's `RegExp`, inspired by C++ `std::regex`.
- **`regexMatch`**: Mirrors `std::regex_match` (determines if the entire string strictly matches the pattern).
- **`regexSearch`**: Mirrors `std::regex_search` (finds the first sub-sequence matching the pattern).
- **`regexReplace`**: Mirrors `std::regex_replace`.
- **`RegexIterator`**: A lazy iterator mirroring `std::sregex_iterator` to sequentially extract all non-overlapping matches without allocating a single block of memory upfront.

#### `search.dart`
- **`knuthMorrisPrattSearch`**: $O(N+M)$ Knuth-Morris-Pratt (KMP) text search algorithm.
- **`boyerMooreSearch`**: Boyer-Moore text search algorithm utilizing the bad-character heuristic for highly efficient, sublinear average-case text searching.

#### `format.dart`
- **`format`**: A type-safe string formatting utility inspired by C++20 `<format>`. Uses a `List<dynamic>` to pass variadic arguments while safely type-guarding before injection. Supports automatic indexing `{}`, positional indexing `{1}`, and type-specific formatters (e.g. `{:.2f}`, `{:x}`, `{:04d}`).
- **`printFormat`**: Utility to immediately print formatted strings.

### Other Improvements
- **Documentation**: Added missing doc comment to `LapStopwatch.new` (default constructor).
- **Tests**: Added comprehensive test suites for regex operations, text search algorithms, and the format utility.
- **Example**: Added `example/string_example.dart` end-to-end demonstration.

---

# 0.6.8
## Documentation — API Coverage Completion for Symbolic Math Module

### Problem

The Dart analyser enforces the `public_member_api_docs` lint rule (declared in `analysis_options.yaml`), which requires every public API member — including fields and constructors — to carry a `///` dartdoc comment. When the symbolic math module was introduced in v0.6.6 the class-level documentation was written, but the **individual fields and constructors** of the AST node classes were left undocumented, producing **33 `info`-level warnings** across three files.

### Root Cause

Three newly introduced files were missing `///` doc comments on their public members:

| File | Members missing docs |
|---|---|
| `lib/src/math/symbolic/expression.dart` | `const Expression()` (base constructor) + `value`/constructor in `ConstantExpr`; `left`, `right`, constructor in `Add`, `Sub`, `Mul`, `Div`; `expr`/constructor in `Neg`, `Sin`, `Cos`, `Log`, `Exp`; `baseExpr`, `exponentExpr`, constructor in `Pow` — **28 warnings** |
| `lib/src/math/algebra/equation.dart` | `left`, `right`, `const Equation(…)` — **3 warnings** |
| `lib/src/math/symbolic/variable.dart` | `name`, `const Variable(…)` — **2 warnings** |

### Solution

Added concise, accurate `///` dartdoc comments to every flagged public member:

- **`Expression`** — documented the protected default constructor.
- **`ConstantExpr`** — `value` field and its constructor.
- **Binary node classes (`Add`, `Sub`, `Mul`, `Div`)** — `left`/`right` fields named semantically (`minuend`/`subtrahend` for `Sub`, `numerator`/`denominator` for `Div`) and their constructors.
- **Unary node classes (`Neg`, `Sin`, `Cos`, `Log`, `Exp`)** — `expr` field and constructor, each describing the mathematical role.
- **`Pow`** — `baseExpr` and `exponentExpr` fields and the constructor.
- **`Variable`** — `name` field (with backtick examples `'x'`, `'y'`) and the constructor.
- **`Equation`** — `left` (LHS) and `right` (RHS) fields and the constructor.

### Result

`dart analyze` now reports **0 issues** (was 33). The full public API surface of the symbolic/algebra module is now consistently documented in line with every other module in the library.

---

# 0.6.7

## Ranges — Predicate-Based Slicing

### New File: `ranges/take_while_range.dart`

- **`TakeWhileRange<T>`** — A lazy view that yields elements from the front of an iterable *as long as* a predicate holds, stopping permanently at the first failing element. Mirrors C++20 `std::views::take_while`.
  - Constructor: `TakeWhileRange(Iterable<T> source, bool Function(T) predicate)`.
  - Semantics: once `predicate(element)` returns `false`, iteration halts regardless of subsequent elements — fundamentally different from `FilterRange` which skips non-matching elements and continues.
  - Works on infinite sources (e.g. `IotaRange`, `CycleRange`, `RepeatRange`) safely.

### New File: `ranges/drop_while_range.dart`

- **`DropWhileRange<T>`** — A lazy view that skips elements from the front of an iterable *while* a predicate holds, then yields all remaining elements unchanged. Mirrors C++20 `std::views::drop_while`.
  - Constructor: `DropWhileRange(Iterable<T> source, bool Function(T) predicate)`.
  - Semantics: once the predicate first fails the skip phase ends and *every* subsequent element is emitted — including those that would again satisfy the predicate.
  - The skip phase runs exactly once per iterator, making repeated iteration correct.

### New Tests (`test/take_while_range_test.dart`, `test/drop_while_range_test.dart`)

Added **~60 new tests** across 2 new test files:

| File | What is covered |
|---|---|
| `test/take_while_range_test.dart` | Basic predicate halt; empty source; all-match (full yield); none-match (empty yield); stop at first failure mid-sequence; reusability (two passes over same view); composition with `TakeRange` and `FilterRange`; works on infinite `IotaRange`; `length`, `first`, `last`, `isEmpty`, `isNotEmpty` |
| `test/drop_while_range_test.dart` | Basic prefix skip; empty source; all-match (empty yield); none-match (full yield); resumes all including re-matching elements; reusability (two passes); composition with `TakeRange`; works after `TakeWhileRange`; `length`, `first`, `last`, `isEmpty`, `isNotEmpty` |

### New Example (`example/take_while_drop_while_example.dart`)

End-to-end demonstration: predicate-stop on sorted data, trimming leading zeros, word prefix extraction, composing `TakeWhileRange` + `DropWhileRange` to extract an inner span, and operating on an infinite `IotaRange`.

---

# 0.6.6

## Math — Comprehensive Algebraic & Calculus Expansion

- **New Feature**: Implemented a comprehensive `math/symbolic` module containing `Expression`, `Variable`, and `simplification` to build and evaluate symbolic math expressions, allowing modern intuitive usage for programmers and non-math experts.
- **New Feature**: Implemented a `math/algebra` module featuring `Polynomial`, `Rational`, and `Equation` classes. Supports exact arithmetic, equation solving, and polynomial operations.
- **New Feature**: Implemented a `math/calculus` module providing both numeric and symbolic differentiation and integration tools. Includes beautiful APIs like `derivative()` and `integrate()`.
- **New Constants**: Added advanced mathematical constants to `constant.dart` and aligned `Rational` representation.
- **Methodology & Design Choices**:
  - *Numerical Integration*: Implemented via **Simpson's 1/3 Rule**. Chosen for its superior O(h⁴) error convergence on smooth curves compared to standard Riemann or trapezoidal sums, achieving high precision with fewer iterations.
  - *Numerical Differentiation*: Implemented via the **Central Difference Method**. Chosen because it provides a balanced O(h²) accuracy compared to the O(h) accuracy of simple forward/backward differences, minimizing floating-point cancellation errors.
  - *Symbolic Mathematics*: Implemented using an **Abstract Syntax Tree (AST)** architecture. Chosen as it is the most robust way to process exact algebraic manipulations, recursive simplification, and symbolic derivatives without losing structural context.

# 0.6.5

## Chrono — Time Expansion

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
