//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '../Math/LogBaseNLib.sol';

contract TestLogBaseN {
    function logbaseN(uint256 n, uint256 x) public pure returns (uint256, uint256) {
        return LogBaseNLib.logbaseN(n, x);
    }
}
