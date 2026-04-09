Type _typeOf<T>() => T;

sealed class Variant2<T0, T1> {
  const Variant2();

  factory Variant2.withT0(T0 value) = Variant2Item0<T0, T1>;
  factory Variant2.withT1(T1 value) = Variant2Item1<T0, T1>;

  R visit<R>(R Function(T0) onT0, R Function(T1) onT1);

  bool holdsAlternative<T>();
}

final class Variant2Item0<T0, T1> extends Variant2<T0, T1> {
  final T0 value;
  const Variant2Item0(this.value);

  @override
  R visit<R>(R Function(T0) onT0, R Function(T1) onT1) => onT0(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T0>();
}

final class Variant2Item1<T0, T1> extends Variant2<T0, T1> {
  final T1 value;
  const Variant2Item1(this.value);

  @override
  R visit<R>(R Function(T0) onT0, R Function(T1) onT1) => onT1(value);

  @override
  bool holdsAlternative<T>() => _typeOf<T>() == _typeOf<T1>();
}

void main() {
  Variant2<int, String> v1 = Variant2.withT0(42);
  print('v1 is int: ${v1.holdsAlternative<int>()}');
  print('v1 is String: ${v1.holdsAlternative<String>()}');
  print('v1 is double: ${v1.holdsAlternative<double>()}');

  v1.visit(
    (int i) => print('Got int: $i'),
    (String s) => print('Got string: $s')
  );
}
