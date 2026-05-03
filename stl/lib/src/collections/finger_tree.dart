import 'dart:collection';

// =============================================================================
// Internal node types — not exported
// =============================================================================

/// Internal 2-node: holds 2 child elements and their combined size.
final class _Node2<T> {
  final T a, b;
  final int size;
  const _Node2(this.a, this.b, this.size);
}

/// Internal 3-node: holds 3 child elements and their combined size.
final class _Node3<T> {
  final T a, b, c;
  final int size;
  const _Node3(this.a, this.b, this.c, this.size);
}

// =============================================================================
// Digit — 1–4 element affix stored at each tree level
// =============================================================================

final class _Digit<T> {
  final List<T> elems; // 1–4 elements
  const _Digit(this.elems);
  int get size => elems.length;
}

// =============================================================================
// Public FingerTree sealed hierarchy
// =============================================================================

/// A persistent, immutable 2-3 finger tree supporting:
/// - O(1) amortized [prepend] and [append]
/// - O(log n) [concat] and [splitAt]
/// - O(1) [length], [first], [last], [isEmpty]
///
/// Based on Hinze & Paterson, "Finger Trees: A Simple General-Purpose Data
/// Structure" (2006). All operations return **new** instances; nothing is
/// mutated in-place.
///
/// ```dart
/// var ft = FingerTree<int>.empty();
/// ft = ft.append(1).append(2).append(3).prepend(0);
/// print(ft.toList()); // [0, 1, 2, 3]
///
/// final (left, right) = ft.splitAt(2);
/// print(left.toList());  // [0, 1]
/// print(right.toList()); // [2, 3]
///
/// final cat = left.concat(right);
/// print(cat.toList()); // [0, 1, 2, 3]
/// ```
sealed class FingerTree<T> with IterableMixin<T> {
  const FingerTree();

  /// Returns an empty [FingerTree].
  factory FingerTree.empty() = _FTEmpty<T>;

  /// Returns a [FingerTree] containing a single element.
  factory FingerTree.single(T value) = _FTSingle<T>;

  /// Builds a [FingerTree] from an [Iterable] in O(n) time.
  factory FingerTree.fromIterable(Iterable<T> iterable) {
    FingerTree<T> tree = _FTEmpty<T>();
    for (final e in iterable) {
      tree = tree.append(e);
    }
    return tree;
  }

  // ---------------------------------------------------------------------------
  // Core properties
  // ---------------------------------------------------------------------------

  /// Returns the number of elements. O(1).
  @override
  int get length;

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => length != 0;

  /// Returns the first element. Throws [StateError] if empty.
  @override
  T get first;

  /// Returns the last element. Throws [StateError] if empty.
  @override
  T get last;

  // ---------------------------------------------------------------------------
  // Structural operations
  // ---------------------------------------------------------------------------

  /// Prepends [value] to the front of the tree. O(1) amortized.
  FingerTree<T> prepend(T value);

  /// Appends [value] to the back of the tree. O(1) amortized.
  FingerTree<T> append(T value);

  /// Returns a new tree with the first element removed. Throws [StateError] if empty.
  FingerTree<T> removeFirst();

  /// Returns a new tree with the last element removed. Throws [StateError] if empty.
  FingerTree<T> removeLast();

  /// Concatenates this tree with [other] into a new tree. O(log n).
  FingerTree<T> concat(FingerTree<T> other);

  /// Splits the tree at [index], returning a record `(left, right)` where
  /// [left] contains the first [index] elements and [right] the remainder.
  ///
  /// O(log n). Throws [RangeError] if [index] is out of `[0, length]`.
  (FingerTree<T>, FingerTree<T>) splitAt(int index);

  /// Returns all elements as a [List] in O(n) time.
  @override
  List<T> toList({bool growable = true});

  @override
  Iterator<T> get iterator;
}

// =============================================================================
// _FTEmpty
// =============================================================================

final class _FTEmpty<T> extends FingerTree<T> {
  const _FTEmpty();

  @override
  int get length => 0;

  @override
  T get first => throw StateError('FingerTree is empty.');

  @override
  T get last => throw StateError('FingerTree is empty.');

  @override
  FingerTree<T> prepend(T value) => _FTSingle<T>(value);

  @override
  FingerTree<T> append(T value) => _FTSingle<T>(value);

  @override
  FingerTree<T> removeFirst() =>
      throw StateError('Cannot removeFirst from an empty FingerTree.');

  @override
  FingerTree<T> removeLast() =>
      throw StateError('Cannot removeLast from an empty FingerTree.');

  @override
  FingerTree<T> concat(FingerTree<T> other) => other;

  @override
  (FingerTree<T>, FingerTree<T>) splitAt(int index) {
    if (index != 0) throw RangeError.range(index, 0, 0, 'index');
    return (const _FTEmpty(), const _FTEmpty());
  }

