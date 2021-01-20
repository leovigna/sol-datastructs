## `HeapLibUInt64`

An optimized uint64 min/max heap

Heap are efficient in keeping track of the min/max of a set of elements. The
root of the heap is always the min/max and this applies recursively, meaning any parent
MUST be less/greater than its children.

The HeapLibUInt64 uses TreeLib for computing indices for traversal within the tree
and ArrayLibUInt64 as a storage medium.

See https://en.wikipedia.org/wiki/Heap_(data_structure)

Note: While HeapLibUInt64 stores uint64, it accepts a custom comparator function that
it calls using staticall(). For example, one can encode the compare value in the lower
8 bits, store a custom value in the upper 56 bits, and only compare the lower 8bits when
determining sort order within the heap.

### `compare(uint64 a, uint64 b, bytes4 compareSelector) → bool result` (internal)

Call comparator function returning true/false.

### `len(bytes32 slot) → uint256 length` (internal)

Length of heap.

### `height(bytes32 slot, uint256 a, uint256 b) → uint256` (internal)

Height of heap tree.

### `maxLength(bytes32 slot, uint256 a, uint256 b) → uint256` (internal)

Max items heap can hold before a height increase.

### `get(bytes32 slot, uint256 i) → uint64 value` (internal)

Get item at tree[i]

### `root(bytes32 slot) → uint64 value` (internal)

Get heap root

### `parentIdx(uint256 a, uint256 b, uint256 i) → uint256` (internal)

Get parent node index

### `leavesIdx(uint256 a, uint256 b, uint256 i) → uint256[]` (internal)

Get children node indices

### `parent(bytes32 slot, uint256 a, uint256 b, uint256 i) → uint64` (internal)

Get parent node value

### `leaves(bytes32 slot, uint256 a, uint256 b, uint256 i) → uint64[]` (internal)

Get children node values

### `set(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint256 i, uint64 val)` (internal)

Overite a value at an index, and heapify with new value

### `push(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint64 val)` (internal)

Push a new value and heapify.

### `remove(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint256 i) → uint64 v` (internal)

Remove value at index and heapify.

### `removeRoot(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector) → uint64 v` (internal)

Remove heap root and heapify.

### `search(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint64 v, uint256 idx) → uint256` (internal)

Search heap for first occurrence.

### `searchUp(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint64 v, uint256 idx) → uint256` (internal)

Search heap depth-first recusing up parents nodes

### `searchDown(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint64 v, uint256[] idxList) → uint256` (internal)

Search heap breadth-first recursing down leaves

### `searchRoot(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint64 v) → uint256` (internal)

Search heap from root.

### `heapifyUp(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint256 i)` (internal)

Swap up to heapify from i

### `heapifyDown(bytes32 slot, uint256 a, uint256 b, bytes4 compareSelector, uint256 i) → uint64 iVal` (internal)

Swap down to heapify from i
