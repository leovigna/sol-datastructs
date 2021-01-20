## `TreeLib`

A storage agnostic implicit Tree indexing library

Note: This Library does not impliment any storage functions and
is only used to convert from node labelling to storage indexing.

Nodes are 0-indexed meaning the root node is at index 0.

See https://en.wikipedia.org/wiki/M-ary_tree#Arrays
See https://en.wikipedia.org/wiki/Implicit_data_structure

The optimized M-ary implicit Tree<T> is specially designed for gas cost tradeoffs on the EVM.|
This tree is meant to be an AB-ary tree using an implicit array-based storage structure.
It is (A-1)B-ary because nodes at even heights from the root (h=0) split into (A-1) children, and nodes at
odd heights split into B children. The inclusion of this 2-tiered split intentional as it enables
great performance on packed arrays with small elements (eg. uint16) since we can chose A=16
(such as to fill a full storage slot with 1 root and 15 children) and an arbitray B.

This Tree is very useful when looking to implent a binary heap though other use cases are also possible.

Below an example with A=3, B=2
Nodes are labelled [0..n-1] in breadth-first top down traversal.
Subnodes are labelled [0..2] within the node, [0..3(n-1)] by top down node traversal, filling each node to max before adding a node.
**\_**
/ <a> \
 / / \ \
 /_<b> <c>_\
 / | | \
 N2 N3 N4 N5

a := nodes per pack, a >= 2
b := pack leaves, b >= 1

### `height(uint256 a, uint256 b, uint256 length) → uint256 h` (internal)

Get height of the tree in packs levels

### `maxLength(uint256 a, uint256 b, uint256 h) → uint256 length` (internal)

Get max number of items the tree can contain given a pack level of h

### `getIdx(uint256 a, uint256 i) → uint256 x, uint256 y` (internal)

Get storage index of node labelled i

### `parentIdx(uint256 a, uint256 b, uint256 i) → uint256` (internal)

Get parent node index

### `leavesIdx(uint256 a, uint256 b, uint256 i) → uint256[]` (internal)

Get children node indices

### `leavesIdxList(uint256 a, uint256 b, uint256[] idxList) → uint256[]` (internal)

Get children node indices for a breadth-first search
