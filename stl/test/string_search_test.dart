import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('String Search Algorithms', () {
    test('knuthMorrisPrattSearch', () {
      expect(knuthMorrisPrattSearch('hello world', 'world'), equals(6));
      expect(knuthMorrisPrattSearch('hello world', 'o w'), equals(4));
      expect(knuthMorrisPrattSearch('hello world', 'dart'), equals(-1));
      expect(knuthMorrisPrattSearch('aaaaab', 'aab'), equals(3));
      expect(knuthMorrisPrattSearch('', 'a'), equals(-1));
      expect(knuthMorrisPrattSearch('a', ''), equals(0));
    });

    test('boyerMooreSearch', () {
      expect(boyerMooreSearch('hello world', 'world'), equals(6));
      expect(boyerMooreSearch('hello world', 'o w'), equals(4));
      expect(boyerMooreSearch('hello world', 'dart'), equals(-1));
      expect(boyerMooreSearch('aaaaab', 'aab'), equals(3));
      expect(boyerMooreSearch('', 'a'), equals(-1));
      expect(boyerMooreSearch('a', ''), equals(0));
    });
  });
}
