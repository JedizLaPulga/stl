import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('StringView Tests', () {
    test('basic operations', () {
      final view = StringView('Hello World');
      expect(view.length, 11);
      expect(view[0], 'H');
      expect(view.isEmpty, isFalse);
    });

    test('substring view', () {
      final view = StringView.substring('Hello World', 6, 11);
      expect(view.length, 5);
      expect(view.toString(), 'World');
    });

    test('startsWith and endsWith', () {
      final view = StringView.substring('Hello World!', 0, 11); // "Hello World"
      expect(view.startsWith('Hello'), isTrue);
      expect(view.endsWith('World'), isTrue);
      expect(view.startsWith('World'), isFalse);
    });

    test('indexOf and contains', () {
      final view = StringView('abracadabra');
      expect(view.indexOf('cad'), 4);
      expect(view.contains('cad'), isTrue);
      expect(view.contains('zoo'), isFalse);
    });
    
    test('trim', () {
      final view = StringView('  hello  ').trim();
      expect(view.toString(), 'hello');
    });
  });
}
