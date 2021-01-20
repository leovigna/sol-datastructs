//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import './ArrayLibUInt.sol';

/**
 * @dev A gas optimized uint64[] implementation. Uses the ArrayLibUInt with bitLength = 64.
 *
 *
 */
library ArrayLibUInt64 {
    /**
     * @dev Get length of the array
     * @param slot storage slot
     * @return length
     *
     * This function is here as a helper to avoid inline assembly (though less efficient).
     * It also helps to show how the arrays' length is stored in its designated slot.
     */
    function len(bytes32 slot) internal view returns (uint256 length) {
        assembly {
            length := sload(slot)
        }
    }

    /**
     * @dev Get item at array[i]
     * @param slot storage slot
     * @param i index
     * @return value
     *
     */
    function get(bytes32 slot, uint256 i) internal view returns (uint64 value) {
        value = uint64(ArrayLibUInt.get(64, slot, i));
    }

    /**
     * @dev Set array[i] = val
     * @param slot storage slot
     * @param i index
     * @param val value
     */
    function set(
        bytes32 slot,
        uint256 i,
        uint64 val
    ) internal {
        ArrayLibUInt.set(64, slot, i, val);
    }

    /**
     * @dev Append val to the end of the array, increasing its length.
     * @param slot storage slot
     * @param val value
     */
    function push(bytes32 slot, uint64 val) internal {
        ArrayLibUInt.push(64, slot, val);
    }

    /**
     * @dev Pop end val of the array, decreasing its length.
     * @param slot storage slot
     */
    function pop(bytes32 slot) internal {
        ArrayLibUInt.pop(64, slot);
    }

    /**
     * @dev Swap two values at i, j.
     * @param slot storage slot
     * @param i index
     * @param j subindex
     *
     * There is potential for optimizing how same slot items are swapped.
     */
    function swap(
        bytes32 slot,
        uint256 i,
        uint256 j
    ) internal {
        ArrayLibUInt.swap(64, slot, i, j);
    }

    /**
     * @dev Get a batch of items.
     * @param slot storage slot
     * @param iArray index array
     * @return valList
     *
     * Note: valList is uint256[]. Higher order bits will be stripped.
     */
    function getBatch(bytes32 slot, uint256[] memory iArray) internal view returns (uint256[] memory valList) {
        valList = ArrayLibUInt.getBatch(64, slot, iArray);
    }

    /**
     * @dev Set a batch of values in the array.
     * @param slot storage slot
     * @param iArray index array
     * @param valArray value array.
     *
     * Note: valArray must already be cast to uint256[]. Higher order bits will be stripped.
     *
     */
    function setBatch(
        bytes32 slot,
        uint256[] memory iArray,
        uint256[] memory valArray
    ) internal {
        ArrayLibUInt.setBatch(64, slot, iArray, valArray);
    }

    /**
     * @dev Append a batch of values to the end of the array, increasing its length.
     * @param slot storage slot
     * @param valArray value array
     *
     * Note: valArray must already be cast to uint256[]. Higher order bits will be stripped.
     *
     */
    function pushBatch(bytes32 slot, uint256[] memory valArray) internal {
        ArrayLibUInt.pushBatch(64, slot, valArray);
    }

    /**
     * @dev Pop a batch of values from the array, decreasing its length.
     * @param slot storage slot
     * @param n number of times to pop
     *
     */
    function popBatch(bytes32 slot, uint256 n) internal {
        ArrayLibUInt.popBatch(64, slot, n);
    }
}
