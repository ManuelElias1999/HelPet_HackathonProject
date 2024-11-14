// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {RegisterUsers} from "../src/registerUsers.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/registerUsers.t.sol --fork-url https://rpc.test.taiko.xyz
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://explorer.test.taiko.xyz/address/0xd28eb2D29964127D102cD0047A1fee319B328Bca
*/

contract RegisterUsersTest is Test {
    RegisterUsers public registerUsers;
    address owner = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Owner and Agent of the real contract
    address agent = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Agent of the real contract
    address user = makeAddr("user");
    address entity = makeAddr("entity");

    function setUp() public {
        registerUsers = RegisterUsers(0xd28eb2D29964127D102cD0047A1fee319B328Bca);
    }

}