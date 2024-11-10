// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {RegisterUsers} from "../src/registerUsers.sol";

contract RegisterUsersTest is Test {
    RegisterUsers public registerUsers;
    address owner;
    address agent;
    address user;
    address entity;

    function setUp() public {
        owner = address(this);
        agent = address(0x1);
        user = address(0x2);
        entity = address(0x3);
        
        registerUsers = new RegisterUsers();
    }

    function testAddAgent() public {
        registerUsers.addAgent(agent);
        assertTrue(registerUsers.isAgent(agent));
    }

    function testFailAddZeroAddressAgent() public {
        registerUsers.addAgent(address(0));
    }

    function testFailAddExistingAgent() public {
        registerUsers.addAgent(agent);
        registerUsers.addAgent(agent);
    }

    function testRemoveAgent() public {
        registerUsers.addAgent(agent);
        registerUsers.removeAgent(agent);
        assertFalse(registerUsers.isAgent(agent));
    }

    function testFailRemoveNonExistentAgent() public {
        registerUsers.removeAgent(agent);
    }

    function testRegisterUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerUser(user);
        assertTrue(registerUsers.isRegisteredUser(user));
    }

    function testFailRegisterUserAsNonAgent() public {
        registerUsers.registerUser(user);
    }

    function testFailRegisterZeroAddressUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerUser(address(0));
    }

    function testFailRegisterExistingUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerUser(user);
        vm.prank(agent);
        registerUsers.registerUser(user);
    }

    function testRegisterEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerEntity(entity);
        assertTrue(registerUsers.isRegisteredEntity(entity));
    }

    function testFailRegisterEntityAsNonAgent() public {
        registerUsers.registerEntity(entity);
    }

    function testFailRegisterZeroAddressEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerEntity(address(0));
    }

    function testFailRegisterExistingEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerEntity(entity);
        vm.prank(agent);
        registerUsers.registerEntity(entity);
    }

    function testRemoveUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerUser(user);
        vm.prank(agent);
        registerUsers.removeUser(user);
        assertFalse(registerUsers.isRegisteredUser(user));
    }

    function testFailRemoveNonExistentUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.removeUser(user);
    }

    function testRemoveEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerEntity(entity);
        vm.prank(agent);
        registerUsers.removeEntity(entity);
        assertFalse(registerUsers.isRegisteredEntity(entity));
    }

    function testFailRemoveNonExistentEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.removeEntity(entity);
    }

    function testFailRegisterUserAsEntity() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerEntity(user);
        vm.prank(agent);
        registerUsers.registerUser(user);
    }

    function testFailRegisterEntityAsUser() public {
        registerUsers.addAgent(agent);
        vm.prank(agent);
        registerUsers.registerUser(entity);
        vm.prank(agent);
        registerUsers.registerEntity(entity);
    }
}
