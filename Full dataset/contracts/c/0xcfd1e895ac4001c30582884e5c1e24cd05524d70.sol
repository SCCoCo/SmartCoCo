/**
 *Submitted for verification at Etherscan.io on 2020-01-14
*/

pragma solidity ^0.4.24;
contract SafeMath {
    

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) { 
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
  

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }
 
   
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        assert(b >=0);
        return a - b;
    }
 
 
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}
 
contract bv is SafeMath{
    
    string public name; 
   
    string public symbol;
    
    uint8 public decimals;
    
    uint256 public totalSupply;
    
    address public owner;
 
    mapping (address => uint256) public balanceOf;
   
    mapping (address => mapping (address => uint256)) public allowance;
    
    mapping (address => uint256) public freezeOf;
 
   
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Freeze(address indexed from, uint256 value);
    event Unfreeze(address indexed from, uint256 value);
 
    constructor( 
        uint256 initialSupply,  
        string tokenName,       
        uint8 decimalUnits,     
        string tokenSymbol      
    ) public {
        decimals = decimalUnits;                           
        balanceOf[msg.sender] = initialSupply * 10 ** 18;    
        totalSupply = initialSupply * 10 ** 18;   
        name = tokenName;      
        symbol = tokenSymbol;
        owner = msg.sender;
    }
 
  
    function transfer(address _to, uint256 _value) public {

        assert(_to != 0x0);
                    
        assert(_value > 0);

        assert(balanceOf[msg.sender] >= _value);
 
        assert(balanceOf[_to] + _value >= balanceOf[_to]);
      
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     
      
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
      
        emit Transfer(msg.sender, _to, _value);// Notify anyone listening that this transfer took place
    }
 
   
    function approve(address _spender, uint256 _value) public returns (bool success) {
        assert(_value > 0);
        allowance[msg.sender][_spender] = _value;
        return true;
    }
 

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        
        assert(_to != 0x0);
      
        assert(_value > 0);
       
        assert(balanceOf[_from] >= _value);
       
        assert(balanceOf[_to] + _value >= balanceOf[_to]);
        
        assert(_value <= allowance[_from][msg.sender]);
       
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); 
       
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
      
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
 
 
    function burn(uint256 _value) public returns (bool success) {
        
        assert(balanceOf[msg.sender] >= _value);
       
        assert(_value > 0);
        
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
        
        totalSupply = SafeMath.safeSub(totalSupply,_value);
        
        emit Burn(msg.sender, _value);
        return true;
    }
 
  
    function freeze(uint256 _value) public returns (bool success) {
        
        assert(balanceOf[msg.sender] >= _value);
       
        assert(_value > 0);
       
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); 
        
        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); 
       
        emit Freeze(msg.sender, _value);
        return true;
    }
 
    
    function unfreeze(uint256 _value) public returns (bool success) {
       
        assert(freezeOf[msg.sender] >= _value);
       
        assert(_value > 0); 
     
        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); 
        
        balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);    
        
        emit Unfreeze(msg.sender, _value);
        return true;
    }
 

    function withdrawEther(uint256 amount) public {
        
        assert(msg.sender == owner);
        
        owner.transfer(amount);
    }
}