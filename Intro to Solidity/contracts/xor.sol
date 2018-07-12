pragma solidity 0.4.24;


contract XOR {
    function xor(uint a, uint b) public pure returns (uint) {
        require((a==1 || a==0) && (b==0 || b==1));
        return a^b;
    }

    function sxor(string a, string b) public pure returns(string){
        bytes memory b_a = bytes(a);
        bytes memory b_b = bytes(b);
        require (b_a.length == b_b.length);
        
        string memory tmp = new string(b_a.length);
        bytes memory xored = bytes(tmp);
        for(uint i = 0; i<b_a.length;i++) {
            uint8 i_a = uint8(b_a[i])-48;
            uint8 i_b = uint8(b_b[i])-48;
            require((i_a==1 || i_a==0) && (i_b==0 || i_b==1));
            xored[i] = byte((i_a^i_b)+48);
        }
    
        return string(xored);
    }
}
