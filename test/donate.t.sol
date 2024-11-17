// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/donate.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/donate.t.sol --fork-url https://hekla.taikoscan.io
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5
*/

contract DonateTest is Test {
    address constant owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743;
    address constant user1 = 0x9F693ea18DA08824E729d5efc343Dd78254a9302;
    address constant user2 = 0xFc6623B340A505E6819349aF6beE2333D31840E1;
    address constant entity1 = 0x9b63FA365019Dd7bdF8cBED2823480F808391970;
    Donate public donate;
    
    function setUp() public {
        donate = Donate(0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5);
    }
    
    // ----------------------------------- Donation post ----------------------------------- 
    function test_createPost() public {
        vm.startPrank(entity1);
        donate.createDonationPost(100, "Test donation post");
        vm.stopPrank();
    }

    function test_fail_createPost() public {
        vm.startPrank(user1);
        vm.expectRevert("Only registered entities can create posts");
        donate.createDonationPost(100, "Test donation post");
        vm.stopPrank();
    }
    // ----------------------------------- Close Post ----------------------------------- 
    function test_closePost() public {
        // First create a donation post
        vm.startPrank(entity1);
        donate.createDonationPost(100, "Test donation post");
        vm.stopPrank();

        // Then close it
        vm.startPrank(entity1);
        donate.closePost(0); // Pass post ID
        vm.stopPrank();
    }

    function test_fail_closePost() public {
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        donate.closePost(0);
        vm.stopPrank();
    }

    // ----------------------------------- Donate ----------------------------------- 
    function test_donate() public {
        // First create a donation post
        vm.startPrank(entity1);
        donate.createDonationPost(100, "Test donation post");
        vm.stopPrank();

        // Then user1 donates to the post
        vm.startPrank(user1);
        donate.donateToPost(0, 50);
        vm.stopPrank();
    }

    function test_fail_donate() public {
        vm.startPrank(user2);
        vm.expectRevert("Invalid amount");
        donate.donateToPost(0, 0);
        vm.stopPrank();
    }
    
}