from . import BaseToken

extends: BaseToken
# Extends `BaseToken` so has `_burn`


@external
def burn(amount: uint256) -> bool:
    self._burn(msg.sender, amount)
    return True
