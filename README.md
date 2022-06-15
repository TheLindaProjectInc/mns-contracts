[![GitHub license](https://img.shields.io/github/license/TheLindaProjectInc/mns-contracts)](https://github.com/TheLindaProjectInc/mns-contracts/blob/main/LICENSE.md) [![npm version](https://badge.fury.io/js/@metrixnames%2Fmns-contracts.svg)](https://badge.fury.io/js/@metrixnames%2Fmns-contracts)

# mns-contracts

mns-contracts is an update/port of [**ens-contracts**](https://github.com/ensdomains/ens-contracts) made to work for the Metrix Name Service and MetrixCoin blockchain.

## Installation

``npm install --save @metrixnames/mns-contracts

## Example Usage

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@metrixnames/mns-contracts/contracts/registry/MNS.sol";

contract HelloRegistrar {
    MNS mns;
    bytes32 rootNode;

    modifier only_owner(bytes32 label) {
        address currentOwner = mns.owner(
            keccak256(abi.encodePacked(rootNode, label))
        );
        require(currentOwner == address(0x0) || currentOwner == msg.sender);
        _;
    }

    /**
     * Constructor.
     * @param mnsAddr The address of the MNS registry.
     * @param node The node that this registrar administers.
     */
    constructor(MNS mnsAddr, bytes32 node) {
        mns = mnsAddr;
        rootNode = node;
    }

    /**
     * Register a name, or change the owner of an existing registration.
     * @param label The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 label, address owner) public only_owner(label) {
        mns.setSubnodeOwner(rootNode, label, owner);
    }
}
```
