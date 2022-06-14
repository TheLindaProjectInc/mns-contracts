// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface INameWrapper {
    function ownerOf(uint256 id) external view returns (address);
}

contract MRXNameWrapper is INameWrapper {
    mapping(uint256 => address) addresses;

    function ownerOf(uint256 id) external view override returns (address) {
        return addresses[id];
    }
}
