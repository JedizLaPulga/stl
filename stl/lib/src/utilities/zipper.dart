import '../exceptions/exceptions.dart';

/// An immutable cursor-based view over a sequence, inspired by Huet's Zipper (1997).
///
/// A [Zipper] splits a list into three parts:
/// - [left]: elements to the left of the cursor (stored in reverse for O(1) navigation).
/// - [focus]: the element currently under the cursor.
/// - [right]: elements to the right of the cursor.
///
/// All navigation and modification operations return a **new** [Zipper] instance.
/// The original is never mutated. Use [toList] to reconstruct the full sequence.
///
/// ```dart
/// final z = Zipper.fromList([1, 2, 3, 4, 5]);
/// print(z.focus);          // 1
/// final z2 = z.moveRight();
/// print(z2.focus);         // 2
/// final z3 = z2.replace(99);
/// print(z3.toList());      // [1, 99, 3, 4, 5]
/// ```
final class Zipper<T> {
  /// Elements to the left of the cursor, stored in **reverse** order for O(1) navigation.
  final List<T> _left;

  /// The element currently under the cursor.
  final T focus;

  /// Elements to the right of the cursor, in natural order.
  final List<T> _right;

  Zipper._(List<T> left, this.focus, List<T> right)
    : _left = List.unmodifiable(left),
      _right = List.unmodifiable(right);

  /// Creates a [Zipper] positioned at index 0 of [list].
  ///
  /// Throws [InvalidArgument] if [list] is empty.
  factory Zipper.fromList(List<T> list) {
    if (list.isEmpty) {
      throw InvalidArgument('Cannot create a Zipper from an empty list.');
    }
    return Zipper._([], list.first, list.sublist(1));
  }

  /// Creates a [Zipper] positioned at [index] of [list].
  ///
  /// Throws [InvalidArgument] if [list] is empty.
  /// Throws [RangeError] if [index] is out of bounds.
  factory Zipper.fromListAt(List<T> list, int index) {
    if (list.isEmpty) {
      throw InvalidArgument('Cannot create a Zipper from an empty list.');
    }
    if (index < 0 || index >= list.length) {
      throw RangeError.index(index, list, 'index');
    }
    return Zipper._(
      list.sublist(0, index).reversed.toList(growable: false),
      list[index],
      list.sublist(index + 1),
    );
  }

  /// Returns `true` if there are elements to the left of the cursor.
  bool get canMoveLeft => _left.isNotEmpty;

  /// Returns `true` if there are elements to the right of the cursor.
  bool get canMoveRight => _right.isNotEmpty;

  /// Returns the current cursor position (0-based index in the full sequence).
  int get index => _left.length;

  /// Returns the total number of elements in the sequence.
  int get length => _left.length + 1 + _right.length;

  /// Returns an unmodifiable view of the right context.
  List<T> get right => _right;

  /// Returns the left context in natural (non-reversed) order.
  List<T> get left => _left.reversed.toList(growable: false);

  /// Moves the cursor one step to the left.
  ///
  /// Throws [StateError] if the cursor is already at the leftmost position.
  Zipper<T> moveLeft() {
    if (!canMoveLeft) {
      throw StateError(
        'Cannot move left: already at the beginning of the sequence.',
      );
    }
    return Zipper._(_left.sublist(1), _left.first, [focus, ..._right]);
  }

  /// Moves the cursor one step to the right.
  ///
  /// Throws [StateError] if the cursor is already at the rightmost position.
  Zipper<T> moveRight() {
    if (!canMoveRight) {
      throw StateError(
        'Cannot move right: already at the end of the sequence.',
      );
    }
    return Zipper._([focus, ..._left], _right.first, _right.sublist(1));
  }

  /// Returns a new [Zipper] with [focus] replaced by [newFocus].
  Zipper<T> replace(T newFocus) => Zipper._(_left, newFocus, _right);

  /// Returns a new [Zipper] with [value] inserted immediately before [focus].
  ///
  /// The cursor remains on the original [focus] after insertion.
  Zipper<T> insert(T value) => Zipper._([value, ..._left], focus, _right);

  /// Removes [focus] and returns a new [Zipper] focused on the next element.
  ///
  /// If there are elements to the right, the cursor moves to the first right element.
  /// Otherwise, it moves to the last left element.
  /// Throws [StateError] if this is the only element in the sequence.
  Zipper<T> delete() {
    if (_right.isNotEmpty) {
      return Zipper._(_left, _right.first, _right.sublist(1));
    } else if (_left.isNotEmpty) {
      return Zipper._(_left.sublist(1), _left.first, []);
    } else {
      throw StateError(
        'Cannot delete: this is the only element in the sequence.',
      );
    }
  }

  /// Reconstructs the full sequence as a [List] in natural order.
  List<T> toList({bool growable = true}) {
    final result = [..._left.reversed, focus, ..._right];
    return growable ? result : List.unmodifiable(result);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Zipper<T>) return false;
    return focus == other.focus &&
        _listEquals(_left, other._left) &&
        _listEquals(_right, other._right);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(_left), focus, Object.hashAll(_right));

  @override
  String toString() => 'Zipper(left: $left, focus: $focus, right: $_right)';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
