## `LogBaseNLib`

Computes logarithms

Note: Only logbases with a magic constant are computable

Inspired from
https://medium.com/coinmonks/math-in-solidity-part-5-exponent-and-logarithm-9aef8515136e

Log2(x) is computed using bit shifting.
LogN(x) is computed using Log2(x) and a precomputed stored LogN(2).

From Wolfrom Alpha we get the LogN(2) magic constants.
The constants hold in 212 bits so overflow by multiplication is impossible when multiplying
with a number [1..256]. To compute logbaseN(x) we compute Log2(x) and multiply with the magic
constant, we then check for rounding errors.

### `logbaseN(uint256 b, uint256 x) → uint256, uint256` (internal)

Compute LogN(x) and N^LogN(x) (round down to larges power)

### `logbaseE(uint256 x) → uint256` (internal)

### `logbase2(uint256 x) → uint256 n, uint256 m` (internal)

Compute Log2(x) and 2^Log2(x) using bit shifting and comparisons
