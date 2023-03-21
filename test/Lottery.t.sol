// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import  {Lottery} from "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;
    address public alice;

    function setup() public{
        lottery = new Lottery();
        alice = address(128);
        vm.deal(alice,10**18);
    }

    function testBuyLottery() public payable {
        // how to add ether in below transaction ?
        vm.prank(alice);
        lottery.buyLottery{value: 0.02 ether}();
    }
    function testFailBuyLottery() public {
        lottery.buyLottery();
    }
}