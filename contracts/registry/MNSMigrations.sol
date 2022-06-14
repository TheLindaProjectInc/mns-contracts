// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A contract to track MNS migrations.
 */
contract MNSMigrations is Ownable {
    mapping(uint256 => bool) public migrations;

    /**
     * @dev Set a migration as complete
     * @param completed a keccak256 hash of the migration file name
     */
    function setCompleted(uint256 completed) public onlyOwner {
        require(
            !migrations[completed],
            "MNSMigrations: Migration already completed"
        );
        migrations[completed] = true;
    }
}
