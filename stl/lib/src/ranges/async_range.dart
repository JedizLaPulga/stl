/// A lazy, composable async range backed by a Dart [Stream].
///
/// [AsyncRange] is the async counterpart to the library's synchronous range
/// views. It wraps a `Stream<T>` and provides a fluent, composable API for
/// transforming, filtering, and consuming asynchronous sequences — mirroring
/// the design of C++23 async generators while staying idiomatic Dart.
///
/// All transformation methods (`map`, `where`, `take`, `drop`, `expand`,
/// `distinct`) are **lazy**: they return a new [AsyncRange] backed by a
/// transformed stream. No work is performed until the stream is consumed via
/// [forEach], [toList], [toStream], [first], or [last].
///
/// ```dart
/// // Emit 0–9 as fast as possible.
/// final range = AsyncRange.generate(10, (i) => Future.value(i));
///
/// // Compose lazily.
/// final result = range
///     .where((x) => x.isEven)
///     .map((x) => x * x);
///
/// // Consume.
/// await result.forEach(print); // 0, 4, 16, 36, 64
///
/// // Or collect.
/// final list = await result.toList(); // [0, 4, 16, 36, 64]
/// ```
///
/// ### Constructors
///
/// | Constructor | Description |
/// |---|---|
/// | [AsyncRange.fromStream] | Wraps an existing [Stream]. |
/// | [AsyncRange.fromIterable] | Converts a synchronous [Iterable] to an async range. |
/// | [AsyncRange.generate] | Produces elements via an async generator function. |
/// | [AsyncRange.periodic] | Emits a value on each tick of a [Duration]. |
/// | [AsyncRange.fromFutures] | Emits the resolved values of an [Iterable<Future<T>>] in order. |
library;

/// A lazy, composable async range backed by a Dart [Stream<T>].
///
/// See the library doc for a full overview and examples.
final class AsyncRange<T> {
  final Stream<T> _stream;

  const AsyncRange._(this._stream);

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Creates an [AsyncRange] that wraps [stream].
  ///
  /// ```dart
  /// final r = AsyncRange.fromStream(myController.stream);
  /// ```
  factory AsyncRange.fromStream(Stream<T> stream) => AsyncRange._(stream);

  /// Creates an [AsyncRange] that synchronously emits every element of
  /// [iterable], then completes.
  ///
  /// ```dart
  /// final r = AsyncRange.fromIterable([1, 2, 3]);
  /// ```
  factory AsyncRange.fromIterable(Iterable<T> iterable) =>
      AsyncRange._(Stream.fromIterable(iterable));

  /// Creates an [AsyncRange] of [count] elements by calling [generator] with
  /// each index (0-based) and awaiting the result.
  ///
  /// Elements are emitted in index order — the next element is not requested
  /// until the previous [Future] resolves.
  ///
  /// ```dart
  /// final r = AsyncRange.generate(5, (i) async {
  ///   await Future.delayed(Duration(milliseconds: 10));
  ///   return i * i;
  /// });
  /// // emits: 0, 1, 4, 9, 16
  /// ```
  factory AsyncRange.generate(
    int count,
    Future<T> Function(int index) generator,
  ) {
    if (count < 0) throw ArgumentError('count must be >= 0');
    return AsyncRange._(_generateStream(count, generator));
  }

  /// Creates an [AsyncRange] that emits `builder(tick)` on each [interval]
  /// tick, indefinitely (or until [count] elements have been emitted).
  ///
  /// [count] defaults to unlimited (the stream never completes on its own).
  ///
  /// ```dart
  /// // Emit a Unix-epoch timestamp every second, 5 times.
  /// final r = AsyncRange.periodic(
  ///   Duration(seconds: 1),
  ///   (i) => DateTime.now().millisecondsSinceEpoch,
  ///   count: 5,
  /// );
  /// ```
  factory AsyncRange.periodic(
    Duration interval,
    T Function(int tick) builder, {
    int? count,
  }) {
    Stream<T> stream = Stream.periodic(interval, builder);
    if (count != null) stream = stream.take(count);
    return AsyncRange._(stream);
  }

  /// Creates an [AsyncRange] that awaits each [Future] in [futures] in order
  /// and emits its resolved value.
  ///
  /// ```dart
  /// final r = AsyncRange.fromFutures([
  ///   Future.value(1),
  ///   Future.delayed(Duration(milliseconds: 50), () => 2),
  ///   Future.value(3),
  /// ]);
  /// ```
  factory AsyncRange.fromFutures(Iterable<Future<T>> futures) =>
      AsyncRange._(_futuresStream(futures));

  // ---------------------------------------------------------------------------
  // Lazy transformations — all return a new AsyncRange<U>
  // ---------------------------------------------------------------------------

  /// Returns a new [AsyncRange] with each element transformed by [f].
  ///
  /// ```dart
  /// final doubled = range.map((x) => x * 2);
  /// ```
  AsyncRange<U> map<U>(U Function(T element) f) =>
      AsyncRange._(_stream.map(f));

  /// Returns a new [AsyncRange] with each element asynchronously transformed
  /// by [f].
  AsyncRange<U> asyncMap<U>(Future<U> Function(T element) f) =>
      AsyncRange._(_stream.asyncMap(f));

  /// Returns a new [AsyncRange] containing only elements satisfying [test].
  ///
  /// ```dart
  /// final evens = range.where((x) => x.isEven);
  /// ```
  AsyncRange<T> where(bool Function(T element) test) =>
      AsyncRange._(_stream.where(test));

  /// Alias for [where].
  AsyncRange<T> filter(bool Function(T element) test) => where(test);

