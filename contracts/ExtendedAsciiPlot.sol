// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./SVG.sol";

error CallerIsNotUser();
error QueryNonexistentToken();
error MintUnderPrice();
error NoFreeMintPrivilege();
error InvalidTokenId();
error MaximumSupplyExceed();

contract ExtendedAsciiPlot is Ownable, ERC721 {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10000;

    uint256 public price = 0.01 ether;

    // The tokenId of the next token to be minted.
    uint256 private _currentIndex;

    // Mapping from tokenId to token index
    mapping(uint256 => uint256) public tokensIndex;

    // Mapping from address to free mint count
    mapping(address => uint256) public freeMintPrivileges;

    modifier callerIsUser() {
        if (tx.origin != msg.sender) revert CallerIsNotUser();
        _;
    }

    constructor() ERC721("Extended ASCII Plot", "EAP") {
        freeMintPrivileges[0xEa8e1d16624CBf0290AB887129bB70E5Cdb4b557] = 1;
    }

    function mint(address to, uint256 tokenId) public payable callerIsUser {
        if (msg.value < price) revert MintUnderPrice();
        if (!SVG.isValid(tokenId)) revert InvalidTokenId();
        if (_currentIndex >= MAX_SUPPLY) revert MaximumSupplyExceed();

        _safeMint(to, tokenId);

        tokensIndex[tokenId] = _currentIndex++;
    }

    function freeMint(address to, uint256 tokenId) public callerIsUser {
        if (freeMintPrivileges[msg.sender] == 0) revert NoFreeMintPrivilege();
        if (!SVG.isValid(tokenId)) revert InvalidTokenId();
        if (_currentIndex >= MAX_SUPPLY) revert MaximumSupplyExceed();

        freeMintPrivileges[msg.sender]--;

        _safeMint(to, tokenId);

        tokensIndex[tokenId] = _currentIndex++;
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

    function totalSupply() public view returns (uint256) {
        return _currentIndex;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
