# `..utils.Ownable` has concrete `_isOwner`
@internal
def _isOwner(user: address):
    ...  # This is abstract, and must be implemented or in the base of an extension


# `BaseToken` has concrete `_mint`
@internal
def _mint(owner: address, amount: uint256):
    ...  # This is abstract, and must be implemented or in the base of an extension


@external
def mint(owner: address, amount: uint256) -> bool:
    assert msg.sender == self.owner
    self._mint(owner, amount)
    return True
