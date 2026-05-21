import 'package:test/test.dart';
import 'package:stl/src/math/random/engine.dart';
import 'package:stl/src/math/random/distribution.dart';


void main() {
  group('RandomDistribution Tests', () {
    late MersenneTwisterEngine engine;

    setUp(() {
      engine = MersenneTwisterEngine(12345);
    });

    test('UniformIntDistribution bounds', () {
      final dist = UniformIntDistribution(10, 50);
      for (int i = 0; i < 1000; i++) {
        final val = dist(engine);
        expect(val >= 10 && val <= 50, isTrue);
      }
    });

    test('UniformRealDistribution bounds', () {
      final dist = UniformRealDistribution(1.5, 5.5);
      for (int i = 0; i < 1000; i++) {
        final val = dist(engine);
        expect(val >= 1.5 && val < 5.5, isTrue);
      }
    });

    test('BernoulliDistribution statistics', () {
      final dist = BernoulliDistribution(0.3);
      int trueCount = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        if (dist(engine)) trueCount++;
      }
      final double p = trueCount / n;
      expect(p, closeTo(0.3, 0.02));
    });

    test('BinomialDistribution statistics', () {
      final dist = BinomialDistribution(100, 0.5);
      double sum = 0;
      int n = 5000;
      for (int i = 0; i < n; i++) {
        sum += dist(engine);
      }
      final double mean = sum / n;
      expect(mean, closeTo(50.0, 0.5));
    });

    test('NormalDistribution statistics', () {
      final dist = NormalDistribution(10.0, 2.0);
      double sum = 0;
      double sqSum = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        final val = dist(engine);
        sum += val;
        sqSum += val * val;
      }
      final double mean = sum / n;
      final double variance = (sqSum / n) - (mean * mean);
      
      expect(mean, closeTo(10.0, 0.1));
      expect(variance, closeTo(4.0, 0.2));
    });

    test('ExponentialDistribution statistics', () {
      final dist = ExponentialDistribution(2.0); // mean = 0.5
      double sum = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        sum += dist(engine);
      }
      final double mean = sum / n;
      expect(mean, closeTo(0.5, 0.05));
    });

    test('PoissonDistribution statistics', () {
      final dist = PoissonDistribution(4.0);
      double sum = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        sum += dist(engine);
      }
      final double mean = sum / n;
      expect(mean, closeTo(4.0, 0.1));
    });

    test('GammaDistribution statistics', () {
      final dist = GammaDistribution(2.0, 2.0); // mean = alpha * beta = 4.0
      double sum = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        sum += dist(engine);
      }
      final double mean = sum / n;
      expect(mean, closeTo(4.0, 0.2));
    });

    test('ChiSquaredDistribution statistics', () {
      final dist = ChiSquaredDistribution(5.0); // mean = k = 5.0
      double sum = 0;
      int n = 10000;
      for (int i = 0; i < n; i++) {
        sum += dist(engine);
      }
      final double mean = sum / n;
      expect(mean, closeTo(5.0, 0.2));
    });
  });
}
