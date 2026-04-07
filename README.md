# 💎 STL (Standard Template Library... and Beyond!)

[![Pub Version](https://img.shields.io/pub/v/stl?color=00b4ab&style=for-the-badge)](https://pub.dev/packages/stl)
[![License: MIT](https://img.shields.io/badge/License-MIT-ff69b4.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

> 🚀 **A versatile, high-performance bank of data collections and structures for the Dart and Flutter ecosystem.**

---

## 🌈 The Vision

Originally inspired by the C++ Standard Template Library (STL), this package has evolved! 🦋 It's **not** just a drop-in replacement anymore. Instead, it serves as a comprehensive **bank of diverse collections** for all your data structure needs. Whether you need familiar sequential containers, complex associative maps, or specialized algorithmic structures, `stl` is here to power up your Dart applications! ✨

### 🎯 Why use this package?

* 📦 **Massive Bank of Collections:** From `Vector` and `Deque` to `Stack`, `ForwardList`, and more!
* ⚡ **Deterministic Performance:** Predictable time complexity ($O(1)$, $O(\log n)$, etc.) focusing on optimized system-level logic.
* 🛠 **Familiar yet Dart-y API:** Intuitive interfaces that blend classic collection methodologies with Dart's modern paradigms.
* 🎨 **Ready for Everything:** Perfect for logic-heavy Flutter apps, game engines, state management, or backend systems.

---

## 📚 What's Inside? (The Collection Bank)

Here are the data structures we currently support (and what we are actively building):

| Category | Data Structure | Status | Description |
| :--- | :--- | :---: | :--- |
| **Linear** | 🚂 `Vector<T>` | ✅ | Dynamic array with $O(1)$ random access. |
| | 🚅 `ForwardList<T>` | ✅ | Singly linked list for fast forward traversal. |
| | 🚋 `List<T>` | 🚧 | Doubly linked list for constant time insertions. |
| **Adapters** | 🥞 `Stack<T>` | ✅ | LIFO (Last-In, First-Out) data structure. |
| | 🚏 `Queue<T>` | 🚧 | FIFO (First-In, First-Out) data structure. |
| | 🌭 `Deque<T>` | ✅ | Double-ended queue for fast front/back operations. |

> *(Note: 🚧 = Under Construction, ✅ = Available)*

---

## 🔥 Getting Started

Add some magic to your `pubspec.yaml` file:

```yaml
dependencies: 
  stl: ^0.2.2
```

Then fetch the latest version:
```bash
dart pub get
```

Import it in your next big project:
```dart
import 'package:stl/stl.dart';
```

---

## 💖 Contributing

We are building a robust repository of collections! Want to add a new exotic data structure to the bank? We welcome pull requests! Let's make this the most colorful and robust collection package in the Dart ecosystem. 🌟

---
*Built with ❤️ for Dart & Flutter.*
