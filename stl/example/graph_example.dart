// ignore_for_file: avoid_print
import 'package:stl/stl.dart';

void main() {
  _undirectedBasics();
  _directedBasics();
  _traversals();
  _shortestPaths();
  _minimumSpanningTree();
  _topologicalSort();
  _connectivityAndCycles();
}

// ── Undirected graph basics ──────────────────────────────────────────────────

void _undirectedBasics() {
  print('=== Undirected Graph Basics ===');

  final g = Graph<String>();

  // Add vertices and edges
  g.addEdge('A', 'B', weight: 4.0);
  g.addEdge('A', 'C', weight: 2.0);
  g.addEdge('B', 'C', weight: 1.0);
  g.addEdge('B', 'D', weight: 5.0);
  g.addEdge('C', 'D', weight: 8.0);

  print('Vertices (${g.vertexCount}): ${g.vertices}');
  print('Edges    (${g.edgeCount}):');
  for (final e in g.edges) {
    print('  $e');
  }

  // Neighbours and degree
  print('Neighbors of A: ${g.neighborsOf('A').map((e) => e.destination)}');
  print('Degree of B:    ${g.degreeOf('B')}');

  // Membership
  print('Has vertex D:   ${g.hasVertex('D')}');
  print('Has edge A-B:   ${g.hasEdge('A', 'B')}');
  print('Has edge D-A:   ${g.hasEdge('D', 'A')}');
}

// ── Directed graph basics ────────────────────────────────────────────────────

void _directedBasics() {
  print('=== Directed Graph Basics ===');

  final g = Graph<int>(directed: true);
  g.addEdge(0, 1, weight: 3.0);
  g.addEdge(0, 2, weight: 6.0);
  g.addEdge(1, 2, weight: 2.0);
  g.addEdge(2, 3, weight: 1.0);

  print('Vertices: ${g.vertices}');
  print('Edge 0→1 exists: ${g.hasEdge(0, 1)}');
  print('Edge 1→0 exists: ${g.hasEdge(1, 0)}');

  g.removeEdge(0, 2);
  print('After removing 0→2, edgeCount: ${g.edgeCount}');
}

// ── Traversals ───────────────────────────────────────────────────────────────

void _traversals() {
  print('=== Traversals ===');

  // Undirected, tree-like structure
  //     1
  //    / \
  //   2   3
  //  / \
  // 4   5
  final g = Graph<int>();
  g.addEdge(1, 2);
  g.addEdge(1, 3);
  g.addEdge(2, 4);
  g.addEdge(2, 5);

  print('BFS from 1: ${g.bfs(1)}');
  print('DFS from 1: ${g.dfs(1)}');
}

// ── Shortest paths ───────────────────────────────────────────────────────────

void _shortestPaths() {
  print('=== Shortest Paths ===');

  // Dijkstra — non-negative weights only
  final gd = Graph<String>(directed: true);
  gd.addEdge('S', 'A', weight: 10.0);
  gd.addEdge('S', 'C', weight: 3.0);
  gd.addEdge('C', 'A', weight: 4.0);
  gd.addEdge('C', 'B', weight: 8.0);
  gd.addEdge('A', 'B', weight: 1.0);
  gd.addEdge('B', 'D', weight: 2.0);
  gd.addEdge('A', 'D', weight: 7.0);

  print('Dijkstra from S:');
  final dijkEntries = gd.dijkstra('S').entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  for (final e in dijkEntries) {
    print('  S → ${e.key}: ${e.value}');
  }

  // Bellman-Ford — supports negative weights
  final gbf = Graph<int>(directed: true);
  gbf.addEdge(0, 1, weight: 4.0);
  gbf.addEdge(0, 2, weight: 5.0);
  gbf.addEdge(1, 3, weight: -3.0);
  gbf.addEdge(2, 3, weight: 3.0);
  gbf.addEdge(3, 4, weight: 2.0);

  print('Bellman-Ford from 0 (negative edge allowed):');
  final bf = gbf.bellmanFord(0)!;
  for (var v in [0, 1, 2, 3, 4]) {
    print('  0 → $v: ${bf[v]}');
  }

  // Negative cycle detection
  final gnc = Graph<int>(directed: true);
  gnc.addEdge(0, 1, weight: 1.0);
  gnc.addEdge(1, 2, weight: -3.0);
  gnc.addEdge(2, 0, weight: 1.0); // creates negative cycle
  print('Bellman-Ford with negative cycle: ${gnc.bellmanFord(0)}'); // null
}

