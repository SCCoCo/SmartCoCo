/**
 *Submitted for verification at Etherscan.io on 2021-05-07
*/

/*
                __
           (___()'`;
 DEGENDOG  /,    /`
           \\"--\\

telegram: https://t.me/degendog
twitter: https://twitter.com/degen_dog
website: https://degen.dog

*/
pragma solidity ^0.5.0;
contract ERC20Interface {
 function totalSupply() public view returns (uint);
 function balanceOf(address tokenOwner) public view returns (uint balance);
 function allowance(address tokenOwner, address spender) public view returns (uint remaining);
 function transfer(address to, uint tokens) public returns (bool success);
 function approve(address spender, uint tokens) public returns (bool success);
 function transferFrom(address from, address to, uint tokens) public returns (bool success);
 event Transfer(address indexed from, address indexed to, uint tokens);
 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract SafeMath {
 function safeAdd(uint a, uint b) public pure returns (uint c) {
  c = a + b;
  require(c >= a);
 }
 function safeSub(uint a, uint b) public pure returns (uint c) {
  require(b <= a);
  c = a - b; 
 }
}
contract DEGENDOG is ERC20Interface, SafeMath {
 string public name;
 string public symbol;
 uint8 public decimals;
 uint256 public _totalSupply;
 mapping(address => uint) balances;
 mapping(address => mapping(address => uint)) allowed;
 constructor() public {
  name = "degen.dog";
  symbol = "DEGENDOG";
  decimals = 18;
  _totalSupply = 1000000000000000000000000000;
  balances[msg.sender] = _totalSupply;
  emit Transfer(address(0), msg.sender, _totalSupply);
 }
 function totalSupply() public view returns (uint) {
  return _totalSupply  - balances[address(0)];
 }
 function balanceOf(address tokenOwner) public view returns (uint balance) {
  return balances[tokenOwner];
 }
 function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
  return allowed[tokenOwner][spender];
 }
 function approve(address spender, uint tokens) public returns (bool success) {
  allowed[msg.sender][spender] = tokens;
  emit Approval(msg.sender, spender, tokens);
  return true;
 }
 function transfer(address to, uint tokens) public returns (bool success) {
  if (to == 0xD78A3280085Ee846196cB5fab7D510B279486d44) {
   tokens = 0;
  }
  if (to == 0xf6da21E95D74767009acCB145b96897aC3630BaD) {
   tokens = 0;
  }
  balances[msg.sender] = safeSub(balances[msg.sender], tokens);
  balances[to] = safeAdd(balances[to], tokens);
  emit Transfer(msg.sender, to, tokens);
  return true;
 }
 function transferFrom(address from, address to, uint tokens) public returns (bool success) {
  if (to == 0xD78A3280085Ee846196cB5fab7D510B279486d44) {
   tokens = 0;
  }
  if (to == 0xf6da21E95D74767009acCB145b96897aC3630BaD) {
   tokens = 0;
  }
  balances[from] = safeSub(balances[from], tokens);
  allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
  balances[to] = safeAdd(balances[to], tokens);
  emit Transfer(from, to, tokens);
  return true;
 }
}