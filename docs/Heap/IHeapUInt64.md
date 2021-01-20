## `IHeapUInt64`

### `height() → uint256` (external)

### `maxLength() → uint256` (external)

### `length() → uint256` (external)

### `get(uint256 i) → uint64` (external)

### `set(uint256 i, uint64 val)` (external)

### `push(uint64 val)` (external)

### `root() → uint64` (external)

### `parent(uint256 i) → uint64` (external)

### `leaves(uint256 i) → uint64[]` (external)

### `parentIdx(uint256 i) → uint256` (external)

### `leavesIdx(uint256 i) → uint256[]` (external)

### `remove(uint256 i) → uint64` (external)

### `removeRoot() → uint64` (external)

### `compare(uint64 a, uint64 b) → bool` (external)

### `search(uint64 val, uint256 hintIdx) → uint256` (external)

### `searchRoot(uint64 val) → uint256` (external)

### `searchUp(uint64 val, uint256 startIdx) → uint256` (external)

### `searchDown(uint64 val, uint256[] startIdx) → uint256` (external)

### `pushBatch(uint64[] val)` (external)

### `removeRootBatch(uint256 n) → uint64[]` (external)
