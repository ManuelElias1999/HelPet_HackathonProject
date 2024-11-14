// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Donate} from "../src/donate.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenHelPet} from "../src/tokenHelPet.sol";

/**
 * @title DonateScript
 * @dev Deployment script for Donate contract
 */
contract DonateScript is Script {
    // Contract instances
    Donate public donate;
    RegisterUsers public registerUsers;
    TokenHelPet public tokenHelPet;
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
     * Deploys Donate contract and sets up initial configuration
     */
    function run() public {
        vm.startBroadcast();

        // Deploy dependency contracts first
        registerUsers = new RegisterUsers();
        tokenHelPet = new TokenHelPet("PetScan Token", "PST");

        // Deploy Donate with dependencies
        donate = new Donate(address(registerUsers), address(tokenHelPet));
        
        // Set up initial agents
        donate.addAgent(owner);
        registerUsers.addAgent(owner);
        tokenHelPet.addAgent(owner);

        vm.stopBroadcast();
    }
}