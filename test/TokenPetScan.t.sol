// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {TokenPetScan} from "../src/TokenPetScan.sol";

contract TokenPetScanTest is Test {
    TokenPetScan public token;
    address owner;
    address agent;
    address user;

    function setUp() public {
        owner = address(this);
        agent = address(0x1);
        user = address(0x2);
        
        vm.startPrank(owner);
        token = new TokenPetScan("PetScan", "PET");
        token.addAgent(agent);
        vm.stopPrank();
    }

    function testMint() public {
        vm.startPrank(agent);
        token.mint(user, 100);
        assertEq(token.balanceOf(user), 100);
        vm.stopPrank();
    }

    function testBurn() public {
        vm.startPrank(agent);
        token.mint(user, 100);
        token.burn(user, 50);
        assertEq(token.balanceOf(user), 50);
        vm.stopPrank();
    }

    function testFreezeAccount() public {
        vm.startPrank(agent);
        token.freezeAccount(user);
        vm.stopPrank();
    }

    function testRevokeTokens() public {
        vm.startPrank(agent);
        token.mint(user, 100);
        token.revokeTokens(user, 50);
        assertEq(token.balanceOf(user), 50);
        assertEq(token.balanceOf(owner), 50);
        vm.stopPrank();
    }
}
