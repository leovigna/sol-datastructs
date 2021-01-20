//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

//Interface to compare different tree implementaions
interface IHeapUInt32 {
    function height() external view returns (uint256);

    function maxLength() external view returns (uint256);

    function length() external view returns (uint256);

    function get(uint256 i) external view returns (uint32);

    function set(uint256 i, uint32 val) external;

    function push(uint32 val) external;

    function root() external view returns (uint32);

    function parent(uint256 i) external view returns (uint32);

    function leaves(uint256 i) external view returns (uint32[] memory);

    function parentIdx(uint256 i) external pure returns (uint256);

    function leavesIdx(uint256 i) external pure returns (uint256[] memory);

    function remove(uint256 i) external returns (uint32);

    function removeRoot() external returns (uint32);

    function compare(uint32 a, uint32 b) external pure returns (bool);

    function search(uint32 val, uint256 hintIdx) external view returns (uint256);

    function searchRoot(uint32 val) external view returns (uint256);

    function searchUp(uint32 val, uint256 startIdx) external view returns (uint256);

    function searchDown(uint32 val, uint256[] memory startIdx) external view returns (uint256);

    //Batching
    function pushBatch(uint32[] calldata val) external;

    function removeRootBatch(uint256 n) external returns (uint32[] memory);
}
