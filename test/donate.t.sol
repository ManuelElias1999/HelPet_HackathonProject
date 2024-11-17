// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/donate.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/donate.t.sol --fork-url https://rpc.test.taiko.xyz
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://hekla.taikoscan.io/address/0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5
*/

contract DonateTest is Test {
    address constant owner = 0xd806A01E295386ef7a7Cea0B9DA037B242622743;
    Donate public donate;
    
    function setUp() public {
        donate = Donate(0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5);
    }
    
    // -----------------------------------
}