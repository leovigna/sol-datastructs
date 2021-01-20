//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../../Array/IListUInt32.sol';
import '../../Array/ArrayLibUInt32.sol';

contract TestArrayLibUInt32 is IListUInt32 {
    using ArrayLibUInt32 for bytes32;
    bytes32 constant array = bytes32(uint256(0));
    uint256 arrayLength;

    function length() external view override returns (uint256) {
        return array.len();
    }

    function get(uint256 i) external view override returns (uint32) {
        return array.get(i);
    }

    function set(uint256 i, uint32 val) external override {
        array.set(i, val);
    }

    function push(uint32 val) external override {
        array.push(val);
    }

    function swap(uint256 i, uint256 j) external override {
        array.swap(i, j);
    }

    function pop() external override {
        array.pop();
    }

    /***** Batched Ops ******/
    function getBatch(uint256[] memory iArray) external view override returns (uint256[] memory) {
        return array.getBatch(iArray);
    }

    function setBatch(uint256[] memory iArray, uint256[] memory valArray) external override {
        array.setBatch(iArray, valArray);
    }

    function pushBatch(uint256[] memory valArray) external override {
        array.pushBatch(valArray);
    }

    function popBatch(uint256 n) external override {
        array.popBatch(n);
    }
}
