// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract deployed on Taiko Hekla
 * @notice You can view the deployed contract at:
 * https://hekla.taikoscan.io/address/0x6aDBd13cF9E403E0e6B80226810905a64d2B29fE
*/


contract TokenHelPet is ERC20, Ownable {
    // Mapping to track authorized agents
    mapping(address => bool) private agents;
    // Mapping to track frozen accounts
    mapping(address => bool) private frozenAccounts;
    // Global freeze switch
    bool private globalFreeze;
    // Address where tokens can be redeemed
    address public redeemAddressContract;

    // Events for various contract actions
    event AccountFrozen(address indexed account, bool frozen);
    event GlobalFreeze(bool frozen);
    event ForcedTransfer(address indexed from, address indexed to, uint256 value);
    event TokensRevoked(address indexed from, uint256 value);
    event AgentAdded(address indexed agent);
    event AgentRemoved(address indexed agent);

    /**
     * @dev Constructor initializes the token with a name and symbol
     * @param name The name of the token
     * @param symbol The symbol of the token
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {}

    /**
     * @dev Modifier to restrict functions to authorized agents only
     */
    modifier onlyAgent() {
        require(agents[msg.sender], "Only agents can perform this action");
        _;
    }

    /**
     * @dev Adds a new agent to the system
     * @param _agent Address of the agent to add
     */
    function addAgent(address _agent) external onlyOwner {
        agents[_agent] = true;
        emit AgentAdded(_agent);
    }

    /**
     * @dev Removes an agent from the system
     * @param _agent Address of the agent to remove
     */
    function removeAgent(address _agent) external onlyOwner {
        agents[_agent] = false;
        emit AgentRemoved(_agent);
    }

    /**
     * @dev Sets the address where tokens can be redeemed
     * @param _redeemAddress The address of the redemption contract
     */
    function setRedeemAddressContract(address _redeemAddress) external onlyOwner {
        require(_redeemAddress != address(0), "Cannot set zero address");
        redeemAddressContract = _redeemAddress;
    }

    /**
     * @dev Mints new tokens to a specified address
     * @param to Address to receive the minted tokens
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyAgent {
        _mint(to, amount);
    }

    /**
     * @dev Burns tokens from a specified address
     * @param from Address to burn tokens from
     * @param amount Amount of tokens to burn
     */
    function burn(address from, uint256 amount) external onlyAgent {
        _burn(from, amount);
    }

    /**
     * @dev Freezes a specific account
     * @param account Address of the account to freeze
     */
    function freezeAccount(address account) external onlyAgent {
        require(account != address(0), "Cannot freeze zero address");
        frozenAccounts[account] = true;
        emit AccountFrozen(account, true);
    }

    /**
     * @dev Unfreezes a specific account
     * @param account Address of the account to unfreeze
     */
    function unfreezeAccount(address account) external onlyAgent {
        require(account != address(0), "Cannot unfreeze zero address");
        require(frozenAccounts[account], "Account is not frozen");
        frozenAccounts[account] = false;
        emit AccountFrozen(account, false);
    }

    /**
     * @dev Enables global freeze on all transfers
     */
    function freezeGlobal() external onlyAgent {
        globalFreeze = true;
        emit GlobalFreeze(true);
    }

    /**
     * @dev Disables global freeze on all transfers
     */
    function unfreezeGlobal() external onlyAgent {
        globalFreeze = false;
        emit GlobalFreeze(false);
    }

    /**
     * @dev Forces a transfer between two addresses
     * @param from Source address
     * @param to Destination address
     * @param amount Amount of tokens to transfer
     */
    function forceTransfer(address from, address to, uint256 amount) external onlyAgent {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(balanceOf(from) >= amount, "Insufficient balance");

        _transfer(from, to, amount);
        emit ForcedTransfer(from, to, amount);
    }

    /**
     * @dev Revokes tokens from an address and sends them to the owner
     * @param from Address to revoke tokens from
     * @param amount Amount of tokens to revoke
     */
    function revokeTokens(address from, uint256 amount) external onlyAgent {
        require(from != address(0), "Revoke from zero address");
        require(balanceOf(from) >= amount, "Insufficient balance");

        _transfer(from, owner(), amount);
        emit TokensRevoked(from, amount);
    }

    /**
     * @dev Override of ERC20 transfer function to restrict transfers to redeem address only
     * @param to Destination address
     * @param amount Amount of tokens to transfer
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(to == redeemAddressContract, "Transfers are only allowed to redeem address");
        return super.transfer(to, amount);
    }

    /**
     * @dev Override of ERC20 transferFrom function to restrict transfers to redeem address only
     * @param from Source address
     * @param to Destination address
     * @param amount Amount of tokens to transfer
     */
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(to == redeemAddressContract, "Transfers are only allowed to redeem address");
        return super.transferFrom(from, to, amount);
    }
    
}