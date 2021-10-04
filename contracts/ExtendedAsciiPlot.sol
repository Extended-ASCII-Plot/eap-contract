// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Preset.sol";

contract ExtendedAsciiPlot is ERC721Preset {
    uint256 private mintFee = 0.001 ether;

    constructor() ERC721Preset("Extended ASCII Plot", "EAP", "") {}

    function setmintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function mint(address to, uint256 tokenId) public payable {
        require(msg.value >= mintFee, "Not enough mint fee");
        _safeMint(to, tokenId);
    }
}
