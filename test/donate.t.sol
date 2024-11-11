// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/donate.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DonateTest is Test {
    Donate public donate;
    RegisterUsers public registerUsers;
    TokenPetScan public tokenPetScan;
    address owner;
    address user1;
    address entity1;
    address agent;
    
    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        entity1 = makeAddr("entity1");
        agent = makeAddr("agent");
        
        vm.startPrank(owner);
        
        // Deploy contracts
        registerUsers = new RegisterUsers();
        tokenPetScan = new TokenPetScan("PetScan Token", "PST");
        donate = new Donate(address(registerUsers), address(tokenPetScan));
        
        // Set up roles
        registerUsers.addAgent(agent);
        donate.addAgent(agent);
        
        // Register test users
        vm.stopPrank();

    }

    function testFail_UnregisteredUserCannotDonate() public {
        // Create a post
        vm.prank(entity1);
        donate.createDonationPost(1000, "Test post");
        
        address unregisteredUser = makeAddr("unregistered");
        vm.prank(unregisteredUser);
        donate.donateToPost(0, 100);
    }

    function testFail_UnregisteredEntityCannotCreatePost() public {
        address unregisteredEntity = makeAddr("unregisteredEntity");
        vm.prank(unregisteredEntity);
        donate.createDonationPost(1000, "Test post");
    }

    function testFail_CannotDonateToClosedPost() public {
        // Create and close a post
        vm.prank(entity1);
        donate.createDonationPost(1000, "Test post");
        
        vm.prank(entity1);
        donate.closePost(0);
        
        vm.prank(user1);
        donate.donateToPost(0, 100);
    }
}
