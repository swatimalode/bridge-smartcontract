// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./Interfaces/IERC721Upgradeable.sol";
import "./Interfaces/IERC1155Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

contract BridgeEthereumV1 is OwnableUpgradeable {
    mapping(address => address) public MapAddresses;
    mapping(address => mapping(address => bool)) public MapAddressesStatus;

    // Events
    event Mapped(
        address Ethereum_Contract_Address,
        address Matic_Contract_Address
    );

    event DepositedERC721(address Ethereum_Contract_Address, address Owner, uint256 TokenId);

    function initialize() public initializer {
        __Ownable_init();
    }

    function MapContracts(
        address _eth_contract_address,
        address _matic_contract_address
    ) external virtual {
        require(
            AddressUpgradeable.isContract(_matic_contract_address),
            "BridgeEthereum: Invalid address"
        );

        require(
            MapAddresses[_matic_contract_address] == address(0) &&
                !MapAddressesStatus[_matic_contract_address][
                    _eth_contract_address
                ],
            "BridgeEthereum: Contract is already mapped"
        );
        require(
            OwnableUpgradeable(_matic_contract_address).owner() == msg.sender,
            "BridgeEthereum: You are not eligible"
        );

        MapAddresses[_matic_contract_address] = _eth_contract_address;
        MapAddressesStatus[_matic_contract_address][
            _eth_contract_address
        ] = true;

        emit Mapped(_eth_contract_address, _matic_contract_address);
    }

    function depositERC721(address _eth_contract_address, uint256 _token_id)
        external
        virtual
    {
        require(
            MapAddresses[_eth_contract_address] != address(0),
            "BridgeEthereum: Invalid address"
        );
        require(
            IERC721Upgradeable(_eth_contract_address).ownerOf(_token_id) ==
                msg.sender,
            "BridgeEthereum: Not a token owner"
        );

        IERC721Upgradeable(_eth_contract_address).burn(_token_id);

        emit DepositedERC721(_eth_contract_address, msg.sender, _token_id);
    }
}
