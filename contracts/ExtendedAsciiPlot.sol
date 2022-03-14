// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./Data.sol";

contract ExtendedAsciiPlot is Ownable, ERC721Enumerable {
    using Strings for uint8;

    uint256 private mintFee = 0 ether;

    constructor() ERC721("Extended ASCII Plot", "EAP") {}

    function mint(address to, uint256 tokenId) public payable {
        require(msg.value >= mintFee, "Not enough mint fee");
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return "";
    }

    function char(
        uint16 value,
        uint8 x,
        uint8 y
    ) internal pure returns (string memory) {
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
        for (uint8 xx = 0; xx < Data.FONT_SIZE; xx++) {
            for (uint8 yy = 0; yy < Data.FONT_SIZE; yy++) {
                if (font & (1 << (xx * Data.FONT_SIZE + yy)) > 0) {
                    dots = (
                        abi.encodePacked(
                            dots,
                            "<rect x='",
                            (Data.FONT_SIZE - 1 - xx).toString(),
                            "' y='",
                            (Data.FONT_SIZE - 1 - yy).toString(),
                            "' fill='",
                            foreground,
                            "' width='1' height='1' />"
                        )
                    );
                }
            }
        }

        return
            string(
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
                )
            );
    }

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
}
