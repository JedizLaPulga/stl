import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // ── Edge ──────────────────────────────────────────────────────────────────
  group('Edge', () {
    test('default weight is 1.0', () {
      const e = Edge('A', 'B');
      expect(e.source, equals('A'));
      expect(e.destination, equals('B'));
      expect(e.weight, equals(1.0));
    });

    test('custom weight is stored correctly', () {
      const e = Edge(1, 2, weight: 3.5);
      expect(e.weight, equals(3.5));
    });

    test('equality and hashCode are value-based', () {
      const e1 = Edge('X', 'Y', weight: 2.0);
      const e2 = Edge('X', 'Y', weight: 2.0);
      const e3 = Edge('X', 'Y', weight: 9.0);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.hashCode, equals(e2.hashCode));
    });

    test('toString is human-readable', () {
      expect(
        Edge('A', 'B', weight: 4.0).toString(),
        equals('Edge(A → B, w=4.0)'),
      );
    });
  });

  // ── Vertex operations ─────────────────────────────────────────────────────
  group('Graph — vertex operations', () {
    late Graph<int> g;
    setUp(() => g = Graph<int>());

    test('addVertex returns true on new vertex and false on duplicate', () {
      expect(g.addVertex(1), isTrue);
      expect(g.addVertex(1), isFalse);
    });

    test('hasVertex reflects current state', () {
      g.addVertex(42);
      expect(g.hasVertex(42), isTrue);
      expect(g.hasVertex(99), isFalse);
    });

    test('vertexCount increments correctly', () {
      expect(g.vertexCount, equals(0));
      g.addVertex(1);
      g.addVertex(2);
      expect(g.vertexCount, equals(2));
    });

    test('removeVertex deletes vertex and incident edges', () {
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      g.addEdge(2, 3);
      g.removeVertex(2);
      expect(g.hasVertex(2), isFalse);
      expect(g.hasEdge(1, 2), isFalse);
      expect(g.hasEdge(2, 3), isFalse);
      expect(g.hasEdge(1, 3), isTrue);
    });

    test('removeVertex returns false for non-existent vertex', () {
      expect(g.removeVertex(99), isFalse);
    });

    test('vertices returns unmodifiable list of all vertices', () {
      g.addVertex(10);
      g.addVertex(20);
      expect(g.vertices, containsAll([10, 20]));
    });

    test('clear removes all vertices and edges', () {
      g.addEdge(1, 2);
      g.clear();
      expect(g.vertexCount, equals(0));
      expect(g.edgeCount, equals(0));
      expect(g.empty, isTrue);
    });

    test('iterableMixin iterates over vertices', () {
      g.addVertex(1);
      g.addVertex(2);
      g.addVertex(3);
      expect(g.toList(), containsAll([1, 2, 3]));
    });
  });

  // ── Edge operations — undirected ──────────────────────────────────────────
  group('Graph — edge operations (undirected)', () {
    late Graph<String> g;
    setUp(() => g = Graph<String>());

    test('addEdge auto-creates vertices', () {
      g.addEdge('A', 'B');
      expect(g.hasVertex('A'), isTrue);
      expect(g.hasVertex('B'), isTrue);
    });

    test('hasEdge is bidirectional for undirected graph', () {
      g.addEdge('A', 'B', weight: 2.0);
      expect(g.hasEdge('A', 'B'), isTrue);
      expect(g.hasEdge('B', 'A'), isTrue);
    });

    test('edgeCount counts each logical edge once', () {
      g.addEdge('A', 'B');
      g.addEdge('A', 'C');
      expect(g.edgeCount, equals(2));
    });

    test('removeEdge removes the edge in both directions', () {
      g.addEdge('A', 'B', weight: 1.0);
      expect(g.removeEdge('A', 'B'), isTrue);
      expect(g.hasEdge('A', 'B'), isFalse);
      expect(g.hasEdge('B', 'A'), isFalse);
      expect(g.edgeCount, equals(0));
    });

    test('removeEdge returns false for non-existent edge', () {
      g.addVertex('A');
      g.addVertex('B');
      expect(g.removeEdge('A', 'B'), isFalse);
    });

    test('neighborsOf returns correct adjacency', () {
      g.addEdge('A', 'B', weight: 3.0);
      g.addEdge('A', 'C', weight: 1.0);
      final ns = g.neighborsOf('A').map((e) => e.destination).toList();
      expect(ns, containsAll(['B', 'C']));
    });

    test('neighborsOf throws OutOfRange for unknown vertex', () {
      expect(() => g.neighborsOf('Z'), throwsA(isA<OutOfRange>()));
    });

    test('degreeOf reflects number of edges', () {
      g.addEdge('A', 'B');
      g.addEdge('A', 'C');
      expect(g.degreeOf('A'), equals(2));
    });

    test('edges deduplicates in undirected graph', () {
      g.addEdge('A', 'B');
      g.addEdge('A', 'C');
      expect(g.edges.length, equals(2));
    });
  });

  // ── Edge operations — directed ────────────────────────────────────────────
  group('Graph — edge operations (directed)', () {
    late Graph<int> g;
    setUp(() => g = Graph<int>(directed: true));

    test('hasEdge is one-directional', () {
      g.addEdge(1, 2);
      expect(g.hasEdge(1, 2), isTrue);
      expect(g.hasEdge(2, 1), isFalse);
    });

    test('edgeCount counts directed edges', () {
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      expect(g.edgeCount, equals(2));
    });

    test('edges lists all directed edges', () {
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      expect(g.edges.length, equals(2));
    });
  });

  // ── BFS ───────────────────────────────────────────────────────────────────
  group('Graph — BFS', () {
    test('visits all reachable vertices in level order', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      g.addEdge(2, 4);
      g.addEdge(3, 5);
      final order = g.bfs(1);
      expect(order.first, equals(1));
      expect(order, containsAll([1, 2, 3, 4, 5]));
      // Level 1 vertices must appear before level 2
      expect(order.indexOf(2), lessThan(order.indexOf(4)));
      expect(order.indexOf(3), lessThan(order.indexOf(5)));
    });

    test('returns only start for isolated vertex', () {
      final g = Graph<int>();
      g.addVertex(7);
      expect(g.bfs(7), equals([7]));
    });

    test('does not visit unreachable vertices', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addVertex(3); // disconnected
      expect(g.bfs(1), equals([1, 2]));
    });

    test('throws OutOfRange for unknown start', () {
      final g = Graph<int>();
      expect(() => g.bfs(99), throwsA(isA<OutOfRange>()));
    });

    test('each vertex appears exactly once', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1);
      final order = g.bfs(1);
      expect(order.toSet().length, equals(order.length));
    });
  });

  // ── DFS ───────────────────────────────────────────────────────────────────
  group('Graph — DFS', () {
    test('visits all reachable vertices', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      g.addEdge(2, 4);
      expect(g.dfs(1), containsAll([1, 2, 3, 4]));
    });

    test('returns only start for isolated vertex', () {
      final g = Graph<int>();
      g.addVertex(5);
      expect(g.dfs(5), equals([5]));
    });

    test('throws OutOfRange for unknown start', () {
      expect(() => Graph<int>().dfs(1), throwsA(isA<OutOfRange>()));
    });

    test('each vertex appears exactly once', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 4);
      g.addEdge(4, 1);
      final order = g.dfs(1);
      expect(order.toSet().length, equals(order.length));
    });

    test('start vertex is first in result', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      expect(g.dfs(1).first, equals(1));
    });
  });

  // ── Dijkstra ──────────────────────────────────────────────────────────────
  group('Graph — Dijkstra', () {
    test('computes shortest paths correctly', () {
      final g = Graph<String>();
      g.addEdge('A', 'B', weight: 4.0);
      g.addEdge('A', 'C', weight: 2.0);
      g.addEdge('C', 'B', weight: 1.0);
      g.addEdge('B', 'D', weight: 3.0);
      g.addEdge('C', 'D', weight: 8.0);
      final d = g.dijkstra('A');
      expect(d['A'], equals(0.0));
      expect(d['C'], equals(2.0));
      expect(d['B'], equals(3.0)); // A→C→B  = 2+1
      expect(d['D'], equals(6.0)); // A→C→B→D = 2+1+3
    });

    test('distance to start is zero', () {
      final g = Graph<int>();
      g.addEdge(1, 2, weight: 5.0);
      expect(g.dijkstra(1)[1], equals(0.0));
    });

    test('unreachable vertices are omitted', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addVertex(3); // isolated
      final d = g.dijkstra(1);
      expect(d.containsKey(3), isFalse);
    });

    test('throws OutOfRange for unknown start', () {
      expect(() => Graph<int>().dijkstra(0), throwsA(isA<OutOfRange>()));
    });

    test('works on directed graph', () {
      final g = Graph<int>(directed: true);
      g.addEdge(0, 1, weight: 1.0);
      g.addEdge(0, 2, weight: 4.0);
      g.addEdge(1, 2, weight: 2.0);
      g.addEdge(1, 3, weight: 6.0);
      g.addEdge(2, 3, weight: 3.0);
      final d = g.dijkstra(0);
      expect(d[3], equals(6.0)); // 0→1→2→3 = 1+2+3
    });
  });

  // ── Bellman-Ford ──────────────────────────────────────────────────────────
  group('Graph — Bellman-Ford', () {
    test('handles negative weights', () {
      final g = Graph<int>(directed: true);
      g.addEdge(0, 1, weight: 4.0);
      g.addEdge(0, 2, weight: 5.0);
      g.addEdge(1, 3, weight: -3.0);
      g.addEdge(2, 3, weight: 3.0);
      final d = g.bellmanFord(0)!;
      expect(d[0], equals(0.0));
      expect(d[1], equals(4.0));
      expect(d[3], equals(1.0)); // 0→1→3 = 4+(-3)
    });

    test('returns null on negative-weight cycle', () {
      final g = Graph<int>(directed: true);
      g.addEdge(0, 1, weight: 1.0);
      g.addEdge(1, 2, weight: -2.0);
      g.addEdge(2, 0, weight: -1.0); // negative cycle
      expect(g.bellmanFord(0), isNull);
    });

    test('distance to start is zero', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2, weight: 3.0);
      expect(g.bellmanFord(1)![1], equals(0.0));
    });

    test('throws OutOfRange for unknown start', () {
      expect(() => Graph<int>().bellmanFord(0), throwsA(isA<OutOfRange>()));
    });
  });

  // ── Topological sort ──────────────────────────────────────────────────────
  group('Graph — topologicalSort', () {
    test('returns valid ordering for a simple DAG', () {
      final g = Graph<String>(directed: true);
      g.addEdge('A', 'C');
      g.addEdge('B', 'C');
      g.addEdge('C', 'D');
      final order = g.topologicalSort()!;
      expect(order, isNotNull);
      expect(order.length, equals(4));
      expect(order.indexOf('A'), lessThan(order.indexOf('C')));
      expect(order.indexOf('B'), lessThan(order.indexOf('C')));
      expect(order.indexOf('C'), lessThan(order.indexOf('D')));
    });

    test('returns null when the graph has a cycle', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1); // cycle
      expect(g.topologicalSort(), isNull);
    });

    test('works on single vertex', () {
      final g = Graph<int>(directed: true);
      g.addVertex(1);
      expect(g.topologicalSort(), equals([1]));
    });

    test('works on linear chain', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 4);
      final order = g.topologicalSort()!;
      expect(order, equals([1, 2, 3, 4]));
    });
  });

  // ── Prim MST ──────────────────────────────────────────────────────────────
  group('Graph — Prim MST', () {
    test('produces correct MST edge count (V-1)', () {
      final g = Graph<String>();
      g.addEdge('A', 'B', weight: 4.0);
      g.addEdge('A', 'C', weight: 2.0);
      g.addEdge('B', 'C', weight: 1.0);
      g.addEdge('B', 'D', weight: 3.0);
      g.addEdge('C', 'D', weight: 5.0);
      final mst = g.prim();
      expect(mst.length, equals(3)); // V-1 = 4-1
    });

    test('MST total weight is minimal', () {
      final g = Graph<String>();
      g.addEdge('A', 'B', weight: 4.0);
      g.addEdge('A', 'C', weight: 2.0);
      g.addEdge('B', 'C', weight: 1.0);
      g.addEdge('B', 'D', weight: 3.0);
      final mst = g.prim();
      final total = mst.fold(0.0, (s, e) => s + e.weight);
      expect(total, equals(6.0)); // B-C(1) + A-C(2) + B-D(3)
    });

    test('returns empty list for empty graph', () {
      expect(Graph<int>().prim(), isEmpty);
    });

    test('throws OutOfRange when start vertex is unknown', () {
      final g = Graph<int>();
      g.addVertex(1);
      expect(() => g.prim(99), throwsA(isA<OutOfRange>()));
    });
  });

  // ── Kruskal MST ───────────────────────────────────────────────────────────
  group('Graph — Kruskal MST', () {
    test('produces correct MST edge count (V-1)', () {
      final g = Graph<String>();
      g.addEdge('A', 'B', weight: 4.0);
      g.addEdge('A', 'C', weight: 2.0);
      g.addEdge('B', 'C', weight: 1.0);
      g.addEdge('B', 'D', weight: 3.0);
      g.addEdge('C', 'D', weight: 5.0);
      expect(g.kruskal().length, equals(3));
    });

    test('MST total weight matches Prim result', () {
      final g = Graph<String>();
      g.addEdge('A', 'B', weight: 4.0);
      g.addEdge('A', 'C', weight: 2.0);
      g.addEdge('B', 'C', weight: 1.0);
      g.addEdge('B', 'D', weight: 3.0);
      final mst = g.kruskal();
      final total = mst.fold(0.0, (s, e) => s + e.weight);
      expect(total, equals(6.0));
    });

    test('returns empty list for empty graph', () {
      expect(Graph<int>().kruskal(), isEmpty);
    });

    test('handles disconnected graph as spanning forest', () {
      final g = Graph<int>();
      g.addEdge(1, 2, weight: 1.0);
      g.addEdge(3, 4, weight: 2.0); // separate component
      final mst = g.kruskal();
      expect(mst.length, equals(2)); // one edge per component
    });
  });

  // ── isConnected ───────────────────────────────────────────────────────────
  group('Graph — isConnected', () {
    test('empty graph is connected', () {
      expect(Graph<int>().isConnected, isTrue);
    });

    test('single vertex is connected', () {
      final g = Graph<int>();
      g.addVertex(1);
      expect(g.isConnected, isTrue);
    });

    test('fully connected undirected graph', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1);
      expect(g.isConnected, isTrue);
    });

    test('disconnected undirected graph', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addVertex(3); // isolated
      expect(g.isConnected, isFalse);
    });

    test('strongly connected directed graph', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1);
      expect(g.isConnected, isTrue);
    });

    test('weakly but not strongly connected directed graph', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      // No back edges — not strongly connected
      expect(g.isConnected, isFalse);
    });
  });

  // ── isAcyclic ─────────────────────────────────────────────────────────────
  group('Graph — isAcyclic', () {
    test('empty graph is acyclic', () {
      expect(Graph<int>().isAcyclic, isTrue);
    });

    test('tree (no cycles) is acyclic', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      g.addEdge(2, 4);
      expect(g.isAcyclic, isTrue);
    });

    test('graph with cycle is not acyclic', () {
      final g = Graph<int>();
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1);
      expect(g.isAcyclic, isFalse);
    });

    test('directed DAG is acyclic', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(1, 3);
      g.addEdge(2, 4);
      g.addEdge(3, 4);
      expect(g.isAcyclic, isTrue);
    });

    test('directed cyclic graph is not acyclic', () {
      final g = Graph<int>(directed: true);
      g.addEdge(1, 2);
      g.addEdge(2, 3);
      g.addEdge(3, 1);
      expect(g.isAcyclic, isFalse);
    });
  });

  // ── toString ──────────────────────────────────────────────────────────────
  group('Graph — toString', () {
    test('produces human-readable output', () {
      final g = Graph<int>();
      g.addEdge(1, 2, weight: 3.0);
      final s = g.toString();
      expect(s, contains('directed=false'));
      expect(s, contains('1'));
      expect(s, contains('2'));
    });
  });
}
