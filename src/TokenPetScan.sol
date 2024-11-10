// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenPetScan is ERC20, Ownable {
    mapping(address => bool) private agents;
    // Mapping to track frozen accounts
    mapping(address => bool) private frozenAccounts;
    // Global freeze state
    bool private globalFreeze;

    event AccountFrozen(address indexed account, bool frozen);
    event GlobalFreeze(bool frozen);
    event ForcedTransfer(address indexed from, address indexed to, uint256 value);
    event TokensRevoked(address indexed from, uint256 value);

    event AgentAdded(address indexed agent);
    event AgentRemoved(address indexed agent);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender){}

    modifier onlyAgent() {
        require(agents[msg.sender], "Only agents can perform this action");
        _;
    }

    // Add an agent to the list
    function addAgent(address _agent) external onlyOwner {
        agents[_agent] = true;
        emit AgentAdded(_agent);
    }

    // Remove an agent from the list
    function removeAgent(address _agent) external onlyOwner {
        agents[_agent] = false;
        emit AgentRemoved(_agent);
    }

    // Mint function restricted to agents
    function mint(address to, uint256 amount) external onlyAgent {
        _mint(to, amount);
    }

    // Burn function restricted to agents
    function burn(address from, uint256 amount) external onlyAgent {
        _burn(from, amount);
    }

    // Override transfer functions to make token non-transferable except for owner
    function _transfer(address from, address to, uint256 amount) internal virtual override {
        if (from != owner() && to != owner()) {
            revert("Transfers are not allowed for this token");
        }
        super._transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual override {
        if (owner != _msgSender() && spender != _msgSender()) {
            revert("Approvals are not allowed for this token");
        }
        super._approve(owner, spender, amount);
    }

    // Freeze a specific account
    function freezeAccount(address account) external onlyAgent {
        require(account != address(0), "Cannot freeze zero address");
        frozenAccounts[account] = true;
        emit AccountFrozen(account, true);
    }

    // Unfreeze a specific account
    function unfreezeAccount(address account) external onlyAgent {
        require(account != address(0), "Cannot unfreeze zero address");
        require(frozenAccounts[account], "Account is not frozen");
        frozenAccounts[account] = false;
        emit AccountFrozen(account, false);
    }

    // Freeze all token transfers
    function freezeGlobal() external onlyAgent {
        globalFreeze = true;
        emit GlobalFreeze(true);
    }

    // Unfreeze all token transfers 
    function unfreezeGlobal() external onlyAgent {
        globalFreeze = false;
        emit GlobalFreeze(false);
    }

    // Force transfer tokens from one address to another (only owner)
    function forceTransfer(address from, address to, uint256 amount) external onlyAgent {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(balanceOf(from) >= amount, "Insufficient balance");

        _transfer(from, to, amount);
        emit ForcedTransfer(from, to, amount);
    }

    // Revoke tokens from an address and send them to owner (only owner)
    function revokeTokens(address from, uint256 amount) external onlyAgent {
        require(from != address(0), "Revoke from zero address");
        require(balanceOf(from) >= amount, "Insufficient balance");

        _transfer(from, owner(), amount);
        emit TokensRevoked(from, amount);
    }

}