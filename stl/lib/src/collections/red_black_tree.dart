

enum NodeColor { red, black }

class RBNode<K, V> {
  K key;
  V value;
  RBNode<K, V>? left;
  RBNode<K, V>? right;
  RBNode<K, V>? parent;
  NodeColor color;

  RBNode(this.key, this.value, {this.color = NodeColor.red});
}

/// A core self-balancing Red-Black Tree implementation.
class RedBlackTree<K, V> {
  RBNode<K, V>? root;
  int _size = 0;
  final int Function(K, K)? _compare;

  RedBlackTree([this._compare]);

  int get length => _size;
  bool get isEmpty => _size == 0;
  bool get isNotEmpty => _size > 0;

  int compare(K a, K b) {
    if (_compare != null) {
      return _compare(a, b);
    }
    return (a as Comparable).compareTo(b);
  }

  /// Inserts a key-value pair into the tree.
  /// If the key already exists, updates the value and returns false (not newly inserted).
  /// If it is newly inserted, returns true.
  bool insert(K key, V value) {
    RBNode<K, V>? y;
    RBNode<K, V>? x = root;

    while (x != null) {
      y = x;
      int cmp = compare(key, x.key);
      if (cmp < 0) {
        x = x.left;
      } else if (cmp > 0) {
        x = x.right;
      } else {
        // Key already exists, update value
        x.value = value;
        return false;
      }
    }

    RBNode<K, V> z = RBNode<K, V>(key, value);
    z.parent = y;

    if (y == null) {
      root = z;
    } else if (compare(z.key, y.key) < 0) {
      y.left = z;
    } else {
      y.right = z;
    }

    _size++;
    _insertFixup(z);
    return true;
  }

  void _insertFixup(RBNode<K, V> z) {
    while (z.parent != null && z.parent!.color == NodeColor.red) {
      if (z.parent == z.parent!.parent!.left) {
        RBNode<K, V>? y = z.parent!.parent!.right;
        if (y != null && y.color == NodeColor.red) {
          z.parent!.color = NodeColor.black;
          y.color = NodeColor.black;
          z.parent!.parent!.color = NodeColor.red;
          z = z.parent!.parent!;
        } else {
          if (z == z.parent!.right) {
            z = z.parent!;
            _leftRotate(z);
          }
          z.parent!.color = NodeColor.black;
          z.parent!.parent!.color = NodeColor.red;
          _rightRotate(z.parent!.parent!);
        }
      } else {
        RBNode<K, V>? y = z.parent!.parent!.left;
        if (y != null && y.color == NodeColor.red) {
          z.parent!.color = NodeColor.black;
          y.color = NodeColor.black;
          z.parent!.parent!.color = NodeColor.red;
          z = z.parent!.parent!;
        } else {
          if (z == z.parent!.left) {
            z = z.parent!;
            _rightRotate(z);
          }
          z.parent!.color = NodeColor.black;
          z.parent!.parent!.color = NodeColor.red;
          _leftRotate(z.parent!.parent!);
        }
      }
    }
    root!.color = NodeColor.black;
  }

  /// Removes the key from the tree. Returns true if removed, false if not found.
  bool erase(K key) {
    RBNode<K, V>? z = findNode(key);
    if (z == null) return false;

    RBNode<K, V> y = z;
    NodeColor yOriginalColor = y.color;
    RBNode<K, V>? x;

    if (z.left == null) {
      x = z.right;
      _transplant(z, z.right);
    } else if (z.right == null) {
      x = z.left;
      _transplant(z, z.left);
    } else {
      y = minimum(z.right!);
      yOriginalColor = y.color;
      x = y.right;
      if (y.parent == z) {
        if (x != null) x.parent = y;
      } else {
        _transplant(y, y.right);
        y.right = z.right;
        y.right!.parent = y;
      }
      _transplant(z, y);
      y.left = z.left;
      y.left!.parent = y;
      y.color = z.color;
    }

    _size--;
    if (yOriginalColor == NodeColor.black && x != null) {
      _eraseFixup(x);
    } else if (yOriginalColor == NodeColor.black && x == null && root != null) {
      // Edge case where x is null and y is a black leaf
      // We need a dummy node for fixup
      RBNode<K, V> dummy = RBNode<K, V>(z.key, z.value, color: NodeColor.black);
      dummy.parent = y.parent == z ? y : y.parent;
      if (dummy.parent != null) {
        if (dummy.parent!.left == null) {
          dummy.parent!.left = dummy;
        } else {
          dummy.parent!.right = dummy;
        }
      } else {
        root = dummy;
      }
      _eraseFixup(dummy);
      
      if (dummy.parent != null) {
        if (dummy.parent!.left == dummy) dummy.parent!.left = null;
        if (dummy.parent!.right == dummy) dummy.parent!.right = null;
      } else {
        root = null;
      }
    }

    return true;
  }

