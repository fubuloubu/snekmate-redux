owner: public(address)
# NOTE: The documentation should make the user aware that they need to set `owner` in constructor
pending_owner: address


@external
def transferOwnership(new_owner: address):
    assert msg.sender == self.owner
    self.pending_owner = new_owner


@external
def acceptOwnership():
    # TODO: Optimize
    assert msg.sender == self.pending_owner
    self.owner = self.pending_owner
