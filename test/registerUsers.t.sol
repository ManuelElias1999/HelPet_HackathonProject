// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {RegisterUsers} from "../src/registerUsers.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/registerUsers.t.sol --fork-url https://hekla.taikoscan.io
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0xd28eb2D29964127D102cD0047A1fee319B328Bca#code
*/

contract RegisterUsersTest is Test {
    RegisterUsers public registerUsers;
    address owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743; // Owner and agent of the real contract
    address user1 = 0xFc6623B340A505E6819349aF6beE2333D31840E1; // User 1
    address user2 = 0x9F693ea18DA08824E729d5efc343Dd78254a9302; // User 2

    function setUp() public {
        registerUsers = RegisterUsers(0xd28eb2D29964127D102cD0047A1fee319B328Bca);
    }

    // ------------------------------------- Register User ----------------------------------- 
    function test_registerUser() public {
        vm.startPrank(owner);
        registerUsers.registerUser(user1);
        vm.stopPrank();
    }

    function test_fail_registerUser() public {
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        registerUsers.registerUser(user1);
        vm.stopPrank();
    }

    // ------------------------------------- Register Entity ----------------------------------- 
    function test_registerEntity() public {
        vm.startPrank(owner);
        registerUsers.registerEntity(user2);
        vm.stopPrank();
    }

    function test_fail_registerEntity() public {
        vm.startPrank(user2);
        vm.expectRevert("Ownable: caller is not the owner");
        registerUsers.registerEntity(user2);
        vm.stopPrank();
    }

}