  /// Returns a new [AsyncRange] by expanding each element into zero or more
  /// elements via [f].
  ///
  /// ```dart
  /// final flat = AsyncRange.fromIterable([1, 2, 3])
  ///     .expand((x) => [x, x * 10]);
  /// // emits: 1, 10, 2, 20, 3, 30
  /// ```
  AsyncRange<U> expand<U>(Iterable<U> Function(T element) f) =>
      AsyncRange._(_stream.expand(f));

  /// Returns a new [AsyncRange] that emits at most [count] elements. $O(1)$.
  ///
  /// ```dart
  /// final first3 = range.take(3);
  /// ```
  AsyncRange<T> take(int count) {
    if (count < 0) throw ArgumentError('count must be >= 0');
    return AsyncRange._(_stream.take(count));
  }

  /// Returns a new [AsyncRange] that skips the first [count] elements. $O(1)$.
  AsyncRange<T> drop(int count) {
    if (count < 0) throw ArgumentError('count must be >= 0');
    return AsyncRange._(_stream.skip(count));
  }

  /// Returns a new [AsyncRange] that emits elements while [test] is `true`,
  /// then completes.
  AsyncRange<T> takeWhile(bool Function(T element) test) =>
      AsyncRange._(_stream.takeWhile(test));

  /// Returns a new [AsyncRange] that skips elements while [test] is `true`,
  /// then emits all remaining elements.
  AsyncRange<T> dropWhile(bool Function(T element) test) =>
      AsyncRange._(_stream.skipWhile(test));

  /// Returns a new [AsyncRange] that suppresses consecutive duplicate values
  /// (by `==`).
  ///
  /// ```dart
  /// // [1, 1, 2, 2, 3] → 1, 2, 3
  /// final r = AsyncRange.fromIterable([1, 1, 2, 2, 3]).distinct();
  /// ```
  AsyncRange<T> distinct() => AsyncRange._(_stream.distinct());

  /// Returns a new [AsyncRange] with all elements of this range followed by
  /// all elements of [other].
  AsyncRange<T> followedBy(AsyncRange<T> other) =>
      AsyncRange._(_stream.followedBy(other._stream));

  /// Returns a new [AsyncRange] that debounces elements: only emits a value
  /// if no further values arrive within [wait].
  AsyncRange<T> debounce(Duration wait) =>
      AsyncRange._(_debounceStream(_stream, wait));

  // ---------------------------------------------------------------------------
  // Terminal operations — consume the stream
  // ---------------------------------------------------------------------------

  /// Exposes the underlying [Stream<T>] for direct use with `await for`, etc.
  Stream<T> toStream() => _stream;

  /// Collects all emitted elements into a [List<T>].
  ///
  /// ```dart
  /// final list = await range.toList();
  /// ```
  Future<List<T>> toList() => _stream.toList();

  /// Calls [action] for every emitted element, in order.
  ///
  /// Returns a [Future] that completes when the stream is done.
  ///
  /// ```dart
  /// await range.forEach(print);
  /// ```
  Future<void> forEach(void Function(T element) action) =>
      _stream.forEach(action);

  /// Returns a [Future] that resolves to the **first** element emitted.
  ///
  /// Throws [StateError] if the stream is empty.
  Future<T> get first => _stream.first;

  /// Returns a [Future] that resolves to the **last** element emitted.
  ///
  /// Throws [StateError] if the stream is empty.
  Future<T> get last => _stream.last;

  /// Returns a [Future] that resolves to the single element emitted.
  ///
  /// Throws [StateError] if the stream emits more than one element or is empty.
  Future<T> get single => _stream.single;

  /// Returns a [Future] that resolves to the element at [index].
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  Future<T> elementAt(int index) => _stream.elementAt(index);

  /// Returns a [Future] resolving to `true` if [test] is satisfied by **any**
  /// element.
  Future<bool> any(bool Function(T element) test) => _stream.any(test);

  /// Returns a [Future] resolving to `true` if [test] is satisfied by **every**
  /// element.
  Future<bool> every(bool Function(T element) test) => _stream.every(test);

  /// Returns a [Future] resolving to `true` if this range emits no elements.
  Future<bool> get isEmpty => _stream.isEmpty;

  /// Returns a [Future] resolving to the number of elements emitted.
  Future<int> get length => _stream.length;

  /// Reduces the stream to a single value by applying [combine] cumulatively.
  ///
  /// Throws [StateError] if the stream is empty.
  Future<T> reduce(T Function(T previous, T element) combine) =>
      _stream.reduce(combine);

  /// Folds the stream to a single value, starting from [initialValue].
  Future<S> fold<S>(
    S initialValue,
    S Function(S previous, T element) combine,
  ) =>
      _stream.fold(initialValue, combine);

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static Stream<T> _generateStream<T>(
    int count,
    Future<T> Function(int) generator,
  ) async* {
    for (var i = 0; i < count; i++) {
      yield await generator(i);
    }
  }

  static Stream<T> _futuresStream<T>(Iterable<Future<T>> futures) async* {
    for (final f in futures) {
      yield await f;
    }
  }

  static Stream<T> _debounceStream<T>(Stream<T> source, Duration wait) {
    late StreamController<T> controller;
    T? lastValue;
    bool hasPending = false;

    controller = StreamController<T>(
      onListen: () {
        source.listen(
          (event) {
            lastValue = event;
            hasPending = true;
            Future.delayed(wait, () {
              if (hasPending) {
                hasPending = false;
                controller.add(lastValue as T);
              }
            });
          },
          onDone: () {
            if (hasPending) {
              hasPending = false;
              controller.add(lastValue as T);
            }
            controller.close();
          },
          onError: controller.addError,
        );
      },
    );
    return controller.stream;
  }

  @override
  String toString() => 'AsyncRange<$T>($_stream)';
}
