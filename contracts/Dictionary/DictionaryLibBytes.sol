// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '../Set/SetLibUInt256.sol';

/**
 * @dev Library for managing Dictionary<uint256,bytes>
 * @author Leo Vigna
 */
library DictionaryLibBytes {
    using SetLibUInt256 for SetLibUInt256.SetUInt256;

    struct DictionaryBytes {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the dictionary.
        mapping(uint256 => bytes) data;
        SetLibUInt256.SetUInt256 keys;
    }

    function containsKey(DictionaryBytes storage dictionary, uint256 key) internal view returns (bool) {
        return dictionary.keys.contains(key);
    }

    /**
     * @dev Returns the number of elements on the dictionary. O(1).
     */
    function length(DictionaryBytes storage dictionary) internal view returns (uint256) {
        return dictionary.keys.length();
    }

    /**
     * @dev Returns an array with all values in the dictionary. O(N).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.

     * WARNING: This function may run out of gas on large DictionaryBytess: use {length} and
     * {get} instead in these cases.
     */
    function enumerateKeys(DictionaryBytes storage dictionary) internal view returns (uint256[] memory) {
        return dictionary.keys.enumerate();
    }

    function getKeyAtIndex(DictionaryBytes storage dictionary, uint256 index) internal view returns (uint256) {
        return dictionary.keys.get(index);
    }

    /**
     * @dev Add a value to a dictionary. O(1).
     * Returns false if the value was already in the dictionary.
     */
    function setValueForKey(
        DictionaryBytes storage dictionary,
        uint256 key,
        bytes memory value
    ) internal returns (bool) {
        dictionary.data[key] = value;
        return dictionary.keys.add(key);
    }

    /**
     * @dev Removes a value from a dictionary. O(1).
     * Returns false if the value was not present in the dictionary.
     */
    function removeKey(DictionaryBytes storage dictionary, uint256 key) internal returns (bool) {
        if (containsKey(dictionary, key)) {
            delete dictionary.data[key];
            return dictionary.keys.remove(key);
        } else {
            return false;
        }
    }

    function getValueForKey(DictionaryBytes storage dictionary, uint256 key) internal view returns (bytes memory) {
        require(containsKey(dictionary, key), 'Key does not exist!');

        return dictionary.data[key];
    }
}
