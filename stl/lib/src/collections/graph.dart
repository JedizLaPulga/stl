import 'dart:collection' show IterableMixin, Queue;
import '../utilities/pair.dart';
import '../exceptions/exceptions.dart';

/// An undirected or directed weighted edge connecting two vertices.
///
/// Mirrors the C++26 `std::graph::edge` concept. Holds the [source] vertex,
/// the [destination] vertex, and an optional [weight] (defaults to `1.0`).
///
/// ```dart
/// final e = Edge('A', 'B', weight: 3.5);
/// print(e.source);      // A
/// print(e.destination); // B
/// print(e.weight);      // 3.5
/// ```
class Edge<V> {
  /// The source vertex of this edge.
  final V source;

  /// The destination vertex of this edge.
  final V destination;

  /// The numeric weight of this edge. Defaults to `1.0`.
  final double weight;

  /// Creates an [Edge] from [source] to [destination] with an optional [weight].
  const Edge(this.source, this.destination, {this.weight = 1.0});

  @override
  bool operator ==(Object other) =>
      other is Edge<V> &&
      other.source == source &&
      other.destination == destination &&
      other.weight == weight;

  @override
  int get hashCode => Object.hash(source, destination, weight);

  @override
  String toString() => 'Edge($source → $destination, w=$weight)';
}

/// A general-purpose weighted graph supporting both directed and undirected
/// topologies, implemented via an adjacency-list representation.
///
/// Inspired by C++26 `<graph>` (`std::adjacency_list`) and Boost.Graph.
/// Vertices are any hashable type [V]; edges carry a `double` weight.
///
/// **Time complexities** (V = vertices, E = edges):
/// | Operation          | Complexity   |
/// |:-------------------|:-------------|
/// | `addVertex`        | O(1)         |
/// | `addEdge`          | O(1)         |
/// | `removeVertex`     | O(V + E)     |
/// | `removeEdge`       | O(degree(v)) |
/// | `hasEdge`          | O(degree(v)) |
/// | `bfs` / `dfs`      | O(V + E)     |
/// | `dijkstra`         | O((V+E) log V) |
/// | `topologicalSort`  | O(V + E)     |
/// | `prim`             | O((V+E) log V) |
/// | `kruskal`          | O(E log E)   |
///
/// ```dart
/// final g = Graph<String>();
/// g.addEdge('A', 'B', weight: 4.0);
/// g.addEdge('A', 'C', weight: 2.0);
/// g.addEdge('B', 'D', weight: 3.0);
/// g.addEdge('C', 'D', weight: 1.0);
///
/// final dist = g.dijkstra('A');
/// print(dist['D']); // 3.0  (A→C→D)
/// ```
class Graph<V> with IterableMixin<V> {
  final Map<V, List<Edge<V>>> _adj;

  /// Whether this graph is directed (`true`) or undirected (`false`).
  final bool directed;
  int _edgeCount = 0;

  @override
  Iterator<V> get iterator => _adj.keys.iterator;

  /// Creates an empty [Graph].
  ///
  /// Set [directed] to `true` for a directed graph (digraph) or `false`
  /// (default) for an undirected graph. Undirected graphs automatically add
  /// a reverse edge whenever [addEdge] is called.
  Graph({this.directed = false}) : _adj = {};

  // ── Vertex operations ───────────────────────────────────────────────────────

  /// Adds [vertex] to the graph if it is not already present.
  ///
  /// Returns `true` if the vertex was newly inserted, `false` if it already
  /// existed.
  bool addVertex(V vertex) {
    if (_adj.containsKey(vertex)) return false;
    _adj[vertex] = [];
    return true;
  }

  /// Removes [vertex] and all edges incident to it from the graph.
  ///
  /// Returns `true` if the vertex existed and was removed, `false` otherwise.
  bool removeVertex(V vertex) {
    if (!_adj.containsKey(vertex)) return false;
    // Count and remove outgoing edges from vertex
    _edgeCount -= _adj[vertex]!.length;
    if (!directed) {
      // For undirected, only half the edges are counted from this side
      // but we remove both directions below.
    }
    _adj.remove(vertex);
    // Remove all edges pointing to this vertex from other adjacency lists
    for (final neighbors in _adj.values) {
      final before = neighbors.length;
      neighbors.removeWhere((e) => e.destination == vertex);
      final removed = before - neighbors.length;
      if (directed) _edgeCount -= removed;
    }
    if (!directed) {
      // Recount from scratch for undirected after removal
      _edgeCount = 0;
      for (final edges in _adj.values) {
        _edgeCount += edges.length;
      }
      _edgeCount ~/= 2;
    }
    return true;
  }

