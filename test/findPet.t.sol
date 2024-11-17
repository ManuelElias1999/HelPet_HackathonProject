// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {FindPet} from "../src/findPet.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/findPet.t.sol --fork-url https://hekla.taikoscan.io
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0x504113E71463E73e516013FBe37EC05aa472B7B3#code
*/

contract FindPetTest is Test {
    FindPet public findPet;
    address public owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743; // Owner and Agent of the real contract
    address public user1 = 0xFc6623B340A505E6819349aF6beE2333D31840E1; // No Agent and no own of the real contract
    address public user2 = 0x9F693ea18DA08824E729d5efc343Dd78254a9302; // No Agent and no Owner of the real contract
    address public user3 = 0x0000000000000000000000000000000000000000; // Invalid address

    function setUp() public {
        findPet = FindPet(0x504113E71463E73e516013FBe37EC05aa472B7B3); 
    }

 
    // ------------------------------------- Create Post ----------------------------------- 
    function test_createPost() public {
        vm.startPrank(user1);
        findPet.createPost(100);
        vm.stopPrank();
    }

    function test_fail_createPost() public {
        vm.startPrank(user3);
        vm.expectRevert("Must be registered user or entity");
        findPet.createPost(100);
        vm.stopPrank();
    }

    // ------------------------------------- Close Post ----------------------------------- 
    function test_closePost() public {
        // First create a post
        vm.startPrank(user1);
        findPet.createPost(100);
        vm.stopPrank();

        // Then close it
        vm.startPrank(owner);
        findPet.closePost(0, user2); // Pass post ID and beneficiary address
        vm.stopPrank();
    }

    function test_fail_closePost() public {
        vm.startPrank(user1);
        vm.expectRevert("Must be registered user or entity");
        findPet.closePost(0, user2);
        vm.stopPrank();
    }
    
}