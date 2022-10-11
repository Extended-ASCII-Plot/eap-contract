// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error RefundPriceIsZero();
error RefundTimedOut();
error RefundCallerNotOwner();
error SomeRefundsArePending();

/**
 * Guaranteeing ERC721 tokens refundable during refund period.
 *
 * Token will be non-refundable if it has been transferred during refund period.
 */
abstract contract ERC721Refundable is ERC721 {
    struct Refundability {
        // The deadline timestamp of refund period.
        uint64 deadline;
        // Price of available refunds.
        uint128 price;
    }

    mapping(uint256 => Refundability) internal _refundabilities;

    uint64 private immutable refundPeriod;

    uint64 public latestRefundabilityTimestamp;

    /**
     * @dev Should add this modifier to 'withdraw' function.
     */
    modifier noPendingRefunds() {
        if (block.timestamp <= latestRefundabilityTimestamp)
            revert SomeRefundsArePending();
        _;
    }

    constructor(uint64 _refundPeriod) {
        refundPeriod = _refundPeriod;
        latestRefundabilityTimestamp = uint64(block.timestamp) + _refundPeriod;
    }

    /**
     * @dev Price can be changed during sale. Just override this function and return current price.
     */
    function _currentPrice() internal view virtual returns (uint128);

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        Refundability storage refundability = _refundabilities[tokenId];

        // Save gas for future transfer.
        if (block.timestamp > refundability.deadline) {
            return;
        }

        // Mint or burn is ignored.
        if (from == address(0) || to == address(0)) {
            return;
        }

        // Self transfer is ignored.
        if (from == to) {
            return;
        }

        // Wen losing refundability, refund gas.
        delete _refundabilities[tokenId];
    }

    function _afterTokenTransfer(
        address from,
        address,
        uint256 tokenId
    ) internal override {
        uint128 price = _currentPrice();

        // Payable mint.
        if (from == address(0) && price > 0) {
            uint64 timestamp = uint64(block.timestamp) + refundPeriod;
            _refundabilities[tokenId] = Refundability(timestamp, price);
            latestRefundabilityTimestamp = timestamp;
        }
    }

    function refund(uint256 tokenId) public {
        Refundability memory refundability = _refundabilities[tokenId];

        if (refundability.price == 0) revert RefundPriceIsZero();
        if (block.timestamp > refundability.deadline) revert RefundTimedOut();
        if (ownerOf(tokenId) != msg.sender) revert RefundCallerNotOwner();

        delete _refundabilities[tokenId];
        _burn(tokenId);

        payable(msg.sender).transfer(refundability.price);
    }
}