  /// Returns `true` if [vertex] exists in the graph.
  bool hasVertex(V vertex) => _adj.containsKey(vertex);

  /// Returns an unmodifiable list of all vertices in the graph.
  List<V> get vertices => List.unmodifiable(_adj.keys);

  // ── Edge operations ─────────────────────────────────────────────────────────

  /// Adds an edge from [from] to [to] with an optional [weight] (default `1.0`).
  ///
  /// Both vertices are created automatically if they do not already exist.
  /// For undirected graphs, the reverse edge is also added.
  /// Parallel (duplicate) edges are permitted — use [hasEdge] to guard if
  /// needed.
  void addEdge(V from, V to, {double weight = 1.0}) {
    addVertex(from);
    addVertex(to);
    _adj[from]!.add(Edge<V>(from, to, weight: weight));
    if (!directed) {
      _adj[to]!.add(Edge<V>(to, from, weight: weight));
    }
    _edgeCount++;
  }

  /// Removes the first edge from [from] to [to] (with optional exact [weight]
  /// match). Returns `true` if an edge was removed, `false` otherwise.
  bool removeEdge(V from, V to, {double? weight}) {
    if (!_adj.containsKey(from)) return false;
    final list = _adj[from]!;
    final idx = list.indexWhere(
      (e) => e.destination == to && (weight == null || e.weight == weight),
    );
    if (idx == -1) return false;
    list.removeAt(idx);
    if (!directed) {
      _adj[to]?.removeWhere(
        (e) => e.destination == from && (weight == null || e.weight == weight),
      );
    }
    _edgeCount--;
    return true;
  }

  /// Returns `true` if there is at least one edge from [from] to [to].
  bool hasEdge(V from, V to) =>
      _adj.containsKey(from) && _adj[from]!.any((e) => e.destination == to);

  /// Returns all edges in the graph.
  ///
  /// For undirected graphs each logical edge appears once (forward direction).
  List<Edge<V>> get edges {
    if (directed) {
      return [for (final list in _adj.values) ...list];
    }
    // Deduplicate for undirected: only include edge where source <= destination
    // by insertion order (use a set of unordered pairs).
    final seen = <({V a, V b})>{};
    final result = <Edge<V>>[];
    for (final list in _adj.values) {
      for (final e in list) {
        final key = _edgeKey(e.source, e.destination);
        if (seen.add(key)) result.add(e);
      }
    }
    return result;
  }

  /// Returns the adjacency list (outgoing edges) for [vertex].
  ///
  /// Throws [OutOfRange] if [vertex] does not exist in the graph.
  List<Edge<V>> neighborsOf(V vertex) {
    if (!_adj.containsKey(vertex)) {
      throw OutOfRange('Vertex $vertex does not exist in the graph.');
    }
    return List.unmodifiable(_adj[vertex]!);
  }

  /// Returns the out-degree (number of outgoing edges) for [vertex].
  ///
  /// For undirected graphs this equals the total degree of the vertex.
  /// Throws [OutOfRange] if [vertex] does not exist.
  int degreeOf(V vertex) {
    if (!_adj.containsKey(vertex)) {
      throw OutOfRange('Vertex $vertex does not exist in the graph.');
    }
    return _adj[vertex]!.length;
  }

  /// Returns the total number of vertices.
  int get vertexCount => _adj.length;

  /// Returns the total number of logical edges.
  ///
  /// For undirected graphs, each edge is counted once regardless of the two
  /// stored adjacency entries.
  int get edgeCount => _edgeCount;

  /// Returns `true` if the graph has no vertices.
  bool get empty => _adj.isEmpty;

