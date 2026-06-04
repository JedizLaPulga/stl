import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // =========================================================================
  // ImmutableList<T>
  // =========================================================================
  group('ImmutableList — construction', () {
    test('empty()', () {
      final il = ImmutableList<int>.empty();
      expect(il.isEmpty, isTrue);
      expect(il.length, 0);
    });

    test('of(iterable)', () {
      final il = ImmutableList.of([1, 2, 3]);
      expect(il.length, 3);
      expect(il.toList(), [1, 2, 3]);
    });

    test('filled(n, v)', () {
      final il = ImmutableList.filled(5, 0);
      expect(il.toList(), [0, 0, 0, 0, 0]);
    });

    test('generate(n, f)', () {
      final il = ImmutableList.generate(5, (i) => i * i);
      expect(il.toList(), [0, 1, 4, 9, 16]);
    });

    test('filled/generate throw on negative length', () {
      expect(
        () => ImmutableList.filled(-1, 0),
        throwsA(isA<InvalidArgument>()),
      );
      expect(
        () => ImmutableList.generate(-1, (i) => i),
        throwsA(isA<InvalidArgument>()),
      );
    });
  });

  group('ImmutableList — element access', () {
    final il = ImmutableList.of([10, 20, 30]);

    test('operator[]', () {
      expect(il[0], 10);
      expect(il[2], 30);
    });

    test('first / last', () {
      expect(il.first, 10);
      expect(il.last, 30);
    });

    test('first/last throw on empty', () {
      final empty = ImmutableList<int>.empty();
      expect(() => empty.first, throwsStateError);
      expect(() => empty.last, throwsStateError);
    });

    test('operator[] throws on out-of-bounds', () {
      expect(() => il[5], throwsRangeError);
    });
  });

  group('ImmutableList — persistent mutations', () {
    final original = ImmutableList.of([1, 2, 3]);

    test('add returns new list; original unchanged', () {
      final next = original.add(4);
      expect(next.toList(), [1, 2, 3, 4]);
      expect(original.toList(), [1, 2, 3]);
    });

    test('addAll', () {
      expect(original.addAll([4, 5]).toList(), [1, 2, 3, 4, 5]);
    });

    test('removeAt', () {
      expect(original.removeAt(1).toList(), [1, 3]);
    });

    test('remove (first occurrence)', () {
      expect(ImmutableList.of([1, 2, 2, 3]).remove(2).toList(), [1, 2, 3]);
    });

    test('set', () {
      expect(original.set(1, 99).toList(), [1, 99, 3]);
    });

    test('insert', () {
      expect(original.insert(1, 42).toList(), [1, 42, 2, 3]);
    });

    test('clear', () {
      expect(original.clear().isEmpty, isTrue);
    });

    test('insert at end (index == length)', () {
      expect(original.insert(3, 9).toList(), [1, 2, 3, 9]);
    });

    test('removeAt throws on bad index', () {
      expect(() => original.removeAt(5), throwsRangeError);
    });
  });

  group('ImmutableList — functional transforms', () {
    final il = ImmutableList.of([1, 2, 3, 4, 5]);

    test('map', () {
      expect(il.map((x) => x * 2).toList(), [2, 4, 6, 8, 10]);
    });

    test('where', () {
      expect(il.where((x) => x.isEven).toList(), [2, 4]);
    });

    test('expand', () {
      expect(ImmutableList.of([1, 2]).expand((x) => [x, x * 10]).toList(), [
        1,
        10,
        2,
        20,
      ]);
    });

    test('take', () {
      expect(il.take(3).toList(), [1, 2, 3]);
      expect(il.take(0).isEmpty, isTrue);
      expect(il.take(10).toList(), [1, 2, 3, 4, 5]);
    });

    test('drop', () {
      expect(il.drop(2).toList(), [3, 4, 5]);
      expect(il.drop(0).toList(), [1, 2, 3, 4, 5]);
      expect(il.drop(10).isEmpty, isTrue);
    });

    test('sublist', () {
      expect(il.sublist(1, 4).toList(), [2, 3, 4]);
    });

    test('sorted', () {
      final unsorted = ImmutableList.of([5, 1, 4, 2, 3]);
      expect(unsorted.sorted().toList(), [1, 2, 3, 4, 5]);
      expect(unsorted.sorted((a, b) => b.compareTo(a)).toList(), [
        5,
        4,
        3,
        2,
        1,
      ]);
    });

    test('reversed', () {
      expect(il.reversed().toList(), [5, 4, 3, 2, 1]);
    });

    test('concat', () {
      final a = ImmutableList.of([1, 2]);
      final b = ImmutableList.of([3, 4]);
      expect(a.concat(b).toList(), [1, 2, 3, 4]);
    });
  });

  group('ImmutableList — queries', () {
    final il = ImmutableList.of([10, 20, 30, 20]);

    test('contains', () {
      expect(il.contains(20), isTrue);
      expect(il.contains(99), isFalse);
    });

    test('indexOf', () {
      expect(il.indexOf(20), 1);
      expect(il.indexOf(99), -1);
    });

    test('lastIndexOf', () {
      expect(il.lastIndexOf(20), 3);
    });
  });

  group('ImmutableList — equality & hashCode', () {
    test('equal lists', () {
      final a = ImmutableList.of([1, 2, 3]);
      final b = ImmutableList.of([1, 2, 3]);
      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('unequal lists', () {
      final a = ImmutableList.of([1, 2, 3]);
      final b = ImmutableList.of([1, 2, 4]);
      expect(a == b, isFalse);
    });

    test('different lengths not equal', () {
      expect(ImmutableList.of([1, 2]) == ImmutableList.of([1, 2, 3]), isFalse);
    });
  });

  // =========================================================================
  // ImmutableMap<K, V>
  // =========================================================================
  group('ImmutableMap — construction', () {
    test('empty()', () {
      final m = ImmutableMap<String, int>.empty();
      expect(m.isEmpty, isTrue);
      expect(m.length, 0);
    });

    test('of(map)', () {
      final m = ImmutableMap.of({'a': 1, 'b': 2});
      expect(m.length, 2);
      expect(m['a'], 1);
      expect(m['b'], 2);
    });

    test('fromPairs', () {
      final m = ImmutableMap.fromPairs([Pair('x', 10), Pair('y', 20)]);
      expect(m['x'], 10);
      expect(m['y'], 20);
    });

    test('fromEntries', () {
      final m = ImmutableMap.fromEntries([
        const MapEntry('p', 100),
        const MapEntry('q', 200),
      ]);
      expect(m['p'], 100);
    });
  });

  group('ImmutableMap — element access', () {
    final m = ImmutableMap.of({'a': 1, 'b': 2, 'c': 3});

    test('operator[]', () {
      expect(m['a'], 1);
      expect(m['z'], isNull);
    });

    test('at() throws on absent key', () {
      expect(() => m.at('z'), throwsArgumentError);
    });

    test('containsKey / containsValue', () {
      expect(m.containsKey('b'), isTrue);
      expect(m.containsKey('z'), isFalse);
      expect(m.containsValue(2), isTrue);
      expect(m.containsValue(99), isFalse);
    });

    test('keys / values / entries', () {
      expect(m.keys.toList(), ['a', 'b', 'c']);
      expect(m.values.toList(), [1, 2, 3]);
      expect(m.entries.map((e) => '${e.key}:${e.value}').toList(), [
        'a:1',
        'b:2',
        'c:3',
      ]);
    });
  });

  group('ImmutableMap — persistent mutations', () {
    final original = ImmutableMap.of({'a': 1, 'b': 2});

    test('put returns new map; original unchanged', () {
      final next = original.put('c', 3);
      expect(next['c'], 3);
      expect(original.length, 2);
    });

    test('put overwrites existing key', () {
      expect(original.put('a', 99)['a'], 99);
    });

    test('putAll', () {
      final m = original.putAll({'c': 3, 'd': 4});
      expect(m.length, 4);
    });

    test('remove existing key', () {
      final next = original.remove('a');
      expect(next.containsKey('a'), isFalse);
      expect(next.length, 1);
    });

    test('remove absent key returns equal copy', () {
      final next = original.remove('z');
      expect(next.length, original.length);
    });

    test('update', () {
      final next = original.update('b', (v) => v * 10);
      expect(next['b'], 20);
    });

    test('update throws on absent key', () {
      expect(() => original.update('z', (v) => v), throwsArgumentError);
    });

    test('updateOrInsert — existing key', () {
      final next = original.updateOrInsert('a', (v) => v + 1, () => 0);
      expect(next['a'], 2);
    });

    test('updateOrInsert — absent key', () {
      final next = original.updateOrInsert('q', (v) => v + 1, () => 99);
      expect(next['q'], 99);
    });

    test('clear', () {
      expect(original.clear().isEmpty, isTrue);
    });
  });

  group('ImmutableMap — functional transforms', () {
    final m = ImmutableMap.of({'a': 1, 'b': 2, 'c': 3});

    test('mapValues', () {
      final doubled = m.mapValues((v) => v * 2);
      expect(doubled['a'], 2);
      expect(doubled['c'], 6);
    });

    test('mapEntries', () {
      final upper = m.mapEntries<String, int>(
        (k, v) => MapEntry(k.toUpperCase(), v),
      );
      expect(upper['A'], 1);
    });

    test('filter (predicate on k,v)', () {
      final filtered = m.filter((k, v) => v > 1);
      expect(filtered.containsKey('a'), isFalse);
      expect(filtered.containsKey('b'), isTrue);
      expect(filtered.containsKey('c'), isTrue);
    });

    test('whereKey', () {
      expect(m.whereKey((k) => k != 'b').containsKey('b'), isFalse);
    });

    test('whereValue', () {
      expect(m.whereValue((v) => v.isEven).toList().length, 1);
    });

    test('merge — other wins on conflict', () {
      final m2 = ImmutableMap.of({'b': 99, 'd': 4});
      final merged = m.merge(m2);
      expect(merged['b'], 99);
      expect(merged['d'], 4);
    });

    test('merge — resolve on conflict', () {
      final m2 = ImmutableMap.of({'b': 10, 'c': 10});
      final merged = m.merge(m2, resolve: (a, b) => a + b);
      expect(merged['b'], 12);
      expect(merged['c'], 13);
    });
  });

  group('ImmutableMap — iteration', () {
    test('iterates as Pair<K,V>', () {
      final m = ImmutableMap.of({'x': 1, 'y': 2});
      final pairs = m.toList();
      expect(pairs.map((p) => p.first).toList(), ['x', 'y']);
      expect(pairs.map((p) => p.second).toList(), [1, 2]);
    });
  });

  group('ImmutableMap — equality & hashCode', () {
    test('equal maps', () {
      final a = ImmutableMap.of({'x': 1, 'y': 2});
      final b = ImmutableMap.of({'x': 1, 'y': 2});
      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('unequal maps', () {
      final a = ImmutableMap.of({'x': 1});
      final b = ImmutableMap.of({'x': 2});
      expect(a == b, isFalse);
    });
  });

  group('ImmutableMap — toMap()', () {
    test('returns mutable copy', () {
      final m = ImmutableMap.of({'a': 1});
      final mutable = m.toMap();
      mutable['b'] = 2;
      expect(m.containsKey('b'), isFalse); // original unchanged
      expect(mutable['b'], 2);
    });
  });

  // =========================================================================
  // AsyncRange<T>
  // =========================================================================
  group('AsyncRange — construction', () {
    test('fromIterable', () async {
      final list = await AsyncRange.fromIterable([1, 2, 3]).toList();
      expect(list, [1, 2, 3]);
    });

    test('generate', () async {
      final list = await AsyncRange.generate(
        5,
        (i) => Future.value(i * 2),
      ).toList();
      expect(list, [0, 2, 4, 6, 8]);
    });

    test('generate throws on negative count', () {
      expect(
        () => AsyncRange.generate(-1, (i) => Future.value(i)),
        throwsArgumentError,
      );
    });

    test('fromFutures', () async {
      final list = await AsyncRange.fromFutures([
        Future.value(10),
        Future.value(20),
        Future.value(30),
      ]).toList();
      expect(list, [10, 20, 30]);
    });

    test('periodic (count)', () async {
      final list = await AsyncRange.periodic(
        const Duration(milliseconds: 10),
        (i) => i,
        count: 4,
      ).toList();
      expect(list, [0, 1, 2, 3]);
    });
  });

  group('AsyncRange — lazy transformations', () {
    test('map', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
      ]).map((x) => x * 3).toList();
      expect(result, [3, 6, 9]);
    });

    test('where / filter', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
        5,
      ]).where((x) => x.isOdd).toList();
      expect(result, [1, 3, 5]);
    });

    test('filter is alias for where', () async {
      final a = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
      ]).where((x) => x > 2).toList();
      final b = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
      ]).filter((x) => x > 2).toList();
      expect(a, b);
    });

    test('expand', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
      ]).expand((x) => [x, x * 10]).toList();
      expect(result, [1, 10, 2, 20]);
    });

    test('take', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
        5,
      ]).take(3).toList();
      expect(result, [1, 2, 3]);
    });

    test('drop', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
        5,
      ]).drop(2).toList();
      expect(result, [3, 4, 5]);
    });

    test('take throws on negative count', () {
      expect(() => AsyncRange.fromIterable([]).take(-1), throwsArgumentError);
    });

    test('drop throws on negative count', () {
      expect(() => AsyncRange.fromIterable([]).drop(-1), throwsArgumentError);
    });

    test('takeWhile', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
        5,
      ]).takeWhile((x) => x < 4).toList();
      expect(result, [1, 2, 3]);
    });

    test('dropWhile', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
        4,
        5,
      ]).dropWhile((x) => x <= 3).toList();
      expect(result, [4, 5]);
    });

    test('distinct', () async {
      final result = await AsyncRange.fromIterable([
        1,
        1,
        2,
        2,
        3,
        1,
      ]).distinct().toList();
      expect(result, [1, 2, 3, 1]);
    });

    test('followedBy', () async {
      final result = AsyncRange.fromIterable([
        1,
        2,
      ]).followedBy(AsyncRange.fromIterable([3, 4]));
      expect(await result.toList(), [1, 2, 3, 4]);
    });

    test('asyncMap', () async {
      final result = await AsyncRange.fromIterable([
        1,
        2,
        3,
      ]).asyncMap((x) async => x * x).toList();
      expect(result, [1, 4, 9]);
    });

    test('composed pipeline', () async {
      final result = await AsyncRange.generate(
        10,
        (i) => Future.value(i),
      ).where((x) => x.isEven).map((x) => x * 3).take(4).toList();
      expect(result, [0, 6, 12, 18]);
    });
  });

  group('AsyncRange — terminal operations', () {
    test('first', () async {
      expect(await AsyncRange.fromIterable([10, 20, 30]).first, 10);
    });

    test('last', () async {
      expect(await AsyncRange.fromIterable([10, 20, 30]).last, 30);
    });

    test('length', () async {
      expect(await AsyncRange.fromIterable([1, 2, 3, 4]).length, 4);
    });

    test('isEmpty — empty stream', () async {
      expect(await AsyncRange.fromIterable(<int>[]).isEmpty, isTrue);
    });

    test('isEmpty — non-empty stream', () async {
      expect(await AsyncRange.fromIterable([1]).isEmpty, isFalse);
    });

    test('any — true', () async {
      expect(
        await AsyncRange.fromIterable([1, 2, 3]).any((x) => x == 2),
        isTrue,
      );
    });

    test('any — false', () async {
      expect(
        await AsyncRange.fromIterable([1, 2, 3]).any((x) => x == 9),
        isFalse,
      );
    });

    test('every — true', () async {
      expect(
        await AsyncRange.fromIterable([2, 4, 6]).every((x) => x.isEven),
        isTrue,
      );
    });

    test('every — false', () async {
      expect(
        await AsyncRange.fromIterable([2, 3, 6]).every((x) => x.isEven),
        isFalse,
      );
    });

    test('fold', () async {
      expect(
        await AsyncRange.fromIterable([
          1,
          2,
          3,
          4,
          5,
        ]).fold<int>(0, (acc, x) => acc + x),
        15,
      );
    });

    test('reduce', () async {
      expect(
        await AsyncRange.fromIterable([1, 2, 3, 4, 5]).reduce((a, b) => a * b),
        120,
      );
    });

    test('elementAt', () async {
      expect(await AsyncRange.fromIterable([10, 20, 30]).elementAt(1), 20);
    });

    test('forEach side effect', () async {
      final collected = <int>[];
      await AsyncRange.fromIterable([7, 8, 9]).forEach(collected.add);
      expect(collected, [7, 8, 9]);
    });

    test('toStream exposes raw stream', () async {
      final stream = AsyncRange.fromIterable([1, 2, 3]).toStream();
      expect(await stream.toList(), [1, 2, 3]);
    });
  });
}
