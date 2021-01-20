//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/**
 * @dev A gas optimized uintX[] implementation. The bitLength param determines the size
 * of the stored value. This can be a min of 1 and a maximum of 256.
 *
 * The array saves gas by avoiding bounds checks and tightly packing uintX elements.
 * The recommended use for this library is to derive from it a ArrayLibUintX library specific
 * to a hard-coded bitLength and then use that library within contracts.
 *
 * The storage layout conforms to the Solidity standard as described at
 * https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html
 *
 * Error Codes (to save on gas costs):
 * - 1: Out of bounds
 * - 2: Invalid arguments
 *
 */
library ArrayLibUInt {
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

    /***** Raw Storage Ops ******/
    /**
     * @dev Get full storage slot at slotIndex
     * @param slot storage slot
     * @param slotIdx slot index
     * @return val
     *
     */
    function _getSlotData(bytes32 slot, uint256 slotIdx) internal view returns (uint256 val) {
        assembly {
            mstore(0x0, slot)
            let p := keccak256(0x0, 0x20) //array[0] storage
            let idx := add(p, slotIdx) //array[idx] storage
            val := sload(idx) //load cur value
        }
    }

    /**
     * @dev Set full storage slot at slotIndex
     * @param slot storage slot
     * @param slotIdx slot index
     * @param val value
     *
     */
    function _setSlotData(
        bytes32 slot,
        uint256 slotIdx,
        uint256 val
    ) internal {
        assembly {
            mstore(0x0, slot)
            let p := keccak256(0x0, 0x20) //array[0] storage
            let idx := add(p, slotIdx) //array[idx] storage
            sstore(idx, val) //load cur value
        }
    }

    /**
     * @dev Parse slot data at index to correct bit length
     * @param bitLength uint bit length
     * @param slotData raw slot data
     * @param subIdx indexed position of value in slot
     * @return val
     *
     */
    function _getSlotDataValueAt(
        uint8 bitLength,
        uint256 slotData,
        uint256 subIdx
    ) internal pure returns (uint256 val) {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF

        uint256 bitShift = (slotPerStorage - 1 - subIdx) * bitLength;
        val = slotData >> bitShift;
        val = val & bitMask;
    }

    /**
     * @dev Encode value into the raw slot data
     * @param bitLength uint bit length
     * @param slotData raw slot data
     * @param subIdx indexed position of value in slot
     * @param val value
     * @return newSlotData
     *
     */
    function _setSlotDataValueAt(
        uint8 bitLength,
        uint256 slotData,
        uint256 subIdx,
        uint256 val
    ) internal pure returns (uint256 newSlotData) {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF

        uint256 bitShift = (slotPerStorage - 1 - subIdx) * bitLength;

        val = val & bitMask;
        val = val << bitShift;

        uint256 slotBitmask = ~(bitMask << bitShift);
        newSlotData = (slotData & slotBitmask) | val;
    }

    /***** Array-Indexed Ops ******/
    /**
     * @dev Get item at array[i]
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @return val
     *
     * The array storage layout is divided in slots starting at keccak(slot).
     * Storage slots can store up to 256/bitLength items since one slot is 256 bits.
     * The get() cleans up the higher-order bits for you ensuring safety when converting.
     * See https://solidity.readthedocs.io/en/v0.7.0/internals/variable_cleanup.html
     */
    function get(
        uint8 bitLength,
        bytes32 slot,
        uint256 i
    ) internal view returns (uint256 val) {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF

        assembly {
            mstore(0x0, slot)
            let p := keccak256(0x0, 0x20) //array[0] storage
            let idx := add(p, div(i, slotPerStorage)) //array[idx] storage
            let start := mul(sub(sub(slotPerStorage, 1), mod(i, slotPerStorage)), bitLength) //start pos

            let storedVal := sload(idx) //load cur value
            val := shr(start, storedVal) //Clean bits here
        }

        val = val & bitMask;
    }

    /**
     * @dev get() with bounds check
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @return val
     */
    function getSAFE(
        uint8 bitLength,
        bytes32 slot,
        uint256 i
    ) internal view returns (uint256 val) {
        uint256 length;
        assembly {
            length := sload(slot)
        }
        require(i < length, '1');
        return get(bitLength, slot, i);
    }

    /**
     * @dev Set array[i] = val
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @param val value
     */
    function set(
        uint8 bitLength,
        bytes32 slot,
        uint256 i,
        uint256 val
    ) internal {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF
        val = val & bitMask;

        assembly {
            mstore(0x0, slot)
            let p := keccak256(0x0, 0x20) //array[0] storage
            let idx := add(p, div(i, slotPerStorage)) //array[idx] storage
            let start := mul(sub(sub(slotPerStorage, 1), mod(i, slotPerStorage)), bitLength) //start pos

            let storedVal := sload(idx) //load cur value
            let newVal := shl(start, val) //shift left logical to start pos
            let bitmask := not(shl(start, bitMask))
            let newStoredVal := or(and(storedVal, bitmask), newVal) //clears old value and inserts new

            sstore(idx, newStoredVal)
        }
    }

    /**
     * @dev set() with bounds check
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @param val value
     */
    function setSAFE(
        uint8 bitLength,
        bytes32 slot,
        uint256 i,
        uint256 val
    ) internal {
        uint256 length;
        assembly {
            length := sload(slot)
        }
        require(i < length, '1');
        set(bitLength, slot, i, val);
    }

    /**
     * @dev Append val to the end of the array, increasing its length.
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param val value
     */
    function push(
        uint8 bitLength,
        bytes32 slot,
        uint256 val
    ) internal {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF
        val = val & bitMask;

        assembly {
            mstore(0x0, slot)
            let p := keccak256(0x0, 0x20) //array[0] storage
            let length := sload(slot) //array length
            let idx := add(p, div(length, slotPerStorage)) //array[idx] storage
            let start := mul(sub(sub(slotPerStorage, 1), mod(length, slotPerStorage)), bitLength) //start pos

            let storedVal := sload(idx) //load cur value
            let newVal := shl(start, val) //shift left logical to start pos
            let bitmask := not(shl(start, bitMask))
            let newStoredVal := or(and(storedVal, bitmask), newVal) //clears old value and inserts new

            sstore(idx, newStoredVal)
            sstore(slot, add(length, 1)) //increase length
        }
    }

    /**
     * @dev Pop end val of the array, decreasing its length.
     * @param bitLength uint bit length
     * @param slot storage slot
     */
    function pop(uint8 bitLength, bytes32 slot) internal {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 bitMask = ~(uint256(-1) << bitLength); // 000...FFFF

        uint256 length;
        assembly {
            length := sload(slot)
        }

        uint256 remainder = length % slotPerStorage;
        if (remainder == 1) {
            //pop slot to get gas refund
            uint256 quotient = length / slotPerStorage;
            assembly {
                mstore(0x0, slot)
                let p := keccak256(0x0, 0x20) //array[0] storage
                let idx := add(p, quotient)
                sstore(idx, 0) //clear storage
            }
        }

        assembly {
            sstore(slot, sub(length, 1)) //decrease length
        }
    }

    /**
     * @dev Swap two values at i, j.
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @param j subindex
     *
     * There is potential for optimizing how same slot items are swapped.
     */
    function swap(
        uint8 bitLength,
        bytes32 slot,
        uint256 i,
        uint256 j
    ) internal {
        uint256 slotPerStorage = 256 / bitLength;
        uint256 slotI = i / slotPerStorage;
        uint256 slotJ = j / slotPerStorage;
        if (slotI == slotJ) {
            uint256 subIdxI = i % slotPerStorage;
            uint256 subIdxJ = j % slotPerStorage;
            //Same storage slot, swap using bit operations
            uint256 slotData = _getSlotData(slot, slotI); //SLOAD
            uint256 a = _getSlotDataValueAt(bitLength, slotData, subIdxI);
            uint256 b = _getSlotDataValueAt(bitLength, slotData, subIdxJ);

            slotData = _setSlotDataValueAt(bitLength, slotData, subIdxI, b);
            slotData = _setSlotDataValueAt(bitLength, slotData, subIdxJ, a);

            _setSlotData(slot, slotI, slotData); //SSTORE
        } else {
            //Naive implementation
            uint256 a = get(bitLength, slot, i);
            uint256 b = get(bitLength, slot, j);
            set(bitLength, slot, i, b);
            set(bitLength, slot, j, a);
        }
    }

    /**
     * @dev swap() with bounds check
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param i index
     * @param j subindex
     */
    function swapSAFE(
        uint8 bitLength,
        bytes32 slot,
        uint256 i,
        uint256 j
    ) internal {
        uint256 length;
        assembly {
            length := sload(slot)
        }
        require(i < length, '1');
        require(j < length, '1');
        swap(bitLength, slot, i, j);
    }

    /***** Batched Ops ******/
    /**
     * @dev Get a batch of items. Optimized to minimize SLOADs.
     * @param bitLength uint bit lengthh
     * @param slot storage slot
     * @param iArray index array. Assumes sorted for purpose of SLOAD optimization though still works if unsorted.
     * @return valList
     *
     */
    function getBatch(
        uint8 bitLength,
        bytes32 slot,
        uint256[] memory iArray
    ) internal view returns (uint256[] memory valList) {
        valList = new uint256[](iArray.length);
        uint256 slotPerStorage = 256 / bitLength;

        uint256 slotPrev = iArray[0] / slotPerStorage;
        uint256 slotDataPrev = _getSlotData(slot, slotPrev); //SLOAD

        uint256 subIdxInit = iArray[0] % slotPerStorage;
        valList[0] = _getSlotDataValueAt(bitLength, slotDataPrev, subIdxInit);

        for (uint256 i = 1; i < iArray.length; i++) {
            uint256 slotCurr = iArray[i] / slotPerStorage;
            uint256 subIdx = iArray[i] % slotPerStorage;
            if (slotCurr == slotPrev) {
                //Use cached slot data
                valList[i] = _getSlotDataValueAt(bitLength, slotDataPrev, subIdx);
            } else {
                //New storage slot data
                slotPrev = slotCurr;
                slotDataPrev = _getSlotData(slot, slotPrev); //SLOAD
                valList[i] = _getSlotDataValueAt(bitLength, slotDataPrev, subIdx);
            }
        }
    }

    /**
     * @dev Set a batch of values in the array.
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param iArray index array. Assumes sorted for purpose of SLOAD optimization though still works if unsorted.
     * @param valArray value array
     *
     */
    function setBatch(
        uint8 bitLength,
        bytes32 slot,
        uint256[] memory iArray,
        uint256[] memory valArray
    ) internal {
        require(iArray.length == valArray.length, '2');
        uint256 slotPerStorage = 256 / bitLength;

        uint256 slotPrev = iArray[0] / slotPerStorage;
        uint256 slotDataPrev = _getSlotData(slot, slotPrev); //SLOAD

        uint256 subIdxInit = iArray[0] % slotPerStorage;
        slotDataPrev = _setSlotDataValueAt(bitLength, slotDataPrev, subIdxInit, valArray[0]);

        for (uint256 i = 1; i < iArray.length; i++) {
            uint256 slotCurr = iArray[i] / slotPerStorage;
            uint256 subIdx = iArray[i] % slotPerStorage;
            if (slotCurr == slotPrev) {
                //Set cached slot data
                slotDataPrev = _setSlotDataValueAt(bitLength, slotDataPrev, subIdx, valArray[i]);
            } else {
                //Write new data
                _setSlotData(slot, slotPrev, slotDataPrev); //STORE
                //New storage slot data
                slotPrev = slotCurr;
                slotDataPrev = _getSlotData(slot, slotPrev); //SLOAD
                slotDataPrev = _setSlotDataValueAt(bitLength, slotDataPrev, subIdx, valArray[i]);
            }
        }

        //Write new data
        _setSlotData(slot, slotPrev, slotDataPrev); //STORE
    }

    /**
     * @dev Append a batch of values to the end of the array, increasing its length.
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param valArray value array
     *
     */
    function pushBatch(
        uint8 bitLength,
        bytes32 slot,
        uint256[] memory valArray
    ) internal {
        //Increment length
        uint256 valArrayLength = valArray.length;
        uint256 length;
        assembly {
            length := sload(slot) //array length
            sstore(slot, add(length, valArrayLength)) //increase length
        }

        //Fill last slot
        uint256 slotPerStorage = 256 / bitLength;

        uint256 slotPrev = length / slotPerStorage; //last slot
        uint256 slotDataPrev;

        uint256 subIdxInit = length % slotPerStorage;
        if (subIdxInit != 0) {
            slotDataPrev = _getSlotData(slot, slotPrev); //SLOAD
            slotDataPrev = _setSlotDataValueAt(bitLength, slotDataPrev, subIdxInit, valArray[0]);
        } else {
            //New slot
            slotDataPrev = _setSlotDataValueAt(bitLength, 0, subIdxInit, valArray[0]);
        }

        for (uint256 i = 1; i < valArray.length; i++) {
            uint256 subIdx = (length + i) % slotPerStorage;
            if (subIdx != 0) {
                //Existing storage slot
                //Set cached slot data
                slotDataPrev = _setSlotDataValueAt(bitLength, slotDataPrev, subIdx, valArray[i]);
            } else {
                //New storage slot
                //Write new data
                _setSlotData(slot, slotPrev, slotDataPrev); //STORE
                //New storage slot data
                slotPrev += 1;
                slotDataPrev = _setSlotDataValueAt(bitLength, 0, subIdx, valArray[i]);
            }
        }

        //Write new data
        _setSlotData(slot, slotPrev, slotDataPrev); //STORE
    }

    /**
     * @dev Pop a batch of values from the array, decreasing its length.
     * @param bitLength uint bit length
     * @param slot storage slot
     * @param n number of times to pop
     *
     */
    function popBatch(
        uint8 bitLength,
        bytes32 slot,
        uint256 n
    ) internal {
        //Decrement length
        uint256 length;
        assembly {
            length := sload(slot) //SLOAD
            sstore(slot, sub(length, n)) //decrease length
        }
        require(n <= length, '1');

        //Pop last slot
        uint256 slotPerStorage = 256 / bitLength;

        uint256 storageLast = length / slotPerStorage; //last storage slot
        uint256 subIdxInit = length % slotPerStorage;

        uint256 storageClear = n / slotPerStorage;
        uint256 storageClearRemainder = n % slotPerStorage;

        if (storageClearRemainder == subIdxInit) {
            storageClear += 1;
        }

        for (uint256 i = 0; i < storageClear; i++) {
            //Pop storage slot
            _setSlotData(slot, storageLast - i, 0); //STORE
        }
    }
}
