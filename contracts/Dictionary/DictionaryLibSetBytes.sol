// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '../Set/SetLibUInt256.sol';
import '../Set/SetLibBytes.sol';

/**
 * @dev Library for managing Dictionary<uint256,Set<bytes>>
 * @author Leo Vigna
 */
library DictionaryLibSetBytes {
    using SetLibUInt256 for SetLibUInt256.SetUInt256;
    using SetLibBytes for SetLibBytes.SetBytes;

    struct DictionarySetBytes {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the setDictionary.
        mapping(uint256 => SetLibBytes.SetBytes) data;
        SetLibUInt256.SetUInt256 keys;
    }

    /**
     * @dev Add a value to a setDictionary. O(1).
     * Returns false if the value was already in the setDictionary.
     */
    function addKey(DictionarySetBytes storage setDictionary, uint256 key) internal returns (bool) {
        return setDictionary.keys.add(key);
    }

    function containsKey(DictionarySetBytes storage setDictionary, uint256 key) internal view returns (bool) {
        return setDictionary.keys.contains(key);
    }

    /**
     * @dev Returns the number of elements on the setDictionary. O(1).
     */
    function length(DictionarySetBytes storage setDictionary) internal view returns (uint256) {
        return setDictionary.keys.length();
    }

    /**
     * @dev Returns an array with all values in the setDictionary. O(N).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.

     * WARNING: This function may run out of gas on large setDictionarys: use {length} and
     * {get} instead in these cases.
     */
    function enumerateKeys(DictionarySetBytes storage setDictionary) internal view returns (uint256[] memory) {
        return setDictionary.keys.enumerate();
    }

    function getKeyAtIndex(DictionarySetBytes storage setDictionary, uint256 index) internal view returns (uint256) {
        return setDictionary.keys.get(index);
    }

    /**
     * @dev Add a value to a setDictionary. O(1).
     * Returns false if the value was already in the setDictionary.
     */
    function addValueForKey(
        DictionarySetBytes storage setDictionary,
        uint256 key,
        bytes memory value
    ) internal returns (bool) {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].add(value);
        } else {
            return false;
        }
    }

    function removeKey(DictionarySetBytes storage setDictionary, uint256 key) internal returns (bool) {
        if (containsKey(setDictionary, key)) {
            //delete setDictionary.data[key];
            return setDictionary.keys.remove(key);
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a setDictionary. O(1).
     * Returns false if the value was not present in the setDictionary.
     */
    function removeValueForKey(
        DictionarySetBytes storage setDictionary,
        uint256 key,
        bytes memory value
    ) internal returns (bool) {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].remove(value);
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the setDictionary. O(1).
     */
    function containsValueForKey(
        DictionarySetBytes storage setDictionary,
        uint256 key,
        bytes memory value
    ) internal view returns (bool) {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].contains(value);
        } else {
            return false;
        }
    }

    function getValueForKey(DictionarySetBytes storage setDictionary, uint256 key)
        internal
        view
        returns (SetLibBytes.SetBytes storage)
    {
        require(containsKey(setDictionary, key), 'Key does not exist!');

        return setDictionary.data[key];
    }

    function enumerateForKey(DictionarySetBytes storage setDictionary, uint256 key)
        internal
        view
        returns (bytes[] memory)
    {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].enumerate();
        } else {
            return new bytes[](0);
        }
    }

    /**
     * @dev Returns the number of elements on the setDictionary. O(1).
     */
    function lengthForKey(DictionarySetBytes storage setDictionary, uint256 key) internal view returns (uint256) {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].length();
        } else {
            return 0;
        }
    }

    /** @dev Returns the element stored at position `index` in the setDictionary. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function getValueAtIndexForKey(
        DictionarySetBytes storage setDictionary,
        uint256 key,
        uint256 index
    ) internal view returns (bytes memory) {
        if (containsKey(setDictionary, key)) {
            return setDictionary.data[key].get(index);
        }

        return new bytes(0);
    }
}
