/**
 *Submitted for verification at Etherscan.io on 2019-12-03
*/

pragma solidity ^0.4.18;

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b); 
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b; 
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
}

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TaurusWallet is ERC20 {

  using SafeMath for uint;
  string public name;
  string public symbol;
  uint8 public decimals;
  mapping(address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;

  function TaurusWallet(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits) public {
    balances[msg.sender] = initialSupply;
    totalSupply = initialSupply;
    name = tokenName;
    decimals = decimalUnits;
    symbol = tokenSymbol;
  }

  function transfer(address to,uint256 value) public returns (bool) {
    require(msg.sender != to);
    require(value > 0);
    require(balances[msg.sender] >= value);

    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);
    Transfer(msg.sender,to,value);

    return true;
  }

  function balanceOf(address addr) public constant returns (uint256) {
    return balances[addr];
  }

  function allowance(address owner, address spender) public constant returns (uint256) {
    return allowed[owner][spender];
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require (balances[from] >= value);
    var _allowance = allowed[from][msg.sender];
    require (_allowance >= value);
    
    balances[to] = balances[to].add(value);
    balances[from] = balances[from].sub(value);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
    Transfer(from, to, value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

}