# `BaseToken` has concrete `_burn`
@internal
def _burn(owner: address, amount: uint256):
    ... # This is abstract, and must be implemented or in the base of an extension


@external
def burn(amount: uint256) -> bool:
    self._burn(msg.sender, amount)
    return True
