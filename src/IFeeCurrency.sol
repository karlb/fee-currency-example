pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFeeCurrency is IERC20 {
    // Called before transaction execution to reserve the maximum amount of gas
    // that can be used by the transaction.
    // The implementation must reduce `from`'s balance by `value`.
    // Must revert if `msg.sender` is not the zero address.
    function debitGasFees(address from, uint256 value) external;

    // New function signature, will be used when all fee currencies have migrated.
    // Credited amounts are gas refund, base fee and tip. Additional components
    // might be added, like an L1 gas fee when Celo becomes and L2.
    // The implementation must increase each `recipient`'s balance by respective `value`.
    // Must revert if `msg.sender` is not the zero address.
    function creditGasFees(address[] calldata recipients, uint256[] calldata amounts) external;

    // Old function signature for backwards compatibility
    // Must revert if `msg.sender` is not the zero address.
    function creditGasFees(
        address from,
        address feeRecipient,
        address gatewayFeeRecipient,
        address communityFund,
        uint256 refund,
        uint256 tipTxFee,
        uint256 gatewayFee,
        uint256 baseTxFee
    ) external;
}
