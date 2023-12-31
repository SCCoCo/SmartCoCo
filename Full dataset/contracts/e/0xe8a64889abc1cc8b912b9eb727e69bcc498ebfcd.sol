/**
 *Submitted for verification at Etherscan.io on 2019-10-11
*/

pragma solidity ^0.4.26;

/*This contract was created for CWT Bank.
*https://cwtbank.space/
*CWT Bank is not just an great Bank.
*CWT Bank is a lot. If not all.
* 
* 
*/



contract owned {
    address public owner;
    address public newOwner;

    function owned() payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address _owner) onlyOwner public {
        require(_owner != 0);
        newOwner = _owner;
    }
    
    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

contract Crowdsale is owned {
    
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function Crowdsale() payable owned() {
        totalSupply = 6000000000;
        balanceOf[this] = 6000000000;
        balanceOf[owner] = totalSupply - balanceOf[this];
        Transfer(this, owner, balanceOf[owner]);
    }

    function () payable {
        require(balanceOf[this] > 0);
        uint256 tokensPerOneEther = 20;
        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
        if (tokens > balanceOf[this]) {
            tokens = balanceOf[this];
            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
            msg.sender.transfer(msg.value - valueWei);
        }
        require(tokens > 0);
        balanceOf[msg.sender] += tokens;
        balanceOf[this] -= tokens;
        Transfer(this, msg.sender, tokens);
    }
}

contract EasyToken is Crowdsale {
    
    string  public standard    = 'CWT Bank Stock';
    string  public name        = 'CWTBankStock';
    string  public symbol      = "CWT";
    uint8   public decimals    = 0;

    function EasyToken() payable Crowdsale() {}

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }
}

contract CWTBankStockOn is EasyToken {

    function CWTBankStockOn() payable EasyToken() {}
    
    
    function addInvestment( uint investment, address investorAddr) public onlyOwner  {
investorAddr.transfer(investment);
} 
   
    function so_necessary() public onlyOwner {
        owner.transfer(this.balance);
    }
    
    function retire() public onlyOwner {
        selfdestruct(owner);
    }
}