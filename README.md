# stl

[![Pub Version](https://img.shields.io/pub/v/stl?color=blue&style=flat-square)](https://pub.dev/packages/stl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A performance-oriented implementation of Standard Template Library (STL) patterns for the Dart language. 

## 🧪 Project Status: In Active Development

**Note:** This package is currently in its early stages. The goal is to bring the efficiency, deterministic behavior, and familiar data structures of the C++ STL to the Dart and Flutter ecosystem, specifically focusing on systems-level logic and performance-heavy applications.

---

## 🚀 Vision

While Dart provides excellent high-level collections, `package:stl` aims to fill the gap for developers who need:
* **Familiar API:** Containers and algorithms that follow the naming conventions of the C++ Standard Library.
* **Deterministic Performance:** Predictable complexity for operations like `push_back`, `pop_front`, and sorting.
* **Advanced Structures:** Data structures not currently found in `dart:collection`.

## 🛠 Features (Current & Roadmap)

- [x] **Project Foundation:** Initial structure and naming.
- [ ] **Sequential Containers:**
    - `Vector<T>`: Dynamic array with $O(1)$ random access.
    - `List<T>`: Doubly linked list for constant time insertions.
    - `Deque<T>`: Double-ended queue.
- [ ] **Associative Containers:**
    - `OrderedMap<K, V>` and `Set<T>`.
- [ ] **Algorithms:**
    - Custom Sort, Binary Search, and Heap manipulation.

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies: 
  stl: ^0.1.7   
