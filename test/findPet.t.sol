// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {FindPet} from "../src/findPet.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/findPet.t.sol --fork-url https://rpc.test.taiko.xyz
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://explorer.test.taiko.xyz/address/0x504113E71463E73e516013FBe37EC05aa472B7B3
*/

contract FindPetTest is Test {
    FindPet public findPet;
    address public owner = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Owner and Agent of the real contract
    address public account1 = 0xd806A01E295386ef7a7Cea0B9DA037B242622743; // No Agent and no own of the real contract
    address public account2 = 0x9b63FA365019Dd7bdF8cBED2823480F808391970; // No Agent and no Owner of the real contract

    function setUp() public {
        findPet = FindPet(0x504113E71463E73e516013FBe37EC05aa472B7B3); 
    }
    
}