  /// Removes all vertices and edges from the graph.
  void clear() {
    _adj.clear();
    _edgeCount = 0;
  }

  // ── Traversal ───────────────────────────────────────────────────────────────

  /// Performs a **Breadth-First Search** from [start], returning vertices in
  /// BFS visit order.
  ///
  /// Mirrors the classical BFS algorithm using a FIFO queue. Visits each
  /// reachable vertex exactly once. Time complexity: O(V + E).
  ///
  /// Throws [OutOfRange] if [start] does not exist.
  ///
  /// ```dart
  /// final g = Graph<int>();
  /// g.addEdge(1, 2); g.addEdge(1, 3); g.addEdge(2, 4);
  /// print(g.bfs(1)); // [1, 2, 3, 4]
  /// ```
  List<V> bfs(V start) {
    if (!_adj.containsKey(start)) {
      throw OutOfRange('Vertex $start does not exist in the graph.');
    }
    final visited = <V>{};
    final queue = Queue<V>()..add(start);
    final result = <V>[];
    visited.add(start);
    while (queue.isNotEmpty) {
      final v = queue.removeFirst();
      result.add(v);
      for (final e in _adj[v]!) {
        if (visited.add(e.destination)) {
          queue.add(e.destination);
        }
      }
    }
    return result;
  }

  /// Performs a **Depth-First Search** from [start], returning vertices in
  /// DFS visit order.
  ///
  /// Uses an explicit stack to avoid call-stack overflow on large graphs.
  /// Visits each reachable vertex exactly once. Time complexity: O(V + E).
  ///
  /// Throws [OutOfRange] if [start] does not exist.
  ///
  /// ```dart
  /// final g = Graph<int>();
  /// g.addEdge(1, 2); g.addEdge(1, 3); g.addEdge(2, 4);
  /// print(g.dfs(1)); // [1, 3, 4, 2] (order depends on adjacency list)
  /// ```
  List<V> dfs(V start) {
    if (!_adj.containsKey(start)) {
      throw OutOfRange('Vertex $start does not exist in the graph.');
    }
    final visited = <V>{};
    final stack = <V>[start];
    final result = <V>[];
    while (stack.isNotEmpty) {
      final v = stack.removeLast();
      if (visited.add(v)) {
        result.add(v);
        for (final e in _adj[v]!.reversed) {
          if (!visited.contains(e.destination)) {
            stack.add(e.destination);
          }
        }
      }
    }
    return result;
  }

  // ── Shortest path ───────────────────────────────────────────────────────────

  /// Computes single-source shortest paths from [start] using **Dijkstra's
  /// algorithm**.
  ///
  /// Returns a map from every reachable vertex to its minimum total distance
  /// from [start]. Unreachable vertices are omitted. Edge weights must be
  /// non-negative; negative weights will produce incorrect results (use
  /// [bellmanFord] instead).
  ///
  /// Time complexity: O((V + E) log V) via a binary-heap priority queue.
  ///
  /// Throws [OutOfRange] if [start] does not exist.
  ///
  /// ```dart
  /// final g = Graph<String>();
  /// g.addEdge('A', 'B', weight: 4.0);
  /// g.addEdge('A', 'C', weight: 2.0);
  /// g.addEdge('C', 'B', weight: 1.0);
  /// g.addEdge('B', 'D', weight: 3.0);
  /// final d = g.dijkstra('A');
  /// print(d['D']); // 6.0  (A→C→B→D)
  /// ```
  Map<V, double> dijkstra(V start) {
    if (!_adj.containsKey(start)) {
      throw OutOfRange('Vertex $start does not exist in the graph.');
    }
    final dist = <V, double>{start: 0.0};
    // Min-heap: [distance, vertex] stored as Pair
    final heap = <Pair<double, V>>[Pair(0.0, start)];

    void siftUp(int i) {
      while (i > 0) {
        final parent = (i - 1) ~/ 2;
        if (heap[parent].first <= heap[i].first) break;
        final tmp = heap[parent];
        heap[parent] = heap[i];
        heap[i] = tmp;
        i = parent;
      }
    }

    void siftDown(int i) {
      final n = heap.length;
      while (true) {
        int smallest = i;
        final l = 2 * i + 1;
        final r = 2 * i + 2;
        if (l < n && heap[l].first < heap[smallest].first) smallest = l;
        if (r < n && heap[r].first < heap[smallest].first) smallest = r;
        if (smallest == i) break;
        final tmp = heap[smallest];
        heap[smallest] = heap[i];
        heap[i] = tmp;
        i = smallest;
      }
    }

    while (heap.isNotEmpty) {
      final top = heap.first;
      heap[0] = heap.last;
      heap.removeLast();
      if (heap.isNotEmpty) siftDown(0);

      final d = top.first;
      final v = top.second;

      if (d > (dist[v] ?? double.infinity)) continue;

      for (final e in _adj[v]!) {
        final nd = d + e.weight;
        if (nd < (dist[e.destination] ?? double.infinity)) {
          dist[e.destination] = nd;
          heap.add(Pair(nd, e.destination));
          siftUp(heap.length - 1);
        }
      }
    }
    return dist;
  }

