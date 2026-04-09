import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Any', () {
    test('holding and checking primitives', () {
      final a = Any(100);
      expect(a.hasValue(), isTrue);
      expect(a.type(), equals(int));
      // Native casting explicitly
      expect(a.cast<int>(), equals(100));
    });

    test('casting strongly enforces type safety and prevents arbitrary conversions', () {
      final s = Any('Hello String');
      expect(s.type(), equals(String));
      expect(s.cast<String>(), equals('Hello String'));

      // Tries to improperly parse a string as a double
      expect(() => s.cast<double>(), throwsA(isA<TypeError>()));
    });

    test('rebounding objects wipes away original inner bindings dynamically', () {
      final dyn = Any(true);
      expect(dyn.cast<bool>(), isTrue);

      dyn.set(5.5);
      expect(dyn.type(), equals(double));
      expect(dyn.cast<double>(), equals(5.5));
    });

    test('resetting actively empties memory and locks functions natively', () {
      final emptyBox = Any.empty();
      expect(emptyBox.hasValue(), isFalse);

      expect(() => emptyBox.cast<String>(), throwsStateError);
      expect(() => emptyBox.type(), throwsStateError);

      emptyBox.set('Data');
      expect(emptyBox.hasValue(), isTrue);
      expect(emptyBox.cast<String>(), equals('Data'));

      emptyBox.reset();
      expect(emptyBox.hasValue(), isFalse);
    });

    test('evaluates mathematical equality structurally correctly', () {
      final x = Any('Alpha');
      final y = Any('Alpha');
      final z = Any('Bravo');
      final e1 = Any.empty();
      final e2 = Any.empty();

      expect(x == y, isTrue);
      expect(x == z, isFalse);
      expect(x == e1, isFalse);
      expect(e1 == e2, isTrue); // Both empty 
    });
  });
}