// ── Minimum spanning tree ─────────────────────────────────────────────────────

void _minimumSpanningTree() {
  print('=== Minimum Spanning Tree ===');

  final g = Graph<String>();
  g.addEdge('A', 'B', weight: 7.0);
  g.addEdge('A', 'D', weight: 5.0);
  g.addEdge('B', 'C', weight: 8.0);
  g.addEdge('B', 'D', weight: 9.0);
  g.addEdge('B', 'E', weight: 7.0);
  g.addEdge('C', 'E', weight: 5.0);
  g.addEdge('D', 'E', weight: 15.0);
  g.addEdge('D', 'F', weight: 6.0);
  g.addEdge('E', 'F', weight: 8.0);
  g.addEdge('E', 'G', weight: 9.0);
  g.addEdge('F', 'G', weight: 11.0);

  final primMst = g.prim();
  final primTotal = primMst.fold(0.0, (s, e) => s + e.weight);
  print("Prim MST (total weight: $primTotal):");
  for (final e in primMst) {
    print('  $e');
  }

  final kruskalMst = g.kruskal();
  final kruskalTotal = kruskalMst.fold(0.0, (s, e) => s + e.weight);
  print("Kruskal MST (total weight: $kruskalTotal):");
  for (final e in kruskalMst) {
    print('  $e');
  }
}

// ── Topological sort ──────────────────────────────────────────────────────────

void _topologicalSort() {
  print('=== Topological Sort ===');

  // Build course prerequisites DAG
  // Math → Algorithms → Thesis
  //      ↘              ↗
  //    Data Structures
  final g = Graph<String>(directed: true);
  g.addEdge('Math', 'Algorithms');
  g.addEdge('Math', 'Data Structures');
  g.addEdge('Algorithms', 'Thesis');
  g.addEdge('Data Structures', 'Thesis');

  final order = g.topologicalSort();
  print('Course order: $order');

  // Cyclic graph returns null
  final cyclic = Graph<String>(directed: true);
  cyclic.addEdge('A', 'B');
  cyclic.addEdge('B', 'C');
  cyclic.addEdge('C', 'A');
  print('Cyclic graph topological sort: ${cyclic.topologicalSort()}'); // null
}

// ── Connectivity and cycle detection ─────────────────────────────────────────

void _connectivityAndCycles() {
  print('=== Connectivity & Cycle Detection ===');

  // Connected undirected graph
  final connected = Graph<int>();
  connected.addEdge(1, 2);
  connected.addEdge(2, 3);
  connected.addEdge(3, 4);
  print('Connected (1-2-3-4):         ${connected.isConnected}'); // true

  // Disconnected
  final disconnected = Graph<int>();
  disconnected.addEdge(1, 2);
  disconnected.addVertex(3);
  print('Disconnected (1-2 and 3):    ${disconnected.isConnected}'); // false

  // Strongly connected directed graph
  final scc = Graph<int>(directed: true);
  scc.addEdge(1, 2);
  scc.addEdge(2, 3);
  scc.addEdge(3, 1);
  print('Strongly connected directed: ${scc.isConnected}'); // true

  // Acyclic tree
  final tree = Graph<int>();
  tree.addEdge(1, 2);
  tree.addEdge(1, 3);
  tree.addEdge(2, 4);
  print('Tree (no cycles) isAcyclic:  ${tree.isAcyclic}'); // true

  // Cyclic undirected
  final ring = Graph<int>();
  ring.addEdge(1, 2);
  ring.addEdge(2, 3);
  ring.addEdge(3, 1);
  print('Ring (1-2-3-1) isAcyclic:    ${ring.isAcyclic}'); // false

  // Directed DAG
  final dag = Graph<int>(directed: true);
  dag.addEdge(1, 2);
  dag.addEdge(1, 3);
  dag.addEdge(2, 4);
  dag.addEdge(3, 4);
  print('DAG isAcyclic:               ${dag.isAcyclic}'); // true

  // Directed cycle
  final dcycle = Graph<int>(directed: true);
  dcycle.addEdge(1, 2);
  dcycle.addEdge(2, 3);
  dcycle.addEdge(3, 1);
  print('Directed cycle isAcyclic:    ${dcycle.isAcyclic}'); // false
}
