from ethereum import abi, keccak256

from ..utils import signatures, eip712

nonces: public(HashMap[address, uint256])

DOMAIN_SEPARATOR: public(immutable(bytes32))
PERMIT_TYPE_HASH: constant(bytes32) = keccak256(
    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
)

# NOTE: Doesn't require extending `BaseToken` but works best with it
# NOTE: Vyper will enforce setting the immutable in user's constructor


@internal
def _approve(owner: address, spender: address, amount: uint256):
    ...  # This is abstract, and must be implemented or in the base of an extension


@external
def permit(
    owner: address,
    spender: address,
    amount: uint256,
    deadline: uint256,
    v: uint8,
    r: bytes32,
    s: bytes32,
):
    assert block.timestamp <= deadline, "ERC20Permit: expired deadline"

    current_nonce: uint256 = self.nonces[owner]

    struct_hash: bytes32 = eip712.hash_struct(
        PERMIT_TYPE_HASH,
        abi.encode(owner, spender, amount, current_nonce, deadline),
    )
    hash: bytes32  = eip712.hash_typed_data_v4(DOMAIN_SEPARATOR, struct_hash)

    signer: address = signatures.recover_vrs(hash, v, r, s)
    assert signer == owner, "ERC20Permit: invalid signature"

    self.nonces[owner] = unsafe_add(current_nonce, 1)
    self._approve(owner, spender, amount)
