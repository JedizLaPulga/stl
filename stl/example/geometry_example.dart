import 'dart:math' as math;

import 'package:stl/stl.dart';

void main() {
  print('=== stl v0.5.9 — Geometry Module Showcase ===\n');

  // ─── Cubic Bézier curve ──────────────────────────────────────────────────
  print('--- CubicBezier ---');
  final bezier = CubicBezier(
    p0: Point(x: 0.0, y: 0.0),
    p1: Point(x: 1.0, y: 2.0),
    p2: Point(x: 2.0, y: 2.0),
    p3: Point(x: 3.0, y: 0.0),
  );

  final midPoint = bezier.evaluate(0.5);
  print(
    'Mid-point at t=0.5: (${midPoint.x.toStringAsFixed(3)}, ${midPoint.y.toStringAsFixed(3)})',
  );

  final arcLen = bezier.arcLength();
  print('Arc length ≈ ${arcLen.toStringAsFixed(4)}');

  final (left, right) = bezier.splitAt(0.5);
  print(
    'Split at 0.5 — left end: (${left.p3.x.toStringAsFixed(3)}, ${left.p3.y.toStringAsFixed(3)})',
  );
  print(
    'Split at 0.5 — right start: (${right.p0.x.toStringAsFixed(3)}, ${right.p0.y.toStringAsFixed(3)})',
  );

  // ─── Convex Hull ─────────────────────────────────────────────────────────
  print('\n--- Convex Hull (Graham scan) ---');
  final cloudPoints = <Point<num>>[
    Point(x: 0, y: 0),
    Point(x: 4, y: 0),
    Point(x: 4, y: 4),
    Point(x: 0, y: 4),
    Point(x: 2, y: 2), // interior
    Point(x: 1, y: 3),
    Point(x: 3, y: 1),
  ];
  final hull = convexHull(cloudPoints);
  print('Input: ${cloudPoints.length} points → Hull: ${hull.length} vertices');
  for (final v in hull) {
    print('  (${v.x}, ${v.y})');
  }

  // ─── Quaternion rotation ──────────────────────────────────────────────────
  print('\n--- Quaternion 90° rotation around Z ---');
  final qRot = Quaternion.fromAxisAngle(Point3D(x: 0, y: 0, z: 1), math.pi / 2);
  final rotated = qRot.rotate(Point3D(x: 1, y: 0, z: 0));
  print(
    'Rotated (1,0,0) by 90° around Z: '
    '(${rotated.x.toStringAsFixed(3)}, ${rotated.y.toStringAsFixed(3)}, ${rotated.z.toStringAsFixed(3)})',
  );

  final euler = qRot.toEulerAngles();
  print(
    'Euler angles (roll, pitch, yaw): '
    '(${euler.x.toStringAsFixed(3)}, ${euler.y.toStringAsFixed(3)}, ${euler.z.toStringAsFixed(3)}) rad',
  );

  // ─── Matrix4x4 transform pipeline ────────────────────────────────────────
  print('\n--- Matrix4x4 Transform Pipeline ---');
  final translate = Matrix4x4.translation(10, 0, 0);
  final scaleM = Matrix4x4.scaling(2, 2, 2);
  final rotZ = Matrix4x4.rotationZ(math.pi / 4);

  final pipeline = translate * scaleM * rotZ;
  final vertex = Point3D(x: 1, y: 0, z: 0);
  final transformed = pipeline.transform(vertex);
  print('Input: $vertex');
  print(
    'After TRS pipeline: '
    '(${transformed.x.toStringAsFixed(4)}, ${transformed.y.toStringAsFixed(4)}, ${transformed.z.toStringAsFixed(4)})',
  );

  // ─── Ray3D–sphere intersection ────────────────────────────────────────────
  print('\n--- Ray3D–Sphere Intersection ---');
  final ray = Ray3D(
    origin: Point3D(x: 0, y: 0, z: 0),
    direction: Point3D(x: 0, y: 0, z: 1),
  );
  final sphere = Sphere3D(center: Point3D(x: 0, y: 0, z: 10), radius: 3);
  final t = ray.intersectSphere(sphere);
  if (t != null) {
    final hit = ray.at(t);
    print(
      'Ray hits sphere at t=${t.toStringAsFixed(4)}: '
      '(${hit.x.toStringAsFixed(3)}, ${hit.y.toStringAsFixed(3)}, ${hit.z.toStringAsFixed(3)})',
    );
  }

  // ─── Triangle circumcenter ────────────────────────────────────────────────
  print('\n--- Triangle Circumcenter ---');
  final tri = Triangle(
    p1: Point(x: 0.0, y: 0.0),
    p2: Point(x: 4.0, y: 0.0),
    p3: Point(x: 0.0, y: 3.0),
  );
  final cc = tri.circumcenter;
  print('Triangle vertices: (0,0), (4,0), (0,3)');
  print(
    'Circumcenter: (${cc.x.toStringAsFixed(4)}, ${cc.y.toStringAsFixed(4)})',
  );
  print('Circumradius: ${tri.circumradius.toStringAsFixed(4)}');
  print('Is right triangle: ${tri.isRight}');
  print(
    'Incenter: (${tri.incenter.x.toStringAsFixed(4)}, ${tri.incenter.y.toStringAsFixed(4)})',
  );

  // ─── Polygon containsPoint ────────────────────────────────────────────────
  print('\n--- Polygon Point-in-Polygon (ray casting) ---');
  final hexVertices = List.generate(6, (i) {
    final a = 2 * math.pi * i / 6;
    return Point(x: math.cos(a), y: math.sin(a));
  });
  final hex = Polygon(hexVertices);
  print('Regular hexagon centred at origin.');
  print('  (0.5, 0.0) inside: ${hex.containsPoint(Point(x: 0.5, y: 0))}');
  print('  (1.5, 0.0) inside: ${hex.containsPoint(Point(x: 1.5, y: 0))}');
  print('  isConvex: ${hex.isConvex}');

  // ─── Closest pair of points ───────────────────────────────────────────────
  print('\n--- Closest Pair of Points ---');
  final randPoints = <Point<num>>[
    Point(x: 0, y: 0),
    Point(x: 100, y: 100),
    Point(x: 0.5, y: 0.3),
    Point(x: 50, y: 50),
    Point(x: 0.1, y: 0.1),
  ];
  final pair = closestPairOfPoints(randPoints);
  print('Closest pair: ${pair[0]} and ${pair[1]}');

  // ─── Arc ──────────────────────────────────────────────────────────────────
  print('\n--- Circular Arc ---');
  final arc = Arc(
    center: Point(x: 0.0, y: 0.0),
    radius: 5,
    startAngle: 0,
    endAngle: math.pi,
  );
  print(
    'Semicircle (r=5): span=${arc.spanAngle.toStringAsFixed(4)} rad, '
    'arcLength=${arc.arcLength.toStringAsFixed(4)}, '
    'chord=${arc.chordLength.toStringAsFixed(4)}',
  );

  // ─── Capsule ─────────────────────────────────────────────────────────────
  print('\n--- Capsule ---');
  final capsule = Capsule(
    spine: LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 10, y: 0)),
    radius: 2,
  );
  print('Capsule area: ${capsule.area.toStringAsFixed(4)}');
  print('Capsule perimeter: ${capsule.perimeter.toStringAsFixed(4)}');
  print('Contains (5, 1): ${capsule.containsPoint(Point(x: 5, y: 1))}');
  print('Contains (5, 3): ${capsule.containsPoint(Point(x: 5, y: 3))}');

  // ─── Segment intersection ─────────────────────────────────────────────────
  print('\n--- Segment Intersection ---');
  final segA = LineSegment(p1: Point(x: 0, y: 0), p2: Point(x: 4, y: 4));
  final segB = LineSegment(p1: Point(x: 0, y: 4), p2: Point(x: 4, y: 0));
  final inter = segmentIntersection(segA, segB);
  print(
    'Intersection of diagonals: '
    '(${inter!.x.toStringAsFixed(3)}, ${inter.y.toStringAsFixed(3)})',
  );

  print('\n=== Done ===');
}
