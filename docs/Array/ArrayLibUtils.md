## `ArrayLibUtils`

Utilities for manipulating memory arrays

Unlike storage arrays, memory arrays can't be resized to we use these
utility functions to generate copies.

### `push(uint256[] array, uint256 val) → uint256[]` (internal)

Append value to copy of the array, increasing its length.

### `pop(uint256[] array) → uint256[]` (internal)

Delete last value from copy of the array, decreasing its length.

### `hash(uint256[] array) → bytes32` (internal)

keccak256 hash the encoded array elements

### `sum(uint256[] array) → uint256` (internal)

Sum the array elements

### `concat(bytes[] arrayOfArrays) → bytes` (internal)

Concatenate byte arrays

### `concat(uint256[][] arrayOfArrays) → uint256[]` (internal)

Concatenate byte arrays

### `range(uint256 from, uint256 to) → uint256[] rangeArray` (internal)

Return range array
