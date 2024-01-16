pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
  @notice This interface should be implemented for tokens which are supposed to
  act as fee currencies on the Celo blockchain, meaning that they can be
  used to pay gas fees for CIP-64 transactions (and some older tx types).
  See https://github.com/celo-org/celo-proposals/blob/master/CIPs/cip-0064.md

  @notice Before executing a tx with non-empty `feeCurrency` field, the fee
  currency's `debitGasFees` function is called to reserve the maximum
  amount of gas token that tx can spend. After the tx has been executed, the
  `creditGasFees` function is called to refund any unused gas and credit
  the spent fees to the appropriate recipients. Events which are emitted in
  these functions will show up for every tx using the token as a
  fee currency.

  @dev Requirements:
  - The functions will be called by the blockchain client with `msg.sender
  == address(0)`. If this condition is not met, the functions must
  revert to prevent malicious users from crediting their accounts directly.
  - `creditGasFees` must credit all specified amounts. If this is not
  possible the functions must revert to prevent inconsistencies between
  the debited and credited amounts.

  @dev Notes on compatibility:
  - There are two versions of `creditGasFees`: one for the current
  (2024-01-16) blockchain implementation and a more future-proof version
  that omits deprecated fields and accommodates potential new recipients
  that might become necessary on later blockchain implementations. Both
  versions should be implemented to increase compatibility.
  - Future Celo blockchain implementations might provide a way for plain
  ERC-20 tokens to be used as gas currencies without implementing this
  interface. If this alternative is preferable for you, please contact cLabs
  before implementing this interface for your token.
 */
interface IFeeCurrency is IERC20 {
    /// @notice Called before transaction execution to reserve the maximum amount of gas
    /// that can be used by the transaction.
    /// - The implementation must deduct `value` from `from`'s balance.
    /// - Must revert if `msg.sender` is not the zero address.
    function debitGasFees(address from, uint256 value) external;

    /// @notice New function signature, will be used when all fee currencies have migrated.
    /// Credited amounts include gas refund, base fee and tip. Future additions
    /// may include L1 gas fee when Celo becomes and L2.
    /// - The implementation must increase each `recipient`'s balance by corresponding `value`.
    /// - Must revert if `msg.sender` is not the zero address.
    /// - Must revert if `recipients` and `amounts` have different lengths.
    function creditGasFees(address[] calldata recipients, uint256[] calldata amounts) external;

    /// @notice Old function signature for backwards compatibility
    /// - Must revert if `msg.sender` is not the zero address.
    /// - `refund` must be credited to `from`
    /// - `tipTxFee` must be credited to `feeRecipient`
    /// - `baseTxFee` must be credited to `communityFund`
    /// - `gatewayFeeRecipient` and `gatewayFee` only exist for backwards
    ///   compatibility reasons and will always be zero.
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
