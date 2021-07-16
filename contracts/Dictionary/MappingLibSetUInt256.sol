// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '../Set/SetLibUInt256.sol';

/**
 * @dev Library for managing Mapping<uint256,Set<uint256>>
 * @author Leo Vigna
 */
library MappingLibSetUInt256 {
    using SetLibUInt256 for SetLibUInt256.SetUInt256;

    struct MappingSetUInt256 {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the setMapping.
        mapping(uint256 => SetLibUInt256.SetUInt256) data;
    }

    /**
     * @dev Add a value to a setMapping. O(1).
     * Returns false if the value was already in the setMapping.
     */
    function addValueForKey(
        MappingSetUInt256 storage setMapping,
        uint256 key,
        uint256 value
    ) internal returns (bool) {
        return setMapping.data[key].add(value);
    }

    /**
     * @dev Removes a value from a setMapping. O(1).
     * Returns false if the value was not present in the setMapping.
     */
    function removeValueForKey(
        MappingSetUInt256 storage setMapping,
        uint256 key,
        uint256 value
    ) internal returns (bool) {
        return setMapping.data[key].remove(value);
    }

    /**
     * @dev Returns true if the value is in the setMapping. O(1).
     */
    function containsValueForKey(
        MappingSetUInt256 storage setMapping,
        uint256 key,
        uint256 value
    ) internal view returns (bool) {
        return setMapping.data[key].contains(value);
    }

    function getValueForKey(MappingSetUInt256 storage setMapping, uint256 key)
        internal
        view
        returns (SetLibUInt256.SetUInt256 storage)
    {
        return setMapping.data[key];
    }

    /**
     * @dev Returns an array with all values in the setMapping. O(N).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.

     * WARNING: This function may run out of gas on large setMappings: use {length} and
     * {get} instead in these cases.
     */
    function enumerateForKey(MappingSetUInt256 storage setMapping, uint256 key)
        internal
        view
        returns (uint256[] memory)
    {
        return setMapping.data[key].enumerate();
    }

    /**
     * @dev Returns the number of elements on the setMapping. O(1).
     */
    function lengthForKey(MappingSetUInt256 storage setMapping, uint256 key) internal view returns (uint256) {
        return setMapping.data[key].length();
    }

    /** @dev Returns the element stored at position `index` in the setMapping. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function getValueAtIndexForKey(
        MappingSetUInt256 storage setMapping,
        uint256 key,
        uint256 index
    ) internal view returns (uint256) {
        return setMapping.data[key].get(index);
    }
}
