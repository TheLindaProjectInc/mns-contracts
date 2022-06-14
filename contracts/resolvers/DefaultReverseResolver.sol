// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../registry/MNS.sol";
import "../registry/ReverseRegistrar.sol";

/**
 * @dev Provides a default implementation of a resolver for reverse records,
 * which permits only the owner to update it.
 */
contract DefaultReverseResolver {
    MNS public mns;
    mapping(bytes32 => string) public name;

    /**
     * @dev Only permits calls by the reverse registrar.
     * @param node The node permission is required for.
     */
    modifier onlyOwner(bytes32 node) {
        require(msg.sender == mns.owner(node));
        _;
    }

    /**
     * @dev Constructor
     * @param mnsAddr The address of the MNS registry.
     */
    constructor(MNS mnsAddr) {
        mns = mnsAddr;

        // Assign ownership of the reverse record to our deployer
        ReverseRegistrar registrar = ReverseRegistrar(
            mns.owner(
                0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2
            )
        );
        if (address(registrar) != address(0x0)) {
            registrar.claim(msg.sender);
        }
    }

    /**
     * @dev Sets the name for a node.
     * @param node The node to update.
     * @param _name The name to set.
     */
    function setName(bytes32 node, string memory _name) public onlyOwner(node) {
        name[node] = _name;
    }
}
