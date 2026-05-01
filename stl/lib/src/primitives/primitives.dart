/// Primitive integer types: zero-cost wrappers and heap-allocated variants.
///
/// Zero-cost (extension type implements int): [I8], [I16], [I32], [I64],
/// [U8], [U16], [U32], [U64].
///
/// Heap-allocated (typed_data-backed): [Int8], [Int16], [Int32], [Int64],
/// [Uint8], [Uint16], [Uint32], [Uint64].
library;

import 'dart:typed_data';

part 'i8.dart';
part 'i16.dart';
part 'i32.dart';
part 'i64.dart';
part 'u8.dart';
part 'u16.dart';
part 'u32.dart';
part 'u64.dart';
part 'int8.dart';
part 'int16.dart';
part 'int32.dart';
part 'int64.dart';
part 'uint8.dart';
part 'uint16.dart';
part 'uint32.dart';
part 'uint64.dart';
