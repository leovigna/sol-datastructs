# Solidity Data Structures

Common gas-optimized data structures implemented in solidity. Currently supports:

-   ArrayLib: Gas Optimized Array for uint16, uint32, uint64, uint128
-   TreeLib: A flexible tree index library, supports wide tress with more than 2 leaves per node.
-   HeapLib: A gas optimized compact heap datastructure. Uses ArrayLib as its storage layer and TreeLib to navigate the heap.
-   Math: A LogBaseN calculator. Used to compute height of tree for informational purposes.

### Contracts

These contracts are all solidity libraries meant to be used within externally facing contracts. See the test contracts as an example on how to use the libraries.

### ArrayLib

Optimized packed array library (uint16,uint32...), conforms to general Solidity storage layout structure by storing data at keccak256(slot) + i.
ArrayLibUtils also implements a naive `push()` function for in-memory arrays (returns a copy with appended element).

### TreeLib

Packed tree stores multiple nodes per storage slot. TreeLib helps with computations such as finding out the parent() or leaves() of a node.

### HeapLib

Optimized heap using ArrayLib as storage and TreeLib to compute tree traversal. See tests for benchmarks.

### LogBaseNLib

Computes logarithm for any base (provided magic constant logN(2) is stored). This is used for informational purposes when computing the tree height only, though other applications are also possible.

## License

2020 Lionsmane Development
MIT License.
