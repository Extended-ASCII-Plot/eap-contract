// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Preset.sol";

contract ExtendedAsciiPlot is ERC721Preset {
    uint256 private mintFee = 0 ether;

    constructor() ERC721Preset("Extended ASCII Plot", "EAP", "https://eap.vercel.app/api/") {}

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function mint(address to, uint256 tokenId) public payable {
        require(msg.value >= mintFee, "Not enough mint fee");
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
        return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId)));
    }
}
