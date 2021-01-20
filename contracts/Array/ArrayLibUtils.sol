// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * @dev Utilities for manipulating memory arrays
 *
 * Unlike storage arrays, memory arrays can't be resized to we use these
 * utility functions to generate copies.
 */
library ArrayLibUtils {
    /**
     * @dev Append value to copy of the array, increasing its length.
     * @param array of uint256
     * @param val value
     * @return newArray
     */
    function push(uint256[] memory array, uint256 val) internal pure returns (uint256[] memory) {
        uint256 arrayLength = array.length;
        uint256[] memory newArray = new uint256[](arrayLength + 1);

        for (uint256 i = 0; i < arrayLength; i++) {
            newArray[i] = array[i];
        }
        newArray[arrayLength] = val;
        return newArray;
    }

    /**
     * @dev Delete last value from copy of the array, decreasing its length.
     * @param array of uint256
     * @return newArray
     */
    function pop(uint256[] memory array) internal pure returns (uint256[] memory) {
        uint256 arrayLength = array.length;
        uint256[] memory newArray = new uint256[](arrayLength - 1);

        for (uint256 i = 0; i < arrayLength - 1; i++) {
            newArray[i] = array[i];
        }
        return newArray;
    }

    /**
     * @dev keccak256 hash the encoded array elements
     * @param array of uint256
     * @return hash
     */
    function hash(uint256[] memory array) internal pure returns (bytes32) {
        return keccak256(abi.encode(array));
    }

    /**
     * @dev Sum the array elements
     * @param array of uint256
     * @return sum
     */
    function sum(uint256[] memory array) internal pure returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < array.length; i++) {
            total += array[i];
        }

        return total;
    }

    /**
     * @dev Concatenate byte arrays
     * @param arrayOfArrays of uint256
     * @return concatenated
     *
     * This function is especially useful when looking to concatenate a
     * dynamic array of strings.
     */
    function concat(bytes[] memory arrayOfArrays) internal pure returns (bytes memory) {
        uint256 arrayCount = arrayOfArrays.length;
        uint256 totalLength = 0;
        for (uint256 i = 0; i < arrayCount; i++) {
            totalLength += arrayOfArrays[i].length;
        }

        bytes memory newArray = new bytes(totalLength);
        uint256 k = 0;
        for (uint256 i = 0; i < arrayCount; i++) {
            for (uint256 j = 0; j < arrayOfArrays[i].length; j++) {
                newArray[k] = arrayOfArrays[i][j];
                k++;
            }
        }

        return newArray;
    }
}
