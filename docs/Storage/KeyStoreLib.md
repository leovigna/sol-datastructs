## `KeyStoreLib`

An unstructured storage library

This library can be used to replace the native Solidity storage layout by
introducing helper functions to get/set storage variables. This can also
be done with inline assembly more efficiently. This library introduces better
readability at the cost of some overhead.

### `getUInt256(bytes32 slot) → uint256 v` (internal)

Get uint256

### `setUInt256(bytes32 slot, uint256 v)` (internal)

Set uint256

### `getBool(bytes32 slot) → bool v` (internal)

Get bool

### `setBool(bytes32 slot, bool v)` (internal)

Set bool

### `getAddress(bytes32 slot) → address v` (internal)

Get address

### `setAddress(bytes32 slot, address v)` (internal)

Set address

### `getString(bytes32 slot) → string v` (internal)

Get string storage

### `getBytes(bytes32 slot) → bytes v` (internal)

Get bytes storage

### `getUInt256Array(bytes32 slot) → uint256[] v` (internal)

Get uint256[] storage

### `getUInt256Mapping(bytes32 slot) → mapping(uint256 => uint256) v` (internal)

Get mapping(uint256 => uint256) storage

### `getAddressArray(bytes32 slot) → address[] v` (internal)

Get address[] storage

### `getAddressMapping(bytes32 slot) → mapping(address => uint256) v` (internal)

Get mapping(address => uint256) storage
