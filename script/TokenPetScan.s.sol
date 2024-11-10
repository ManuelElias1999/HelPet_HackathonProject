// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TokenPetScan} from "../src/TokenPetScan.sol";

contract TokenPetScanScript is Script {
    TokenPetScan public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new TokenPetScan("PetScan", "PET");

        vm.stopBroadcast();
    }
}
