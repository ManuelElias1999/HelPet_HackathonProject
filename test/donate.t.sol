// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/donate.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/donate.t.sol --fork-url https://rpc.test.taiko.xyz
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://explorer.test.taiko.xyz/address/0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5
*/

contract DonateTest is Test {
    Donate public donate;
    address owner;
    address user1;
    address entity1;
    address agent;
    
    function setUp() public {
        donate = Donate(0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5);
        
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        entity1 = makeAddr("entity1");
        agent = makeAddr("agent");
    }

}
