<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Diamond.png" alt="Diamond" width="100" height="100" />
  
  # STL (Standard Template Library... and Beyond!)

  [![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=20&pause=1000&color=00B4AB&center=true&vCenter=true&width=500&lines=Dart+Collections+Reimagined;C%2B%2B+STL+Inspired+Architecture;Lightning+Fast+Data+Structures;Now+featuring+C%2B%2B23+Ranges!)](https://git.io/typing-svg)

  [![License: MIT](https://img.shields.io/badge/License-MIT-ff69b4.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Pub Version](https://img.shields.io/badge/pub-0.3.3-blueviolet.svg?style=for-the-badge)](https://pub.dev/packages/stl)

  > 🚀 **A highly-versatile, performance-driven bank of data collections, structures, and algorithmic ranges for the Dart and Flutter ecosystem.**

  ---

  <br/>

  ### 🛠️ Quick Install
  
  ```bash
  dart pub add stl
  ```
  *or for Flutter:*
  ```bash
  flutter pub add stl
  ```

  <br/>

  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Star-Struck.png" alt="Star-Struck" width="55" height="55" />

</div>

## 🌈 The Vision

Originally inspired by the strict blueprints of the **C++ Standard Template Library (STL)**, this package has heavily evolved into a comprehensive **bank of diverse collections** for all your data structure needs. Whether you require familiar sequential containers, complex associative maps, specialized utility adapters, or bleeding-edge C++23 functional ranges, `stl` drastically supercharges your Dart architecture! ✨

### 🎯 Why use this package over standard Dart tools?

* 📦 **Massive Bank of Collections:** Unlock custom abilities via `Vector`, `Deque`, `Stack`, `ForwardList`, and more!
* 🌀 **Next-Gen Iteration:** Introducing **Ranges**! Seamlessly generate subsets, zips, Cartesian products, and infinite loops on the fly without breaking your memory limit.
* ⚡ **Deterministic Performance:** Predictable time complexity ($O(1)$, $O(\log n)$, etc.) with heavily optimized system-level logic.
* 🛠 **Familiar yet Dart-y API:** Native `Iterable` mixins seamlessly integrated with perfectly replicated C++ architectural rules, wrapped cleanly in standard Dart `camelCase` for maximum ecosystem interoperability.
* 🎨 **Ready for Everything:** Perfect for logic-heavy Flutter apps, scalable game engines, dynamic state management, or enterprise backend systems.

<br/>

---

<br/>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Open%20Book.png" alt="Book" width="50" height="50" />
</div>

## 📚 The Collection Bank 

Here are the traditional core data structures currently fully supported and battle-tested:

### 🚅 Linear Containers
| Data Structure | Description | Time Complexity (Access) |
| :--- | :--- | :---: |
| 🚂 **`Vector<T>`** | Dynamic array with contiguous memory behavior, strict bounds checking, and powerful modifiers. | $O(1)$ |
| 🚅 **`ForwardList<T>`** | Singly linked list optimized for extremely fast forward traversal, insertions, and shifting. | $O(N)$ |
| 🧊 **`Array<T>`** | Conceptually strict fixed-size contiguous array mirroring C++ `std::array`. | $O(1)$ |

### 🥞 Adapter Containers
| Data Structure | Description | Behavior |
| :--- | :--- | :---: |
| 🥞 **`Stack<T>`** | Custom LIFO (Last-In, First-Out) adapter. Operates flawlessly over any given sequence. | LIFO |
| 🚏 **`Queue<T>`** | Custom FIFO (First-In, First-Out) adapter for messaging and task processing. | FIFO |
| ⏳ **`PriorityQueue<T>`** | Max/Min heap priority structure. Constantly dynamically sorts elements upon insertion. | $O(\log N)$ |

### 🗃️ Associative Containers
| Data Structure | Description |
| :--- | :--- |
| 🗃️ **`Set<T>`** | Unique element container ensuring no duplicates with generic equality support. |
| 🌲 **`SortedSet<T>`** | Tree-based strictly sorted unique container mirroring C++ `std::set`. Keeps data autonomously ordered. |
| 🌭 **`Deque<T>`** | Double-ended queue allowing extremely fast front/back algorithmic insertions & removals without memory reallocation overhead. |

### 🛠️ Utility Structures
| Utility | Description |
| :--- | :--- |
| 👯 **`Pair<T1, T2>`** | Native C++ utility structure to hold heterogeneous objects. Features gorgeous Dart 3 Record translation. |
| ✨ **`Optional<T>`** | A beautifully sealed functional wrapper representing possibly-absent values smoothly without relying on raw `null` checks. |
| 🔀 **`Variant<T0, T1...>`** | Type-safe discriminated union handling distinct architectural alternatives elegantly via exhausted switch statements. |
| 📦 **`Box<T>` / `Ref<T>`** | Wrappers unlocking primitive pass-by-reference logic with dynamic mathematical operators. |
| 🔢 **`BitSet`** | Hyper-efficient space-optimized boolean bit flags array mimicking `std::bitset`. $O(1)$ toggles. |
| 👽 **`Any`** | Generic type-safe bounding box safely encapsulating abstract data with strictly enforced extraction boundaries. |

<br/>

---

<br/>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Symbols/Fire.png" alt="Fire" width="50" height="50" />
</div>

## 🧬 Ranges Module (Inspired by C++23)

Welcome to functional magic! Inspired deeply by **C++23 `std::views`**, our Ranges module allows you to cleanly manipulate, combine, generate, and stream data iteratively without aggressively eager memory consumption. Operations are performed **lazily**, bringing algorithmic elegance to your pipeline.

### 🔥 Spotlight Ranges

<details open>
<summary><b>📐 NumberLine (Iota)</b></summary>
<br>

Mimicking `std::views::iota`. Generate precise linear layouts of floating-point boundaries, or standard integer jumps, in mathematically optimized $O(1)$ operations instead of building massive explicit arrays.

```dart
// Custom Step Increment of 4 (0 to 20):
final evens = NumberLine(0, 20, step: 4);
print(evens.toList()); // [0, 4, 8, 12, 16]

// Highly mathematically optimized checks:
print(evens.contains(12)); // True! (Does NOT iterate over memory)
```
</details>

<details open>
<summary><b>🔗 ZipRange (Parallel Iteration)</b></summary>
<br>

Mimics `std::views::zip`. Dynamically clamp two different structured iterables together until the shortest one expires. Phenomenal for generating maps!

```dart
final keys = ['Player1', 'Player2', 'Player3'];
final scores = [9500, 8400]; // Uneven length!

final zipped = ZipRange(keys, scores);
final scoreMap = Map.fromEntries(zipped.map((p) => p.toMapEntry()));
// Results: {'Player1': 9500, 'Player2': 8400}
```
</details>

<details>
<summary><b>🔲 ChunkRange (Data Fragmentation)</b></summary>
<br>

Mimics `std::views::chunk`. Need to batch network packets or paginate rendering blocks? `ChunkRange` divides collections precisely into requested sizing constraints.

```dart
final data = [1, 2, 3, 4, 5, 6, 7];
final pagination = ChunkRange(data, 3);
print(pagination.toList()); 
// Results: [[1, 2, 3], [4, 5, 6], [7]]
```
</details>

<details>
<summary><b>🧩 CartesianRange (Combinations)</b></summary>
<br>

Mimics `std::views::cartesian_product`. Produces flat combinatorial intersections elegantly.

```dart
final suits = ['Hearts', 'Spades'];
final ranks = ['King', 'Queen'];

final deck = CartesianRange(suits, ranks);
// Yields Pairs: (Hearts, King), (Hearts, Queen), (Spades, King), (Spades, Queen)
```
</details>

<details>
<summary><b>♾️ RepeatRange (Infinite Streams)</b></summary>
<br>

Mimics `std::views::repeat`. Repeat specific data continuously or infinitely. Perfect for mock data pipelines!

```dart
final zeroes = RepeatRange(0);
print(zeroes.take(5).toList()); // [0, 0, 0, 0, 0]
```
</details>

<details>
<summary><b>✂️ TakeRange & DropRange (Slicing)</b></summary>
<br>

Mimics `std::views::take` and `std::views::drop`. Extract or ignore sections of an iterable pipeline iteratively without explicitly allocating memory-heavy sublists.

```dart
final data = NumberLine(1, 10).toList();
final middle = TakeRange(DropRange(data, 3), 4);
print(middle.toList()); // [4, 5, 6, 7]
```
</details>

<details>
<summary><b>🧪 FilterRange & TransformRange (Functional Hooks)</b></summary>
<br>

Mimics `std::views::filter` and `std::views::transform`. Eagerly processes data dynamically through custom conditional predicates and data type mutating hooks.

```dart
final data = [1, 2, 3, 4, 5];
// Keep evens, then multiply by 10
final tens = TransformRange<int, int>(FilterRange(data, (int n) => n % 2 == 0), (int n) => n * 10);
print(tens.toList()); // [20, 40]
```
</details>

<details>
<summary><b>🌊 JoinRange (Stream Flattening)</b></summary>
<br>

Mimics `std::views::join`. Instantly reassembles an iterable of iterables back into a perfectly contiguous 1-dimensional functional flow without recursive allocations.

```dart
final arrays = [[1, 2], [], [3, 4, 5], [6]];
final stream = JoinRange(arrays);
print(stream.toList()); // [1, 2, 3, 4, 5, 6]
```
</details>

<br/>

---

<br/>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Laptop.png" alt="Laptop" width="50" height="50" />
</div>

## 💻 Spotlight Integrations

By blending C++ architectures with Dart's `IterableMixin`, `stl` gives you incredible syntactical power:

### 🚂 **Vector Memory Architecture**
```dart
final vec = Vector<String>(['Apple', 'Banana']);
vec.pushBack('Cherry');
vec.popBack();
print(vec.front()); // "Apple"
```

### 👯 **The Powerful `Pair` & Dart 3 Records**
```dart
// Effortless Pair initialization
var duo = makePair(99, 'Balloons');

// Native Dart 3 tuple/record unwrapping
var (count, item) = duo.record;

// Native deep equality
var sibling = makePair(99, 'Balloons');
print(duo == sibling); // True!
```

### 🥞 **Iterable Adapters (`Stack`)**
```dart
final stack = Stack<int>.from([1, 2, 3]); // Top element is 3
var removed = stack.pop(); // Removes and returns 3

// Instantly iterable safely from top-to-bottom! 
for (var item in stack) {
  print(item); // 2, then 1
}
```

### 🌲 **Autonomous Self-Balancing Sets (`SortedSet`)**
```dart
final sorted = SortedSet<String>((a, b) => b.length.compareTo(a.length));
sorted.insert("Strawberry");
sorted.insert("Apple"); 
sorted.insert("A");

print(sorted.toList()); 
// ["Strawberry", "Apple", "A"] (Sorting strictly maintained on insert!)
```

<br/>

---

<br/>

## 💖 Contributing

Want to see an exotic data structure, an algorithmic graph traversal, or a missing `std::ranges` feature added to the library? We emphatically welcome pull requests, bug reports, and issue tickets. Let's make this the most powerful and scalable system-level algorithms repository in the Flutter and Dart ecosystem! 🌟

<br>

<p align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png" alt="Rocket" width="35" height="35" /> <i>Engineered with passion for Dart & Flutter architectures.</i> <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png" alt="Rocket" width="35" height="35" />
</p>
