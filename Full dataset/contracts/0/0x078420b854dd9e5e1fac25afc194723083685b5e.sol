/**
 *Submitted for verification at Etherscan.io on 2019-09-12
*/

pragma solidity ^0.5.4;

contract truth{
    bool public x;
    address payable z;
    
    constructor() public{
        z = msg.sender;
    }
    
    function vote(bool y) public payable{
        x=y;
    }
    
    function transf() public{
        z.transfer(address(this).balance);
    }
}