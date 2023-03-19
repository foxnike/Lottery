// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Lottery {
    enum Lottery_state {CLOSED, OPEN, SELECT_WINNER, EXCEPTION }

    Lottery_state public state;
    address public admin;
    uint256 public basicBid = 0.0001 ether;

    address[] public candidate;

    constructor() {
        state = Lottery_state.CLOSED; 
        admin = msg.sender;
    }

    // buyers call this function with some eths,
    // return a num that is the lottery count
    function buyLottery() public payable returns(uint256 count) {
        require(state == Lottery_state.OPEN,"The Lottery system is not open");
        count = msg.value / basicBid;
        // buy lotterys
        for(uint256 i = 0; i < count; i++){
            candidate.push(msg.sender);
        }
        // extra gas costs in user ?
        if(msg.value != count * basicBid) {
            uint256 extra = msg.value - count * basicBid;
            payable(msg.sender).transfer(extra);
        }
    }

    // this contract call this function at the right moment
    // return the id of chosen winner
    function selectWiner(uint256 maxNum) internal returns(uint256 winnerId) {

    }


    // this function is called when this contract happens a unexpect error
    // this function will refund all base eth in last round
    function refund() internal returns(bool isSucc) {

    }
}