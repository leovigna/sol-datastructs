//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import './KeyStoreLib.sol';

/**
 * @dev An example external facing contract using KeyStoreLib
 *
 * WARNING: Contracts should use KeyStoreLib directly (recommended) or override KeyStore setter methods.
 *
 */
contract KeyStore {
    using KeyStoreLib for bytes32;

    /**
     * @dev Get uint256
     * @param slot storage slot
     * @return v
     *
     */
    function getUInt256(bytes32 slot) public view returns (uint256 v) {
        return slot.getUInt256();
    }

    /**
     * @dev Set uint256
     * @param slot storage slot
     * @param v value
     *
     */
    function setUInt256(bytes32 slot, uint256 v) public {
        slot.setUInt256(v);
    }

    /**
     * @dev Get address
     * @param slot storage slot
     * @return v
     *
     */
    function getAddress(bytes32 slot) public view returns (address v) {
        return slot.getAddress();
    }

    /**
     * @dev Set address
     * @param slot storage slot
     * @param v value
     *
     */
    function setAddress(bytes32 slot, address v) public {
        slot.setAddress(v);
    }

    /**
     * @dev Get uint256[] storage
     * @param slot storage slot
     * @param k index
     * @return v
     *
     */
    function getUInt256Array(bytes32 slot, uint256 k) public view returns (uint256) {
        uint256[] storage m = slot.getUInt256Array();
        return m[k];
    }

    /**
     * @dev Push uint256[] storage
     * @param slot storage slot
     * @param v value
     *
     */
    function pushUInt256Array(bytes32 slot, uint256 v) public {
        uint256[] storage m = slot.getUInt256Array();
        m.push(v);
    }

    /**
     * @dev Get mapping(uint256 => uint256) storage
     * @param slot storage slot
     * @param k key
     * @return v
     *
     */
    function getUInt256Mapping(bytes32 slot, uint256 k) public view returns (uint256) {
        mapping(uint256 => uint256) storage m = slot.getUInt256Mapping();
        return m[k];
    }

    /**
     * @dev Set mapping(uint256 => uint256) storage
     * @param slot storage slot
     * @param k key
     * @param v value
     *
     */
    function setUInt256Mapping(
        bytes32 slot,
        uint256 k,
        uint256 v
    ) public {
        mapping(uint256 => uint256) storage m = slot.getUInt256Mapping();
        m[k] = v;
    }
}
