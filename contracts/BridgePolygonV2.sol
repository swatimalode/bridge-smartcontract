// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

contract BridgePolygonV2 is OwnableUpgradeable{

    function initialize() public initializer {
        __Ownable_init();
    }


}