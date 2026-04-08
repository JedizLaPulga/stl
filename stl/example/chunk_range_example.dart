import 'package:stl/stl.dart';

void main() {
  final largeDataset = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  print('--- ChunkRange Example: Paginating elements ---');
  // Splits a flat list into multiple smaller sub-lists (e.g. for batches or pagination)
  final pagination = ChunkRange(largeDataset, 3);
  
  int pageNum = 1;
  for (final page in pagination) {
    print('Page $pageNum: $page');
    pageNum++;
  }
}
