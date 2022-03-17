// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error RefundPriceIsZero();
error RefundTimedOut();
error RefundCallerNotOwner();
error SomeRefundsArePending();

/**
 * Making ERC721 tokens refundable during refund period.
 *
 * Assumes all ETH transfers are used only for minting in one transaction.
 *
 * Token will be non-refundable if it has been transferred during refund period.
 */
abstract contract ERC721Refundable is ERC721 {
    struct Refundability {
        // The end of refund period.
        uint64 timestamp;
        // Price value of available refunds.
        uint128 value;
    }

    uint64 private immutable refundPeriod;

    uint64 public latestRefundabilityTimestamp;

    mapping(uint256 => Refundability) internal _refundabilities;

    constructor(uint64 _refundPeriod) {
        refundPeriod = _refundPeriod;
        latestRefundabilityTimestamp = uint64(block.timestamp) + _refundPeriod;
    }

    function _tokenPrice(uint256 tokenId)
        internal
        view
        virtual
        returns (uint128);

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        // Save gas for future transfer.
        if (block.timestamp > latestRefundabilityTimestamp) {
            return;
        }

        // Transfer.
        if (from != address(0) && to != address(0)) {
            // Self transfer is ignored.
            if (from != to) {
                if (_refundabilities[tokenId].value > 0) {
                    delete _refundabilities[tokenId];
                }
            }
        }
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        // Mint.
        if (from == address(0) && _tokenPrice(tokenId) > 0) {
            _refundabilities[tokenId] = Refundability(
                uint64(block.timestamp) + refundPeriod,
                _tokenPrice(tokenId)
            );
            latestRefundabilityTimestamp =
                uint64(block.timestamp) +
                refundPeriod;
        }
    }

    function refund(uint256 tokenId) public {
        Refundability memory refundability = _refundabilities[tokenId];

        if (refundability.value == 0) revert RefundPriceIsZero();
        if (block.timestamp > refundability.timestamp) revert RefundTimedOut();
        if (ownerOf(tokenId) != msg.sender) revert RefundCallerNotOwner();

        delete _refundabilities[tokenId];
        _burn(tokenId);

        payable(msg.sender).transfer(refundability.value);
    }

    modifier noPendingRefunds() {
        if (block.timestamp <= latestRefundabilityTimestamp)
            revert SomeRefundsArePending();
        _;
    }
}