  /// Computes single-source shortest paths from [start] using the
  /// **Bellman-Ford algorithm**.
  ///
  /// Unlike [dijkstra], Bellman-Ford handles **negative edge weights**.
  /// Returns `null` if a negative-weight cycle is reachable from [start]
  /// (distance would be unbounded). Otherwise returns a map from each
  /// reachable vertex to its minimum distance.
  ///
  /// Time complexity: O(V × E).
  ///
  /// Throws [OutOfRange] if [start] does not exist.
  ///
  /// ```dart
  /// final g = Graph<int>(directed: true);
  /// g.addEdge(0, 1, weight: 4.0);
  /// g.addEdge(0, 2, weight: 5.0);
  /// g.addEdge(1, 3, weight: -3.0);
  /// final d = g.bellmanFord(0)!;
  /// print(d[3]); // 1.0
  /// ```
  Map<V, double>? bellmanFord(V start) {
    if (!_adj.containsKey(start)) {
      throw OutOfRange('Vertex $start does not exist in the graph.');
    }
    final dist = <V, double>{};
    for (final v in _adj.keys) {
      dist[v] = double.infinity;
    }
    dist[start] = 0.0;

    final allEdges = edges;
    final n = _adj.length;

    // Relax all edges n-1 times
    for (var i = 0; i < n - 1; i++) {
      for (final e in allEdges) {
        final du = dist[e.source]!;
        if (du == double.infinity) continue;
        final newDist = du + e.weight;
        if (newDist < dist[e.destination]!) {
          dist[e.destination] = newDist;
        }
      }
    }

    // Detect negative-weight cycles
    for (final e in allEdges) {
      final du = dist[e.source]!;
      if (du != double.infinity && du + e.weight < dist[e.destination]!) {
        return null; // negative cycle detected
      }
    }

    // Remove unreachable vertices from result
    dist.removeWhere((_, v) => v == double.infinity);
    return dist;
  }

  // ── Topological sort ────────────────────────────────────────────────────────

  /// Returns a **topological ordering** of all vertices using Kahn's algorithm
  /// (BFS-based).
  ///
  /// Only valid for directed acyclic graphs (DAGs). Returns `null` if the
  /// graph contains a cycle (not a DAG).
  ///
  /// Time complexity: O(V + E).
  ///
  /// ```dart
  /// final g = Graph<String>(directed: true);
  /// g.addEdge('A', 'C'); g.addEdge('B', 'C'); g.addEdge('C', 'D');
  /// print(g.topologicalSort()); // [A, B, C, D] or [B, A, C, D]
  /// ```
  List<V>? topologicalSort() {
    final inDegree = <V, int>{};
    for (final v in _adj.keys) {
      inDegree[v] ??= 0;
      for (final e in _adj[v]!) {
        inDegree[e.destination] = (inDegree[e.destination] ?? 0) + 1;
      }
    }

    final queue = Queue<V>();
    for (final v in inDegree.keys) {
      if (inDegree[v] == 0) queue.add(v);
    }

    final result = <V>[];
    while (queue.isNotEmpty) {
      final v = queue.removeFirst();
      result.add(v);
      for (final e in _adj[v]!) {
        inDegree[e.destination] = inDegree[e.destination]! - 1;
        if (inDegree[e.destination] == 0) queue.add(e.destination);
      }
    }

    return result.length == _adj.length ? result : null;
  }

