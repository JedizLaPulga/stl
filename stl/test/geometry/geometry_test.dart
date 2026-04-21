import 'dart:math' as math;
import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('geometry', () {
    group('Point', () {
      test('distanceTo calculates Euclidean distance', () {
        final p1 = Point(x: 0, y: 0);
        final p2 = Point(x: 3, y: 4);
        expect(p1.distanceTo(p2), equals(5.0));
      });
      
      test('equality matches on values', () {
        final p1 = Point(x: 1, y: 2);
        final p2 = Point(x: 1, y: 2);
        expect(p1, equals(p2));
      });

      test('vector arithmetic and magnitude', () {
        final p1 = Point<num>(x: 1, y: 2);
        final p2 = Point<num>(x: 3, y: 4);
        expect((p1 + p2), equals(Point<num>(x: 4, y: 6)));
        expect((p2 - p1), equals(Point<num>(x: 2, y: 2)));
        expect((p1 * 2), equals(Point<num>(x: 2, y: 4)));
        expect(p1.dotProduct(p2), equals(11));
        
        final p3 = Point(x: 3, y: 4);
        expect(p3.magnitude, equals(5.0));
      });
    });

    group('Circle', () {
      test('area and perimeter calculation', () {
        final c = Circle(radius: 10);
        expect(c.area, closeTo(314.159, 0.001));
        expect(c.perimeter, closeTo(62.831, 0.001));
      });

      test('validates negative radius', () {
        expect(() => Circle(radius: -5), throwsArgumentError);
      });

      test('transformations return strict Circle type', () {
        final c = Circle(radius: 10, center: Point<num>(x: 0, y: 0));
        Circle translated = c.translate(Point<num>(x: 5, y: 5));
        expect(translated.center.x, equals(5));
        expect(translated.center.y, equals(5));

        Circle scaled = c.scale(2.0);
        expect(scaled.radius, equals(20.0));
      });
    });

    group('Rectangle', () {
      test('area and perimeter calculation', () {
        final r = Rectangle(width: 5, height: 10);
        expect(r.area, equals(50.0));
        expect(r.perimeter, equals(30.0));
      });

      test('validates negative dimensions', () {
        expect(() => Rectangle(width: -5, height: 10), throwsArgumentError);
      });
    });

    group('Triangle', () {
      test('area and perimeter calculations', () {
        // A standard 3, 4, 5 right triangle via coordinates
        final t = Triangle(
          p1: Point(x: 0, y: 0),
          p2: Point(x: 3, y: 0),
          p3: Point(x: 0, y: 4)
        );
        expect(t.perimeter, equals(12.0));
        expect(t.area, equals(6.0));
      });

      test('validates impossible collinear triangles', () {
        expect(() => Triangle(
          p1: Point(x: 0, y: 0), 
          p2: Point(x: 1, y: 1), 
          p3: Point(x: 2, y: 2)
        ), throwsArgumentError);
      });
    });

    group('Polygon', () {
      test('shoelace formula calculates exact area', () {
        // A simple square from 0,0 to 10,10
        final p = Polygon([
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 10, y: 10),
          Point(x: 0, y: 10)
        ]);
        expect(p.area, equals(100.0));
        expect(p.perimeter, equals(40.0));
      });
    });

    group('Ellipse', () {
      test('Ramanujan perimeter approximation', () {
        final e = Ellipse(semiMajorAxis: 3, semiMinorAxis: 2);
        expect(e.area, closeTo(math.pi * 6, 0.001));
        // Approximate circumference
        expect(e.perimeter, closeTo(15.865, 0.001));
      });
    });
  });
}