  @override
  List<T> toList({bool growable = true}) =>
      growable ? [] : List.unmodifiable([]);

  @override
  Iterator<T> get iterator => const _EmptyIterator();

  @override
  bool operator ==(Object other) => other is _FTEmpty<T>;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'FingerTree.empty()';
}

// =============================================================================
// _FTSingle
// =============================================================================

final class _FTSingle<T> extends FingerTree<T> {
  final T value;
  const _FTSingle(this.value);

  @override
  int get length => 1;

  @override
  T get first => value;

  @override
  T get last => value;

  @override
  FingerTree<T> prepend(T v) =>
      _FTDeep<T>(_Digit([v]), _FTEmpty(), _Digit([value]), 2);

  @override
  FingerTree<T> append(T v) =>
      _FTDeep<T>(_Digit([value]), _FTEmpty(), _Digit([v]), 2);

  @override
  FingerTree<T> removeFirst() => const _FTEmpty();

  @override
  FingerTree<T> removeLast() => const _FTEmpty();

  @override
  FingerTree<T> concat(FingerTree<T> other) => other.prepend(value);

  @override
  (FingerTree<T>, FingerTree<T>) splitAt(int index) {
    if (index < 0 || index > 1) throw RangeError.range(index, 0, 1, 'index');
    if (index == 0) return (const _FTEmpty(), this);
    return (this, const _FTEmpty());
  }

  @override
  List<T> toList({bool growable = true}) {
    final result = [value];
    return growable ? result : List.unmodifiable(result);
  }

  @override
  Iterator<T> get iterator => _ListIterator([value]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _FTSingle<T> && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'FingerTree.single($value)';
}

// =============================================================================
// _FTDeep  — the main structural node
// =============================================================================

final class _FTDeep<T> extends FingerTree<T> {
  final _Digit<T> prefix;
  final FingerTree<Object?> spine; // spine holds _Node2/_Node3 as erasure
  final _Digit<T> suffix;
  @override
  final int length;

  const _FTDeep(this.prefix, this.spine, this.suffix, this.length);

  @override
  T get first => prefix.elems.first;

  @override
  T get last => suffix.elems.last;

  // --------------- prepend --------------------------------------------------

  @override
  FingerTree<T> prepend(T v) {
    if (prefix.size < 4) {
      return _FTDeep<T>(
        _Digit([v, ...prefix.elems]),
        spine,
        suffix,
        length + 1,
      );
    }
    // prefix is full (4 elems) — push a node into spine
    final a = prefix.elems[0];
    final b = prefix.elems[1];
    final c = prefix.elems[2];
    final d = prefix.elems[3];
    final node = _Node3<T>(b, c, d, 3);
    return _FTDeep<T>(_Digit([v, a]), spine.prepend(node), suffix, length + 1);
  }

  // --------------- append ---------------------------------------------------

  @override
  FingerTree<T> append(T v) {
    if (suffix.size < 4) {
      return _FTDeep<T>(
        prefix,
        spine,
        _Digit([...suffix.elems, v]),
        length + 1,
      );
    }
    // suffix is full — push a node into spine
    final a = suffix.elems[0];
    final b = suffix.elems[1];
    final c = suffix.elems[2];
    final d = suffix.elems[3];
    final node = _Node3<T>(a, b, c, 3);
    return _FTDeep<T>(prefix, spine.append(node), _Digit([d, v]), length + 1);
  }

  // --------------- removeFirst / removeLast ---------------------------------

  @override
  FingerTree<T> removeFirst() {
    if (prefix.size > 1) {
      return _FTDeep<T>(
        _Digit(prefix.elems.sublist(1)),
        spine,
        suffix,
        length - 1,
      );
    }
    // prefix has exactly 1 element — borrow from spine
    if (spine.isEmpty) {
      // Merge suffix into a tree
      if (suffix.size == 1) return const _FTEmpty();
      final newPrefix = _Digit([suffix.elems.first]);
      final newSuffix = _Digit(suffix.elems.sublist(1));
      return _FTDeep<T>(newPrefix, const _FTEmpty(), newSuffix, length - 1);
    }
    final newSpine = spine.removeFirst();
    final node = spine.first;
    final borrowed = _nodeToList<T>(node);
    return _FTDeep<T>(_Digit(borrowed), newSpine, suffix, length - 1);
  }

