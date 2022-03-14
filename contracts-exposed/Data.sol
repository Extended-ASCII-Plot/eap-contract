// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/Data.sol";

contract $Data {
    constructor() {}

    function $getFontAt(uint256 index) external pure returns (uint64) {
        return Data.getFontAt(index);
    }

    function $getColorAt(uint256 index) external pure returns (uint8, uint8, uint8) {
        return Data.getColorAt(index);
    }
}
