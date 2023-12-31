/**
 *Submitted for verification at Etherscan.io on 2019-11-16
*/

pragma solidity ^0.4.16;
 
interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract owned {
    address public owner;

    function owned () public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
 
  }
 
contract TokenERC20 is owned {
    string public name; 
    string public symbol; 
    uint8 public decimals = 8;  
    uint256 public totalSupply; 
 
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);  
 
    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {

        totalSupply = initialSupply * 10 ** uint256(decimals);   

        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
 

    function _transfer(address _from, address _to, uint256 _value) internal {
 
      require(_to != 0x0);
 
      require(balanceOf[_from] >= _value);
 
      require(balanceOf[_to] + _value > balanceOf[_to]);
 
      uint previousBalances = balanceOf[_from] + balanceOf[_to];
 
      balanceOf[_from] -= _value;
 
      balanceOf[_to] += _value;
 
      Transfer(_from, _to, _value);
 
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
 
    }
 
  }