// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;

    function setup() public{
        lottery = new Lottery();
    }

    function testBuyLottery() public payable {
        // how to add ether in below transaction ?
        lottery.buyLottery();
    }
    function testFailBuyLottery() public {
        lottery.buyLottery();
    }
}