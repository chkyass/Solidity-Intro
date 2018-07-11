pragma solidity ^0.4.0;
contract Betting {
    /* Constructor function, where owner and outcomes are set */
    constructor(uint[] _outcomes) public {
        owner = msg.sender;
        outcomesLength =_outcomes.length;
        for(uint i=0; i<_outcomes.length; i++)
            outcomes[i] = _outcomes[i];
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;
    uint public outcomesLength;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();
    
    
    /* Function code inserted in place of _; */
    modifier ownerOnly() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
        
    }
    
    modifier oracleOnly() {
        require(msg.sender == oracle, "Only oracle can call this function");
        _;
        
    }
    
    modifier outcomeExists(uint outcome) {
        uint i;
        for(i=0; i<outcomesLength; i++) {
            if(outcomes[i] == outcome) {
                break;
            }
        }
        require(i != outcomesLength, "This outcome doesn't exist");
        _;
        
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
        
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public outcomeExists(_outcome) payable returns (bool) {
        require(msg.value > 0, "You have to make a bet");
        require(gamblerA == 0x0 || gamblerB == 0x0);
        
        if(gamblerA == 0x0) {
            gamblerA = msg.sender;
        }
        else if(gamblerB == 0x0 && msg.sender != gamblerA) {
            gamblerB = msg.sender;
            emit BetClosed();
        }
        else {
            
            return false;
        }
        
        Bet memory bet;
        bet.outcome = _outcome;
        bet.amount = msg.value;
        
        bet.initialized = true;
        bets[msg.sender] = bet;
        
        emit BetMade(msg.sender);
        return true;
    }
    
    function getWinner(uint outcome) private view returns(address) {
        if(bets[gamblerA].outcome == outcome)
            return gamblerA;
        if(bets[gamblerB].outcome == outcome)
            return gamblerB;
        return 0xdeadbeef;
    }
    
    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        require(gamblerA != 0x0 && gamblerB != 0x0);
        address winner = getWinner(_outcome);
        
        if(winner == 0xdeadbeef) {
            winnings[oracle] = bets[gamblerA].amount + bets[gamblerB].amount;
        }
        else if(bets[gamblerA].outcome == bets[gamblerB].outcome) {
            winnings[gamblerA] = bets[gamblerA].amount;    
            winnings[gamblerB] = bets[gamblerB].amount;
        }
        else {
            winnings[winner] += bets[gamblerA].amount + bets[gamblerB].amount;
        }
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount >= winnings[msg.sender], "You don't have enough winnings");
        msg.sender.transfer(withdrawAmount);
        winnings[msg.sender] -= withdrawAmount;
        return winnings[msg.sender];
        
    }
    
    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint index) public view returns (uint) {
        require(index < outcomesLength, "index is to high");
        return outcomes[index];
    }
    
    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
        
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete gamblerB;
        delete gamblerA;
        delete oracle;
    }
    
    function getBalance() external returns(uint){
        return address(this).balance;
    }
}
