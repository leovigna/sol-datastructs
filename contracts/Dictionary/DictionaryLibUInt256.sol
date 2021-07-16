// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '../Set/SetLibUInt256.sol';

/**
 * @dev Library for managing Dictionary<uint256,uint256>
 *
 * DictionaryUInt256 has the following properties:
 *
 * - Key/Value pairs are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Keys are enumerated in O(n). No guarantees are made on the ordering.
 * - Values are enumerated in O(n). No guarantees are made on the ordering.
 *
 * @author Leo Vigna
 */
library DictionaryLibUInt256 {
    using SetLibUInt256 for SetLibUInt256.SetUInt256;

    struct DictionaryUInt256 {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the dictionary.
        mapping(uint256 => uint256) data;
        SetLibUInt256.SetUInt256 keys;
    }

    function containsKey(DictionaryUInt256 storage dictionary, uint256 key) internal view returns (bool) {
        return dictionary.keys.contains(key);
    }

    /**
     * @dev Returns the number of elements on the dictionary. O(1).
     */
    function length(DictionaryUInt256 storage dictionary) internal view returns (uint256) {
        return dictionary.keys.length();
    }

    /**
     * @dev Returns an array with all values in the dictionary. O(N).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.

     * WARNING: This function may run out of gas on large DictionaryUInt256s: use {length} and
     * {get} instead in these cases.
     */
    function enumerateKeys(DictionaryUInt256 storage dictionary) internal view returns (uint256[] memory) {
        return dictionary.keys.enumerate();
    }

    function getKeyAtIndex(DictionaryUInt256 storage dictionary, uint256 index) internal view returns (uint256) {
        return dictionary.keys.get(index);
    }

    /**
     * @dev Add a value to a dictionary. O(1).
     * Returns false if the value was already in the dictionary.
     */
    function setValueForKey(
        DictionaryUInt256 storage dictionary,
        uint256 key,
        uint256 value
    ) internal returns (bool) {
        dictionary.data[key] = value;
        return dictionary.keys.add(key);
    }

    /**
     * @dev Removes a value from a dictionary. O(1).
     * Returns false if the value was not present in the dictionary.
     */
    function removeKey(DictionaryUInt256 storage dictionary, uint256 key) internal returns (bool) {
        if (containsKey(dictionary, key)) {
            delete dictionary.data[key];
            return dictionary.keys.remove(key);
        } else {
            return false;
        }
    }

    function getValueForKey(DictionaryUInt256 storage dictionary, uint256 key) internal view returns (uint256) {
        require(containsKey(dictionary, key), 'Key does not exist!');

        return dictionary.data[key];
    }
}
