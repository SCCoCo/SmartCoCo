/**
 *Submitted for verification at Etherscan.io on 2019-10-15
*/

pragma solidity ^0.5.8;

contract Daypick {
    address private _owner;
    mapping(uint32 => string) private _map;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        _owner = msg.sender;
    }

    function changeOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != address(0), 'new owner should not be 0x0!');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function writeDay(uint32 date, string memory data) public onlyOwner {
        _map[date] = data;
    }

    function getDay(uint32 date) public view returns (string memory) {
        return _map[date];
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Only owner can call this function.");
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
}