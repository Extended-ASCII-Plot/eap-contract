// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./SVG.sol";

error QueryNonexistentToken();
error MintUnderPrice();

contract ExtendedAsciiPlot is Ownable, ERC721 {
    using Strings for uint256;

    uint256 private mintFee = 0 ether;

    // The tokenId of the next token to be minted.
    uint256 private _currentIndex;

    // Mapping from tokenId to token index
    mapping(uint256 => uint256) private _tokensIndex;

    constructor() ERC721("Extended ASCII Plot", "EAP") {}

    function mint(address to, uint256 tokenId) public payable {
        if (msg.value < mintFee) revert MintUnderPrice();

        _safeMint(to, tokenId);

        _tokensIndex[tokenId] = _currentIndex++;
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
                            _tokensIndex[tokenId].toString(),
                            '", "description": "Extended ASCII Plot (EAP) is user-generated 256bit textmode art fully stored on chain.", "image": "data:image/svg+xml;base64,',
                            Base64.encode(SVG.svg(tokenId)),
                            '"}'
                        )
                    )
                )
            );
    }

    function totalSupply() public view returns (uint256) {
        return _currentIndex;
    }

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
}
