import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Ref<T>', () {
    test('constructs and gets successfully', () {
      final myRef = Ref<int>(10);
      expect(myRef.get(), equals(10));
      expect(myRef(), equals(10));
    });

    test('rebinds strictly overriding old value', () {
      final nameRef = Ref<String>('Alpha');
      nameRef.set('Bravo');
      expect(nameRef.get(), equals('Bravo'));
    });

    test('rebinding one reference to another', () {
      final targetNode = Ref<int>(500);
      final pointer = Ref<int>(0);
      
      pointer.rebind(targetNode);
      expect(pointer.get(), equals(500));
      expect(pointer, equals(targetNode));
    });

    test('validates equality against underlying value', () {
      final refA = Ref<double>(3.14);
      final refB = Ref<double>(3.14);
      final refC = Ref<double>(0.0);

      expect(refA, equals(refB));
      expect(refA.hashCode, equals(refB.hashCode));
      expect(refA, isNot(equals(refC)));
    });

    test('string outputs inner bounds correctly', () {
      final ref = Ref<bool>(true);
      expect(ref.toString(), equals('true'));
    });
  });
}
