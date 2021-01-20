## `ArrayLibUInt64`

A gas optimized uint64[] implementation. Uses the ArrayLibUInt with bitLength = 64.

### `len(bytes32 slot) → uint256 length` (internal)

Get length of the array

### `get(bytes32 slot, uint256 i) → uint64 value` (internal)

Get item at array[i]

### `set(bytes32 slot, uint256 i, uint64 val)` (internal)

Set array[i] = val

### `push(bytes32 slot, uint64 val)` (internal)

Append val to the end of the array, increasing its length.

### `pop(bytes32 slot)` (internal)

Pop end val of the array, decreasing its length.

### `swap(bytes32 slot, uint256 i, uint256 j)` (internal)

Swap two values at i, j.

### `getBatch(bytes32 slot, uint256[] iArray) → uint256[] valList` (internal)

Get a batch of items.

### `setBatch(bytes32 slot, uint256[] iArray, uint256[] valArray)` (internal)

Set a batch of values in the array.

### `pushBatch(bytes32 slot, uint256[] valArray)` (internal)

Append a batch of values to the end of the array, increasing its length.

### `popBatch(bytes32 slot, uint256 n)` (internal)

Pop a batch of values from the array, decreasing its length.
