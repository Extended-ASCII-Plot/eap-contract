// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/ExtendedAsciiPlot.sol";

contract $ExtendedAsciiPlot is ExtendedAsciiPlot {
    constructor() {}

    function $char(uint16 value,uint8 x,uint8 y) external pure returns (string memory) {
        return super.char(value,x,y);
    }

    function $_beforeTokenTransfer(address from,address to,uint256 tokenId) external {
        return super._beforeTokenTransfer(from,to,tokenId);
    }

    function $_baseURI() external view returns (string memory) {
        return super._baseURI();
    }

    function $_safeTransfer(address from,address to,uint256 tokenId,bytes calldata _data) external {
        return super._safeTransfer(from,to,tokenId,_data);
    }

    function $_exists(uint256 tokenId) external view returns (bool) {
        return super._exists(tokenId);
    }

    function $_isApprovedOrOwner(address spender,uint256 tokenId) external view returns (bool) {
        return super._isApprovedOrOwner(spender,tokenId);
    }

    function $_safeMint(address to,uint256 tokenId) external {
        return super._safeMint(to,tokenId);
    }

    function $_safeMint(address to,uint256 tokenId,bytes calldata _data) external {
        return super._safeMint(to,tokenId,_data);
    }

    function $_mint(address to,uint256 tokenId) external {
        return super._mint(to,tokenId);
    }

    function $_burn(uint256 tokenId) external {
        return super._burn(tokenId);
    }

    function $_transfer(address from,address to,uint256 tokenId) external {
        return super._transfer(from,to,tokenId);
    }

    function $_approve(address to,uint256 tokenId) external {
        return super._approve(to,tokenId);
    }

    function $_setApprovalForAll(address owner,address operator,bool approved) external {
        return super._setApprovalForAll(owner,operator,approved);
    }

    function $_afterTokenTransfer(address from,address to,uint256 tokenId) external {
        return super._afterTokenTransfer(from,to,tokenId);
    }

    function $_transferOwnership(address newOwner) external {
        return super._transferOwnership(newOwner);
    }

    function $_msgSender() external view returns (address) {
        return super._msgSender();
    }

    function $_msgData() external view returns (bytes memory) {
        return super._msgData();
    }
}
