// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {FindPet} from "../src/findPet.sol";
import {RegisterUsers} from "../src/registerUsers.sol";
import {TokenPetScan} from "../src/tokenPetScan.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FindPetTest is Test {
    FindPet public findPet;
    RegisterUsers public registerUsers;
    TokenPetScan public tokenPetScan;
    address owner;
    address user;
    address entity;
    address agent;
    address beneficiary;

    function setUp() public {
        owner = makeAddr("owner");
        user = makeAddr("user"); 
        entity = makeAddr("entity");
        agent = makeAddr("agent");
        beneficiary = makeAddr("beneficiary");

        vm.startPrank(owner);
        
        // Deploy contracts
        registerUsers = new RegisterUsers();
        tokenPetScan = new TokenPetScan("PetScan Token", "PST");
        findPet = new FindPet(address(registerUsers), address(tokenPetScan));

        // Set up initial agents
        findPet.addAgent(agent);
        registerUsers.addAgent(agent);
        tokenPetScan.addAgent(agent);

        vm.stopPrank();
    }

    function testAddAgent() public {
        vm.prank(owner);
        address newAgent = makeAddr("newAgent");
        findPet.addAgent(newAgent);
        assertTrue(findPet.isAgent(newAgent));
    }

    function testRemoveAgent() public {
        vm.startPrank(owner);
        address newAgent = makeAddr("newAgent");
        findPet.addAgent(newAgent);
        findPet.removeAgent(newAgent);
        assertFalse(findPet.isAgent(newAgent));
        vm.stopPrank();
    }

    function testCreatePost() public {
        // Register user first
        vm.prank(agent);

        uint256 amount = 1000;
        
        // Mock USDC approval and transfer
        mockUSDCTransfer(user, amount);
        
        vm.prank(user);
        findPet.createPost(amount);

        (address creator, uint256 postAmount, bool isOpen) = findPet.getPost(0);
        assertEq(creator, user);
        assertEq(postAmount, amount);
        assertTrue(isOpen);
    }

    function testClosePost() public {
        // Register user and create post
        vm.prank(agent);

        uint256 amount = 1000;
        mockUSDCTransfer(user, amount);
        
        vm.prank(user);
        findPet.createPost(amount);

        // Close post
        mockUSDCTransfer(address(findPet), amount);
        
        vm.prank(agent);
        findPet.closePost(0, beneficiary);

        (,, bool isOpen) = findPet.getPost(0);
        assertFalse(isOpen);
    }

    function testFailCreatePostUnregistered() public {
        vm.prank(user);
        findPet.createPost(1000);
    }

    function testFailClosePostUnauthorized() public {
        vm.prank(address(1));
        findPet.closePost(0, beneficiary);
    }

    // Helper function to mock USDC transfers
    function mockUSDCTransfer(address from, uint256 amount) internal {
        // Mock USDC contract calls
        vm.mockCall(
            findPet.USDC(),
            abi.encodeWithSelector(IERC20.transferFrom.selector, from, address(findPet), amount),
            abi.encode(true)
        );
    }
}
