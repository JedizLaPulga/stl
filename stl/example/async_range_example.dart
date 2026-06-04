import 'dart:async';

import 'package:stl/stl.dart';

Future<void> main() async {
  print('--- AsyncRange<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // fromIterable — synchronous source lifted into async
  // -----------------------------------------------------------------------
  print('fromIterable([1..5]):');
  await AsyncRange.fromIterable([1, 2, 3, 4, 5]).forEach(print);

  // -----------------------------------------------------------------------
  // generate — async producer function
  // -----------------------------------------------------------------------
  print('\ngenerate(6, i => i*i):');
  final gen = AsyncRange.generate(6, (i) => Future.value(i * i));
  final squares = await gen.toList();
  print(squares); // [0, 1, 4, 9, 16, 25]

  // -----------------------------------------------------------------------
  // fromFutures — ordered resolution of a list of Futures
  // -----------------------------------------------------------------------
  print('\nfromFutures (ordered):');
  final futures = [
    Future.value(10),
    Future.delayed(const Duration(milliseconds: 20), () => 20),
    Future.value(30),
  ];
  await AsyncRange.fromFutures(futures).forEach(print);

  // -----------------------------------------------------------------------
  // periodic — emit a value on every tick
  // -----------------------------------------------------------------------
  print('\nperiodic (5 ticks, 50 ms each):');
  final ticks = await AsyncRange.periodic(
    const Duration(milliseconds: 50),
    (i) => 'tick-$i',
    count: 5,
  ).toList();
  print(ticks);

  // -----------------------------------------------------------------------
  // map / where / take / drop — lazy composition
  // -----------------------------------------------------------------------
  print('\nCompose: generate(10) → where(even) → map(×3) → take(4):');
  final composed = AsyncRange.generate(
    10,
    (i) => Future.value(i),
  ).where((x) => x.isEven).map((x) => x * 3).take(4);
  print(await composed.toList()); // [0, 6, 12, 18]

  // -----------------------------------------------------------------------
  // expand — one-to-many flattening
  // -----------------------------------------------------------------------
  print('\nexpand([x, x*10]):');
  final expanded = AsyncRange.fromIterable([
    1,
    2,
    3,
  ]).expand((x) => [x, x * 10]);
  print(await expanded.toList()); // [1, 10, 2, 20, 3, 30]

  // -----------------------------------------------------------------------
  // takeWhile / dropWhile
  // -----------------------------------------------------------------------
  print('\ntakeWhile(< 5):');
  final tw = AsyncRange.fromIterable([
    1,
    2,
    3,
    4,
    5,
    6,
    7,
  ]).takeWhile((x) => x < 5);
  print(await tw.toList()); // [1, 2, 3, 4]

  print('\ndropWhile(<= 3):');
  final dw = AsyncRange.fromIterable([1, 2, 3, 4, 5]).dropWhile((x) => x <= 3);
  print(await dw.toList()); // [4, 5]

  // -----------------------------------------------------------------------
  // distinct — suppress consecutive duplicates
  // -----------------------------------------------------------------------
  print('\ndistinct:');
  final dist = AsyncRange.fromIterable([1, 1, 2, 2, 2, 3, 1, 1]).distinct();
  print(await dist.toList()); // [1, 2, 3, 1]

  // -----------------------------------------------------------------------
  // followedBy — sequential concatenation
  // -----------------------------------------------------------------------
  print('\nfollowedBy:');
  final cat = AsyncRange.fromIterable([
    1,
    2,
    3,
  ]).followedBy(AsyncRange.fromIterable([4, 5, 6]));
  print(await cat.toList()); // [1, 2, 3, 4, 5, 6]

  // -----------------------------------------------------------------------
  // fold / reduce
  // -----------------------------------------------------------------------
  final sum = await AsyncRange.fromIterable([
    1,
    2,
    3,
    4,
    5,
  ]).fold<int>(0, (acc, x) => acc + x);
  print('\nfold sum: $sum'); // 15

  final product = await AsyncRange.fromIterable([
    1,
    2,
    3,
    4,
    5,
  ]).reduce((a, b) => a * b);
  print('reduce product: $product'); // 120

  // -----------------------------------------------------------------------
  // first / last / length / any / every
  // -----------------------------------------------------------------------
  final r = AsyncRange.fromIterable([10, 20, 30, 40, 50]);
  print('\nfirst:  ${await r.first}');
  print('last:   ${await r.last}');
  print('length: ${await r.length}');
  print('any > 25: ${await r.any((x) => x > 25)}');
  print('every > 5: ${await r.every((x) => x > 5)}');

  // -----------------------------------------------------------------------
  // fromStream — wrapping an arbitrary Dart Stream
  // -----------------------------------------------------------------------
  print('\nfromStream (StreamController):');
  final controller = StreamController<String>();
  final streamRange = AsyncRange.fromStream(controller.stream);
  controller
    ..add('hello')
    ..add('async')
    ..add('world')
    ..close();
  await streamRange.forEach(print);

  // -----------------------------------------------------------------------
  // asyncMap — async element transformation
  // -----------------------------------------------------------------------
  print('\nasyncMap (async lookup simulation):');
  final asyncMapped = AsyncRange.fromIterable([1, 2, 3]).asyncMap((x) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return x * x;
  });
  print(await asyncMapped.toList()); // [1, 4, 9]
}
