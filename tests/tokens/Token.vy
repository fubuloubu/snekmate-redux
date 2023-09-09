from snekmate.erc20 import Mintable, Permit, TokenDetails, Burnable, FlashMintable

extends: Mintable, Burnable, TokenDetails, Permit, FlashMintable
# NOTE: `Permit` has abstract `_approve`, but `Mintable:BaseToken._approve` satisfies it


@external
def __init__():
    # NOTE: To satisfy `TokenDetails` immutables
    name = "Test Token"
    symbol = "TEST"
    decimals = 18

    # NOTE: To satisfy `Permit` immutables
    DOMAIN_SEPARATOR = self._domain_separator()

    # NOTE: Nothing requires setting this, but docs for `Mintable:Ownable` should make it clear
    #       to always set in constructor.
    self.owner = msg.sender
