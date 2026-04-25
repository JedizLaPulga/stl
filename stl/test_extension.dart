extension type const I8._(int value) implements int {
  /// Instantiates a new [I8] spanning a strictly bounded 8-bit value.
  const I8(this.value);
}

void main() {
  const x = I8(5);
  print(x);
}
