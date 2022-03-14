// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ExtendedAsciiPlot is Ownable, ERC721Enumerable {
    uint256 private mintFee = 0 ether;

    constructor(address _proxyRegistryAddress)
        ERC721("Extended ASCII Plot", "EAP")
    {}

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

    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
}
