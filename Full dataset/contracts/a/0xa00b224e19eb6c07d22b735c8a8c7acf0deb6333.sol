/**
 *Submitted for verification at Etherscan.io on 2019-11-04
*/

pragma solidity ^0.4.23;

contract CoinBcu // @eachvar
{
    // ======== ��ʼ����������߼� ==============
    // ��ַ��Ϣ
    address public admin_address = 0xE69dcb576c93b4CC440C72E5A7A67CB4484163e8; // @eachvar
    address public account_address = 0xE69dcb576c93b4CC440C72E5A7A67CB4484163e8; // @eachvar ��ʼ����ת����ҵĵ�ַ
    
    // �����˻����
    mapping(address => uint256) balances;
    
    // solidity ���Զ�Ϊ public �������ӷ����������±���Щ���������ܻ�ô��ҵĻ�����Ϣ��
    string public name = "Block Coin Chips UP"; // @eachvar
    string public symbol = "BCU"; // @eachvar
    uint8 public decimals = 18; // @eachvar
    uint256 initSupply = 210000000; // @eachvar
    uint256 public totalSupply = 0; // @eachvar

    // ���ɴ��ң���ת�뵽 account_address ��ַ
    constructor() 
    payable 
    public
    {
        totalSupply = mul(initSupply, 10**uint256(decimals));
        balances[account_address] = totalSupply;

        
    }

    function balanceOf( address _addr ) public view returns ( uint )
    {
        return balances[_addr];
    }

    // ========== ת������߼� ====================
    event Transfer(
        address indexed from, 
        address indexed to, 
        uint256 value
    ); 

    function transfer(
        address _to, 
        uint256 _value
    ) 
    public 
    returns (bool) 
    {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = sub(balances[msg.sender],_value);

            

        balances[_to] = add(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // ========= ��Ȩת������߼� =============
    
    mapping (address => mapping (address => uint256)) internal allowed;
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
    public
    returns (bool)
    {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = sub(balances[_from], _value);
        
        
        balances[_to] = add(balances[_to], _value);
        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender, 
        uint256 _value
    ) 
    public 
    returns (bool) 
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    )
    public
    view
    returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    function increaseApproval(
        address _spender,
        uint256 _addedValue
    )
    public
    returns (bool)
    {
        allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(
        address _spender,
        uint256 _subtractedValue
    )
    public
    returns (bool)
    {
        uint256 oldValue = allowed[msg.sender][_spender];

        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } 
        else 
        {
            allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
        }
        
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    
    

     
    // ========== ������������߼� ================
    event Burn(address indexed burner, uint256 value);

    function burn(uint256 _value) public 
    {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal 
    {
        require(_value <= balances[_who]);
        
        balances[_who] = sub(balances[_who], _value);

            

        totalSupply = sub(totalSupply, _value);
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }
    
    
    // ============== admin ��غ��� ==================
    modifier admin_only()
    {
        require(msg.sender==admin_address);
        _;
    }

    function setAdmin( address new_admin_address ) 
    public 
    admin_only 
    returns (bool)
    {
        require(new_admin_address != address(0));
        admin_address = new_admin_address;
        return true;
    }

    
    // ��Ȼû�п���ֱͶ����Ҳ����ת��Ǯ�ģ�����Լ��һ�����ֿ����Ǻõ�
    function withDraw()
    public
    admin_only
    {
        require(address(this).balance > 0);
        admin_address.transfer(address(this).balance);
    }
        // ======================================
    /// Ĭ�Ϻ���
    function () external payable
    {
                
        
        
           
    }

    // ========== ���ú��� ===============
    // ��Ҫ���� safemath
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
    {
        if (a == 0) 
        {
            return 0;
        }

        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
    {
        c = a + b;
        assert(c >= a);
        return c;
    }

}