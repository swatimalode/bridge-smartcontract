// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./Interfaces/IERC721Upgradeable.sol";
import "./Interfaces/IERC1155Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/SignatureCheckerUpgradeable.sol";

contract BridgeEthereumV1 is OwnableUpgradeable {
    mapping(address => address) public MapAddressesEthereum;
    mapping(address => address) public MapAddressesMatic;
    mapping(address => mapping(address => bool)) public MapAddressesStatus;
    mapping(bytes => bool) private checker;

    struct WithdrawOrder {
        address eth_contract_address;
        address owner_address;
        uint256 tokenId;
        bytes32 messageHash;
    }

    // Events
    event Mapped(
        address Ethereum_Contract_Address,
        address Matic_Contract_Address
    );

    event DepositedERC721(
        address Ethereum_Contract_Address,
        address Owner,
        uint256 TokenId
    );

    event WithdrawnERC721(
        address Ethereum_Contract_Address,
        address Owner,
        uint256 TokenId
    );

    function initialize() public initializer {
        __Ownable_init();
    }

    function MapContracts(
        address _eth_contract_address,
        address _matic_contract_address
    ) external virtual {
        require(
            AddressUpgradeable.isContract(_eth_contract_address),
            "BridgeEthereum: Invalid address"
        );

        require(
            MapAddressesMatic[_matic_contract_address] == address(0) &&
            MapAddressesEthereum[_eth_contract_address] == address(0) &&
            !MapAddressesStatus[_eth_contract_address][_matic_contract_address],
            "BridgeEthereum: Contract is already mapped"
        );
        require(
            OwnableUpgradeable(_eth_contract_address).owner() == msg.sender,
            "BridgeEthereum: You are not eligible"
        );

        MapAddressesMatic[_matic_contract_address] = _eth_contract_address;
        MapAddressesEthereum[_eth_contract_address] = _matic_contract_address;
        MapAddressesStatus[_eth_contract_address][_matic_contract_address] = true;

        emit Mapped(_eth_contract_address, _matic_contract_address);
    }

    function depositERC721(address _eth_contract_address, uint256 _token_id)
        external
        virtual
    {
        require(
            MapAddressesEthereum[_eth_contract_address] != address(0),
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

    function withdrawERC721(
        WithdrawOrder memory _order,
        bytes memory _signature
    ) external virtual {
        require(
            SignatureCheckerUpgradeable.isValidSignatureNow(
                owner(),
                _order.messageHash,
                _signature
            ) && !checker[_signature],
            "BridgeEthereum: UNAUTHORISED"
        );
        require(_order.owner_address == msg.sender, "BridgeEthereum: Invalid Owner");
        require(
            MapAddressesMatic[_order.eth_contract_address] != address(0),
            "BridgeEthereum: Invalid address"
        );

        checker[_signature] = true;

        IERC721Upgradeable(_order.eth_contract_address).mint(_order.tokenId);

        emit WithdrawnERC721(_order.eth_contract_address, msg.sender, _order.tokenId);
    }
}
