// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./SVG.sol";

error QueryNonexistentToken();
error MintUnderPrice();

contract ExtendedAsciiPlot is Ownable, ERC721Enumerable {
    using Strings for uint256;

    uint256 private mintFee = 0 ether;

    constructor() ERC721("Extended ASCII Plot", "EAP") {}

    function mint(address to, uint256 tokenId) public payable {
        if (msg.value < mintFee) revert MintUnderPrice();

        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert QueryNonexistentToken();

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"name": "EAP #',
                            tokenId.toString(),
                            '", "description": "Extended ASCII Plot (EAP) is user-generated 256bit textmode art fully stored on chain.", "image": "data:image/svg+xml;base64,',
                            Base64.encode(SVG.svg(tokenId)),
                            '"}'
                        )
                    )
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
