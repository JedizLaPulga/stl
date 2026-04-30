import 'dart:math' as math;

import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  const eps = 1e-9;
  void approxEq(double a, double b, {double tolerance = eps}) =>
      expect(a, closeTo(b, tolerance));

  // ─── Point2D enrichments ──────────────────────────────────────────────────
  group('Point enrichments', () {
    test('normalize', () {
      final p = Point(x: 3, y: 4);
      final n = p.normalize();
      approxEq(n.x, 0.6);
      approxEq(n.y, 0.8);
    });

    test('normalize zero throws', () {
      expect(() => Point(x: 0, y: 0).normalize(), throwsStateError);
    });

    test('cross product (2D scalar)', () {
      approxEq(Point(x: 1, y: 0).cross(Point(x: 0, y: 1)), 1.0);
      approxEq(Point(x: 0, y: 1).cross(Point(x: 1, y: 0)), -1.0);
    });

    test('angleTo', () {
      // angleTo uses atan2(dy,dx): from (1,0) toward (0,1): atan2(1,-1) = 3π/4
      approxEq(
        Point(x: 1, y: 0).angleTo(Point(x: 0, y: 1)),
        3 * math.pi / 4,
        tolerance: 1e-9,
      );
    });

    test('midpointTo', () {
      final mid = Point(x: 0, y: 0).midpointTo(Point(x: 4, y: 2));
      approxEq(mid.x, 2.0);
      approxEq(mid.y, 1.0);
    });

    test('lerp', () {
      final l = Point(x: 0, y: 0).lerp(Point(x: 10, y: 20), 0.3);
      approxEq(l.x, 3.0);
      approxEq(l.y, 6.0);
    });

    test('operator/', () {
      final p = Point(x: 6, y: 4) / 2.0;
      approxEq(p.x, 3.0);
      approxEq(p.y, 2.0);
    });

    test('operator/ zero throws', () {
      expect(() => Point(x: 1, y: 1) / 0.0, throwsArgumentError);
    });
  });

  // ─── Triangle enrichments ─────────────────────────────────────────────────
  group('Triangle enrichments', () {
    // Right-angled triangle: (0,0),(3,0),(0,4) — sides 3,4,5
    final tri = Triangle(
      p1: Point(x: 0, y: 0),
      p2: Point(x: 3, y: 0),
      p3: Point(x: 0, y: 4),
    );

    test('area', () => approxEq(tri.area, 6.0));

    test('angleA (at origin, between sides 3 and 4)', () {
      // Angle at p1=(0,0) opposite side p2p3 (length=5).
      approxEq(
        tri.angleA,
        math.acos((9 + 16 - 25) / (2 * 3 * 4)),
        tolerance: 1e-9,
      );
    });

    test('isRight', () => expect(tri.isRight, isTrue));
    test(
      'isAcute is false for right triangle',
      () => expect(tri.isAcute, isFalse),
    );
    test(
      'isObtuse is false for right triangle',
      () => expect(tri.isObtuse, isFalse),
    );

    test('circumcenter', () {
      // For a 3-4-5 right triangle the circumcenter is the midpoint of the hypotenuse.
      final cc = tri.circumcenter;
      approxEq(cc.x, 1.5, tolerance: 1e-9);
      approxEq(cc.y, 2.0, tolerance: 1e-9);
    });

    test(
      'circumradius',
      () => approxEq(tri.circumradius, 2.5, tolerance: 1e-9),
    );

    test('isEquilateral', () {
      final s = math.sqrt(3.0) / 2;
      final eq = Triangle(
        p1: Point(x: 0, y: 0),
        p2: Point(x: 1, y: 0),
        p3: Point(x: 0.5, y: s),
      );
      expect(eq.isEquilateral, isTrue);
    });

    test('isScalene', () => expect(tri.isScalene, isTrue));
    test('isIsoceles', () {
      final iso = Triangle(
        p1: Point(x: 0, y: 0),
        p2: Point(x: 2, y: 0),
        p3: Point(x: 1, y: 2),
      );
      expect(iso.isIsoceles, isTrue);
    });
  });

  // ─── Circle enrichments ───────────────────────────────────────────────────
  group('Circle enrichments', () {
    final c = Circle(center: Point(x: 0, y: 0), radius: 5);

    test(
      'containsPoint inside',
      () => expect(c.containsPoint(Point(x: 3, y: 4)), isTrue),
    );
    test(
      'containsPoint on boundary',
      () => expect(c.containsPoint(Point(x: 5, y: 0)), isTrue),
    );
    test(
      'containsPoint outside',
      () => expect(c.containsPoint(Point(x: 5, y: 1)), isFalse),
    );

    test('intersectsCircle overlapping', () {
      expect(
        c.intersectsCircle(Circle(center: Point(x: 6, y: 0), radius: 2)),
        isTrue,
      );
    });
    test('intersectsCircle non-overlapping', () {
      expect(
        c.intersectsCircle(Circle(center: Point(x: 11, y: 0), radius: 2)),
        isFalse,
      );
    });

    test('tangentLength external point', () {
      // Distance from (13,0) to center = 13, radius = 5 → tangent = sqrt(169-25) = 12.
      approxEq(c.tangentLength(Point(x: 13, y: 0)), 12.0, tolerance: 1e-9);
    });
    test('tangentLength inside returns 0', () {
      approxEq(c.tangentLength(Point(x: 1, y: 0)), 0.0);
    });

    test('circumference equals perimeter', () {
      approxEq(c.circumference, c.perimeter);
    });
  });

  // ─── Rectangle enrichments ────────────────────────────────────────────────
  group('Rectangle enrichments', () {
    final r = Rectangle(width: 6, height: 4, center: Point(x: 0, y: 0));

    test(
      'containsPoint inside',
      () => expect(r.containsPoint(Point(x: 2, y: 1)), isTrue),
    );
    test(
      'containsPoint on edge',
      () => expect(r.containsPoint(Point(x: 3, y: 0)), isTrue),
    );
    test(
      'containsPoint outside',
      () => expect(r.containsPoint(Point(x: 4, y: 0)), isFalse),
    );

    test('intersects overlapping', () {
      final r2 = Rectangle(width: 4, height: 4, center: Point(x: 4, y: 0));
      expect(r.intersects(r2), isTrue);
    });
    test('intersects non-overlapping', () {
      final r2 = Rectangle(width: 2, height: 2, center: Point(x: 10, y: 0));
      expect(r.intersects(r2), isFalse);
    });

    test('corners count and order', () {
      final corners = r.corners;
      expect(corners.length, 4);
      // BL, BR, TR, TL
      approxEq(corners[0].x, -3.0);
      approxEq(corners[0].y, -2.0);
      approxEq(corners[1].x, 3.0);
      approxEq(corners[1].y, -2.0);
      approxEq(corners[2].x, 3.0);
      approxEq(corners[2].y, 2.0);
      approxEq(corners[3].x, -3.0);
      approxEq(corners[3].y, 2.0);
    });
  });

  // ─── Polygon enrichments ──────────────────────────────────────────────────
  group('Polygon enrichments', () {
    // Unit square CCW.
    final square = Polygon([
      Point(x: 0, y: 0),
      Point(x: 1, y: 0),
      Point(x: 1, y: 1),
      Point(x: 0, y: 1),
    ]);

    test('area', () => approxEq(square.area, 1.0));
    test('centroid', () {
      final c = square.centroid;
      approxEq(c.x, 0.5);
      approxEq(c.y, 0.5);
    });
    test('isConvex square', () => expect(square.isConvex, isTrue));
    test('isConvex concave polygon', () {
      final concave = Polygon([
        Point(x: 0, y: 0),
        Point(x: 2, y: 0),
        Point(x: 2, y: 2),
        Point(x: 1, y: 1), // dent
        Point(x: 0, y: 2),
      ]);
      expect(concave.isConvex, isFalse);
    });

    test(
      'containsPoint inside',
      () => expect(square.containsPoint(Point(x: 0.5, y: 0.5)), isTrue),
    );
    test(
      'containsPoint outside',
      () => expect(square.containsPoint(Point(x: 2, y: 2)), isFalse),
    );
  });

  // ─── Ray2D ────────────────────────────────────────────────────────────────
  group('Ray2D', () {
    final ray = Ray2D(origin: Point(x: 0, y: 0), direction: Point(x: 1, y: 0));

    test('at(t)', () {
      final p = ray.at(3);
      approxEq(p.x, 3.0);
      approxEq(p.y, 0.0);
    });

    test('intersectCircle hits', () {
      final circle = Circle(center: Point(x: 5, y: 0), radius: 1);
      final t = ray.intersectCircle(circle);
      expect(t, isNotNull);
      approxEq(t!, 4.0, tolerance: 1e-9);
    });

    test('intersectCircle misses', () {
      final circle = Circle(center: Point(x: 5, y: 5), radius: 1);
      expect(ray.intersectCircle(circle), isNull);
    });

    test('intersectSegment hits', () {
      final seg = LineSegment(p1: Point(x: 5, y: -1), p2: Point(x: 5, y: 1));
      final t = ray.intersectSegment(seg);
      expect(t, isNotNull);
      approxEq(t!, 5.0, tolerance: 1e-9);
    });
  });

  // ─── Capsule ──────────────────────────────────────────────────────────────
  group('Capsule', () {
    final capsule = Capsule(
      spine: LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 10, y: 0)),
      radius: 2,
    );

    test(
      'area',
      () => approxEq(capsule.area, 10 * 4 + math.pi * 4, tolerance: 1e-9),
    );
    test(
      'perimeter',
      () => approxEq(capsule.perimeter, 20 + 4 * math.pi, tolerance: 1e-9),
    );
    test('centroid', () {
      approxEq(capsule.centroid.x, 5.0);
      approxEq(capsule.centroid.y, 0.0);
    });
    test(
      'containsPoint inside',
      () => expect(capsule.containsPoint(Point(x: 5, y: 1)), isTrue),
    );
    test(
      'containsPoint on cap',
      () => expect(capsule.containsPoint(Point(x: -2, y: 0)), isTrue),
    );
    test(
      'containsPoint outside',
      () => expect(capsule.containsPoint(Point(x: 5, y: 3)), isFalse),
    );
  });

  // ─── Arc ──────────────────────────────────────────────────────────────────
  group('Arc', () {
    final arc = Arc(
      center: Point(x: 0, y: 0),
      radius: 5,
      startAngle: 0,
      endAngle: math.pi / 2,
    );

    test('spanAngle', () => approxEq(arc.spanAngle, math.pi / 2));
    test(
      'arcLength',
      () => approxEq(arc.arcLength, 5 * math.pi / 2, tolerance: 1e-9),
    );
    test(
      'chordLength',
      () => approxEq(arc.chordLength, 5 * math.sqrt(2), tolerance: 1e-9),
    );
    test('startPoint', () {
      approxEq(arc.startPoint.x, 5.0);
      approxEq(arc.startPoint.y, 0.0, tolerance: 1e-9);
    });
    test('endPoint', () {
      approxEq(arc.endPoint.x, 0.0, tolerance: 1e-9);
      approxEq(arc.endPoint.y, 5.0, tolerance: 1e-9);
    });
    test('pointAt', () {
      final p = arc.pointAt(math.pi / 4);
      approxEq(p.x, 5 * math.cos(math.pi / 4), tolerance: 1e-9);
    });
    test(
      'containsAngle in range',
      () => expect(arc.containsAngle(math.pi / 4), isTrue),
    );
    test(
      'containsAngle out of range',
      () => expect(arc.containsAngle(math.pi), isFalse),
    );
  });

  // ─── Bezier ───────────────────────────────────────────────────────────────
  group('QuadraticBezier', () {
    final qb = QuadraticBezier(
      p0: Point(x: 0, y: 0),
      p1: Point(x: 1, y: 2),
      p2: Point(x: 2, y: 0),
    );

    test('evaluate t=0', () {
      final p = qb.evaluate(0);
      approxEq(p.x, 0.0);
      approxEq(p.y, 0.0);
    });
    test('evaluate t=1', () {
      final p = qb.evaluate(1);
      approxEq(p.x, 2.0);
      approxEq(p.y, 0.0);
    });
    test('evaluate t=0.5 midpoint', () {
      final p = qb.evaluate(0.5);
      approxEq(p.x, 1.0);
      approxEq(p.y, 1.0);
    });
    test('splitAt returns two curves', () {
      final (left, right) = qb.splitAt(0.5);
      final e = qb.evaluate(0.5);
      approxEq(left.evaluate(1).x, e.x, tolerance: 1e-9);
      approxEq(right.evaluate(0).x, e.x, tolerance: 1e-9);
    });
    test('arcLength positive', () => expect(qb.arcLength(), greaterThan(0)));
  });

  group('CubicBezier', () {
    final cb = CubicBezier(
      p0: Point(x: 0, y: 0),
      p1: Point(x: 1, y: 2),
      p2: Point(x: 2, y: 2),
      p3: Point(x: 3, y: 0),
    );

    test('evaluate t=0', () {
      final p = cb.evaluate(0);
      approxEq(p.x, 0.0);
      approxEq(p.y, 0.0);
    });
    test('evaluate t=1', () {
      final p = cb.evaluate(1);
      approxEq(p.x, 3.0);
      approxEq(p.y, 0.0);
    });
    test('splitAt continuity', () {
      final (left, right) = cb.splitAt(0.5);
      final mid = cb.evaluate(0.5);
      approxEq(left.evaluate(1).x, mid.x, tolerance: 1e-9);
      approxEq(right.evaluate(0).x, mid.x, tolerance: 1e-9);
    });
  });

  // ─── Point3D ──────────────────────────────────────────────────────────────
  group('Point3D', () {
    test('magnitude', () {
      approxEq(Point3D(x: 1, y: 2, z: 2).magnitude, 3.0);
    });
    test('normalize', () {
      final n = Point3D(x: 0, y: 0, z: 5).normalize();
      approxEq(n.z, 1.0);
    });
    test('dot', () {
      approxEq(Point3D(x: 1, y: 2, z: 3).dot(Point3D(x: 4, y: 5, z: 6)), 32.0);
    });
    test('cross', () {
      final c = Point3D(x: 1, y: 0, z: 0).cross(Point3D(x: 0, y: 1, z: 0));
      approxEq(c.z, 1.0);
      approxEq(c.x, 0.0);
      approxEq(c.y, 0.0);
    });
    test('lerp', () {
      final l = Point3D(
        x: 0,
        y: 0,
        z: 0,
      ).lerp(Point3D(x: 10, y: 10, z: 10), 0.5);
      approxEq(l.x, 5.0);
    });
    test('midpointTo', () {
      final m = Point3D(x: 0, y: 0, z: 0).midpointTo(Point3D(x: 2, y: 4, z: 6));
      approxEq(m.x, 1);
      approxEq(m.y, 2);
      approxEq(m.z, 3);
    });
    test('angleTo perpendicular', () {
      approxEq(
        Point3D(x: 1, y: 0, z: 0).angleTo(Point3D(x: 0, y: 1, z: 0)),
        math.pi / 2,
        tolerance: 1e-9,
      );
    });
    test('operators', () {
      final a = Point3D(x: 1, y: 2, z: 3);
      final b = Point3D(x: 4, y: 5, z: 6);
      final sum = a + b;
      approxEq(sum.x, 5);
      approxEq(sum.y, 7);
      approxEq(sum.z, 9);
      final diff = b - a;
      approxEq(diff.x, 3);
      final scaled = a * 2;
      approxEq(scaled.z, 6);
      final div = b / 2;
      approxEq(div.x, 2);
      final neg = -a;
      approxEq(neg.y, -2);
    });
    test('divide by zero throws', () {
      expect(() => Point3D(x: 1, y: 1, z: 1) / 0.0, throwsArgumentError);
    });
    test('factory of', () {
      final p = Point3D.of(1, 2, 3);
      approxEq(p.x, 1);
      approxEq(p.y, 2);
      approxEq(p.z, 3);
    });
    test('equality and hashCode', () {
      final p1 = Point3D(x: 1, y: 2, z: 3);
      final p2 = Point3D(x: 1, y: 2, z: 3);
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
    });
  });

  // ─── Sphere3D ─────────────────────────────────────────────────────────────
  group('Sphere3D', () {
    final s = Sphere3D(center: Point3D(x: 0, y: 0, z: 0), radius: 5);
    test(
      'volume',
      () => approxEq(s.volume, (4.0 / 3.0) * math.pi * 125, tolerance: 1e-9),
    );
    test(
      'surfaceArea',
      () => approxEq(s.surfaceArea, 4 * math.pi * 25, tolerance: 1e-9),
    );
    test(
      'containsPoint inside',
      () => expect(s.containsPoint(Point3D(x: 3, y: 4, z: 0)), isTrue),
    );
    test(
      'containsPoint outside',
      () => expect(s.containsPoint(Point3D(x: 6, y: 0, z: 0)), isFalse),
    );
    test('intersectsSphere true', () {
      expect(
        s.intersectsSphere(
          Sphere3D(center: Point3D(x: 8, y: 0, z: 0), radius: 4),
        ),
        isTrue,
      );
    });
    test('intersectsSphere false', () {
      expect(
        s.intersectsSphere(
          Sphere3D(center: Point3D(x: 20, y: 0, z: 0), radius: 1),
        ),
        isFalse,
      );
    });
    test('negative radius throws', () {
      expect(
        () => Sphere3D(center: Point3D(x: 0, y: 0, z: 0), radius: -1),
        throwsArgumentError,
      );
    });
  });

  // ─── Plane3D ──────────────────────────────────────────────────────────────
  group('Plane3D', () {
    // XY plane (z=0): normal=(0,0,1), d=0
    final plane = Plane3D(normal: Point3D(x: 0, y: 0, z: 1), distance: 0);

    test(
      'distanceTo above',
      () => approxEq(plane.distanceTo(Point3D(x: 0, y: 0, z: 3)), 3.0),
    );
    test(
      'distanceTo below',
      () => approxEq(plane.distanceTo(Point3D(x: 0, y: 0, z: -2)), -2.0),
    );
    test(
      'containsPoint on plane',
      () => expect(plane.containsPoint(Point3D(x: 5, y: 3, z: 0)), isTrue),
    );
    test('project onto plane', () {
      final p = plane.project(Point3D(x: 2, y: 3, z: 5));
      approxEq(p.z, 0.0, tolerance: 1e-9);
      approxEq(p.x, 2.0, tolerance: 1e-9);
    });
    test('reflect across plane', () {
      final r = plane.reflect(Point3D(x: 0, y: 0, z: 4));
      approxEq(r.z, -4.0, tolerance: 1e-9);
    });
    test('fromPoints factory', () {
      final p = Plane3D.fromPoints(
        Point3D(x: 0, y: 0, z: 0),
        Point3D(x: 1, y: 0, z: 0),
        Point3D(x: 0, y: 1, z: 0),
      );
      approxEq(p.normal.z.abs(), 1.0, tolerance: 1e-9);
    });
    test('fromPoints collinear throws', () {
      expect(
        () => Plane3D.fromPoints(
          Point3D(x: 0, y: 0, z: 0),
          Point3D(x: 1, y: 0, z: 0),
          Point3D(x: 2, y: 0, z: 0),
        ),
        throwsArgumentError,
      );
    });
  });

  // ─── Ray3D ────────────────────────────────────────────────────────────────
  group('Ray3D', () {
    final ray = Ray3D(
      origin: Point3D(x: 0, y: 0, z: 0),
      direction: Point3D(x: 0, y: 0, z: 1),
    );

    test('at(t)', () {
      final p = ray.at(5);
      approxEq(p.z, 5.0);
    });

    test('intersectSphere hits', () {
      final s = Sphere3D(center: Point3D(x: 0, y: 0, z: 10), radius: 2);
      final t = ray.intersectSphere(s);
      expect(t, isNotNull);
      approxEq(t!, 8.0, tolerance: 1e-9);
    });

    test('intersectSphere misses', () {
      final s = Sphere3D(center: Point3D(x: 5, y: 5, z: 5), radius: 1);
      expect(ray.intersectSphere(s), isNull);
    });

    test('intersectPlane hits', () {
      final plane = Plane3D(normal: Point3D(x: 0, y: 0, z: 1), distance: 7);
      final t = ray.intersectPlane(plane);
      expect(t, isNotNull);
      approxEq(t!, 7.0, tolerance: 1e-9);
    });

    test('intersectPlane parallel returns null', () {
      final plane = Plane3D(normal: Point3D(x: 1, y: 0, z: 0), distance: 5);
      expect(ray.intersectPlane(plane), isNull);
    });
  });

  // ─── Triangle3D ───────────────────────────────────────────────────────────
  group('Triangle3D', () {
    final t3 = Triangle3D(
      p1: Point3D(x: 0, y: 0, z: 0),
      p2: Point3D(x: 1, y: 0, z: 0),
      p3: Point3D(x: 0, y: 1, z: 0),
    );

    test('area', () => approxEq(t3.area, 0.5, tolerance: 1e-9));
    test('normal points up', () {
      final n = t3.normal;
      approxEq(n.z.abs(), 1.0, tolerance: 1e-9);
    });
    test('centroid', () {
      final c = t3.centroid;
      approxEq(c.x, 1.0 / 3, tolerance: 1e-9);
      approxEq(c.y, 1.0 / 3, tolerance: 1e-9);
      approxEq(c.z, 0.0, tolerance: 1e-9);
    });
    test('containsPoint inside', () {
      expect(t3.containsPoint(Point3D(x: 0.25, y: 0.25, z: 0)), isTrue);
    });
    test('containsPoint outside', () {
      expect(t3.containsPoint(Point3D(x: 1, y: 1, z: 0)), isFalse);
    });
    test('toTriangle', () {
      final t2 = t3.toTriangle();
      approxEq(t2.area, 0.5, tolerance: 1e-9);
    });
    test('collinear vertices throw', () {
      expect(
        () => Triangle3D(
          p1: Point3D(x: 0, y: 0, z: 0),
          p2: Point3D(x: 1, y: 0, z: 0),
          p3: Point3D(x: 2, y: 0, z: 0),
        ),
        throwsArgumentError,
      );
    });
  });

  // ─── Matrix2x2 ────────────────────────────────────────────────────────────
  group('Matrix2x2', () {
    const m = Matrix2x2(a: 1, b: 2, c: 3, d: 4);

    test('determinant', () => approxEq(m.determinant, -2.0));
    test('transpose', () {
      final t = m.transpose;
      expect(t.a, 1);
      expect(t.b, 3);
      expect(t.c, 2);
      expect(t.d, 4);
    });
    test('inverse', () {
      final inv = m.inverse;
      final id = m * inv;
      approxEq(id.a, 1, tolerance: 1e-9);
      approxEq(id.d, 1, tolerance: 1e-9);
      approxEq(id.b, 0, tolerance: 1e-9);
    });
    test('multiply identity', () {
      final id = Matrix2x2.identity();
      final r = m * id;
      expect(r, equals(m));
    });
    test('rotation 90 degrees', () {
      final rot = Matrix2x2.rotation(math.pi / 2);
      approxEq(rot.a, 0, tolerance: 1e-9);
      approxEq(rot.b, -1, tolerance: 1e-9);
    });
    test('scale', () {
      final s = m.scale(2);
      expect(s.a, 2);
      expect(s.d, 8);
    });
    test('add', () {
      final s = m + m;
      expect(s.a, 2);
      expect(s.d, 8);
    });
    test('subtract', () {
      final s = m - m;
      expect(s.a, 0);
      expect(s.d, 0);
    });
    test('singular inverse throws', () {
      expect(() => Matrix2x2(a: 1, b: 2, c: 2, d: 4).inverse, throwsStateError);
    });
    test('equality and hashCode', () {
      const m2 = Matrix2x2(a: 1, b: 2, c: 3, d: 4);
      expect(m, equals(m2));
      expect(m.hashCode, equals(m2.hashCode));
    });
  });

  // ─── Matrix3x3 ────────────────────────────────────────────────────────────
  group('Matrix3x3', () {
    final id = Matrix3x3.identity();

    test('identity determinant = 1', () => approxEq(id.determinant, 1.0));
    test('rotationX preserves determinant = 1', () {
      approxEq(
        Matrix3x3.rotationX(math.pi / 4).determinant,
        1.0,
        tolerance: 1e-9,
      );
    });
    test('rotationY preserves determinant = 1', () {
      approxEq(
        Matrix3x3.rotationY(math.pi / 3).determinant,
        1.0,
        tolerance: 1e-9,
      );
    });
    test('rotationZ preserves determinant = 1', () {
      approxEq(
        Matrix3x3.rotationZ(math.pi / 6).determinant,
        1.0,
        tolerance: 1e-9,
      );
    });
    test('transpose of identity = identity', () {
      final t = id.transpose;
      approxEq(t.m00, 1);
      approxEq(t.m11, 1);
      approxEq(t.m22, 1);
    });
    test('inverse of identity = identity', () {
      final inv = id.inverse;
      approxEq(inv.m00, 1);
      approxEq(inv.m11, 1);
      approxEq(inv.m22, 1);
    });
    test('multiply by identity', () {
      final r = Matrix3x3.rotationZ(0.5);
      final prod = r * id;
      approxEq(prod.m00, r.m00, tolerance: 1e-9);
    });
    test('add', () {
      final r = id + id;
      approxEq(r.m00, 2.0);
    });
    test('scaled', () {
      final s = id.scaled(3);
      approxEq(s.m00, 3.0);
    });
    test('singular inverse throws', () {
      const zero = Matrix3x3(
        m00: 0,
        m01: 0,
        m02: 0,
        m10: 0,
        m11: 0,
        m12: 0,
        m20: 0,
        m21: 0,
        m22: 0,
      );
      expect(() => zero.inverse, throwsStateError);
    });
  });

  // ─── Matrix4x4 ────────────────────────────────────────────────────────────
  group('Matrix4x4', () {
    test('identity transform', () {
      final id = Matrix4x4.identity();
      final p = id.transform(Point3D(x: 1, y: 2, z: 3));
      approxEq(p.x, 1);
      approxEq(p.y, 2);
      approxEq(p.z, 3);
    });

    test('translation', () {
      final t = Matrix4x4.translation(10, 20, 30);
      final p = t.transform(Point3D(x: 1, y: 2, z: 3));
      approxEq(p.x, 11);
      approxEq(p.y, 22);
      approxEq(p.z, 33);
    });

    test('scaling', () {
      final s = Matrix4x4.scaling(2, 3, 4);
      final p = s.transform(Point3D(x: 1, y: 1, z: 1));
      approxEq(p.x, 2);
      approxEq(p.y, 3);
      approxEq(p.z, 4);
    });

    test('rotationZ 90 degrees', () {
      final r = Matrix4x4.rotationZ(math.pi / 2);
      final p = r.transform(Point3D(x: 1, y: 0, z: 0));
      approxEq(p.x, 0, tolerance: 1e-9);
      approxEq(p.y, 1, tolerance: 1e-9);
    });

    test('rotationX 90 degrees', () {
      final r = Matrix4x4.rotationX(math.pi / 2);
      final p = r.transform(Point3D(x: 0, y: 1, z: 0));
      approxEq(p.y, 0, tolerance: 1e-9);
      approxEq(p.z, 1, tolerance: 1e-9);
    });

    test('rotationY 90 degrees', () {
      final r = Matrix4x4.rotationY(math.pi / 2);
      final p = r.transform(Point3D(x: 0, y: 0, z: 1));
      approxEq(p.z, 0, tolerance: 1e-9);
      approxEq(p.x, 1, tolerance: 1e-9);
    });

    test('multiply identity', () {
      final id = Matrix4x4.identity();
      final r = Matrix4x4.translation(1, 2, 3) * id;
      final p = r.transform(Point3D(x: 0, y: 0, z: 0));
      approxEq(p.x, 1);
      approxEq(p.y, 2);
      approxEq(p.z, 3);
    });

    test('perspective creates valid matrix', () {
      final p = Matrix4x4.perspective(math.pi / 4, 16 / 9, 0.1, 100);
      expect(p.m30, equals(0));
      expect(p.m31, equals(0));
      expect(p.m32, equals(-1));
    });

    test('transpose', () {
      final t = Matrix4x4.translation(1, 2, 3);
      final tr = t.transpose;
      approxEq(tr.m30, 1);
      approxEq(tr.m31, 2);
      approxEq(tr.m32, 3);
    });
  });

  // ─── Quaternion ───────────────────────────────────────────────────────────
  group('Quaternion', () {
    test('identity rotate is no-op', () {
      final q = Quaternion.identity();
      final p = q.rotate(Point3D(x: 1, y: 2, z: 3));
      approxEq(p.x, 1, tolerance: 1e-9);
      approxEq(p.y, 2, tolerance: 1e-9);
      approxEq(p.z, 3, tolerance: 1e-9);
    });

    test('fromAxisAngle 90° around Z rotates X→Y', () {
      final q = Quaternion.fromAxisAngle(
        Point3D(x: 0, y: 0, z: 1),
        math.pi / 2,
      );
      final p = q.rotate(Point3D(x: 1, y: 0, z: 0));
      approxEq(p.x, 0, tolerance: 1e-9);
      approxEq(p.y, 1, tolerance: 1e-9);
    });

    test('conjugate', () {
      final q = Quaternion(w: 1, x: 2, y: 3, z: 4);
      final c = q.conjugate;
      expect(c.x, -2);
      expect(c.y, -3);
      expect(c.z, -4);
    });

    test('inverse * self ≈ identity', () {
      final q = Quaternion.fromAxisAngle(Point3D(x: 1, y: 0, z: 0), 1.0);
      final inv = q.inverse;
      final prod = q * inv;
      approxEq(prod.w, 1, tolerance: 1e-9);
      approxEq(prod.x, 0, tolerance: 1e-9);
    });

    test('dot', () {
      final q = Quaternion.identity();
      approxEq(q.dot(q), 1.0);
    });

    test('normalize', () {
      final q = Quaternion(w: 2, x: 0, y: 0, z: 0).normalize();
      approxEq(q.w, 1.0);
    });

    test('slerp t=0 returns self', () {
      final q1 = Quaternion.fromAxisAngle(Point3D(x: 0, y: 0, z: 1), 0);
      final q2 = Quaternion.fromAxisAngle(
        Point3D(x: 0, y: 0, z: 1),
        math.pi / 2,
      );
      final s = q1.slerp(q2, 0);
      approxEq(s.w, q1.w, tolerance: 1e-9);
    });

    test('slerp t=1 returns other', () {
      final q1 = Quaternion.fromAxisAngle(Point3D(x: 0, y: 0, z: 1), 0);
      final q2 = Quaternion.fromAxisAngle(
        Point3D(x: 0, y: 0, z: 1),
        math.pi / 2,
      );
      final s = q1.slerp(q2, 1);
      approxEq(s.w, q2.w, tolerance: 1e-9);
    });

    test('toMatrix3x3 is rotation matrix (det≈1)', () {
      final q = Quaternion.fromAxisAngle(
        Point3D(x: 0, y: 1, z: 0),
        math.pi / 3,
      );
      approxEq(q.toMatrix3x3().determinant, 1.0, tolerance: 1e-9);
    });

    test('toEulerAngles round-trip via fromAxisAngle Z', () {
      final q = Quaternion.fromAxisAngle(
        Point3D(x: 0, y: 0, z: 1),
        math.pi / 4,
      );
      final euler = q.toEulerAngles();
      approxEq(euler.z, math.pi / 4, tolerance: 1e-9);
    });

    test('equality and hashCode', () {
      final q1 = Quaternion(w: 1, x: 0, y: 0, z: 0);
      final q2 = Quaternion(w: 1, x: 0, y: 0, z: 0);
      expect(q1, equals(q2));
      expect(q1.hashCode, equals(q2.hashCode));
    });
  });

  // ─── Geometry Algorithms ──────────────────────────────────────────────────
  group('convexHull', () {
    test('square hull', () {
      final pts = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 1, y: 1),
        Point(x: 0, y: 1),
        Point(x: 0.5, y: 0.5), // interior
      ];
      final hull = convexHull(pts);
      expect(hull.length, 4);
    });

    test('collinear points', () {
      final pts = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 2, y: 0),
        Point(x: 1, y: 1),
      ];
      final hull = convexHull(pts);
      expect(hull.length, greaterThanOrEqualTo(3));
    });

    test('fewer than 3 points returns sorted', () {
      final pts = [Point(x: 2, y: 0), Point(x: 1, y: 0)];
      final hull = convexHull(pts);
      expect(hull.length, 2);
      expect(hull[0].x, lessThanOrEqualTo(hull[1].x));
    });
  });

  group('closestPairOfPoints', () {
    test('finds closest pair', () {
      final pts = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0.1, y: 0),
        Point(x: 5, y: 5),
      ];
      final pair = closestPairOfPoints(pts);
      expect(pair.length, 2);
      // The two closest are (0,0) and (0.1,0)
      final d = ((pair[0].x - pair[1].x).abs() + (pair[0].y - pair[1].y).abs())
          .toDouble();
      approxEq(d, 0.1, tolerance: 0.01);
    });

    test('throws with fewer than 2 points', () {
      expect(
        () => closestPairOfPoints([Point(x: 0, y: 0)]),
        throwsArgumentError,
      );
    });
  });

  group('segmentIntersection', () {
    test('crossing segments', () {
      final a = LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 2, y: 2));
      final b = LineSegment(p1: Point(x: 0, y: 2), p2: Point(x: 2, y: 0));
      final pt = segmentIntersection(a, b);
      expect(pt, isNotNull);
      approxEq(pt!.x, 1.0, tolerance: 1e-9);
      approxEq(pt.y, 1.0, tolerance: 1e-9);
    });

    test('parallel segments return null', () {
      final a = LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 1, y: 0));
      final b = LineSegment(p1: Point(x: 0, y: 1), p2: Point(x: 1, y: 1));
      expect(segmentIntersection(a, b), isNull);
    });

    test('non-crossing T segments return null', () {
      final a = LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 1, y: 0));
      final b = LineSegment(p1: Point(x: 5, y: -1), p2: Point(x: 5, y: 1));
      expect(segmentIntersection(a, b), isNull);
    });
  });

  group('pointInPolygon', () {
    final square = Polygon([
      Point(x: 0, y: 0),
      Point(x: 2, y: 0),
      Point(x: 2, y: 2),
      Point(x: 0, y: 2),
    ]);

    test(
      'inside',
      () => expect(pointInPolygon(Point(x: 1, y: 1), square), isTrue),
    );
    test(
      'outside',
      () => expect(pointInPolygon(Point(x: 3, y: 3), square), isFalse),
    );
  });

  group('triangulate', () {
    test('square triangulates into 2 triangles', () {
      final square = Polygon([
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 1, y: 1),
        Point(x: 0, y: 1),
      ]);
      final tris = triangulate(square);
      expect(tris.length, 2);
    });

    test('pentagon triangulates into 3 triangles', () {
      // Regular pentagon (CCW)
      final verts = List.generate(5, (i) {
        final a = 2 * math.pi * i / 5 - math.pi / 2;
        return Point(x: math.cos(a), y: math.sin(a));
      });
      final poly = Polygon(verts);
      final tris = triangulate(poly);
      expect(tris.length, 3);
    });
  });
}
