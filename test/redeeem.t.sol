// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Redeem} from "../src/redeem.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";

contract RedeemTest is Test {
    Redeem public redeem;
    RegisterUsers public registerUsers;
    TokenPetScan public tokenPetScan;

    address owner = makeAddr("owner");
    address agent = makeAddr("agent");
    address entity = makeAddr("entity");
    address user = makeAddr("user");

    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy contracts
        registerUsers = new RegisterUsers();
        tokenPetScan = new TokenPetScan("PetScan Token", "PST");
        redeem = new Redeem(address(registerUsers), address(tokenPetScan));

        // Setup initial roles
        redeem.addAgent(agent);
        registerUsers.addAgent(agent);
        tokenPetScan.addAgent(agent);

        // Register test users
        vm.startPrank(agent);
        registerUsers.registerEntity(entity);
        registerUsers.registerUser(user);
        vm.stopPrank();

        // Give tokens to user
        vm.startPrank(agent);
        tokenPetScan.mint(user, 1000 ether);
        vm.stopPrank();

        vm.stopPrank();
    }

    function testCreatePost() public {
        vm.startPrank(entity);
        redeem.createPost(10, 100 ether);
        
        (address creator, uint256 stock, uint256 price, bool isOpen) = redeem.posts(0);
        
        assertEq(creator, entity);
        assertEq(stock, 10);
        assertEq(price, 100 ether);
        assertTrue(isOpen);
        vm.stopPrank();
    }

    function testRedeemItem() public {
        // Create post first
        vm.startPrank(entity);
        redeem.createPost(10, 100 ether);
        vm.stopPrank();

        // Approve tokens
        vm.startPrank(user);
        tokenPetScan.approve(address(redeem), 100 ether);
        
        // Redeem item
        redeem.redeemItem(0);

        // Verify state changes
        (,uint256 stock,,) = redeem.posts(0);
        assertEq(stock, 9);
        assertEq(tokenPetScan.balanceOf(user), 900 ether);
        assertEq(tokenPetScan.balanceOf(entity), 100 ether);
        vm.stopPrank();
    }

    function testClosePost() public {
        // Create post
        vm.startPrank(entity);
        redeem.createPost(10, 100 ether);
        vm.stopPrank();

        // Close post as agent
        vm.startPrank(agent);
        redeem.closePost(0);
        
        (,,, bool isOpen) = redeem.posts(0);
        assertFalse(isOpen);
        vm.stopPrank();
    }

    function testFailCreatePostNotEntity() public {
        vm.startPrank(user);
        redeem.createPost(10, 100 ether);
        vm.stopPrank();
    }

    function testFailRedeemClosedPost() public {
        // Create and close post
        vm.startPrank(entity);
        redeem.createPost(10, 100 ether);
        redeem.closePost(0);
        vm.stopPrank();

        // Try to redeem
        vm.startPrank(user);
        redeem.redeemItem(0);
        vm.stopPrank();
    }

    function testFailRedeemInsufficientBalance() public {
        // Create post
        vm.startPrank(entity);
        redeem.createPost(10, 2000 ether);
        vm.stopPrank();

        // Try to redeem with insufficient balance
        vm.startPrank(user);
        redeem.redeemItem(0);
        vm.stopPrank();
    }
}
