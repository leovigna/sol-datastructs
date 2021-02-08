//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/**
 * @dev An unstructured storage library
 *
 * This library can be used to replace the native Solidity storage layout by
 * introducing helper functions to get/set storage variables. This can also
 * be done with inline assembly more efficiently. This library introduces better
 * readability at the cost of some overhead.
 *
 */
library KeyStoreLib {
    /**
     * @dev Get uint256
     * @param slot storage slot
     * @return v
     *
     */
    function getUInt256(bytes32 slot) internal view returns (uint256 v) {
        assembly {
            v := sload(slot)
        }
    }

    /**
     * @dev Set uint256
     * @param slot storage slot
     * @param v value
     *
     */
    function setUInt256(bytes32 slot, uint256 v) internal {
        assembly {
            sstore(slot, v)
        }
    }

    /**
     * @dev Get bool
     * @param slot storage slot
     * @return v
     *
     */
    function getBool(bytes32 slot) internal view returns (bool v) {
        assembly {
            v := sload(slot)
        }
    }

    /**
     * @dev Set bool
     * @param slot storage slot
     * @param v value
     *
     */
    function setBool(bytes32 slot, bool v) internal {
        assembly {
            sstore(slot, v)
        }
    }

    /**
     * @dev Get address
     * @param slot storage slot
     * @return v
     *
     */
    function getAddress(bytes32 slot) internal view returns (address v) {
        assembly {
            v := sload(slot)
        }
    }

    /**
     * @dev Set address
     * @param slot storage slot
     * @param v value
     *
     */
    function setAddress(bytes32 slot, address v) internal {
        assembly {
            sstore(slot, v)
        }
    }

    /**
     * @dev Get string storage
     * @param slot storage slot
     * @return v
     */
    function getString(bytes32 slot) internal pure returns (string storage v) {
        assembly {
            v_slot := slot
        }
    }

    /**
     * @dev Get bytes storage
     * @param slot storage slot
     * @return v
     *
     */
    function getBytes(bytes32 slot) internal pure returns (bytes storage v) {
        assembly {
            v_slot := slot
        }
    }

    /**
     * @dev Get uint256[] storage
     * @param slot storage slot
     * @return v
     *
     */
    function getUInt256Array(bytes32 slot) internal pure returns (uint256[] storage v) {
        assembly {
            v_slot := slot
        }
    }

    /**
     * @dev Get mapping(uint256 => uint256) storage
     * @param slot storage slot
     * @return v
     *
     */
    function getUInt256Mapping(bytes32 slot) internal pure returns (mapping(uint256 => uint256) storage v) {
        assembly {
            v_slot := slot
        }
    }

    /**
     * @dev Get address[] storage
     * @param slot storage slot
     * @return v
     *
     */
    function getAddressArray(bytes32 slot) internal pure returns (address[] storage v) {
        assembly {
            v_slot := slot
        }
    }

    /**
     * @dev Get mapping(address => uint256) storage
     * @param slot storage slot
     * @return v
     *
     */
    function getAddressMapping(bytes32 slot) internal pure returns (mapping(address => uint256) storage v) {
        assembly {
            v_slot := slot
        }
    }
}
