// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RegisterUsers} from "../src/registerUsers.sol";

/**
 * @title RegisterUsersScript
 * @dev Deployment script for RegisterUsers contract
 */
contract RegisterUsersScript is Script {
    // Instance of the RegisterUsers contract
    RegisterUsers public registerUsers;
    // Address that will be set as owner and agent
    address owner;

    /**
     * @dev Sets up initial state before deployment
     */
    function setUp() public {
        owner = msg.sender;
    }

    /**
     * @dev Main deployment function
     * Deploys RegisterUsers contract and sets up initial agent
     */
    function run() public {
        vm.startBroadcast();

        // Deploy new RegisterUsers contract
        registerUsers = new RegisterUsers();
        // Add deployer as an agent
        registerUsers.addAgent(owner);

        vm.stopBroadcast();
    }
}