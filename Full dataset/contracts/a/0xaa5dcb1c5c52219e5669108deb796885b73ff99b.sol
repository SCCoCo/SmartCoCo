/**
 *Submitted for verification at Etherscan.io on 2020-10-23
*/

pragma solidity ^0.7.4;

contract ZippieREG {
    function publish(uint256 stream, bytes memory cid) public {
        emit NewEvent(msg.sender, stream, cid);
    }

    event NewEvent(address indexed publisher, uint256 indexed stream, bytes cid);
}