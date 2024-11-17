// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Redeem} from "../src/redeem.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/redeem.t.sol --fork-url https://hekla.taikoscan.io
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A
*/

contract RedeemTest is Test {
    Redeem public redeem;
    address constant owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743;
    address constant user1 = 0x9F693ea18DA08824E729d5efc343Dd78254a9302;
    address constant user2 = 0xFc6623B340A505E6819349aF6beE2333D31840E1;
    address constant entity1 = 0x9b63FA365019Dd7bdF8cBED2823480F808391970;

    function setUp() public {
        redeem = Redeem(0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A);
    }

    // ----------------------------------- Create post ----------------------------------- 
    function test_createPost() public {
        vm.startPrank(entity1);
        redeem.createPost(100, 100);
        vm.stopPrank();
    }

    function test_fail_createPost() public {
        vm.startPrank(user1);
        vm.expectRevert("Only registered entities can create posts");
        redeem.createPost(100, 100);
        vm.stopPrank();
    }

    // ----------------------------------- Close post ----------------------------------- 
    function test_closePost() public {
        // First create a post
        vm.startPrank(entity1);
        redeem.createPost(100, 100);
        vm.stopPrank();

        // Then close it
        vm.startPrank(entity1);
        redeem.closePost(0); // Pass post ID
        vm.stopPrank();
    }

    function test_fail_closePost() public {
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        redeem.closePost(0);
        vm.stopPrank();
    }

    // ----------------------------------- Redeem item -----------------------------------
    function test_redeemItem() public {
        // First create a post
        vm.startPrank(entity1);
        redeem.createPost(100, 100);
        vm.stopPrank();

        // Then redeem an item
        vm.startPrank(user1);
        redeem.redeemItem(0); // Pass post ID
        vm.stopPrank();
    }

    function test_fail_redeemItem() public {
        vm.startPrank(user2);
        vm.expectRevert("Only registered users or entities can redeem");
        redeem.redeemItem(0);
        vm.stopPrank();
    }
    
}