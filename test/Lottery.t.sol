// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import  {Lottery} from "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;
    address public alice;

    function setUp() public{
        lottery = new Lottery();
        alice = address(128);
        vm.deal(alice,10**18);
    }

    function testBuyLottery() public payable {
        // in state of OPEN
        //TODO need a code to change the state of Lottery contract
        vm.startPrank(alice);
        uint256 count =  lottery.buyLottery{value: 0.02 ether}();
        assertEq(count, 2);
    }
    function testFailBuyLottery() public {
        // in any state 
        lottery.buyLottery{value: 0 ether}();
    }
}