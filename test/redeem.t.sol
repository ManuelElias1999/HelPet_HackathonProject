// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Redeem} from "../src/redeem.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";

contract RedeemTest is Test {
    Redeem public redeem;
    RegisterUsers public registerUsers;
    TokenPetScan public tokenPetScan;
    
    address owner;
    address user1;
    address entity1;
    address agent;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        entity1 = makeAddr("entity1");
        agent = makeAddr("agent");

        // Deploy contracts
        registerUsers = new RegisterUsers();
        tokenPetScan = new TokenPetScan("PetScan Token", "PST");
        redeem = new Redeem(address(registerUsers), address(tokenPetScan));

        // Setup roles
        registerUsers.addAgent(owner);
        registerUsers.registerUser(user1);
        registerUsers.registerEntity(entity1);
        redeem.addAgent(agent);

        // Give tokens to user1
        tokenPetScan.mint(user1, 1000 ether);
        vm.prank(user1);
        tokenPetScan.approve(address(redeem), type(uint256).max);
    }

    function test_CreatePost() public {
        vm.startPrank(entity1);
        redeem.createPost(10, 100);
        
        (address creator, uint256 stock, uint256 price, bool isOpen) = redeem.posts(0);
        assertEq(creator, entity1);
        assertEq(stock, 10);
        assertEq(price, 100);
        assertTrue(isOpen);
        vm.stopPrank();
    }

    function test_RevertCreatePostNotEntity() public {
        vm.startPrank(user1);
        vm.expectRevert("Only registered entities can create posts");
        redeem.createPost(10, 100);
        vm.stopPrank();
    }

    function test_ClosePost() public {
        vm.prank(entity1);
        redeem.createPost(10, 100);

        vm.prank(entity1);
        redeem.closePost(0);

        (, , , bool isOpen) = redeem.posts(0);
        assertFalse(isOpen);
    }

    function test_AgentCanClosePost() public {
        vm.prank(entity1);
        redeem.createPost(10, 100);

        vm.prank(agent);
        redeem.closePost(0);

        (, , , bool isOpen) = redeem.posts(0);
        assertFalse(isOpen);
    }

    function test_RedeemItem() public {
        vm.prank(entity1);
        redeem.createPost(10, 100);

        uint256 initialBalance = tokenPetScan.balanceOf(user1);
        uint256 initialEntityBalance = tokenPetScan.balanceOf(entity1);

        vm.prank(user1);
        redeem.redeemItem(0);

        (,uint256 stock,,) = redeem.posts(0);
        assertEq(stock, 9);
        assertEq(tokenPetScan.balanceOf(user1), initialBalance - 100);
        assertEq(tokenPetScan.balanceOf(entity1), initialEntityBalance + 100);
    }

    function test_RevertRedeemClosedPost() public {
        vm.prank(entity1);
        redeem.createPost(10, 100);

        vm.prank(entity1);
        redeem.closePost(0);

        vm.prank(user1);
        vm.expectRevert("Post is closed");
        redeem.redeemItem(0);
    }

    function test_RevertRedeemInsufficientBalance() public {
        vm.prank(entity1);
        redeem.createPost(10, 2000 ether);

        vm.prank(user1);
        vm.expectRevert("Insufficient token balance");
        redeem.redeemItem(0);
    }
}
