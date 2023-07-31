/**

 *Submitted for verification at Etherscan.io on 2018-10-18

*/



//PPPPPPPPPPPPPPPPP   LLLLLLLLLLL            UUUUUUUU     UUUUUUUUTTTTTTTTTTTTTTTTTTTTTTTUUUUUUUU     UUUUUUUU   SSSSSSSSSSSSSSS 

//P::::::::::::::::P  L:::::::::L            U::::::U     U::::::UT:::::::::::::::::::::TU::::::U     U::::::U SS:::::::::::::::S

//P::::::PPPPPP:::::P L:::::::::L            U::::::U     U::::::UT:::::::::::::::::::::TU::::::U     U::::::US:::::SSSSSS::::::S

//PP:::::P     P:::::PLL:::::::LL            UU:::::U     U:::::UUT:::::TT:::::::TT:::::TUU:::::U     U:::::UUS:::::S     SSSSSSS

//  P::::P     P:::::P  L:::::L               U:::::U     U:::::U TTTTTT  T:::::T  TTTTTT U:::::U     U:::::U S:::::S            

//  P::::P     P:::::P  L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U S:::::S            

//  P::::PPPPPP:::::P   L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U  S::::SSSS         

//  P:::::::::::::PP    L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U   SS::::::SSSSS    

//  P::::PPPPPPPPP      L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U     SSS::::::::SS  

//  P::::P              L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U        SSSSSS::::S 

//  P::::P              L:::::L               U:::::D     D:::::U         T:::::T         U:::::D     D:::::U             S:::::S

//  P::::P              L:::::L         LLLLLLU::::::U   U::::::U         T:::::T         U::::::U   U::::::U             S:::::S

//PP::::::PP          LL:::::::LLLLLLLLL:::::LU:::::::UUU:::::::U       TT:::::::TT       U:::::::UUU:::::::U SSSSSSS     S:::::S

//P::::::::P          L::::::::::::::::::::::L UU:::::::::::::UU        T:::::::::T        UU:::::::::::::UU  S::::::SSSSSS:::::S

//P::::::::P          L::::::::::::::::::::::L   UU:::::::::UU          T:::::::::T          UU:::::::::UU    S:::::::::::::::SS 

//PPPPPPPPPP          LLLLLLLLLLLLLLLLLLLLLLLL     UUUUUUUUU            TTTTTTTTTTT            UUUUUUUUU       SSSSSSSSSSSSSSS  



//Token Name    : PLUTUS

//symbol        : PTU

//decimals      : 8

//website       : plutusofficial.tk



pragma solidity ^0.4.23;





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

    mapping (address => uint256) public freezeOf;

}





library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        assert(c / a == b);

        return c;

    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return a / b;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        assert(c >= a);

        return c;

    }

}



    contract ForeignToken {

        function balanceOf(address _owner) constant public returns (uint256);

        function transfer(address _to, uint256 _value) public returns (bool);

    }









