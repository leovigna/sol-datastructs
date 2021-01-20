//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../Math/LogBaseNLib.sol';

/**
 * @dev A storage agnostic implicit Tree indexing library
 *
 * Note: This Library does not impliment any storage functions and
 * is only used to convert from node labelling to storage indexing.
 *
 * Nodes are 0-indexed meaning the root node is at index 0.
 *
 * See https://en.wikipedia.org/wiki/M-ary_tree#Arrays
 * See https://en.wikipedia.org/wiki/Implicit_data_structure
 *
 * The optimized M-ary implicit Tree<T> is specially designed for gas cost tradeoffs on the EVM.|
 * This tree is meant to be an AB-ary tree using an implicit array-based storage structure.
 * It is (A-1)B-ary because nodes at even heights from the root (h=0) split into (A-1) children, and nodes at
 * odd heights split into B children. The inclusion of this 2-tiered split intentional as it enables
 * great performance on packed arrays with small elements (eg. uint16) since we can chose A=16
 * (such as to fill a full storage slot with 1 root and 15 children) and an arbitray B.
 *
 * This Tree is very useful when looking to implent a binary heap though other use cases are also possible.
 *
 * Below an example with A=3, B=2
 * Nodes are labelled [0..n-1] in breadth-first top down traversal.
 * Subnodes are labelled [0..2] within the node, [0..3(n-1)] by top down node traversal, filling each node to max before adding a node.
 *           _____
 *          / <a> \
 *         /  / \  \
 *        /_<b> <c>_\
 *        / |    | \
 *       N2 N3   N4 N5
 *
 * a := nodes per pack, a >= 2
 * b := pack leaves, b >= 1
 *
 */
library TreeLib {
    /**
     * @dev Get height of the tree in packs levels
     * @param a items per slot
     * @param b leaves
     * @param length number of items
     * @return h
     *
     * Note: This function is used to estimate SSTORE costs since gas cost increases
     * with tree height.
     * Unlike other tree definitions, we consider a single node to be of height one
     */
    function height(
        uint256 a,
        uint256 b,
        uint256 length
    ) internal pure returns (uint256 h) {
        uint256 pSplit = b * (a - 1);
        uint256 pCount = length / a;
        (h, ) = LogBaseNLib.logbaseN(pSplit, pCount * (pSplit - 1) + 1);
    }

    /**
     * @dev Get max number of items the tree can contain given a pack level of h
     * @param a items per slot
     * @param b leaves
     * @param h height
     * @return length
     *
     * This function is used to estimate SSTORE costs.
     */
    function maxLength(
        uint256 a,
        uint256 b,
        uint256 h
    ) internal pure returns (uint256 length) {
        uint256 pSplit = b * (a - 1);
        length = ((pSplit**(h + 1) - 1) / (pSplit - 1)) * a;
    }

    /**
     * @dev Get storage index of node labelled i
     * @param a items per slot
     * @param i node index
     * @return x major index, correponds to pack slot index
     * @return y minor index, corresponds to index within the pack (0=root, 1-a=children)
     */
    function getIdx(uint256 a, uint256 i) internal pure returns (uint256 x, uint256 y) {
        x = i / a;
        y = i % a;
    }

    /**
     * @dev Get parent node index
     * @param a items per slot
     * @param b leaves
     * @param i node index
     * @return parentIdx
     */
    function parentIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) internal pure returns (uint256) {
        if (i == 0) {
            return 0;
        }

        {
            uint256 remainder = i % a;
            if (remainder != 0) {
                //leaf subnode
                return i - remainder;
            }
        }
        //Lemma: Let tree T, where each parent node has (a) leaves, label nodes in breadth-first traversal starting with the root at 0. => parent(i) = (i - 1) / a
        //Is root, parent subnode is in another node
        uint256 currNodeIdx = i / a; //  = i / a   | Each node has (a) subnodes => Node id is i / a
        uint256 pSplit = b * (a - 1);
        uint256 parentNodeIdx = (currNodeIdx - 1) / pSplit; //  = i / ((a - 1) * 2)  | Each node has (a - 1) leaves (from lemma)
        uint256 nodeRemainder = (currNodeIdx - 1) % pSplit; //  = i % ((a - 1) * 2)

        return parentNodeIdx * a + 1 + nodeRemainder / b; //  = p * a + 1 + r / 2
    }

    /**
     * @dev Get children node indices
     * @param a items per slot
     * @param b leaves
     * @param i node index
     * @return leavesIdx[]
     */
    function leavesIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) internal pure returns (uint256[] memory) {
        uint256 remainder = i % a;
        if (remainder == 0) {
            uint256[] memory le = new uint256[](a - 1);
            //Loop through leaves
            for (uint256 j = 0; j < a - 1; j++) {
                le[j] = i + j + 1;
            }

            return le;
        }

        uint256 currNodeIdx = i / a; //  = i / a   | Each node has (a) subnodes => Node id is i / a
        uint256 pSplit = b * (a - 1);
        uint256[] memory le = new uint256[](b);
        //Loop through leaves
        for (uint256 j = 0; j < b; j++) {
            uint256 childNode = currNodeIdx * pSplit + remainder * b - b + 1 + j;

            le[j] = childNode * a;
        }

        return le;
    }

    /**
     * @dev Get children node indices for a breadth-first search
     * @param a items per slot
     * @param b leaves
     * @param idxList list of node indices, assumes all are at the same level (and all are pack leaves or roots).
     * @return leavesIdx[]
     */
    function leavesIdxList(
        uint256 a,
        uint256 b,
        uint256[] memory idxList
    ) internal pure returns (uint256[] memory) {
        if (idxList.length == 0) {
            return new uint256[](0);
        }

        //Recurse leaves of leaves,
        uint256 remainder = idxList[0] % a; //Check if pack root
        uint256[] memory le;
        if (remainder == 0) {
            //Leaves are pack roots, each with a-1 leaves
            le = new uint256[](idxList.length * (a - 1));
            for (uint256 i = 0; i < idxList.length; i++) {
                //Add new leaves
                for (uint256 j = 0; j < a - 1; j++) {
                    le[i * (a - 1) + j] = idxList[i] + j + 1;
                }
            }
        } else {
            //Leaves are pack leaves, each with b leaves
            le = new uint256[](idxList.length * b);
            for (uint256 i = 0; i < idxList.length; i++) {
                //Add new leaves
                uint256[] memory li = leavesIdx(a, b, idxList[i]);
                for (uint256 j = 0; j < b; j++) {
                    le[i * b + j] = li[j];
                }
            }
        }

        return le;
    }
}
