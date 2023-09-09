from vyper.interfaces import ERC20Detailed
# NOTE: eventually maybe `ethereum.standards import IERC20Detailed`?

implements: ERC20Detailed
# NOTE: Downstream usage of `extends: TokenDetails` enforces `implements: ERC20Detailed` as well

name: public(immutable(String[64]))  # NOTE: 64 chars as an enforced recommended length
symbol: public(immutable(String[16]))  # NOTE: 16 chars as an enforced recommended length
decimals: public(immutable(uint8))

# NOTE: Doesn't require extending `BaseToken` but works best with it
# NOTE: Vyper will enforce setting the immutables in user's constructor

from ..utils import eip712


EIP712_DOMAIN_HASH: constant(bytes32) = keccak256(
    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
)

@internal
def _domain_separator() -> bytes32:
    # NOTE: Can be used to set `DOMAIN_SEPARATOR` during constructor when using `Permit`,
    #       or you can use your own, just a helpful function to use
    return eip712.generate_domain_separator(
        keccak256(abi.encode(EIP712_DOMAIN_HASH, name, "1.0", chain.id, self))
    )
