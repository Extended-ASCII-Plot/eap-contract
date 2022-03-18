// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Attribute {
    function distinctCountOfChars(uint256 value)
        internal
        pure
        returns (uint256)
    {
        unchecked {
            uint256 bits;
            for (uint256 i = 0; i < 16; i++) {
                uint8 t = uint8((value & 0xff00) >> 0x8);
                bits |= 1 << t;
            }
            return countSetBits(bits);
        }
    }

    function countSetBits(uint256 value) internal pure returns (uint256) {
        if (value == 0) return 0;
        else return countSetBits(value & (value - 1)) + 1;
    }
}
