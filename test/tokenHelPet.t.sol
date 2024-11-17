// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {TokenHelPet} from "../src/tokenHelPet.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/tokenHelPet.t.sol --fork-url https://hekla.taikoscan.io
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0x6aDBd13cF9E403E0e6B80226810905a64d2B29fE#code
*/

contract TokenHelPetTest is Test {
    TokenHelPet public token;
    address owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743; // Owner and agent of the real contract
    address user1 = 0xFc6623B340A505E6819349aF6beE2333D31840E1; // User 1


    function setUp() public {
        token = TokenHelPet(0x6aDBd13cF9E403E0e6B80226810905a64d2B29fE);
    }

    // ------------------------------------- Mint ----------------------------------- 
    function test_mint() public {
        // Start impersonating owner who is also an agent
        vm.startPrank(owner);
        
        // Mint 50 tokens to user1 address
        token.mint(user1, 50 * 10**18);
        
        // Verify user1 received 50 tokens
        assertEq(token.balanceOf(user1), 50 * 10**18);
        
        vm.stopPrank();
    }

    function test_fail_mint() public {
        // Start impersonating user1
        vm.startPrank(user1);
        
        // User1 tries to mint tokens for himself, which should fail since he's not owner/agent
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(user1, 50 * 10**18);
        
        vm.stopPrank();
    }

    // ------------------------------------- Burn ----------------------------------- 
    function test_burn() public {
        vm.startPrank(owner);
        // First mint tokens to user1
        token.mint(user1, 50 * 10**18);
        
        // Verify user1 received the tokens
        assertEq(token.balanceOf(user1), 50 * 10**18);
        
        // Then burn the tokens
        token.burn(user1, 50 * 10**18);
        
        // Verify tokens were burned
        assertEq(token.balanceOf(user1), 0);
        vm.stopPrank();
    }

    function test_fail_burn() public {
        // First mint tokens to user1 as owner
        vm.startPrank(owner);
        token.mint(user1, 50 * 10**18);
        vm.stopPrank();

        // Now try to burn tokens as user1 which should fail
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.burn(user1, 50 * 10**18);
        vm.stopPrank();
    }

    // ------------------------------------- Freeze Account ----------------------------------- 
    function test_freezeAccount() public {
        vm.startPrank(owner);
        token.freezeAccount(user1);
        vm.stopPrank();
    }

    function test_fail_freezeAccount() public {
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.freezeAccount(user1);
        vm.stopPrank();
    }

    // ------------------------------------- Freeze Global ----------------------------------- 
    function test_freezeGlobal() public {
        vm.startPrank(owner);
        token.freezeGlobal();
        vm.stopPrank();
    }

    function test_fail_freezeGlobal() public {
        vm.startPrank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.freezeGlobal();
        vm.stopPrank();
    }

}