## `KeyStore`

An example external facing contract using KeyStoreLib

WARNING: Contracts should use KeyStoreLib directly (recommended) or override KeyStore setter methods.

### `getUInt256(bytes32 slot) → uint256 v` (public)

Get uint256

### `setUInt256(bytes32 slot, uint256 v)` (public)

Set uint256

### `getAddress(bytes32 slot) → address v` (public)

Get address

### `setAddress(bytes32 slot, address v)` (public)

Set address

### `getUInt256Array(bytes32 slot, uint256 k) → uint256` (public)

Get uint256[] storage

### `pushUInt256Array(bytes32 slot, uint256 v)` (public)

Push uint256[] storage

### `getUInt256Mapping(bytes32 slot, uint256 k) → uint256` (public)

Get mapping(uint256 => uint256) storage

### `setUInt256Mapping(bytes32 slot, uint256 k, uint256 v)` (public)

Set mapping(uint256 => uint256) storage
