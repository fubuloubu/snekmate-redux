from snekmate.erc20 import BaseToken, Mintable, Permit, TokenDetails, Burnable, FlashMintable
from snekmate.utils.ownership import SingleOwner

extends: BaseToken, Mintable, Burnable, TokenDetails, Permit, FlashMintable
# NOTE: `Mintable` has abstract `_mint`, but `BaseToken._mint` satisfies it
# NOTE: `Mintable` has abstract `_isOwner`, but `SingleOwner._isOwner` satisfies it
# NOTE: `Burnable` has abstract `_burn`, but `BaseToken._burn` satisfies it
# NOTE: `Permit` has abstract `_approve`, but `BaseToken._approve` satisfies it
# NOTE: `FlashMintable` has abstract `_mint`, but `BaseToken._mint` satisfies it


@external
def __init__():
    # NOTE: To satisfy `TokenDetails` immutables
    name = "Test Token"
    symbol = "TEST"
    decimals = 18

    # NOTE: To satisfy `Permit` immutables
    DOMAIN_SEPARATOR = self._domain_separator()

    # NOTE: Nothing requires setting this, but docs for `Ownable` should make it clear
    #       to always set in constructor.
    self.owner = msg.sender
