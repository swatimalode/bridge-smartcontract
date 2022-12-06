// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

contract BridgePolygonV1 is OwnableUpgradeable {
    mapping(address => address) public MapAddresses;
    mapping(address => mapping(address => bool)) public MapAddressesStatus;


    // Events
    event Mapped(address Ethereum_Contract_Address, address Matic_Contract_Address);

    function initialize() public initializer {
        __Ownable_init();
    }

    function MapContracts(
        address _eth_contract_address,
        address _matic_contract_address
    ) external virtual{
        require(
            AddressUpgradeable.isContract(_matic_contract_address),
            "BridgePolygon: Invalid address"
        );

        require(
            MapAddresses[_matic_contract_address] == address(0) &&
                !MapAddressesStatus[_matic_contract_address][_eth_contract_address],
            "BridgePolygon: Contract is already mapped"
        );
        require(
            OwnableUpgradeable(_matic_contract_address).owner() == msg.sender,
            "BridgePolygon: You are not eligible"
        );

        MapAddresses[_matic_contract_address] = _eth_contract_address;
        MapAddressesStatus[_matic_contract_address][_eth_contract_address] = true;

        emit Mapped(_eth_contract_address, _matic_contract_address);
    }

    function withdrawERC721(address _matic_contract_address, uint256 _token_id) external virtual {
        
    }
}
