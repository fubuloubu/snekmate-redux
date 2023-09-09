from . import BaseToken

from ..utils import Ownable

extends: BaseToken, Ownable
# Extends `BaseToken` so has `_mint`
# Extends `Ownable` so has access to `self.owner`


@external
def mint(owner: address, amount: uint256) -> bool:
    assert msg.sender == self.owner
    self._mint(owner, amount)
    return True
