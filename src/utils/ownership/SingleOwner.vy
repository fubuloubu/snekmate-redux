owner: public(address)
# NOTE: The documentation should make the user aware that they need to set `owner` in constructor


# NOTE: Is useful downstream
@internal
def _isOwner(user: address):
    return user == self.owner


@external
def transferOwnership(new_owner: address):
    assert self._isOwner(msg.sender)
    self.owner = new_owner
