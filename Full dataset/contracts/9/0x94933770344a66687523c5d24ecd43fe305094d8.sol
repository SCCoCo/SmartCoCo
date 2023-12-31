/**
 *Submitted for verification at Etherscan.io on 2019-10-17
*/

pragma solidity ^0.5.11;

contract ERC20 {
  function balanceOf(address who) public view returns (uint256);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  function transfer(address to, uint value) public returns(bool);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Burn(address indexed from, uint256 value);
}

contract ERC223 {
    function transfer(address to, uint value, bytes memory data) public returns(bool);
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

contract ERC223ReceivingContract { 
    function tokenFallback(address _from, uint _value, bytes memory _data) public;
}


contract hydrogen is ERC20, ERC223 {
    
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint256 internal _totalSupply;
   
    address internal  _admin;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    
    
    
    
    

    constructor() public {
        
        _admin = msg.sender;
        _symbol = "HYD";  
        _name = "Hydrogen"; 
        _decimals = 8; 
        _totalSupply = 500000000* 10**uint(_decimals);
        balances[msg.sender] = _totalSupply;
    }
    
    
    //Safe Math functions
    function mul(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        if (a == 0) {
        return 0;}
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function name() public view returns (string memory) 
    {
        return _name;
    }

    function symbol() public view returns (string memory) 
    {
        return _symbol;
    }

    function decimals() public view returns (uint8) 
    {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) 
    {
        return _totalSupply;
    }
    
    modifier onlyOwner(){
        require(msg.sender == _admin);
        _;
    }
    
    //ERC20 functions
   function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0) && _value > 0);
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = sub(balances[msg.sender], _value);
        balances[_to] = add(balances[_to], _value);
        emit ERC20.Transfer(msg.sender, _to, _value);
        return true;
   }
   
 

  function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0));
        return balances[_owner];
   }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0) && _from != address(0) && _value > 0);
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        
        balances[_from] = sub(balances[_from], _value);
        balances[_to] = add(balances[_to], _value);
        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
        emit ERC20.Transfer(_from, _to, _value);
        return true;
   }

   function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit ERC20.Approval(msg.sender, _spender, _value);
        return true;
   }

  function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
   }

  
  
  
  function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] -= _value;            // Subtract from the sender
        _totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

   
    // * Destroy tokens from other account
     //*
     //* Remove `_value` tokens from the system irreversibly on behalf of `_from`.
    
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowed[_from][msg.sender]);    // Check allowance
        balances[_from] -= _value;                         // Subtract from the targeted balance
        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        _totalSupply -= _value;                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }
  
  
  
  //ERC223 functions
    function transfer(address _to, uint _value, bytes memory _data) public returns (bool ){
        require(_value > 0 );
        if(isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        balances[msg.sender] = sub(balances[msg.sender],_value);
        balances[_to] = add(balances[_to],(_value));
        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }
    
  function isContract(address _addr) private view returns (bool is_contract) {
      uint length;
      assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
      }
      return (length>0);
    }

}