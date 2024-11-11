// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {FindPet} from "../src/findPet.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";

/**
 * @title FindPetScript
 * @dev Deployment script for FindPet contract
 */
contract FindPetScript is Script {
    // Contract instances
    FindPet public findPet;
    RegisterUsers public registerUsers;
    TokenPetScan public tokenPetScan;
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
     * Deploys FindPet contract and sets up initial configuration
     */
    function run() public {
        vm.startBroadcast();

        // Deploy dependency contracts first
        registerUsers = new RegisterUsers();
        tokenPetScan = new TokenPetScan("PetScan Token", "PST");

        // Deploy FindPet with dependencies
        findPet = new FindPet(address(registerUsers), address(tokenPetScan));
        
        // Set up initial agents
        findPet.addAgent(owner);
        registerUsers.addAgent(owner);
        tokenPetScan.addAgent(owner);

        vm.stopBroadcast();
    }
}