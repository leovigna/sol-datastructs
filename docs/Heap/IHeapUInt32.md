## `IHeapUInt32`

### `height() → uint256` (external)

### `maxLength() → uint256` (external)

### `length() → uint256` (external)

### `get(uint256 i) → uint32` (external)

### `set(uint256 i, uint32 val)` (external)

### `push(uint32 val)` (external)

### `root() → uint32` (external)

### `parent(uint256 i) → uint32` (external)

### `leaves(uint256 i) → uint32[]` (external)

### `parentIdx(uint256 i) → uint256` (external)

### `leavesIdx(uint256 i) → uint256[]` (external)

### `remove(uint256 i) → uint32` (external)

### `removeRoot() → uint32` (external)

### `compare(uint32 a, uint32 b) → bool` (external)

### `search(uint32 val, uint256 hintIdx) → uint256` (external)

### `searchRoot(uint32 val) → uint256` (external)

### `searchUp(uint32 val, uint256 startIdx) → uint256` (external)

### `searchDown(uint32 val, uint256[] startIdx) → uint256` (external)

### `pushBatch(uint32[] val)` (external)

### `removeRootBatch(uint256 n) → uint32[]` (external)
