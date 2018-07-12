pragma solidity 0.4.24;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
        if(n==1)
            return 1;
        if(n==0)
            return 0;
        return fibRecur(n-1)+fibRecur(n-2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public pure returns (uint) {
        uint i = 0;
        uint j = 1;
        uint tmp;
        for (n;n>1;n--) {
            tmp = i;
            i = j;
            j = tmp+j;
        }
        return j;
    }
}
