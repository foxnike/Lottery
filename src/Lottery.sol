// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Lottery {
    uint256 public stateCount = 3;
    enum LotteryState {CLOSED, OPEN, SELECT_WINNER, EXCEPTION }
    //legal state transformation is
    // CLOSED to OPEN EXCEPTION
    // OPEN to SELECT_WINNER EXCEPTION
    // SELECT_WINNER to OPEN CLOSE EXCEPTION
    // EXCEPTION to CLOSED 
    error stateError(LotteryState current, LotteryState target);

    LotteryState public state;
    address public admin;
    uint256 public basicBid = 0.01 ether;
    address public oracle;

    uint256 public round;
    uint256 public account;
    address[] public candidate;

    event NewRound(string details, uint256 round);

    event SelectWinner(string details, uint256 round, uint256 prize);

    event produceWinner(uint256 round, address winner, uint256 prize);

    event closeSystem(string details);

    constructor() {
        state = LotteryState.CLOSED;
        admin = msg.sender;
        round = 0;
    }


    /// @notice use oracle to change system state and call other function
    /// @dev you should read the oracle code before use this function
    /// @param toState a  index of state you want to change to 
    /// @return succ if this call is successful
    function stateFlow(uint256 toState) public returns(bool succ) {
        require(msg.sender == oracle,"stateFlow() is only called by oracle");
        require(toState <= stateCount,"toState is an illegal index");
        LotteryState target = LotteryState(toState);
        try this.handleChange(state,target) {
            succ = true;
        }catch {
            succ = false;
            revert stateError(state,target);
            //TODO need a error output
        }
    }
    /// @notice this function handle the process between state changes
    /// @param current current system state variable
    /// @param target tatget state wanted to change to
    function handleChange(LotteryState current,LotteryState target) external {
        if(current == LotteryState.CLOSED && target == LotteryState.OPEN) {
            state = LotteryState.OPEN;
            round++;
            emit NewRound("The Lottery System is open now",round);
        }else
        if(current == LotteryState.OPEN && target == LotteryState.SELECT_WINNER) {
            state = LotteryState.SELECT_WINNER;
            emit SelectWinner("The Lottery System is selecting winner",round,candidate.length);
            selectWinner();
        }else
        if(current == LotteryState.SELECT_WINNER && target == LotteryState.OPEN) {
            delete candidate;
            account = 0;
            state = LotteryState.OPEN;
            round++;
            emit NewRound("The Lottery System is open now",round);
        }else
        if(current == LotteryState.SELECT_WINNER && target == LotteryState.CLOSED) {
            delete candidate;
            account = 0;
            state = LotteryState.CLOSED;
            emit closeSystem("the Lottery System has closed");
        }else {
            revert stateError(state,target);
        }

    }

    // buyers call this function with some eths,
    // return a num that is the lottery count
    function buyLottery() public payable returns(uint256 count) {
        require(state == LotteryState.OPEN,"The Lottery system is not open");
        count = msg.value / basicBid;
        // buy lotterys
        for(uint256 i = 0; i < count; i++){
            candidate.push(msg.sender);
        }
        account += count * basicBid;
        if(msg.value != count * basicBid) {
            uint256 extra = msg.value - count * basicBid;
            payable(msg.sender).transfer(extra);
        }
    }

    // this contract call this function at the right moment
    // return the id of chosen winner
    function selectWinner() internal returns(uint256 winnerId) {
        require(state == LotteryState.OPEN, "The Lottery system is not open");
        state = LotteryState.SELECT_WINNER;
        winnerId = getRandomNum(candidate.length);
        address payable winner = payable(candidate[winnerId]);
        uint256 prize = account * 10 / 9;
        winner.transfer(prize);
        emit produceWinner(round,winner, prize);
    }

    function getRandomNum(uint256 total) internal returns( uint256 num) {
        
    }

    // this function is called when this contract happens a unexpect error
    // this function will refund all base eth in last round
    // this function should be called only by contract
    function refund() internal {
        uint256 count = 0;
        address current = candidate[0];
        for(uint256 i = 0; i < candidate.length; i++) {
            if(current == candidate[i]){
                count++;
            }else{
                payable(current).transfer(basicBid * count);
                count = 1;
                current = candidate[i];
            }
        }
    }

    function getNum(address owner) public view returns(uint256 num) {
        for(uint256 i = 0; i < candidate.length; i++) {
            if(candidate[i] == owner) num++;
        }
    }

    function getState() public view returns(uint256){
        return uint256(state);
    }
    function getRound() public view returns(uint256){
        return round;
    }
}