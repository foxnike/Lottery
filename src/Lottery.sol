// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Lottery {
    enum Lottery_state {CLOSED, OPEN, SELECT_WINNER, EXCEPTION }
    //legal state transformation is
    // CLOSED to OPEN EXCEPTION
    // OPEN to SELECT_WINNER EXCEPTION
    // SELECT_WINNER to OPEN CLOSE EXCEPTION
    // EXCEPTION to CLOSED 
    error stateError(Lottery_state current, Lottery_state target);

    Lottery_state public state;
    address public admin;
    uint256 public basicBid = 0.01 ether;
    address public oracle;

    uint256 public round;
    uint256 public account;
    address[] public candidate;

    event Winner(uint256 round, address winner, uint256 prize);

    constructor() {
        state = Lottery_state.CLOSED;
        admin = msg.sender;
        round = 0;
    }


    /// @notice use oracle to change system state and call other function
    /// @dev you should read the oracle code before use this function
    /// @param toState a  index of state you want to change to 
    /// @return succ if this call is successful
    function stateFlow(uint256 toState) public returns(bool succ) {
        require(msg.sender == oracle,"stateFlow() is only called by oracle");
        
        
    }


    function getState() public view returns(uint256){
        return uint256(state);
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
        account += count * basicBid;
        // extra gas costs in user ?
        if(msg.value != count * basicBid) {
            uint256 extra = msg.value - count * basicBid;
            payable(msg.sender).transfer(extra);
        }
    }

    // this contract call this function at the right moment
    // return the id of chosen winner
    function selectWinner() internal returns(uint256 winnerId) {
        require(state == Lottery_state.OPEN, "The Lottery system is not open");
        state = Lottery_state.SELECT_WINNER;
        winnerId = getRandomNum(candidate.length);
        uint256 prize = account * 10 / 9;
        emit Winner(round,candidate[winnerId], prize);
        round++;
        // begin next stage
    }

    function getRandomNum(uint256 total) internal returns( uint256 num) {
        
    }

    // this function is called when this contract happens a unexpect error
    // this function will refund all base eth in last round
    function refund() internal returns(bool isSucc) {

    }

    function getNum(address owner) public view returns(uint256 num) {
        for(uint256 i = 0; i < candidate.length; i++) {
            if(candidate[i] == owner) num++;
        }
    }
}