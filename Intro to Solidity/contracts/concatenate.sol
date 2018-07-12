pragma solidity 0.4.24;


contract Concatenate {
    function concatWithoutImport(string _s, string _t) public pure returns (string) {
        bytes memory b_s = bytes(_s);
        bytes memory b_t = bytes(_t);
        
        string memory concat = new string(b_s.length+b_t.length);
        bytes memory b_concat = bytes(concat);
        
        uint i;
        uint j = 0;
        for(i = 0;i<b_s.length;i++)
            b_concat[j++] = b_s[i];
        for(i = 0;i<b_t.length;i++)
            b_concat[j++] = b_t[i];

        return string(b_concat);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
