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
        // A standard 3, 4, 5 right triangle
        final t = Triangle(sideA: 3, sideB: 4, sideC: 5);
        expect(t.perimeter, equals(12.0));
        expect(t.area, equals(6.0));
      });

      test('validates impossible triangles via Inequality Theorem', () {
        // 1 + 1 is NOT greater than 10
        expect(() => Triangle(sideA: 1, sideB: 1, sideC: 10), throwsArgumentError);
      });

      test('validates zero or negative sides', () {
        expect(() => Triangle(sideA: 0, sideB: 4, sideC: 5), throwsArgumentError);
        expect(() => Triangle(sideA: -3, sideB: 4, sideC: 5), throwsArgumentError);
      });
    });
  });
}
