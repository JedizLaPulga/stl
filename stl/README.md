<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Diamond.png" alt="Diamond" width="80" height="80" />
  
  # STL (Standard Template Library... and Beyond!)

  [![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=20&pause=1000&color=00B4AB&center=true&vCenter=true&width=435&lines=Dart+Collections+Reimagined;C%2B%2B+STL+Inspired+Architecture;Lightning+Fast+Data+Structures;Now+featuring+C%2B%2B23+Ranges!)](https://git.io/typing-svg)

  [![Pub Version](https://img.shields.io/pub/v/stl?color=00b4ab&style=for-the-badge&logo=dart)](https://pub.dev/packages/stl)
  [![License: MIT](https://img.shields.io/badge/License-MIT-ff69b4.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  <br>

  > 🚀 **A highly-versatile, performance-driven bank of data collections, structures, and algorithmic ranges for the Dart and Flutter ecosystem.**

</div>

---

<br>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Star-Struck.png" alt="Star-Struck" width="45" height="45" />
</div>

## 🌈 The Vision

Originally inspired by the strict blueprints of the **C++ Standard Template Library (STL)**, this package has heavily evolved! 🦋 It's **not** just a drop-in replacement anymore. 

Instead, it serves as a comprehensive **bank of diverse collections** for all your data structure needs. Whether you need familiar sequential containers, complex associative maps, specialized utility adapters, or bleeding-edge C++23 functional ranges, `stl` is here to drastically supercharge your Dart architecture! ✨

### 🎯 Why use this package over standard Dart tools?

* 📦 **Massive Bank of Collections:** Unlocking custom abilities via `Vector`, `Deque`, `Stack`, `ForwardList`, and more!
* 🌀 **Next-Gen Iteration:** Introducing **Ranges**! Seamlessly generate subsets, zips, Cartesian products, and infinite loops on the fly without breaking your memory!
* ⚡ **Deterministic Performance:** Predictable time complexity ($O(1)$, $O(\log n)$, etc.) focusing on heavily optimized system-level logic.
* 🛠 **Familiar yet Dart-y API:** Native `Iterable` mixins seamlessly integrated with perfectly replicated C++ architectural rules, wrapped cleanly in standard Dart `camelCase` for maximum ecosystem interoperability.
* 🎨 **Ready for Everything:** Perfect for logic-heavy Flutter apps, scalable game engines, dynamic state management, or enterprise backend systems.

<br>

---

<br>

## 📚 The Collection Bank 

Here are the traditional core data structures we currently support:

| Category | Data Structure | Status | Description |
| :--- | :--- | :---: | :--- |
| **Linear** | 🚂 `Vector<T>` | ✅ | Dynamic array with $O(1)$ random access and strict bounds checking. |
| | 🚅 `ForwardList<T>` | ✅ | Singly linked list for extremely fast forward traversal and shifting. |
| | 🚋 `List<T>` | 🚧 | *Doubly linked list for constant time insertions (Coming Soon).* |
| **Adapters** | 🥞 `Stack<T>` | ✅ | LIFO (Last-In, First-Out) data structure operating flawlessly over a given sequence. |
| | 🚏 `Queue<T>` | ✅ | FIFO (First-In, First-Out) data structure adapter. |
| | ⏳ `PriorityQueue<T>` | ✅ | Max/Min heap priority structure. |
| **Associative**| 🗃️ `Set<T>` | ✅ | Unique element container (O(1) lookups). |
| | 🗄️ `HashSet<T>` | ✅ | Unordered unique element container (std::unordered_set). |
| | 🌲 `SortedSet<T>` | 🚧 | *Tree-based sorted unique container (Coming Soon).* |
| | 🌭 `Deque<T>` | ✅ | Double-ended queue for extremely fast front/back algorithmic operations. |
| **Utility** | 👯 `Pair<T1, T2>` | ✅ | Native C++ utility structure to hold heterogeneous objects (Features Dart 3 Record translation). |

*(Note: 🚧 = Under Construction, ✅ = Available)*

<br>

---

<br>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Symbols/Fire.png" alt="Fire" width="50" height="50" />
</div>

## 🧬 Ranges Module (NEW in 0.2.4!)

Welcome to functional magic! Inspired deeply by **C++23 `std::views`**, our new Ranges module allows you to cleanly manipulate, combine, generate, and stream data iteratively without eagerly consuming memory! 

<details open>
<summary><b>🔥 NumberLine (Ranges & Iterables)</b></summary>
<br>

Mimicking `std::views::iota`. Generate extremely precise linear layouts of floating-point boundaries, or standard integer jumps.

```dart
// Custom Step Increment of 4 (0 to 20):
final evens = NumberLine(0, 20, step: 4);
print(evens.toList()); // [0, 4, 8, 12, 16]

// Wait! This is deeply mathematically optimized!
// Checking for values does NOT generate an array. O(1) performance.
print(evens.contains(12)); // True! Highly optimized.
```
</details>

<details>
<summary><b>🔥 ZipRange (Parallel Iteration)</b></summary>
<br>

Mimics `std::views::zip`. Dynamically clamp two different sized iterables together strictly until one expires. Extremely useful for Map generation!

```dart
final userIds = [101, 102, 103, 104];
final roles = ['Admin', 'Editor', 'Viewer']; // Uneven lengths!

final zippedRoles = ZipRange(userIds, roles);
// Dynamically casts into Dart Maps seamlessly!
final roleMap = Map.fromEntries(zippedRoles.map((p) => p.toMapEntry()));
// Results: {101: Admin, 102: Editor, 103: Viewer}
```
</details>

<details>
<summary><b>🔥 ChunkRange (Data Fragmentation)</b></summary>
<br>

Mimics `std::views::chunk`. Need to send network packets? Paginate rendering blocks? `ChunkRange` splits data strictly.

```dart
final largeDataset = [1, 2, 3, 4, 5, 6, 7];
final pagination = ChunkRange(largeDataset, 3);
print(pagination.toList()); 
// Results: [[1, 2, 3], [4, 5, 6], [7]]
```
</details>


<details>
<summary><b>🔥 CartesianRange (Combinations)</b></summary>
<br>

Mimics `std::views::cartesian_product`. Produces flat pair intersections elegantly for combinatorics mapping.

```dart
final shapes = ['Circle', 'Square'];
final colors = ['Red', 'Green'];

final combinations = CartesianRange(shapes, colors);
// Iterates: Red Circle, Green Circle, Red Square, Green Square.
```
</details>

<details>
<summary><b>🔥 RepeatRange (Infinite Fills)</b></summary>
<br>

Mimics `std::views::repeat`. Repeats data strictly... or **infinitely**.

```dart
final infiniteZeros = RepeatRange(0);
print(infiniteZeros.take(10).toList()); // [0,0,0,0,0,0,0,0,0,0]
```
</details>


<br>

---

<br>

## 🚀 Getting Started

Inject some hardcore C++ styled performance logic directly into your Dart pipelines. Add to your `pubspec.yaml` file:

```yaml
dependencies: 
  stl: ^0.2.6
```

Then fetch the latest version and drop it into your project:
```bash
dart pub get
```
```dart
import 'package:stl/stl.dart';
```

<br>

---

<br>

## 💻 Spotlight Features

Your collections natively support `camelCase` methods mirroring strict C++ structure!

### **Vector Memory Blocks**
```dart
final vec = Vector<String>(['Apple', 'Banana']);
vec.pushBack('Cherry');
print(vec.back()); // "Cherry"
```

### **The Powerful `Pair`**
```dart
// Effortless generation
var duo = makePair(99, 'Balloons');

// Native Dart 3 Tuple/Record interop!
var (count, item) = duo.record;

// Deep equality across arrays, maps, and tests is natively handled:
var sibling = makePair(99, 'Balloons');
print(duo == sibling); // True!
```


### **LIFO Stacks & Native Iterables**
```dart
final stack = Stack<int>.from([1, 2, 3]); // Top element is 3
var removed = stack.pop(); // Returns 3

// Instantly iterable because of Native Dart IterableMixins! 
// Strictly iterates top-to-bottom safely!
for (var item in stack) {
  print(item); // 2, 1
}
```

<br>

---

<br>

## 💖 Contributing

Want to add a new exotic data structure or missing `std::ranges` feature to the bank? We welcome pull requests! Let's make this the most colorful, performant, and robust algorithmic package in the Dart ecosystem. 🌟

<p align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png" alt="Rocket" width="35" height="35" /> <i>Built with ❤️ for Dart & Flutter integrations.</i> <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png" alt="Rocket" width="35" height="35" />
</p>
