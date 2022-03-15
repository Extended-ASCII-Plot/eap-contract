// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "./Data.sol";

library SVG {
    using Strings for uint8;

    function svg(uint256 value) public pure returns (bytes memory) {
        unchecked {
            return
                abi.encodePacked(
                    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='512' height='512' shape-rendering='crispEdges'>",
                    plot(value),
                    "</svg>"
                );
        }
    }

    function plot(uint256 value) public pure returns (bytes memory) {
        bytes memory chars;
        for (uint8 x = 0; x < 4; x++) {
            for (uint8 y = 0; y < 4; y++) {
                chars = abi.encodePacked(
                    chars,
                    char(
                        uint16(value >> ((x + y * 4) * 16)),
                        (4 - 1 - x) * 8,
                        (4 - 1 - y) * 8
                    )
                );
            }
        }
        return chars;
    }

    function char(
        uint16 value,
        uint8 x,
        uint8 y
    ) public pure returns (bytes memory) {
        uint64 font = Data.getFontAt((value & 0xff00) >> 0x8);
        (uint8 fRed, uint8 fGreen, uint8 fBlue) = Data.getColorAt(
            (value & 0xf0) >> 0x4
        );
        (uint8 bRed, uint8 bGreen, uint8 bBlue) = Data.getColorAt(value & 0xf);
        bytes memory fGround = abi.encodePacked(
            "rgb(",
            fRed.toString(),
            ",",
            fGreen.toString(),
            ",",
            fBlue.toString(),
            ")"
        );
        bytes memory bGround = abi.encodePacked(
            "rgb(",
            bRed.toString(),
            ",",
            bGreen.toString(),
            ",",
            bBlue.toString(),
            ")"
        );

        bytes memory dots;
        for (uint8 i = 0; i < 8 * 8; i++) {
            if (font & (1 << i) > 0) {
                uint8 xx = i / 8 + x;
                uint8 yy = (i % 8) + y;
                dots = abi.encodePacked(dots, dot(xx, yy, fGround));
            }
        }

        return
            abi.encodePacked(
                "<rect x='",
                x.toString(),
                "' y='",
                y.toString(),
                "' width='8' height='8' fill='",
                bGround,
                "' />",
                dots
            );
    }

    function dot(
        uint8 x,
        uint8 y,
        bytes memory foreground
    ) public pure returns (bytes memory) {
        return
            abi.encodePacked(
                "<rect x='",
                x.toString(),
                "' y='",
                y.toString(),
                "' width='1' height='1' fill='",
                foreground,
                "' />"
            );
    }

    function isValid(uint256 value) public pure returns (bool) {
        unchecked {
            for (uint256 i = 0; i < 16; i++) {
                uint16 t = uint16(value >> (i * 16));
                uint8 fGround = uint8((t & 0xf0) >> 0x4);
                uint8 bGround = uint8(t & 0xf);
                if (fGround == bGround) {
                    return false;
                }
            }
            return true;
        }
    }
}
