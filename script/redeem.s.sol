// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Redeem} from "../src/redeem.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenHelPet} from "../src/tokenHelPet.sol";

/**
 * @title RedeemScript
 * @dev Deployment script for Redeem contract
 */

contract RedeemScript is Script {
    // Contract instances
    Redeem public redeem;
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
     * Deploys Redeem contract and sets up initial configuration
     */
    function run() public {
        vm.startBroadcast();

        // Deploy dependency contracts first
        registerUsers = new RegisterUsers();
        tokenHelPet = new TokenHelPet("PetScan Token", "PST");

        // Deploy Redeem with dependencies
        redeem = new Redeem(address(registerUsers), address(tokenHelPet));
        
        // Set up initial agents
        redeem.addAgent(owner);
        registerUsers.addAgent(owner);
        tokenHelPet.addAgent(owner);

        vm.stopBroadcast();
    }
    
}