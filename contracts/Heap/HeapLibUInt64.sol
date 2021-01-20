//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../Tree/TreeLib.sol';
import '../Array/ArrayLibUInt64.sol';

/**
 * @dev An optimized uint64 min/max heap
 *
 * Heap are efficient in keeping track of the min/max of a set of elements. The
 * root of the heap is always the min/max and this applies recursively, meaning any parent
 * MUST be less/greater than its children.
 *
 * The HeapLibUInt64 uses TreeLib for computing indices for traversal within the tree
 * and ArrayLibUInt64 as a storage medium.
 *
 * See https://en.wikipedia.org/wiki/Heap_(data_structure)
 *
 * Note: While HeapLibUInt64 stores uint64, it accepts a custom comparator function that
 * it calls using staticall(). For example, one can encode the compare value in the lower
 * 8 bits, store a custom value in the upper 56 bits, and only compare the lower 8bits when
 * determining sort order within the heap.
 *
 */
library HeapLibUInt64 {
    using ArrayLibUInt64 for bytes32;

    /**
     * @dev Call comparator function returning true/false.
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @return result
     *
     * Note: The compareSelector MUST be implemented in the parent contract using
     * the library. The heap invariant is compare(parent,child) = true. So for a min-heap
     * use a < b.
     *
     * Potential improvements:
     *  - Replace staticall with jumpcall (internal)
     */
    function compare(
        uint64 a,
        uint64 b,
        bytes4 compareSelector
    ) internal view returns (bool result) {
        (, bytes memory compareBytes) = address(this).staticcall(abi.encodeWithSelector(compareSelector, a, b));
        assembly {
            result := mload(add(compareBytes, 32))
        }
    }

    /**
     * @dev Length of heap.
     * @param slot storage
     * @return length
     */
    function len(bytes32 slot) internal view returns (uint256 length) {
        length = slot.len();
    }

    /**
     * @dev Height of heap tree.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @return height
     */
    function height(
        bytes32 slot,
        uint256 a,
        uint256 b
    ) internal view returns (uint256) {
        uint256 length = slot.len();
        return TreeLib.height(a, b, length);
    }

    /**
     * @dev Max items heap can hold before a height increase.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @return maxLength
     *
     * Note: This function is used to estimate SSTORE costs since gas cost increases
     * with tree height.
     */
    function maxLength(
        bytes32 slot,
        uint256 a,
        uint256 b
    ) internal view returns (uint256) {
        uint256 h = height(slot, a, b);
        return TreeLib.maxLength(a, b, h);
    }

    /**
     * @dev Get item at tree[i]
     * @param slot storage slot
     * @param i index
     * @return value
     *
     * Note: Values are NOT sorted, but heap-sorted meaning the only guarantee
     * is that get(slot,0) will be the min/max.
     */
    function get(bytes32 slot, uint256 i) internal view returns (uint64 value) {
        value = slot.get(i);
    }

    /**
     * @dev Get heap root
     * @param slot storage slot
     * @return value
     */
    function root(bytes32 slot) internal view returns (uint64 value) {
        value = slot.get(0);
    }

    /**
     * @dev Get parent node index
     * @param a items per slot
     * @param b leaves
     * @param i, node index
     * @return parentIdx
     */
    function parentIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) internal pure returns (uint256) {
        return TreeLib.parentIdx(a, b, i);
    }

    /**
     * @dev Get children node indices
     * @param a items per slot
     * @param b leaves
     * @param i, node index
     * @return leavesIdx[]
     */
    function leavesIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) internal pure returns (uint256[] memory) {
        return TreeLib.leavesIdx(a, b, i);
    }

    /**
     * @dev Get parent node value
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param i, node index
     * @return parent
     */
    function parent(
        bytes32 slot,
        uint256 a,
        uint256 b,
        uint256 i
    ) internal view returns (uint64) {
        uint256 pIdx = TreeLib.parentIdx(a, b, i);
        return slot.get(pIdx);
    }

    /**
     * @dev Get children node values
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param i, node index
     * @return leaves[]
     */
    function leaves(
        bytes32 slot,
        uint256 a,
        uint256 b,
        uint256 i
    ) internal view returns (uint64[] memory) {
        uint256[] memory lIdx = TreeLib.leavesIdx(a, b, i);
        uint64[] memory le = new uint64[](lIdx.length);

        for (uint256 j; j < lIdx.length; j++) {
            le[j] = slot.get(lIdx[j]);
        }

        return le;
    }

    /**
     * @dev Overite a value at an index, and heapify with new value
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param i index
     * @param val value
     *
     * Note: This is a niche use case for the heap as it replaces an existing value.
     * Developers should favor push(), remove().
     */
    function set(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint256 i,
        uint64 val
    ) internal {
        slot.set(i, val);
        if (compare(slot.get(i), slot.get(TreeLib.parentIdx(a, b, i)), compareSelector)) {
            // a < parent, heapifyUp
            heapifyUp(slot, a, b, compareSelector, i);
        } else {
            heapifyDown(slot, a, b, compareSelector, i);
        }
    }

    /**
     * @dev Push a new value and heapify.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param val value
     */
    function push(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint64 val
    ) internal {
        slot.push(val);
        heapifyUp(slot, a, b, compareSelector, slot.len() - 1);
    }

    /**
     * @dev Remove value at index and heapify.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param i index
     * @return v
     */
    function remove(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint256 i
    ) internal returns (uint64 v) {
        v = slot.get(i);
        slot.set(i, 0); //clear slot

        uint256 length;
        assembly {
            length := sload(slot)
            sstore(slot, sub(length, 1)) //decrease length
        }

        slot.swap(i, length - 1); //Replace with last element
        heapifyDown(slot, a, b, compareSelector, i); //Heapify down
    }

    /**
     * @dev Remove heap root and heapify.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @return v
     */
    function removeRoot(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector
    ) internal returns (uint64 v) {
        return remove(slot, a, b, compareSelector, 0);
    }

    /**
     * @dev Search heap for first occurrence.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param v search value
     * @param idx index hint
     * @return index
     *
     * Note: We use the index hint as a starting point for our search. Instead
     * of doing a breadth-first search from the root, we start at our hint and
     * recurse parents or leaves from there.
     */
    function search(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint64 v,
        uint256 idx
    ) internal view returns (uint256) {
        //Check hint index
        if (v == slot.get(idx)) {
            return idx;
        }

        //Check parent index
        idx = searchUp(slot, a, b, compareSelector, v, idx);
        if (v == slot.get(idx)) {
            return idx;
        }

        //Check leaf indices
        uint256[] memory startLeafIndices = TreeLib.leavesIdx(a, b, idx); // leaf indices in sorted order
        idx = searchDown(slot, a, b, compareSelector, v, startLeafIndices); // reverts if not found

        return idx;
    }

    /**
     * @dev Search heap depth-first recusing up parents nodes
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param v search value
     * @param idx start index
     * @return index
     *
     * Note: This does not search based on equality but rather continues recursing
     * until the parent node would correctly be the search value's parent. In
     * a min-heap, this would equate to recursing up to the first root less than the
     * search value. Base case returns the root with idx=0.
     *
     */
    function searchUp(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint64 v,
        uint256 idx
    ) internal view returns (uint256) {
        uint256 length = slot.len();
        require(idx < length, 'HeapLibUInt64.searchUp: idx out of bounds.');

        while (compare(v, slot.get(idx), compareSelector) && idx != 0) {
            // v < heap[i] (min-heap), recurse parents
            idx = TreeLib.parentIdx(a, b, idx);
        }

        return idx;
    }

    /**
     * @dev Search heap breadth-first recursing down leaves
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param v search value
     * @param idxList list of start indices in sorted order
     * @return index
     *
     * Note: Stops searching leaves that cannot be parents of the search value.
     * Base case reverts upon reaching bottom of tree.
     */
    function searchDown(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint64 v,
        uint256[] memory idxList
    ) internal view returns (uint256) {
        uint256 length = slot.len();

        while (idxList.length > 0) {
            uint256 recIdxLength;
            uint256[] memory recIdxList = new uint256[](idxList.length);
            for (uint256 li = 0; li < idxList.length; li++) {
                uint256 idx = idxList[li];
                if (idx < length) {
                    if (v == slot.get(idx)) {
                        return idx;
                    }

                    if (!compare(v, slot.get(idx), compareSelector)) {
                        // v > heap[i] (min-heap), recurse leaves
                        recIdxList[recIdxLength++] = idx;
                    }
                }
            }

            //Overwrite array length
            assembly {
                mstore(recIdxList, recIdxLength)
            }
            //Recurse leaves of leaves
            idxList = TreeLib.leavesIdxList(a, b, recIdxList);
        }

        revert('HeapLibUInt64.searchDown: v not found.'); //No more leaves to search. These get removed recursively as they are either out of bounds or cannot be parents to the search value.
    }

    /**
     * @dev Search heap from root.
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param v search value
     * @return index
     *
     * Note: This is very inefficient O(n). Recommended use is to call off-chain and
     * use result as hint, optimizing the efficiency of the search when it is actually
     * used during contract execution.
     */
    function searchRoot(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint64 v
    ) internal view returns (uint256) {
        return search(slot, a, b, compareSelector, v, 0);
    }

    /**
     * @dev Swap up to heapify from i
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * @param i index
     * Used for after push() to update from leaf to root
     */
    function heapifyUp(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint256 i
    ) internal {
        // a < b
        while (i > 0 && compare(slot.get(i), slot.get(TreeLib.parentIdx(a, b, i)), compareSelector)) {
            // compare(i, parent), we swap them
            uint256 pIdx = TreeLib.parentIdx(a, b, i);
            slot.swap(i, pIdx);
            i = pIdx; //Set current index to parent
        }
    }

    /**
     * @dev Swap down to heapify from i
     * @param slot storage
     * @param a items per slot
     * @param b leaves
     * @param compareSelector comparison function 4byte selector
     * Used for after remove() to update from root to leaf
     */
    function heapifyDown(
        bytes32 slot,
        uint256 a,
        uint256 b,
        bytes4 compareSelector,
        uint256 i
    ) internal returns (uint64 iVal) {
        //Find children minimum and swap
        uint256 length = slot.len();
        iVal = slot.get(i);

        while (true) {
            uint256 minIdx;
            uint64 minVal;
            if (i % a == 0) {
                minIdx = i + 1;
                if (minIdx >= length) {
                    break; //Null pointer, done heapifyDown
                }

                //Adjacent leaves, use batch reads
                uint256[] memory idxList = new uint256[](4);
                idxList[0] = i;
                idxList[1] = i + 1;
                idxList[2] = i + 2;
                idxList[3] = i + 3;
                uint256[] memory valList = slot.getBatch(idxList);

                minVal = uint64(valList[1]);

                // Find min leaf
                for (uint256 j = 2; j < valList.length; j++) {
                    uint256 cmpIdx = i + j;
                    if (cmpIdx >= length) {
                        break; //Null pointer, done find minLeaf
                    }
                    uint64 cmpVal = uint64(valList[j]); //cached value
                    bool c = compare(minVal, cmpVal, compareSelector); // a <= b
                    minIdx = c ? minIdx : cmpIdx;
                    minVal = c ? minVal : cmpVal;
                }
            } else {
                uint256[] memory lIdx = TreeLib.leavesIdx(a, b, i); // leaf indices in sorted order
                minIdx = lIdx[0];
                if (minIdx >= length) {
                    break; //Null pointer, done heapifyDown
                }
                minVal = slot.get(minIdx);

                // Find min leaf
                for (uint256 j = 1; j < lIdx.length; j++) {
                    uint256 cmpIdx = lIdx[j];
                    if (cmpIdx >= length) {
                        break; //Null pointer, done find minLeaf
                    }
                    uint64 cmpVal = slot.get(cmpIdx);
                    bool c = compare(minVal, cmpVal, compareSelector); // a <= b
                    minIdx = c ? minIdx : cmpIdx;
                    minVal = c ? minVal : cmpVal;
                }
            }

            // Swap with min leaf
            if (compare(minVal, iVal, compareSelector)) {
                //minVal <= iVal
                slot.swap(i, minIdx);
                i = minIdx;
            } else {
                break; // iVal < minVal, min heap invariant preserved
            }
        }
    }
}
