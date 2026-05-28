import 'dart:math' as math;

import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  // ── Constructors ─────────────────────────────────────────────────────────────
  group('Vec constructors', () {
    test('Vec(data) stores elements correctly', () {
      final v = Vec([1.0, 2.0, 3.0]);
      expect(v[0], 1.0);
      expect(v[1], 2.0);
      expect(v[2], 3.0);
    });

    test('Vec(data) copies data defensively', () {
      final data = [1.0, 2.0, 3.0];
      final v = Vec(data);
      data[0] = 99.0;
      expect(v[0], 1.0); // mutation should not affect Vec
    });

    test('Vec(empty) throws ArgumentError', () {
      expect(() => Vec([]), throwsArgumentError);
    });

    test('Vec.zeros creates zero vector', () {
      final v = Vec.zeros(4);
      expect(v.length, 4);
      for (var i = 0; i < 4; i++) {
        expect(v[i], 0.0);
      }
    });

    test('Vec.zeros(0) throws', () {
      expect(() => Vec.zeros(0), throwsArgumentError);
    });

    test('Vec.ones creates ones vector', () {
      final v = Vec.ones(3);
      for (var i = 0; i < 3; i++) {
        expect(v[i], 1.0);
      }
    });

    test('Vec.filled creates constant vector', () {
      final v = Vec.filled(5, 3.14);
      for (var i = 0; i < 5; i++) {
        expect(v[i], 3.14);
      }
    });

    test('Vec.basis creates standard basis vector', () {
      final e2 = Vec.basis(4, 2);
      expect(e2[0], 0.0);
      expect(e2[1], 0.0);
      expect(e2[2], 1.0);
      expect(e2[3], 0.0);
    });

    test('Vec.basis out-of-range throws', () {
      expect(() => Vec.basis(3, 3), throwsArgumentError);
      expect(() => Vec.basis(3, -1), throwsArgumentError);
    });
  });

  // ── Properties ───────────────────────────────────────────────────────────────
  group('Vec properties', () {
    test('length returns dimension', () {
      expect(Vec([1.0, 2.0, 3.0]).length, 3);
    });

    test('isEmpty is always false for valid Vec', () {
      expect(Vec([1.0]).isEmpty, false);
    });
  });

  // ── Arithmetic ───────────────────────────────────────────────────────────────
  group('Vec arithmetic', () {
    final a = Vec([1.0, 2.0, 3.0]);
    final b = Vec([4.0, 5.0, 6.0]);

    test('addition element-wise', () {
      final c = a + b;
      expect(c[0], 5.0);
      expect(c[1], 7.0);
      expect(c[2], 9.0);
    });

    test('subtraction element-wise', () {
      final c = b - a;
      expect(c[0], 3.0);
      expect(c[1], 3.0);
      expect(c[2], 3.0);
    });

    test('unary negation', () {
      final c = -a;
      expect(c[0], -1.0);
      expect(c[1], -2.0);
      expect(c[2], -3.0);
    });

    test('scalar multiplication', () {
      final c = a * 2.0;
      expect(c[0], 2.0);
      expect(c[1], 4.0);
      expect(c[2], 6.0);
    });

    test('scalar division', () {
      final c = a / 2.0;
      expect(c[0], 0.5);
      expect(c[1], 1.0);
      expect(c[2], 1.5);
    });

    test('division by zero throws', () {
      expect(() => a / 0.0, throwsArgumentError);
    });

    test('addition dimension mismatch throws', () {
      expect(() => Vec([1.0]) + Vec([1.0, 2.0]), throwsArgumentError);
    });

    test('subtraction dimension mismatch throws', () {
      expect(() => Vec([1.0]) - Vec([1.0, 2.0]), throwsArgumentError);
    });
  });

  // ── Products ─────────────────────────────────────────────────────────────────
  group('Vec products', () {
    test('dot product', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([4.0, 5.0, 6.0]);
      expect(a.dot(b), 32.0); // 1*4 + 2*5 + 3*6
    });

    test('dot of orthogonal vectors is zero', () {
      final x = Vec([1.0, 0.0, 0.0]);
      final y = Vec([0.0, 1.0, 0.0]);
      expect(x.dot(y), 0.0);
    });

    test('dot dimension mismatch throws', () {
      expect(() => Vec([1.0]).dot(Vec([1.0, 2.0])), throwsArgumentError);
    });

    test('cross product', () {
      final x = Vec([1.0, 0.0, 0.0]);
      final y = Vec([0.0, 1.0, 0.0]);
      final z = x.cross(y);
      expect(z[0], closeTo(0.0, 1e-12));
      expect(z[1], closeTo(0.0, 1e-12));
      expect(z[2], closeTo(1.0, 1e-12));
    });

    test('cross product anti-commutativity: a×b = -(b×a)', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([4.0, 5.0, 6.0]);
      final ab = a.cross(b);
      final ba = b.cross(a);
      for (var i = 0; i < 3; i++) {
        expect(ab[i], closeTo(-ba[i], 1e-12));
      }
    });

    test('cross product of parallel vectors is zero', () {
      final a = Vec([1.0, 0.0, 0.0]);
      final b = Vec([3.0, 0.0, 0.0]);
      final c = a.cross(b);
      expect(c.norm(), closeTo(0.0, 1e-12));
    });

    test('cross product non-3D throws', () {
      expect(() => Vec([1.0, 2.0]).cross(Vec([3.0, 4.0])), throwsArgumentError);
    });

    test('outer product dimensions', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([4.0, 5.0]);
      final m = a.outer(b);
      expect(m.rows, 3);
      expect(m.cols, 2);
      expect(m.at(0, 0), 4.0);
      expect(m.at(1, 1), 10.0);
      expect(m.at(2, 0), 12.0);
    });
  });

  // ── Norms ────────────────────────────────────────────────────────────────────
  group('Vec norms', () {
    final v = Vec([3.0, 4.0]);

    test('L2 norm (default)', () {
      expect(v.norm(), closeTo(5.0, 1e-12));
    });

    test('L1 norm', () {
      expect(v.norm(1), closeTo(7.0, 1e-12));
    });

    test('L-infinity norm (p=0)', () {
      expect(v.norm(0), closeTo(4.0, 1e-12));
    });

    test('negative p throws', () {
      expect(() => v.norm(-1), throwsArgumentError);
    });

    test('normalize returns unit vector', () {
      final u = Vec([3.0, 4.0]).normalize();
      expect(u.norm(), closeTo(1.0, 1e-12));
      expect(u[0], closeTo(0.6, 1e-12));
      expect(u[1], closeTo(0.8, 1e-12));
    });

    test('normalize zero vector throws StateError', () {
      expect(() => Vec.zeros(3).normalize(), throwsStateError);
    });

    test('norm of standard basis vector is 1', () {
      expect(Vec.basis(5, 2).norm(), closeTo(1.0, 1e-12));
    });
  });

  // ── Equality & utilities ─────────────────────────────────────────────────────
  group('Vec equality and utilities', () {
    test('equal vectors are equal', () {
      expect(Vec([1.0, 2.0]) == Vec([1.0, 2.0]), isTrue);
    });

    test('different vectors are not equal', () {
      expect(Vec([1.0, 2.0]) == Vec([1.0, 3.0]), isFalse);
    });

    test('different lengths are not equal', () {
      expect(Vec([1.0, 2.0]) == Vec([1.0, 2.0, 3.0]), isFalse);
    });

    test('hashCode consistent with equality', () {
      final a = Vec([1.0, 2.0]);
      final b = Vec([1.0, 2.0]);
      expect(a.hashCode, b.hashCode);
    });

    test('toList returns modifiable copy', () {
      final v = Vec([1.0, 2.0, 3.0]);
      final list = v.toList();
      list[0] = 99.0;
      expect(v[0], 1.0); // original unchanged
    });

    test('toString contains Vec label', () {
      expect(Vec([1.0, 2.0]).toString(), contains('Vec'));
    });
  });

  // ── Immutability ─────────────────────────────────────────────────────────────
  group('Vec immutability', () {
    test('arithmetic operations return new instances', () {
      final a = Vec([1.0, 2.0, 3.0]);
      final b = Vec([4.0, 5.0, 6.0]);
      final c = a + b;
      expect(identical(a, c), isFalse);
      expect(a[0], 1.0); // a unchanged
    });
  });

  // ── Large vector operations ───────────────────────────────────────────────────
  group('Vec large dimensions', () {
    test('1000-element dot product', () {
      final a = Vec(List<double>.generate(1000, (i) => i.toDouble()));
      final b = Vec(List<double>.filled(1000, 1.0));
      // sum 0..999 = 999*1000/2 = 499500
      expect(a.dot(b), closeTo(499500.0, 1e-6));
    });

    test('L2 norm of 1000-element ones vector', () {
      final v = Vec.ones(1000);
      expect(v.norm(), closeTo(math.sqrt(1000), 1e-9));
    });
  });
}
