pragma solidity 0.4.24;


contract Greeter {
    string private greeting;

    function Greeter(string _greeter) public {
        greeting = _greeter;
    }

    function greet() public view returns (string) {
        return greeting;
    }

    function setGreeteing(string _greeter) public{
        greeting = _greeter;
    }
}
