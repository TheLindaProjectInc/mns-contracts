// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../namewrapper/Controllable.sol";
import "./PriceOracle.sol";

contract MRXtoUSDOracle is PriceOracle, Controllable {
    uint256 public value;
    uint256 public updated;
    uint256[7] public averages;

    event PriceSet(uint256 oldPrice, uint256 newPrice);
    event PriceChanged(uint256 dailyPrice, uint256 oldPrice, uint256 newPrice);

    constructor(uint256 _value) {
        setController(msg.sender, true);
        setPrice(_value);
    }

    /**
     * @dev Sets the new price and updated the 7 days prices. Only executable by a controller
     * @param _value the new MRX/USD value
     */
    function setPrice(uint256 _value) public onlyController {
        uint256 oldPrice = value;
        averages = [_value, _value, _value, _value, _value, _value, _value];
        value = _value;
        updated = block.timestamp;
        emit PriceSet(oldPrice, _value);
    }

    /**
     * @dev Sets the new price based on the 7 day average of the price. Only executable by a controller
     * @param _value the new daily MRX/USD value
     */
    function setAveragePricing(uint256 _value) public onlyController {
        uint256 oldPrice = value;
        uint256 average = 0;
        uint256[7] memory tmp = averages;
        for (uint256 i = 0; i + 1 < tmp.length && i < averages.length; i++) {
            averages[i] = tmp[i + 1];
            average += tmp[i + 1];
        }
        averages[6] = _value;
        average += _value;
        value = average / 7;
        updated = block.timestamp;
        emit PriceChanged(_value, oldPrice, value);
    }

    /**
     * @dev See {PriceOracle}
     */
    function price(
        string calldata name,
        uint256, /*expires*/
        uint256 duration
    ) external view override returns (uint256) {
        uint256 _price = 3 * 1e18;
        uint256 len = bytes(name).length;
        require(
            duration > 0,
            "MRXtoUSDOracle: Duration must be greater than 0"
        );
        if (len == 3) {
            _price = ((value * 320) / (365 days)) * duration;
        } else if (len == 4) {
            _price = ((value * 80) / (365 days)) * duration;
        } else if (len >= 5) {
            _price = ((value * 5) / (365 days)) * duration;
        }
        return _price;
    }

    /**
     * @dev returns the block timestamp of the last update
     */
    function lastUpdate() external view returns (uint256) {
        return updated;
    }
}
