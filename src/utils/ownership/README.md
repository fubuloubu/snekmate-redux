# Ownership

Use case relies on exposing the `_isOwner` concrete function to enable different ownership structures

## SingleOwner

Owner is a single role, and ownership is transferred in a single action `transferOwnership`.

NOTE: Owner must be set in constructor.

## SingleOwnerTwoPhaseCommit

Owner is a single role, and ownership is transferred in a sequence of actions,
first `transferOwnership` then `acceptOwnership`.

NOTE: Owner must be set in constructor.
