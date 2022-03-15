// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a/contracts/ERC721A.sol";

import "./SVG.sol";

error QueryNonexistentToken();
error MintUnderPrice();
error ValueAlreadyMinted();

contract ExtendedAsciiPlot is Ownable, ERC721A {
    using Strings for uint256;

    uint256 private mintFee = 0 ether;

    constructor() ERC721A("Extended ASCII Plot", "EAP") {}

    mapping(uint256 => uint256) public tokens;

    function mint(address to, uint256 value) public payable {
        if (msg.value < mintFee) revert MintUnderPrice();
        if (tokens[totalSupply()] > 0) revert ValueAlreadyMinted();

        _safeMint(to, 1);

        tokens[totalSupply()] = value;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert QueryNonexistentToken();

        unchecked {
            return
                string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                '{"name": "EAP #',
                                tokenId.toString(),
                                '", "description": "Extended ASCII Plot (EAP) is user created 256bit textmode art fully stored on chain.", "image": "data:image/svg+xml;base64,',
                                Base64.encode(SVG.svg(tokens[tokenId])),
                                '"}'
                            )
                        )
                    )
                );
        }
    }

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
