import 'package:test/test.dart';
import 'package:stl/src/math/random/engine.dart';

void main() {
  group('RandomEngine Tests', () {
    test('LinearCongruentialEngine.minstd generation', () {
      final engine = LinearCongruentialEngine.minstd(1);
      
      // Known 10000th value of std::minstd_rand seeded with 1 is 399268537
      int val = 0;
      for (int i = 0; i < 10000; i++) {
        val = engine.next();
      }
      expect(val, equals(399268537));
    });

    test('LinearCongruentialEngine.minstd0 generation', () {
      final engine = LinearCongruentialEngine.minstd0(1);
      
      // Known 10000th value of std::minstd_rand0 seeded with 1 is 1043618065
      int val = 0;
      for (int i = 0; i < 10000; i++) {
        val = engine.next();
      }
      expect(val, equals(1043618065));
    });

    test('MersenneTwisterEngine generation', () {
      final engine = MersenneTwisterEngine(5489);
      
      // Known 10000th value of std::mt19937 seeded with 5489 is 4123659995
      int val = 0;
      for (int i = 0; i < 10000; i++) {
        val = engine.next();
      }
      expect(val, equals(4123659995));
    });

    test('Engine discard functionality', () {
      final engine1 = MersenneTwisterEngine(12345);
      final engine2 = MersenneTwisterEngine(12345);

      engine1.discard(5000);
      for (int i = 0; i < 5000; i++) {
        engine2.next();
      }

      expect(engine1.next(), equals(engine2.next()));
    });
    
    test('DartNativeEngine bounds', () {
      final engine = DartNativeEngine(42);
      expect(engine.min, equals(0));
      expect(engine.max, equals(0xFFFFFFFF));
      
      for (int i = 0; i < 100; i++) {
        final val = engine.next();
        expect(val >= engine.min && val <= engine.max, isTrue);
      }
    });
  });
}
