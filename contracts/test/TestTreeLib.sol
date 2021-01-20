//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import '../Tree/TreeLib.sol';

contract TestTreeLib {
    function height(
        uint256 a,
        uint256 b,
        uint256 l
    ) public pure returns (uint256) {
        require(a >= 2, 'a < 2');
        require(b >= 2, 'b < 2');

        return TreeLib.height(a, b, l);
    }

    function maxLength(
        uint256 a,
        uint256 b,
        uint256 h
    ) public pure returns (uint256) {
        require(a >= 2, 'a < 2');
        require(b >= 2, 'b < 2');

        return TreeLib.maxLength(a, b, h);
    }

    function getIdx(uint256 a, uint256 i) public pure returns (uint256, uint256) {
        require(a >= 2, 'a < 2');

        return TreeLib.getIdx(a, i);
    }

    function parentIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) public pure returns (uint256) {
        require(a >= 2, 'a < 2');
        require(b >= 2, 'b < 2');

        return TreeLib.parentIdx(a, b, i);
    }

    function leavesIdx(
        uint256 a,
        uint256 b,
        uint256 i
    ) public pure returns (uint256[] memory) {
        require(a >= 2, 'a < 2');
        require(b >= 2, 'b < 2');

        return TreeLib.leavesIdx(a, b, i);
    }
}
