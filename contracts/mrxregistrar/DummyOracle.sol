// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./PriceOracle.sol";

contract DummyOracle is PriceOracle {
    uint256 value;

    constructor(uint256 _value) {
        set(_value);
    }

    function set(uint256 _value) public {
        value = _value;
    }

    /**
     * @dev Returns the price to register or renew a name.
     * @return The price of this renewal or registration, in wei.
     */
    function price(
        string calldata, /* name */
        uint256, /* expires */
        uint256 /* duration */
    ) external view override returns (uint256) {
        return value;
    }
}