  // ── Minimum Spanning Tree ───────────────────────────────────────────────────

  /// Computes a **Minimum Spanning Tree** (MST) using **Prim's algorithm**.
  ///
  /// Grows the MST greedily by always picking the cheapest edge that connects
  /// a visited vertex to an unvisited one. Starts from [start] (defaults to
  /// the first vertex).
  ///
  /// Returns the list of edges in the MST. The total number of MST edges is
  /// always `V − 1` for a connected graph.
  ///
  /// For disconnected graphs, returns the MST of the component containing
  /// [start].
  ///
  /// Time complexity: O((V + E) log V).
  ///
  /// ```dart
  /// final g = Graph<String>();
  /// g.addEdge('A', 'B', weight: 4.0);
  /// g.addEdge('A', 'C', weight: 2.0);
  /// g.addEdge('B', 'C', weight: 1.0);
  /// g.addEdge('B', 'D', weight: 3.0);
  /// final mst = g.prim();
  /// // Edges: B-C(1), A-C(2), B-D(3)  total weight = 6
  /// ```
  List<Edge<V>> prim([V? start]) {
    if (_adj.isEmpty) return [];
    final src = start ?? _adj.keys.first;
    if (!_adj.containsKey(src)) {
      throw OutOfRange('Vertex $src does not exist in the graph.');
    }

    final inMst = <V>{src};
    final mstEdges = <Edge<V>>[];

    // Min-heap of candidate edges
    final heap = <Edge<V>>[..._adj[src]!];
    heap.sort((a, b) => a.weight.compareTo(b.weight));

    void siftUp(int i) {
      while (i > 0) {
        final p = (i - 1) ~/ 2;
        if (heap[p].weight <= heap[i].weight) break;
        final tmp = heap[p];
        heap[p] = heap[i];
        heap[i] = tmp;
        i = p;
      }
    }

    void siftDown(int i) {
      final n = heap.length;
      while (true) {
        int s = i;
        final l = 2 * i + 1, r = 2 * i + 2;
        if (l < n && heap[l].weight < heap[s].weight) s = l;
        if (r < n && heap[r].weight < heap[s].weight) s = r;
        if (s == i) break;
        final tmp = heap[s];
        heap[s] = heap[i];
        heap[i] = tmp;
        i = s;
      }
    }

    while (heap.isNotEmpty && mstEdges.length < _adj.length - 1) {
      final top = heap.first;
      heap[0] = heap.last;
      heap.removeLast();
      if (heap.isNotEmpty) siftDown(0);

      final dest = top.destination;
      if (inMst.contains(dest)) continue;

      inMst.add(dest);
      mstEdges.add(top);

      for (final e in _adj[dest]!) {
        if (!inMst.contains(e.destination)) {
          heap.add(e);
          siftUp(heap.length - 1);
        }
      }
    }

    return mstEdges;
  }

  /// Computes a **Minimum Spanning Tree** using **Kruskal's algorithm**.
  ///
  /// Sorts all edges by weight, then greedily adds edges that do not form a
  /// cycle, using a Union-Find (disjoint-set) data structure to detect cycles
  /// in O(α(V)) per operation.
  ///
  /// Returns the list of MST edges. For disconnected graphs, returns a minimum
  /// spanning **forest** (one tree per connected component).
  ///
  /// Time complexity: O(E log E).
  ///
  /// ```dart
  /// final g = Graph<String>();
  /// g.addEdge('A', 'B', weight: 4.0);
  /// g.addEdge('A', 'C', weight: 2.0);
  /// g.addEdge('B', 'C', weight: 1.0);
  /// g.addEdge('B', 'D', weight: 3.0);
  /// final mst = g.kruskal();
  /// // Edges: B-C(1), A-C(2), B-D(3)
  /// ```
  List<Edge<V>> kruskal() {
    final allEdges = edges..sort((a, b) => a.weight.compareTo(b.weight));
    final parent = <V, V>{};
    final rank = <V, int>{};

    for (final v in _adj.keys) {
      parent[v] = v;
      rank[v] = 0;
    }

    V find(V x) {
      if (parent[x] != x) parent[x] = find(parent[x] as V);
      return parent[x] as V;
    }

    void union(V a, V b) {
      final ra = find(a), rb = find(b);
      if (ra == rb) return;
      if (rank[ra]! < rank[rb]!) {
        parent[ra] = rb;
      } else if (rank[ra]! > rank[rb]!) {
        parent[rb] = ra;
      } else {
        parent[rb] = ra;
        rank[ra] = rank[ra]! + 1;
      }
    }

    final mst = <Edge<V>>[];
    for (final e in allEdges) {
      if (find(e.source) != find(e.destination)) {
        union(e.source, e.destination);
        mst.add(e);
      }
    }
    return mst;
  }

