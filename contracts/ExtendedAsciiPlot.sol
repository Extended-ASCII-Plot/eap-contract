// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./SVG.sol";
import "./ERC721Refundable.sol";

error CallerIsNotUser();
error QueryNonexistentToken();
error MintUnderPrice();
error InvalidTokenId();
error MaximumSupplyExceed();

contract ExtendedAsciiPlot is Ownable, ERC721Refundable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 4096;

    uint256 public price = 0.01 ether;

    // The tokenId of the next token to be minted.
    uint256 private _currentIndex;

    // Mapping from tokenId to token index
    mapping(uint256 => uint256) public tokensIndex;

    modifier callerIsUser() {
        if (tx.origin != msg.sender) revert CallerIsNotUser();
        _;
    }

    constructor()
        ERC721("Extended ASCII Plot", "EAP")
        ERC721Refundable(7 days)
    {}

    function mint(address to, uint256 tokenId) public payable callerIsUser {
        if (msg.value < price) revert MintUnderPrice();
        if (!SVG.isValid(tokenId)) revert InvalidTokenId();
        if (_currentIndex >= MAX_SUPPLY) revert MaximumSupplyExceed();

        _safeMint(to, tokenId);

        tokensIndex[tokenId] = _currentIndex++;
    }

    function _currentPrice() internal view override returns (uint128) {
        return uint128(price);
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
                            '{"name":"EAP #',
                            tokensIndex[tokenId].toString(),
                            '","image":"data:image/svg+xml;base64,',
                            Base64.encode(SVG.svg(tokenId)),
                            '"}'
                        )
                    )
                )
            );
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdraw() external onlyOwner noPendingRefunds {
        payable(owner()).transfer(address(this).balance);
    }
}