  @override
  FingerTree<T> removeLast() {
    if (suffix.size > 1) {
      return _FTDeep<T>(
        prefix,
        spine,
        _Digit(suffix.elems.sublist(0, suffix.size - 1)),
        length - 1,
      );
    }
    if (spine.isEmpty) {
      if (prefix.size == 1) return const _FTEmpty();
      final newSuffix = _Digit([prefix.elems.last]);
      final newPrefix = _Digit(prefix.elems.sublist(0, prefix.size - 1));
      return _FTDeep<T>(newPrefix, const _FTEmpty(), newSuffix, length - 1);
    }
    final newSpine = spine.removeLast();
    final node = spine.last;
    final borrowed = _nodeToList<T>(node);
    return _FTDeep<T>(prefix, newSpine, _Digit(borrowed), length - 1);
  }

  // --------------- concat ---------------------------------------------------

  @override
  FingerTree<T> concat(FingerTree<T> other) {
    return _concatWithMiddle<T>(this, [], other);
  }

  // --------------- splitAt --------------------------------------------------

  @override
  (FingerTree<T>, FingerTree<T>) splitAt(int index) {
    if (index < 0 || index > length) {
      throw RangeError.range(index, 0, length, 'index');
    }
    if (index == 0) return (const _FTEmpty(), this);
    if (index == length) return (this, const _FTEmpty());
    return _splitTree<T>(this, index);
  }

  // --------------- toList / iterator ----------------------------------------

  @override
  List<T> toList({bool growable = true}) {
    final result = <T>[];
    _collectInto(result);
    return growable ? result : List.unmodifiable(result);
  }

  void _collectInto(List<T> out) {
    out.addAll(prefix.elems);
    for (final node in spine) {
      out.addAll(_nodeToList<T>(node));
    }
    out.addAll(suffix.elems);
  }

  @override
  Iterator<T> get iterator => _ListIterator(toList(growable: false));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _FTDeep<T>) return false;
    if (length != other.length) return false;
    return toList() == other.toList();
  }

  @override
  int get hashCode => Object.hashAll(toList());

  @override
  String toString() => 'FingerTree(${toList()})';
}

// =============================================================================
// Internal helpers
// =============================================================================

/// Converts a _Node2 or _Node3 (stored as Object? for spine type erasure)
/// back into a flat list of elements.
List<T> _nodeToList<T>(Object? node) {
  if (node is _Node3) return [node.a as T, node.b as T, node.c as T];
  if (node is _Node2) return [node.a as T, node.b as T];
  throw StateError('Unexpected node type: ${node.runtimeType}');
}

/// Concatenates two deep trees with an optional list of middle elements.
FingerTree<T> _concatWithMiddle<T>(
  FingerTree<T> left,
  List<T> middle,
  FingerTree<T> right,
) {
  return switch ((left, right)) {
    (_FTEmpty(), _) => _prependAll(middle, right),
    (_, _FTEmpty()) => _appendAll(left, middle),
    (_FTSingle(:final value), _) => _concatWithMiddle<T>(_FTEmpty(), [
      value,
      ...middle,
    ], right),
    (_, _FTSingle(:final value)) => _concatWithMiddle<T>(left, [
      ...middle,
      value,
    ], _FTEmpty()),
    (
      _FTDeep(
        :final prefix,
        spine: final ls,
        suffix: final lsuffix,
        :final length,
      ),
      _FTDeep(
        prefix: final rprefix,
        spine: final rs,
        suffix: final rsuffix,
        length: final rLength,
      ),
    ) =>
      () {
        final allMiddle = [...lsuffix.elems, ...middle, ...rprefix.elems];
        final nodes = _makeNodes<T>(allMiddle);
        final newSpine = _concatWithMiddle<Object?>(ls, nodes, rs);
        return _FTDeep<T>(
          prefix,
          newSpine,
          rsuffix,
          length + middle.length + rLength,
        );
      }(),
  };
}

FingerTree<T> _prependAll<T>(List<T> elems, FingerTree<T> tree) {
  var t = tree;
  for (final e in elems.reversed) {
    t = t.prepend(e);
  }
  return t;
}

FingerTree<T> _appendAll<T>(FingerTree<T> tree, List<T> elems) {
  var t = tree;
  for (final e in elems) {
    t = t.append(e);
  }
  return t;
}

