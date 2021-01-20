//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

//Interface to compare different list implementaions
interface IListUInt16 {
    function length() external view returns (uint256);

    function get(uint256 i) external view returns (uint16);

    function set(uint256 i, uint16 val) external;

    function push(uint16 val) external;

    function swap(uint256 i, uint256 j) external;

    function pop() external;

    /***** Batched Ops ******/
    function getBatch(uint256[] memory iArray) external view returns (uint256[] memory);

    function setBatch(uint256[] memory iArray, uint256[] memory valArray) external;

    function pushBatch(uint256[] memory valArray) external;

    function popBatch(uint256 n) external;
}
