import 'package:stl/stl.dart';

void main() {
  print('====================================================');
  print('    💎 STL MEGA SHOWCASE & ARCHITECTURE ALBUM');
  print('====================================================\n');

  print(eulerMascheroni);
  print(ln2);
  print(sqrt2);
  print(log2e);

  // ========================================
  // 1. DYNAMIC ARRAYS & MEMORY
  // ========================================
  print('>>> 1. CORE ARRAYS & SINGLY-LINKED LISTS <<<\n');

  final vec = Vector<String>(['Alpha', 'Bravo', 'Charlie', 'Delta']);
  print('• Vector initialized: ~vec evaluates to ${~vec}');

  // Appending and checking limits
  vec.pushBack('Echo');
  print('• Memory bounds strictly managed. Vector size is ${vec.size()}');

  // Vector advanced operations (assigning blocks of memory)
  final secondaryVec = Vector<String>([]);
  secondaryVec.assign(3, 'EmptySlot');
  print('• Vectors support raw memory block assigns: $secondaryVec');

  // ForwardList excels at fast shifting and removal algorithms
  print('\n[Converting Vector into a ForwardList]');
  final list = ForwardList<String>.from(vec);

  // ForwardList allows ultra-fast manipulations without resizing arrays
  list.insertAfter(1, 'Bravo-Two');
  list.removeIf((val) => val.startsWith('C')); // Removes "Charlie" immediately
  list.pushFront('Zulu');
  print('• ForwardList after O(1) shifts: $list');

  // ForwardList can inherently detect and crush contiguous duplicates
  list.pushFront('Zulu');
  list.pushFront('Zulu');
  list.unique();
  print('• List crushed duplicates instantly: $list\n');

  // ========================================
  // 2. ADAPTERS (Deque, Queue, Stack)
  // ========================================
  print('>>> 2. CONTAINER ADAPTERS (LIFO/FIFO) <<<\n');

  // Deque serves as the legendary backbone for stacks and queues
  final deque = Deque<int>.from([10, 20, 30, 40]);
  print('• Deque Backbone: $deque');

  // Deque supports random access AND double-ended insertions
  deque.pushFront(5);
  deque.pushBack(50);
  print('• Deque after O(1) double-ended operations: $deque\n');

  // 🥞 Stack natively uses Deque logic to restrict access to LIFO (Last-In, First-Out)
  final stack1 = Stack<int>.from(deque);
  final stack2 = Stack<int>.from([999, 888]);
  stack1.push(99);
  print('• Stack 1 spawned from Deque. Pushed 99.');
  print('  Top of Stack 1 is ${stack1.top} (Ready to pop: ${stack1.pop()})');

  print('\n[Swapping entire Stacks instantly!]');
  stack1.swap(stack2); // Swaps underlying structures immediately
  print('  Stack 1 is now strictly processing: $stack1');
  print('  Stack 2 inherited the massive chain: $stack2\n');

  // 🚏 Queue restricts access to FIFO (First-In, First-Out)
  final queue = Queue<int>.from(deque);
  queue.push(100);
  print('• Queue spawned from original Deque. Pushed 100.');
  print(
    '  Front of Queue is ${queue.front} (Ready to strictly FIFO pop: ${queue.pop()})\n',
  );

  // ========================================
  // 3. MATHEMATICAL SETS (O(1) Lookups & Trees)
  // ========================================
  print('>>> 3. ASSOCIATIVE SETS & TREES <<<\n');

  // Creating unique arrays
  final rawData = ['Apple', 'Banana', 'Apple', 'Cherry', 'Banana', 'Date'];

  // 1. Standard Set (Insertion Ordered)
  final orderedSet = Set<String>.from(rawData);
  print('• Standard Set (Preserves Insertion): $orderedSet'); // Duplicates gone

  // 2. HashSet (Unordered, Hyper-Optimized O(1))
  final hashSet = HashSet<String>.from(rawData);
  print('• HashSet (No guaranteed order, raw speed): ${hashSet.toList()}');

  // 3. SortedSet (Self-balancing Binary Search Tree)
  // Let's sort them strictly by string length, descending!
  final treeSet = SortedSet<String>.from(
    rawData,
    (a, b) => b.length.compareTo(a.length),
  );
  print('• SortedSet (Autonomous custom sorting): $treeSet');

  // Set Algebra (Intersections across different sets)
  final exoticFruits = Set<String>.from(['Cherry', 'Mango', 'Banana', 'Kiwi']);
  final intersection = orderedSet.intersection(exoticFruits);
  print(
    '• Intersection of orderedSet and exoticFruits: ${intersection.toList()}',
  );

  final difference = orderedSet.difference(exoticFruits);
  print('• Difference (Apples and Dates remain!): ${difference.toList()}\n');

  // ========================================
  // 4. UTILITIES (Pair & PriorityQueue)
  // ========================================
  print('>>> 4. UTILITIES & PRIORITY HEAPS <<<\n');

  // A Pair lets us strictly bind heterogeneous types (ID: String, Priority: int)
  final task1 = makePair('Login System Task', 2);
  final task2 = makePair('Update UI Colors Task', 5);
  final task3 = makePair(
    'Critical Database Migration',
    1,
  ); // 1 = highest priority

  print('• Stored compound types smoothly: $task3');

  // Let's create a custom PriorityQueue (Min-Heap) that reads the Pair's second value (the integer priority)
  final pQueue = PriorityQueue<Pair<String, int>>((a, b) {
    // Standard min-heap logic: b compared to a.
    return b.second.compareTo(a.second);
  });

  pQueue.push(task1);
  pQueue.push(task2);
  pQueue.push(task3);

  print('\n• Processing PriorityQueue via Heap Extraction:');
  while (pQueue.isNotEmpty) {
    final highestTarget = pQueue.pop();
    print(
      '  -> Processing (Priority ${highestTarget.second}): ${highestTarget.first}',
    );
  }
  print('');

  // ========================================
  // 5. C++23 RANGES & PIPELINING 🧬
  // ========================================
  print('>>> 5. C++23 FUNCTIONAL RANGES <<<\n');

  // NumberLine: Generate integers dynamically without loading memory arrays
  final series = NumberLine(0, 100, step: 25);
  print('• NumberLine (0 to 100, step 25): ${series.toList()}');

  // RepeatRange: Repeat a state machine value strictly
  final defaultConfigs = RepeatRange('Config_v1');
  final servers = defaultConfigs.take(3).toList();
  print('• RepeatRange limits to 3 servers: $servers');

  // ZipRange: Bind two parallel arrays perfectly (Map creation)
  final headers = Vector<String>(['id', 'status', 'token']);
  final values = [9912, 'Active', 'xyz-888-abc'];

  final zip = ZipRange(headers, values);
  print('\n• ZipRange merging 2 vectors strictly:');
  for (final pair in zip) {
    print('  ${pair.first}: ${pair.second}');
  }

  // ChunkRange & Stack relationship pipeline!
  // Let's chunk a large array of numbers into batches of 3,
  // then push those fragmented packets into a Stack for LIFO processing!
  print('\n[ChunkRange -> Stack Relationship Pipeline]');
  final byteData = NumberLine(
    1,
    10,
  ).toList(); // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  final chunks = ChunkRange(byteData, 3); // [[1,2,3], [4,5,6], [7,8,9], [10]]

  final packetStack = Stack<List<int>>();
  for (final packet in chunks) {
    packetStack.push(packet);
  }

  // Read them back strictly in reverse!
  print('• Stack processing downloaded chunks strictly backwards:');
  while (packetStack.isNotEmpty) {
    print('  -> Decompressing Packet: ${packetStack.pop()}');
  }

  // CartesianRange: Intersect two properties
  final suits = ['♠️', '♥️', '♣️', '♦️'];
  final royals = ['Jack', 'Queen', 'King', 'Ace'];
  final deckSegment = CartesianRange(royals, suits);

  print(
    '\n• CartesianRange generates combinations (Showing 10 from 16 matrix tiles):',
  );
  print('  ${deckSegment.take(10).toList()}');

  // New C++20/23 Functional Ranges Pipeline!
  print('\n[Pipeline: Filter -> Transform -> Drop -> Take]');
  final rawDataNodes = NumberLine(1, 20).toList();
  // Filter even numbers
  final evens = FilterRange(rawDataNodes, (int n) => n % 2 == 0);
  // Transform them by multiplying by 10
  final tens = TransformRange<int, int>(evens, (int n) => n * 10);
  // Drop the first 2 (20, 40)
  final droppedTens = DropRange(tens, 2);
  // Take the next 3 (60, 80, 100)
  final finalNodes = TakeRange(droppedTens, 3);
  print('• Raw Nodes: \$rawDataNodes');
  print(
    '• After Pipeline (Filter evens -> x10 -> Drop 2 -> Take 3): \${finalNodes.toList()}',
  );

  // JoinRange Showcase: Flattening fragmented chunks
  final fragmentedData = ChunkRange(NumberLine(1, 10), 3);
  final joinedData = JoinRange(fragmentedData);
  print('\n• JoinRange reassembling chunks back into a contiguous flow:');
  print('  Chunks: \${fragmentedData.toList()}');
  print('  Joined: \${joinedData.toList()}');

  // One final combination: PriorityQueue pushing Zipped Ranges!
  print('\n[ZipRange -> PriorityQueue Pipeline]');
  final userIds = [101, 105, 102];
  final userLevels = [80, 99, 15]; // Level 99 is highest
  final zippedUsers = ZipRange(userIds, userLevels);

  // Custom Max-Heap
  final levelHeap = PriorityQueue<Pair<int, int>>(
    (a, b) => a.second.compareTo(b.second),
  );

  for (final userRecord in zippedUsers) {
    levelHeap.push(userRecord);
  }

  print('• Highest level user gets processed first:');
  while (levelHeap.isNotEmpty) {
    var usr = levelHeap.pop();
    print('  -> Processed User ${usr.first} (Level ${usr.second})');
  }

  // Final interaction: Deque -> Vector -> HashSet Unique Extractor
  print('\n[Deque -> Vector -> HashSet Pipeline]');
  final dirtyDeque = Deque<String>.from([
    'Error',
    'Warning',
    'Log',
    'Error',
    'Error',
    'Warning',
  ]);
  print('• Raw Server Logs in Deque: $dirtyDeque');

  // Extract to Vector for processing
  final logVector = Vector<String>(dirtyDeque.toList());
  // Offload to HashSet to instantly destroy all duplicates with O(1) mathematical speed
  final cleanSet = HashSet<String>.from(logVector);
  print('• Extracted Unique Log Signatures instantly: ${cleanSet.toList()}');

  print('\n====================================================');
  print(' 🎉 END OF MEGA SHOWCASE');
  print('====================================================\n');
}
