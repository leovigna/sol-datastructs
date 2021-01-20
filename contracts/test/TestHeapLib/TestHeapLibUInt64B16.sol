//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../../Heap/HeapLibUInt64.sol';
import '../../Heap/IHeapUInt64.sol';

//Test Heap Lib with optimized parameters
contract TestHeapLibUInt64B16 is IHeapUInt64 {
    using HeapLibUInt64 for *;

    bytes32 constant heap = bytes32(uint256(0));
    uint256 constant a = 4; //256 / 64 = 4
    uint256 constant b = 16;
    uint256 heapLength;

    event RemoveValue(uint64 val); //used by truffle to fetched remove() value

    function compare(uint64 x, uint64 y) public pure override returns (bool) {
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

    function get(uint256 i) external view override returns (uint64) {
        return heap.get(i);
    }

    function root() external view override returns (uint64) {
        return heap.root();
    }

    function parent(uint256 i) external view override returns (uint64) {
        return heap.parent(a, b, i);
    }

    function parentIdx(uint256 i) external pure override returns (uint256) {
        return HeapLibUInt64.parentIdx(a, b, i);
    }

    function leavesIdx(uint256 i) external pure override returns (uint256[] memory) {
        return HeapLibUInt64.leavesIdx(a, b, i);
    }

    function leaves(uint256 i) external view override returns (uint64[] memory) {
        return heap.leaves(a, b, i);
    }

    function set(uint256 i, uint64 val) external override {
        heap.set(a, b, this.compare.selector, i, val);
    }

    function push(uint64 val) external override {
        heap.push(a, b, this.compare.selector, val);
    }

    function remove(uint256 i) external override returns (uint64) {
        uint64 val = heap.remove(a, b, this.compare.selector, i);
        emit RemoveValue(val);
        return val;
    }

    function removeRoot() external override returns (uint64) {
        uint64 val = heap.removeRoot(a, b, this.compare.selector);
        emit RemoveValue(val);
        return val;
    }

    function search(uint64 val, uint256 hintIdx) external view override returns (uint256) {
        return heap.search(a, b, this.compare.selector, val, hintIdx);
    }

    function searchRoot(uint64 val) external view override returns (uint256) {
        return heap.searchRoot(a, b, this.compare.selector, val);
    }

    function searchUp(uint64 val, uint256 startIdx) external view override returns (uint256) {
        return heap.searchUp(a, b, this.compare.selector, val, startIdx);
    }

    function searchDown(uint64 val, uint256[] memory startIdx) external view override returns (uint256) {
        return heap.searchDown(a, b, this.compare.selector, val, startIdx);
    }

    //Batching tx to speedup testing
    function pushBatch(uint64[] memory val) external override {
        for (uint256 i = 0; i < val.length; i++) {
            heap.push(a, b, this.compare.selector, val[i]);
        }
    }

    function removeRootBatch(uint256 n) external override returns (uint64[] memory) {
        uint64[] memory r = new uint64[](n);
        for (uint256 i = 0; i < n; i++) {
            r[i] = heap.removeRoot(a, b, this.compare.selector);
        }

        return r;
    }
}