/// Packs a flat list into a list of _Node2/_Node3 objects (spine nodes).
List<Object?> _makeNodes<T>(List<T> elems) {
  final result = <Object?>[];
  var i = 0;
  while (i < elems.length) {
    final remaining = elems.length - i;
    if (remaining == 2) {
      result.add(_Node2<T>(elems[i], elems[i + 1], 2));
      i += 2;
    } else if (remaining == 4) {
      // Split 4 into two 2-nodes to avoid a 4-node
      result.add(_Node2<T>(elems[i], elems[i + 1], 2));
      result.add(_Node2<T>(elems[i + 2], elems[i + 3], 2));
      i += 4;
    } else {
      // 3 or more (not 4): take 3
      result.add(_Node3<T>(elems[i], elems[i + 1], elems[i + 2], 3));
      i += 3;
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// splitAt helper — O(log n) split using accumulated index
// ---------------------------------------------------------------------------

(FingerTree<T>, FingerTree<T>) _splitTree<T>(FingerTree<T> tree, int index) {
  if (tree is _FTEmpty<T>) {
    return (const _FTEmpty(), const _FTEmpty());
  }
  if (tree is _FTSingle<T>) {
    if (index == 0) return (const _FTEmpty(), tree);
    return (tree, const _FTEmpty());
  }
  final deep = tree as _FTDeep<T>;

  // Try prefix
  final prefixLen = deep.prefix.size;
  if (index <= prefixLen) {
    final (l, r) = _splitDigit(deep.prefix.elems, index);
    final rightTree = _prependAll(
      r,
      _deepL(_FTEmpty<T>(), deep.spine, deep.suffix),
    );
    final leftTree = FingerTree<T>.fromIterable(l);
    return (leftTree, rightTree);
  }

  // Try spine
  final actualSpineLen = deep.length - prefixLen - deep.suffix.size;

  if (index <= prefixLen + actualSpineLen) {
    final spineIndex = index - prefixLen;
    final (leftSpine, rightSpine) = _splitSpine<T>(deep.spine, spineIndex);
    final leftTree = _prependAll(deep.prefix.elems, leftSpine as FingerTree<T>);
    final rightTree = _appendAll(
      rightSpine as FingerTree<T>,
      deep.suffix.elems,
    );
    return (leftTree, rightTree);
  }

  // Must be in suffix
  final suffixStart = deep.length - deep.suffix.size;
  final suffixIndex = index - suffixStart;
  final (l, r) = _splitDigit(deep.suffix.elems, suffixIndex);
  final leftTree = _appendAll(
    _deepR(deep.prefix, deep.spine, _FTEmpty<T>()),
    l,
  );
  final rightTree = FingerTree<T>.fromIterable(r);
  return (leftTree, rightTree);
}

(List<T>, List<T>) _splitDigit<T>(List<T> elems, int index) {
  final clamped = index.clamp(0, elems.length);
  return (elems.sublist(0, clamped), elems.sublist(clamped));
}

/// Split spine (which holds Object? nodes) at a given element count.
(FingerTree<Object?>, FingerTree<Object?>) _splitSpine<T>(
  FingerTree<Object?> spine,
  int index,
) {
  if (spine.isEmpty) return (const _FTEmpty(), const _FTEmpty());
  // Walk elements to find split point
  int acc = 0;
  int i = 0;
  final elems = spine.toList();
  for (final node in elems) {
    final nodeSize = node is _Node3 ? 3 : (node is _Node2 ? 2 : 1);
    if (acc + nodeSize > index) break;
    acc += nodeSize;
    i++;
  }
  final leftSpine = FingerTree.fromIterable(elems.sublist(0, i));
  final rightSpine = FingerTree.fromIterable(elems.sublist(i));
  return (leftSpine, rightSpine);
}

FingerTree<T> _deepL<T>(
  FingerTree<T> prefix,
  FingerTree<Object?> spine,
  _Digit<T> suffix,
) {
  if (prefix.isEmpty) {
    if (spine.isEmpty) return FingerTree.fromIterable(suffix.elems);
    final node = spine.first;
    final borrowed = _nodeToList<T>(node);
    return _FTDeep<T>(
      _Digit(borrowed),
      spine.removeFirst(),
      suffix,
      borrowed.length + spine.length + suffix.size,
    );
  }
  return _FTDeep<T>(
    _Digit(prefix.toList()),
    spine,
    suffix,
    prefix.length + spine.length + suffix.size,
  );
}

FingerTree<T> _deepR<T>(
  _Digit<T> prefix,
  FingerTree<Object?> spine,
  FingerTree<T> suffix,
) {
  if (suffix.isEmpty) {
    if (spine.isEmpty) return FingerTree.fromIterable(prefix.elems);
    final node = spine.last;
    final borrowed = _nodeToList<T>(node);
    return _FTDeep<T>(
      prefix,
      spine.removeLast(),
      _Digit(borrowed),
      prefix.size + spine.length + borrowed.length,
    );
  }
  return _FTDeep<T>(
    prefix,
    spine,
    _Digit(suffix.toList()),
    prefix.size + spine.length + suffix.length,
  );
}

// =============================================================================
// Iterators
// =============================================================================

class _EmptyIterator<T> implements Iterator<T> {
  const _EmptyIterator();
  @override
  T get current => throw StateError('No current element.');
  @override
  bool moveNext() => false;
}

class _ListIterator<T> implements Iterator<T> {
  final List<T> _list;
  int _index = -1;
  _ListIterator(this._list);

  @override
  T get current => _list[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _list.length;
  }
}
