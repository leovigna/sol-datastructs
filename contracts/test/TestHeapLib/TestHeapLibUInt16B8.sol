//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../../Heap/HeapLibUInt16.sol';
import '../../Heap/IHeapUInt16.sol';

//Test Heap Lib with optimized parameters
contract TestHeapLibUInt16B8 is IHeapUInt16 {
    using HeapLibUInt16 for *;

    bytes32 constant heap = bytes32(uint256(0));
    uint256 constant a = 16;
    uint256 constant b = 8;
    uint256 heapLength;

    event RemoveValue(uint16 val); //used by truffle to fetched remove() value

    function compare(uint16 x, uint16 y) public pure override returns (bool) {
        return x < y;
    }

    function height() external view override returns (uint256) {
        return heap.height(a, b);
    }

    function maxLength() external view override returns (uint256) {
        return heap.maxLength(a, b);
    }

    function length() external view override returns (uint256) {
        return heap.len();
    }

    function get(uint256 i) external view override returns (uint16) {
        return heap.get(i);
    }

    function root() external view override returns (uint16) {
        return heap.root();
    }

    function parent(uint256 i) external view override returns (uint16) {
        return heap.parent(a, b, i);
    }

    function parentIdx(uint256 i) external pure override returns (uint256) {
        return HeapLibUInt16.parentIdx(a, b, i);
    }

    function leavesIdx(uint256 i) external pure override returns (uint256[] memory) {
        return HeapLibUInt16.leavesIdx(a, b, i);
    }

    function leaves(uint256 i) external view override returns (uint16[] memory) {
        return heap.leaves(a, b, i);
    }

    function set(uint256 i, uint16 val) external override {
        heap.set(a, b, this.compare.selector, i, val);
    }

    function push(uint16 val) external override {
        heap.push(a, b, this.compare.selector, val);
    }

    function remove(uint256 i) external override returns (uint16) {
        uint16 val = heap.remove(a, b, this.compare.selector, i);
        emit RemoveValue(val);
        return val;
    }

    function removeRoot() external override returns (uint16) {
        uint16 val = heap.removeRoot(a, b, this.compare.selector);
        emit RemoveValue(val);
        return val;
    }

    function search(uint16 val, uint256 hintIdx) external view override returns (uint256) {
        return heap.search(a, b, this.compare.selector, val, hintIdx);
    }

    function searchRoot(uint16 val) external view override returns (uint256) {
        return heap.searchRoot(a, b, this.compare.selector, val);
    }

    function searchUp(uint16 val, uint256 startIdx) external view override returns (uint256) {
        return heap.searchUp(a, b, this.compare.selector, val, startIdx);
    }

    function searchDown(uint16 val, uint256[] memory startIdx) external view override returns (uint256) {
        return heap.searchDown(a, b, this.compare.selector, val, startIdx);
    }

    //Batching tx to speedup testing
    function pushBatch(uint16[] memory val) external override {
        for (uint256 i = 0; i < val.length; i++) {
            heap.push(a, b, this.compare.selector, val[i]);
        }
    }

    function removeRootBatch(uint256 n) external override returns (uint16[] memory) {
        uint16[] memory r = new uint16[](n);
        for (uint256 i = 0; i < n; i++) {
            r[i] = heap.removeRoot(a, b, this.compare.selector);
        }

        return r;
    }
}
