# `from ethereum.erc import ERC3156` and `implements: ERC3156` when available

from . import BaseToken

extends: BaseToken
# Extends `BaseToken` so has `_mint` and `_reduceAllowance`


interface FlashBorrower:
    def onFlashLoan(
        caller: address,
        token: address,
        amount: uint256,
        fee: uint256,
        data: Bytes[65535],
    ) -> bytes32: nonpayable

ERC3156_CALLBACK_SUCCESS: constant(bytes32) = keccak256("ERC3156FlashBorrower.onFlashLoan")

flashMinted: public(uint256)

@view
@internal
# NOTE: Drop `@internal`?
def _maxFlashLoan() -> uint256:
    return ...  # Abstract, user must implement


@view
@external
def maxFlashLoan(token: address) -> uint256:
    # NOTE: Only designed for `FlashMintable` use case, not `FlashLoan`
    if token != self:
        return 0

    return return self._maxFlashLoan()


@view
@internal
# NOTE: Drop `@internal`?
def flashFee(amount: uint256) -> uint256:
    return ...  # Abstract, user must implement


@view
@external
def flashFee(token: address, amount: uint256) -> uint256:
    assert token == self
    return self._flashFee(amount)


@internal
def _handleFee(provider: address, amount: uint256):
    ...  # Abstract, user must implement
    # NOTE: Document that `amount` violates invariant of `sum(balanceOf) == totalSupply` unless handled
    # Could be `self.totalSupply -= amount` in order to reduce supply/benefit all holders
    #   (But don't forget to log `Transfer` event!)
    # Could also be `self._transfer(provider, self.owner, amount)` to benefit owner


@external
def flashLoan(receiver: address, token: address, amount: uint256, data: Bytes[65535]) -> bool:
    assert token == self
    assert amount <= self._maxFlashLoan()

    self._mint(receiver, amount)
    self.flashMinted += amount

    assert FlashBorrower(receiver).onFlashLoan(msg.sender, self, amount, 0, data) == ERC3156_CALLBACK_SUCCESS
    fee: uint256 = self._flashFee(amount)

    # NOTE: According to ERC3156, `receiver` must set an approval for this contract
    self._reduceAllowance(receiver, self, amount + fee)
    self._burn(receiver, amount)
    self._handleFee(receiver, fee)
    # NOTE: Sure it's a little less efficient to touch `self.balanceOf[receiver]` twice (potentially),
    #       but there's more flexibility in this approach in terms of how user can handle this situation
    self.flashMinted -= amount

    return True