  // ── Connectivity helpers ────────────────────────────────────────────────────

  /// Returns `true` if every vertex is reachable from every other vertex.
  ///
  /// For directed graphs this checks **strong** connectivity via two BFS
  /// passes on the original and the transpose graph. For undirected graphs a
  /// single BFS suffices.
  ///
  /// Time complexity: O(V + E).
  bool get isConnected {
    if (_adj.isEmpty) return true;
    final start = _adj.keys.first;
    if (directed) {
      // First BFS on original graph
      if (bfs(start).length != _adj.length) return false;
      // Second BFS on transposed graph
      final transposed = _transpose();
      if (transposed.bfs(start).length != _adj.length) return false;
      return true;
    }
    return bfs(start).length == _adj.length;
  }

  /// Returns `true` if the graph contains no cycles.
  ///
  /// Uses DFS-based cycle detection (white/grey/black colouring for directed,
  /// parent-tracking for undirected). Time complexity: O(V + E).
  bool get isAcyclic {
    if (directed) return _isAcyclicDirected();
    return _isAcyclicUndirected();
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  /// Creates a key for undirected edge deduplication that is symmetric.
  ({V a, V b}) _edgeKey(V u, V v) {
    // Use a canonical ordering based on hashCode to make the key symmetric.
    return u.hashCode <= v.hashCode ? (a: u, b: v) : (a: v, b: u);
  }

  /// Builds the transpose (reversed-edge) graph. Used by [isConnected] for
  /// directed graphs.
  Graph<V> _transpose() {
    final t = Graph<V>(directed: true);
    for (final v in _adj.keys) {
      t.addVertex(v);
    }
    for (final list in _adj.values) {
      for (final e in list) {
        t.addEdge(e.destination, e.source, weight: e.weight);
      }
    }
    return t;
  }

  bool _isAcyclicDirected() {
    // 0 = white (unvisited), 1 = grey (in-stack), 2 = black (done)
    final color = <V, int>{};
    for (final v in _adj.keys) {
      color[v] = 0;
    }

    bool dfsVisit(V v) {
      color[v] = 1;
      for (final e in _adj[v]!) {
        final c = color[e.destination] ?? 0;
        if (c == 1) return false; // back edge → cycle
        if (c == 0 && !dfsVisit(e.destination)) return false;
      }
      color[v] = 2;
      return true;
    }

    for (final v in _adj.keys) {
      if (color[v] == 0 && !dfsVisit(v)) return false;
    }
    return true;
  }

  bool _isAcyclicUndirected() {
    final visited = <V>{};

    bool dfsVisit(V v, V? parent) {
      visited.add(v);
      for (final e in _adj[v]!) {
        if (!visited.contains(e.destination)) {
          if (!dfsVisit(e.destination, v)) return false;
        } else if (e.destination != parent) {
          return false; // back edge → cycle
        }
      }
      return true;
    }

    for (final v in _adj.keys) {
      if (!visited.contains(v) && !dfsVisit(v, null)) return false;
    }
    return true;
  }

  @override
  String toString() {
    final buf = StringBuffer('Graph(directed=$directed) {\n');
    for (final v in _adj.keys) {
      buf.write(
        '  $v → ${_adj[v]!.map((e) => '${e.destination}(${e.weight})').join(', ')}\n',
      );
    }
    buf.write('}');
    return buf.toString();
  }
}
