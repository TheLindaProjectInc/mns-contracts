//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../interfaces/IMetadataService.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract StaticMetadataService is IMetadataService {
    using Address for address;
    using Strings for uint256;
    string private _uri;

    constructor(string memory _metaDataUri) {
        _uri = _metaDataUri;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return
            bytes(_uri).length > 0
                ? string(abi.encodePacked(_uri, tokenId.toString()))
                : "";
    }
}
