// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "./Data.sol";

library SVG {
    using Strings for uint8;

    uint8 public constant PLOT_CHAR_SIZE = 4;

    function plot(uint256 value) public pure returns (bytes memory) {
        bytes memory chars;
        for (uint8 x = 0; x < PLOT_CHAR_SIZE; x++) {
            for (uint8 y = 0; y < PLOT_CHAR_SIZE; y++) {
                chars = abi.encodePacked(
                    chars,
                    char(
                        uint16(value >> ((x + y * PLOT_CHAR_SIZE) * 16)),
                        (PLOT_CHAR_SIZE - 1 - x) * Data.FONT_SIZE,
                        (PLOT_CHAR_SIZE - 1 - y) * Data.FONT_SIZE
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
        (uint8 fr, uint8 fg, uint8 fb) = Data.getColorAt((value & 0xf0) >> 0x4);
        (uint8 br, uint8 bg, uint8 bb) = Data.getColorAt(value & 0xf);
        bytes memory foreground = abi.encodePacked(
            "rgb(",
            fr.toString(),
            ",",
            fg.toString(),
            ",",
            fb.toString(),
            ")"
        );
        bytes memory background = abi.encodePacked(
            "rgb(",
            br.toString(),
            ",",
            bg.toString(),
            ",",
            bb.toString(),
            ")"
        );

        bytes memory dots;
        for (uint8 i = 0; i < Data.FONT_SIZE * Data.FONT_SIZE; i++) {
            if (font & (1 << i) > 0) {
                uint8 xx = i / Data.FONT_SIZE + x;
                uint8 yy = (i % Data.FONT_SIZE) + y;
                dots = abi.encodePacked(dots, dot(xx, yy, foreground));
            }
        }

        return
            abi.encodePacked(
                "<rect x='",
                x.toString(),
                "' y='",
                y.toString(),
                "' width='",
                Data.FONT_SIZE.toString(),
                "' height='",
                Data.FONT_SIZE.toString(),
                "' fill='",
                background,
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
}
