// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";

/**
 * @title TokenPetScanScript
 * @dev Deployment script for TokenPetScan contract
 */
contract TokenPetScanScript is Script {
    // Instance of the TokenPetScan contract
    TokenPetScan public token;
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
     * Deploys TokenPetScan contract and sets up initial agent
     */
    function run() public {
        setUp();
        vm.startBroadcast();

        // Deploy new token contract with name "PetScan" and symbol "PET"
        token = new TokenPetScan("PetScan", "PET");
        // Add deployer as an agent
        token.addAgent(owner);

        vm.stopBroadcast();
    }
}
