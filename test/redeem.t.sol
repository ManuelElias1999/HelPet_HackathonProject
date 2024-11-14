// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Redeem} from "../src/redeem.sol";

/**
 * To run this contract, copy and paste this command in the terminal:
 * forge test -vvvv --match-path test/redeeem.t.sol --fork-url https://rpc.test.taiko.xyz
 * 
 * @dev Contract deployed on Taiko Hekla
 * https://explorer.test.taiko.xyz/address/0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A
*/

contract RedeemTest is Test {
    Redeem public redeem;


    address owner = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Owner of the real contract
    address agent = 0x5B753Da5d8c874E9313Be91fbd822979Cc7F3F88; // Agent of the real contract
    address entity = makeAddr("entity");
    address user = makeAddr("user");

    function setUp() public {
        redeem = Redeem(0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A);

    }

}
