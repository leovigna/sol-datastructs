//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../../Heap/HeapLibUInt32.sol';
import '../../Heap/IHeapUInt32.sol';

//Test Heap Lib with optimized parameters
contract TestHeapLibUInt32B8 is IHeapUInt32 {
    using HeapLibUInt32 for *;

    bytes32 constant heap = bytes32(uint256(0));
    uint256 constant a = 8; //256 / 32 = 8
    uint256 constant b = 8;
    uint256 heapLength;

    event RemoveValue(uint32 val); //used by truffle to fetched remove() value

    function compare(uint32 x, uint32 y) public pure override returns (bool) {
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

    function get(uint256 i) external view override returns (uint32) {
        return heap.get(i);
    }

    function root() external view override returns (uint32) {
        return heap.root();
    }

    function parent(uint256 i) external view override returns (uint32) {
        return heap.parent(a, b, i);
    }

    function parentIdx(uint256 i) external pure override returns (uint256) {
        return HeapLibUInt32.parentIdx(a, b, i);
    }

    function leavesIdx(uint256 i) external pure override returns (uint256[] memory) {
        return HeapLibUInt32.leavesIdx(a, b, i);
    }

    function leaves(uint256 i) external view override returns (uint32[] memory) {
        return heap.leaves(a, b, i);
    }

    function set(uint256 i, uint32 val) external override {
        heap.set(a, b, this.compare.selector, i, val);
    }

    function push(uint32 val) external override {
        heap.push(a, b, this.compare.selector, val);
    }

    function remove(uint256 i) external override returns (uint32) {
        uint32 val = heap.remove(a, b, this.compare.selector, i);
        emit RemoveValue(val);
        return val;
    }

    function removeRoot() external override returns (uint32) {
        uint32 val = heap.removeRoot(a, b, this.compare.selector);
        emit RemoveValue(val);
        return val;
    }

    function search(uint32 val, uint256 hintIdx) external view override returns (uint256) {
        return heap.search(a, b, this.compare.selector, val, hintIdx);
    }

    function searchRoot(uint32 val) external view override returns (uint256) {
        return heap.searchRoot(a, b, this.compare.selector, val);
    }

    function searchUp(uint32 val, uint256 startIdx) external view override returns (uint256) {
        return heap.searchUp(a, b, this.compare.selector, val, startIdx);
    }

    function searchDown(uint32 val, uint256[] memory startIdx) external view override returns (uint256) {
        return heap.searchDown(a, b, this.compare.selector, val, startIdx);
    }

    //Batching tx to speedup testing
    function pushBatch(uint32[] memory val) external override {
        for (uint256 i = 0; i < val.length; i++) {
            heap.push(a, b, this.compare.selector, val[i]);
        }
    }

    function removeRootBatch(uint256 n) external override returns (uint32[] memory) {
        uint32[] memory r = new uint32[](n);
        for (uint256 i = 0; i < n; i++) {
            r[i] = heap.removeRoot(a, b, this.compare.selector);
        }

        return r;
    }
}
