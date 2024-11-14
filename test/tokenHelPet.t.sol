// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {TokenHelPet} from "../src/tokenHelPet.sol";

contract TokenHelPetTest is Test {
    TokenHelPet public token;
    address owner = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Owner of the real contract
    address agent = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Agent of the real contract
    address user = makeAddr("user");

    function setUp() public {
        token = TokenHelPet(0x6aDBd13cF9E403E0e6B80226810905a64d2B29fE);
    }

}