# 💎 STL (Standard Template Library... and Beyond!)

[![Pub Version](https://img.shields.io/pub/v/stl?color=00b4ab&style=for-the-badge)](https://pub.dev/packages/stl)
[![License: MIT](https://img.shields.io/badge/License-MIT-ff69b4.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

> 🚀 **A versatile, high-performance bank of data collections and structures for the Dart and Flutter ecosystem.**

---

## 🌈 The Vision

Originally inspired by the C++ Standard Template Library (STL), this package has evolved! 🦋 It's **not** just a drop-in replacement anymore. Instead, it serves as a comprehensive **bank of diverse collections** for all your data structure needs. Whether you need familiar sequential containers, complex associative maps, or specialized algorithmic structures, `stl` is here to power up your Dart applications! ✨

### 🎯 Why use this package?

* 📦 **Massive Bank of Collections:** From `Vector` and `Deque` to `Stack`, `Pair`, and `ForwardList`!
* ⚡ **Deterministic Performance:** Predictable time complexity ($O(1)$, $O(\log n)$, etc.) focusing on optimized system-level logic.
* 🛠 **Familiar yet Dart-y API:** Native `Iterable` mixins seamlessly integrated with perfectly replicated C++ architectural rules, wrapped cleanly in standard Dart `camelCase` for maximum interoperability.
* 🎨 **Ready for Everything:** Perfect for logic-heavy Flutter apps, game engines, state management, or backend systems.

---

## 📚 What's Inside? (The Collection Bank)

Here are the data structures we currently support (and what we are actively building):

| Category | Data Structure | Status | Description |
| :--- | :--- | :---: | :--- |
| **Linear** | 🚂 `Vector<T>` | ✅ | Dynamic array with $O(1)$ random access. |
| | 🚅 `ForwardList<T>` | ✅ | Singly linked list for fast forward traversal. |
| | 🚋 `List<T>` | 🚧 | Doubly linked list for constant time insertions. |
| **Adapters** | 🥞 `Stack<T>` | ✅ | LIFO (Last-In, First-Out) data structure over a deque. |
| | 🚏 `Queue<T>` | 🚧 | FIFO (First-In, First-Out) data structure. |
| | 🌭 `Deque<T>` | ✅ | Double-ended queue for fast front/back operations. |
| **Utility** | 👯 `Pair<T1, T2>` | ✅ | Native C++ utility structure to hold heterogeneous objects, featuring deep equality, record destructuring, and map translations. |

> *(Note: 🚧 = Under Construction, ✅ = Available)*

---

## 🔥 Getting Started

Add some magic to your `pubspec.yaml` file:

```yaml
dependencies: 
  stl: ^0.2.3
```

Then fetch the latest version and import it in your codebase:
```bash
dart pub get
```
```dart
import 'package:stl/stl.dart';
```

---

## 💻 Quick Usage Examples

Your collections natively support `camelCase` methods mirroring strict C++ structure!

### Vector Showcase
```dart
final vec = Vector<String>(['Apple', 'Banana']);
vec.pushBack('Cherry');
print(vec.back()); // "Cherry"
```

### Stack & Iterables
```dart
final stack = Stack<int>.from([1, 2, 3]); // Top element is 3
var removed = stack.pop(); // Returns 3

// Instantly iterable because of IterableMixin! 
// Iterates top-to-bottom!
for (var item in stack) {
  print(item); // 2, 1
}
```

### The Powerful Pair
```dart
// Effortless generation
var duo = makePair(99, 'Balloons');

// Native Dart 3 Tuple/Record interop!
var (count, item) = duo.record;

// Deep equality across arrays, maps, and tests!
var sibling = makePair(99, 'Balloons');
print(duo == sibling); // True!
```

---

## 💖 Contributing

We are building a robust repository of collections! Want to add a new exotic data structure to the bank? We welcome pull requests! Let's make this the most colorful and robust collection package in the Dart ecosystem. 🌟

---
*Built with ❤️ for Dart & Flutter.*
