// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "../ResolverBase.sol";

abstract contract AddrResolver is ResolverBase {
    bytes4 private constant ADDR_INTERFACE_ID = 0x3b3b57de;
    bytes4 private constant ADDRESS_INTERFACE_ID = 0xf1cb7e06;
    uint256 private constant COIN_TYPE_MRX = 326;

    event AddrChanged(bytes32 indexed node, address a);
    event AddressChanged(
        bytes32 indexed node,
        uint256 coinType,
        bytes newAddress
    );

    mapping(bytes32 => mapping(uint256 => bytes)) _addresses;

    /**
     * Sets the address associated with an MNS node.
     * May only be called by the owner of that node in the MNS registry.
     * @param node The node to update.
     * @param a The address to set.
     */
    function setAddr(bytes32 node, address a) external authorised(node) {
        setAddr(node, COIN_TYPE_MRX, addressToBytes(a));
    }

    /**
     * Returns the address associated with an MNS node.
     * @param node The MNS node to query.
     * @return The associated address.
     */
    function addr(bytes32 node) public view returns (address payable) {
        bytes memory a = addr(node, COIN_TYPE_MRX);
        if (a.length == 0) {
            return payable(0);
        }
        return bytesToAddress(a);
    }

    function setAddr(
        bytes32 node,
        uint256 coinType,
        bytes memory a
    ) public authorised(node) {
        emit AddressChanged(node, coinType, a);
        if (coinType == COIN_TYPE_MRX) {
            emit AddrChanged(node, bytesToAddress(a));
        }
        _addresses[node][coinType] = a;
    }

    function addr(bytes32 node, uint256 coinType)
        public
        view
        returns (bytes memory)
    {
        return _addresses[node][coinType];
    }

    function supportsInterface(bytes4 interfaceID)
        public
        pure
        virtual
        override
        returns (bool)
    {
        return
            interfaceID == ADDR_INTERFACE_ID ||
            interfaceID == ADDRESS_INTERFACE_ID ||
            super.supportsInterface(interfaceID);
    }

    function bytesToAddress(bytes memory b)
        internal
        pure
        returns (address payable a)
    {
        require(b.length == 20);
        assembly {
            a := div(mload(add(b, 32)), exp(256, 12))
        }
    }

    function addressToBytes(address a) internal pure returns (bytes memory b) {
        b = new bytes(20);
        assembly {
            mstore(add(b, 32), mul(a, exp(256, 12)))
        }
    }
}