contract PLUTUS is ERC20 {

    using SafeMath for uint256;

    address owner = msg.sender;

    

    mapping (address => uint256) balances;

    

    mapping (address => mapping (address => uint256)) allowed;   

    

    string public constant name = "PLUTUS"; //* Token Name *//

    

    string public constant symbol = "PTU"; //* PLUTUS Symbol *//

    

    uint public constant decimals = 8; //* Number of Decimals *//

    

    uint256 public totalSupply = 5000000000000000000; //* total supply of PLUTUS *//

    

    uint256 public totalDistributed =  0;  //* Initial PLUTUS that will give to contract creator *//

    

    uint256 public constant MIN = 1 ether / 100;  //* Minimum Contribution for PLUTUS //

    

    uint256 public tokensPerEth = 2000000000000000; //* PLUTUS Amount per Ethereum *//

    

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    

    event Distr(address indexed to, uint256 amount);

    

    event DistrFinished();

    event Airdrop(address indexed _owner, uint _amount, uint _balance);

    

    event TokensPerEthUpdated(uint _tokensPerEth);

    

    event Burn(address indexed burner, uint256 value);

    

    event Freeze(address indexed from, uint256 value); //event freezing

    

    event Unfreeze(address indexed from, uint256 value); //event Unfreezing

    

    bool public distributionFinished = false;

    

    modifier canDistr() {

        require(!distributionFinished);

        _;

    }



    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }

    

    function PLUTUS () public {

        owner = msg.sender;    

        distr(owner, totalDistributed);

    }



    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

            owner = newOwner;

        }

    }

    

    function finishDistribution() onlyOwner canDistr public returns (bool) {

        distributionFinished = true;

        emit DistrFinished();

        return true;

    }

    

    function distr(address _to, uint256 _amount) canDistr private returns (bool) {

        totalDistributed = totalDistributed.add(_amount);        

        balances[_to] = balances[_to].add(_amount);

        emit Distr(_to, _amount);

        emit Transfer(address(0), _to, _amount);



        return true;

    }



    function doAirdrop(address _participant, uint _amount) internal {



        require( _amount > 0 );      



        require( totalDistributed < totalSupply );

        

        balances[_participant] = balances[_participant].add(_amount);

        totalDistributed = totalDistributed.add(_amount);



        if (totalDistributed >= totalSupply) {

            distributionFinished = true;

        }

        emit Airdrop(_participant, _amount, balances[_participant]);

        emit Transfer(address(0), _participant, _amount);

    }



    function AirdropSingle(address _participant, uint _amount) public onlyOwner {        

        doAirdrop(_participant, _amount);

    }



    function AirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        

        for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);

    }



    function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        

        tokensPerEth = _tokensPerEth;

        emit TokensPerEthUpdated(_tokensPerEth);

    }

           

    function () external payable {

        getTokens();

     }

    

    function getTokens() payable canDistr  public {

        uint256 tokens = 0;

        require( msg.value >= MIN );

        require( msg.value > 0 );

        tokens = tokensPerEth.mul(msg.value) / 1 ether;        

        address investor = msg.sender;

        

        if (tokens > 0) {

            distr(investor, tokens);

        }



        if (totalDistributed >= totalSupply) {

            distributionFinished = true;

        }

    }





    modifier onlyPayloadSize(uint size) {

        assert(msg.data.length >= size + 4);

        _;

    }



    function balanceOf(address _owner) constant public returns (uint256) {

        return balances[_owner];

    }

    

    

    function freeze(uint256 _value) returns (bool success) {

        if (balances[msg.sender] < _value) throw;                               // Check if the sender has enough

		if (_value <= 0) throw; 

        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      // Subtract from the sender

        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       // Updates totalSupply

        Freeze(msg.sender, _value);

        return true;

    }

	

	function unfreeze(uint256 _value) returns (bool success) {

        if (freezeOf[msg.sender] < _value) throw;                               // Check if the sender has enough

		if (_value <= 0) throw; 

        freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);      // Subtract from the sender

		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);

        Unfreeze(msg.sender, _value);

        return true;

    }

    

    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {

        //check if sender has balance and for oveflow

        require(_to != address(0));

        require(_amount <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        emit Transfer(msg.sender, _to, _amount);

        return true;

    }

    

    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {

        require(_to != address(0));

        require(_amount <= balances[_from]);

        require(_amount <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_amount);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        emit Transfer(_from, _to, _amount);

        return true;

    }



    //allow the contract owner to withdraw any token that are not belongs to PLUTUS Community

     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {

        ForeignToken token = ForeignToken(_tokenContract);

        uint256 amount = token.balanceOf(address(this));

        return token.transfer(owner, amount);

    } //withdraw foreign tokens

    

    function approve(address _spender, uint256 _value) public returns (bool success) {

        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    } 

    

    

    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){

        ForeignToken t = ForeignToken(tokenAddress);

        uint bal = t.balanceOf(who);

        return bal;

    }

    

    //withdraw Ethereum from Contract address

    function withdrawEther() onlyOwner public {

        address myAddress = this;

        uint256 etherBalance = myAddress.balance;

        owner.transfer(etherBalance);

    }

    

    function allowance(address _owner, address _spender) constant public returns (uint256) {

        return allowed[_owner][_spender];

    }

    

    //Burning specific amount of PLUTUS

    function burnPLUTUS(uint256 _value) onlyOwner public {

        require(_value <= balances[msg.sender]);

        address burner = msg.sender;

        balances[burner] = balances[burner].sub(_value);

        totalSupply = totalSupply.sub(_value);

        totalDistributed = totalDistributed.sub(_value);

        emit Burn(burner, _value);

    } 

    

}