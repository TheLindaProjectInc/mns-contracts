// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "../registry/MNS.sol";
import "./MRXRegistrarController.sol";
import "../resolvers/Resolver.sol";

contract BulkRenewal {
    bytes32 private constant ETH_NAMEHASH =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes4 private constant REGISTRAR_CONTROLLER_ID = 0x018fac06;
    bytes4 private constant INTERFACE_META_ID =
        bytes4(keccak256("supportsInterface(bytes4)"));
    bytes4 public constant BULK_RENEWAL_ID =
        bytes4(
            keccak256("rentPrice(string[],uint)") ^
                keccak256("renewAll(string[],uint")
        );

    MNS public mns;

    constructor(MNS _mns) {
        mns = _mns;
    }

    function getController() internal view returns (MRXRegistrarController) {
        Resolver r = Resolver(mns.resolver(ETH_NAMEHASH));
        return
            MRXRegistrarController(
                r.interfaceImplementer(ETH_NAMEHASH, REGISTRAR_CONTROLLER_ID)
            );
    }

    function rentPrice(string[] calldata names, uint256 duration)
        external
        view
        returns (uint256 total)
    {
        MRXRegistrarController controller = getController();
        for (uint256 i = 0; i < names.length; i++) {
            total += controller.rentPrice(names[i], duration);
        }
    }

    function renewAll(string[] calldata names, uint256 duration)
        external
        payable
    {
        MRXRegistrarController controller = getController();
        for (uint256 i = 0; i < names.length; i++) {
            uint256 cost = controller.rentPrice(names[i], duration);
            controller.renew{value: cost}(names[i], duration);
        }
        // Send any excess funds back
        payable(msg.sender).transfer(payable(address(this)).balance);
    }

    function supportsInterface(bytes4 interfaceID)
        external
        pure
        returns (bool)
    {
        return
            interfaceID == INTERFACE_META_ID || interfaceID == BULK_RENEWAL_ID;
    }
}