  void _eraseFixup(RBNode<K, V> x) {
    while (x != root && x.color == NodeColor.black) {
      if (x == x.parent!.left) {
        RBNode<K, V>? w = x.parent!.right;
        if (w != null && w.color == NodeColor.red) {
          w.color = NodeColor.black;
          x.parent!.color = NodeColor.red;
          _leftRotate(x.parent!);
          w = x.parent!.right;
        }
        if (w == null || ((w.left == null || w.left!.color == NodeColor.black) &&
            (w.right == null || w.right!.color == NodeColor.black))) {
          if (w != null) w.color = NodeColor.red;
          x = x.parent!;
        } else {
          if (w.right == null || w.right!.color == NodeColor.black) {
            if (w.left != null) w.left!.color = NodeColor.black;
            w.color = NodeColor.red;
            _rightRotate(w);
            w = x.parent!.right;
          }
          if (w != null) {
            w.color = x.parent!.color;
            if (w.right != null) w.right!.color = NodeColor.black;
          }
          x.parent!.color = NodeColor.black;
          _leftRotate(x.parent!);
          x = root!;
        }
      } else {
        RBNode<K, V>? w = x.parent!.left;
        if (w != null && w.color == NodeColor.red) {
          w.color = NodeColor.black;
          x.parent!.color = NodeColor.red;
          _rightRotate(x.parent!);
          w = x.parent!.left;
        }
        if (w == null || ((w.right == null || w.right!.color == NodeColor.black) &&
            (w.left == null || w.left!.color == NodeColor.black))) {
          if (w != null) w.color = NodeColor.red;
          x = x.parent!;
        } else {
          if (w.left == null || w.left!.color == NodeColor.black) {
            if (w.right != null) w.right!.color = NodeColor.black;
            w.color = NodeColor.red;
            _leftRotate(w);
            w = x.parent!.left;
          }
          if (w != null) {
            w.color = x.parent!.color;
            if (w.left != null) w.left!.color = NodeColor.black;
          }
          x.parent!.color = NodeColor.black;
          _rightRotate(x.parent!);
          x = root!;
        }
      }
    }
    x.color = NodeColor.black;
  }

  void _transplant(RBNode<K, V> u, RBNode<K, V>? v) {
    if (u.parent == null) {
      root = v;
    } else if (u == u.parent!.left) {
      u.parent!.left = v;
    } else {
      u.parent!.right = v;
    }
    if (v != null) {
      v.parent = u.parent;
    }
  }

  void _leftRotate(RBNode<K, V> x) {
    RBNode<K, V>? y = x.right;
    if (y == null) return;
    x.right = y.left;
    if (y.left != null) {
      y.left!.parent = x;
    }
    y.parent = x.parent;
    if (x.parent == null) {
      root = y;
    } else if (x == x.parent!.left) {
      x.parent!.left = y;
    } else {
      x.parent!.right = y;
    }
    y.left = x;
    x.parent = y;
  }

  void _rightRotate(RBNode<K, V> y) {
    RBNode<K, V>? x = y.left;
    if (x == null) return;
    y.left = x.right;
    if (x.right != null) {
      x.right!.parent = y;
    }
    x.parent = y.parent;
    if (y.parent == null) {
      root = x;
    } else if (y == y.parent!.right) {
      y.parent!.right = x;
    } else {
      y.parent!.left = x;
    }
    x.right = y;
    y.parent = x;
  }

  RBNode<K, V> minimum(RBNode<K, V> node) {
    while (node.left != null) {
      node = node.left!;
    }
    return node;
  }

  RBNode<K, V> maximum(RBNode<K, V> node) {
    while (node.right != null) {
      node = node.right!;
    }
    return node;
  }

  RBNode<K, V>? findNode(K key) {
    RBNode<K, V>? node = root;
    while (node != null) {
      int cmp = compare(key, node.key);
      if (cmp == 0) return node;
      if (cmp < 0) {
        node = node.left;
      } else {
        node = node.right;
      }
    }
    return null;
  }

  void clear() {
    root = null;
    _size = 0;
  }

  void swap(RedBlackTree<K, V> other) {
    RBNode<K, V>? tempRoot = root;
    root = other.root;
    other.root = tempRoot;

    int tempSize = _size;
    _size = other._size;
    other._size = tempSize;
  }

  Iterator<RBNode<K, V>> get iterator => _RedBlackTreeIterator<K, V>(this);
  
  Iterable<RBNode<K, V>> get nodes => _RedBlackTreeIterable<K, V>(this);
}

class _RedBlackTreeIterable<K, V> extends Iterable<RBNode<K, V>> {
  final RedBlackTree<K, V> tree;
  _RedBlackTreeIterable(this.tree);

  @override
  Iterator<RBNode<K, V>> get iterator => tree.iterator;
}

class _RedBlackTreeIterator<K, V> implements Iterator<RBNode<K, V>> {
  RBNode<K, V>? _current;
  RBNode<K, V>? _next;
  final RedBlackTree<K, V> _tree;

  _RedBlackTreeIterator(this._tree) {
    if (_tree.root != null) {
      _next = _tree.minimum(_tree.root!);
    }
  }

  @override
  RBNode<K, V> get current => _current!;

  @override
  bool moveNext() {
    if (_next == null) {
      _current = null;
      return false;
    }
    _current = _next;
    _next = _successor(_next!);
    return true;
  }

  RBNode<K, V>? _successor(RBNode<K, V> node) {
    if (node.right != null) {
      return _tree.minimum(node.right!);
    }
    RBNode<K, V>? p = node.parent;
    while (p != null && node == p.right) {
      node = p;
      p = p.parent;
    }
    return p;
  }
}