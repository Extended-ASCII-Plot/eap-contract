// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

contract ExtendedAsciiPlot is ERC721Tradable {
    uint256 private mintFee = 0 ether;

    string private _baseTokenURI = "https://eap.wtf/api/";

    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Extended ASCII Plot", "EAP", _proxyRegistryAddress)
    {}

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function mint(address to, uint256 tokenId) public payable {
        require(msg.value >= mintFee, "Not enough mint fee");
        _safeMint(to, tokenId);
    }

    function baseTokenURI() public view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseTokenURI(string memory newBaseTokenURI) external onlyOwner {
        _baseTokenURI = newBaseTokenURI;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
}
