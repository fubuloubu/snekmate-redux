from vyper.interfaces import ERC20
# NOTE: eventually maybe `ethereum.standards import IERC20`?

implements: ERC20
# NOTE: Downstream usage of `extends: BaseToken` enforces `implements: ERC20` as well

totalSupply: public(uint256)
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])


# NOTE: Only basic ERC20 functionality, not ERC20Detailed


event Transfer:
    owner: indexed(address)
    receiver: indexed(address)
    amount: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    amount: uint256


@internal
# NOTE: Drop `@internal`?
# NOTE: This is actually dead code if no downstream user uses it
def _mint(receiver: address, amount: uint256):
    # TODO: Gas optimize this if you want
    self.balanceOf[receiver] += amount
    self.totalSupply += amount

    log Transfer(empty(address), receiver, amount)


@internal
# NOTE: Drop `@internal`?
# NOTE: This is actually dead code if no downstream user uses it
def _burn(owner: address, amount: uint256):
    # TODO: Gas optimize this if you want
    self.balanceOf[owner] -= amount
    self.totalSupply -= amount

    log Transfer(owner, empty(address), amount)


@internal
# NOTE: Drop `@internal`?
def _transfer(owner: address, receiver: address, amount: uint256):
    # TODO: Gas optimize this if you want
    self.balanceOf[owner] -= amount
    self.balanceOf[receiver] += amount

    log Transfer(owner, receiver, amount)


@external
def transfer(receiver: address, amount: uint256) -> bool:
    self._transfer(msg.sender, receiver, amount)
    return True


@internal
# NOTE: Drop `@internal`?
# NOTE: Useful for `Permit`
def _approve(owner: address, spender: address, amount: uint256) -> bool:
    self.allowance[owner][spender] = amount
    log Approval(owner, spender, amount)


@external
def approve(spender: address, amount: uint256) -> bool:
    self._approve(msg.sender, spender, amount)
    return True


@internal
# NOTE: Drop `@internal`?
def _reduceAllowance(owner: address, spender: address, amount: uint256):
    # TODO: Gas optimize this if you want
    self.allowance[owner][msg.sender] -= amount


@external
def transferFrom(owner: address, receiver: address, amount: uint256) -> bool:
    self._reduceAllowance(owner, msg.sender, amount)
    self._transfer(owner, receiver, amount)
    return True


# TODO: Add documentation, testing, etc.
