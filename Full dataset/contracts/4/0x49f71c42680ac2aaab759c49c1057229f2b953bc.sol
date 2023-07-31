/**

 *Submitted for verification at Etherscan.io on 2019-05-07

*/



pragma solidity ^0.5.1;



contract CareerOnToken {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed a_owner, address indexed _spender, uint256 _value);

    event OwnerChang(address indexed _old,address indexed _new,uint256 _coin_change);

    

    uint256 public totalSupply;  

    string public name;                   //���ƣ�����"My test token"

    uint8 public decimals;               //����tokenʹ�õ�С�����λ�������������Ϊ3������֧��0.001��ʾ.

    string public symbol;               //token���,like MTT

    address public owner;

    mapping (address => uint256) public balances;

    mapping (address => mapping (address => uint256)) public allowed;

    

	//���ͨ������setPauseStatus�����������ΪTRUE��������ת�˽��׶���ʧ��

    bool isTransPaused=false;

    

    constructor(

        uint256 _initialAmount,

        uint8 _decimalUnits) public 

    {

        owner=msg.sender;//��¼��Լ��owner

		if(_initialAmount<=0){

		    totalSupply = 100000000000000000;   // ���ó�ʼ����

		    balances[owner]=totalSupply;

		}else{

		    totalSupply = _initialAmount;   // ���ó�ʼ����

		    balances[owner]=_initialAmount;

		}

		if(_decimalUnits<=0){

		    decimals=2;

		}else{

		    decimals = _decimalUnits;

		}

        name = "CareerOn Chain Token"; 

        symbol = "COT";

    }

    

    

    function transfer(

        address _to, 

        uint256 _value) public returns (bool success) 

    {

        assert(_to!=address(this) && 

                !isTransPaused &&

                balances[msg.sender] >= _value &&

                balances[_to] + _value > balances[_to]

        );

        

        balances[msg.sender] -= _value;//����Ϣ�������˻��м�ȥtoken����_value

        balances[_to] += _value;//�������˻�����token����_value

		if(msg.sender==owner){

			emit Transfer(address(this), _to, _value);//����ת�ҽ����¼�

		}else{

			emit Transfer(msg.sender, _to, _value);//����ת�ҽ����¼�

		}

        return true;

    }





    function transferFrom(

        address _from, 

        address _to, 

        uint256 _value) public returns (bool success) 

    {

        assert(_to!=address(this) && 

                !isTransPaused &&

                balances[msg.sender] >= _value &&

                balances[_to] + _value > balances[_to] &&

                allowed[_from][msg.sender] >= _value

        );

        

        balances[_to] += _value;//�����˻�����token����_value

        balances[_from] -= _value; //֧���˻�_from��ȥtoken����_value

        allowed[_from][msg.sender] -= _value;//��Ϣ�����߿��Դ��˻�_from��ת������������_value

        if(_from==owner){

			emit Transfer(address(this), _to, _value);//����ת�ҽ����¼�

		}else{

			emit Transfer(_from, _to, _value);//����ת�ҽ����¼�

		}

        return true;

    }



    function approve(address _spender, uint256 _value) public returns (bool success) 

    { 

        assert(msg.sender!=_spender && _value>0);

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(

        address _owner, 

        address _spender) public view returns (uint256 remaining) 

    {

        return allowed[_owner][_spender];//����_spender��_owner��ת����token��

    }

	

	//����Ϊ������Э��������߼�

	//ת��Э������Ȩ���������Ĵ���һ��ת�ƹ�ȥ

	function changeOwner(address newOwner) public{

        assert(msg.sender==owner && msg.sender!=newOwner);

        balances[newOwner]=balances[owner];

        balances[owner]=0;

        owner=newOwner;

        emit OwnerChang(msg.sender,newOwner,balances[owner]);//������Լ����Ȩ��ת���¼�

    }

    

	//isPausedΪtrue����ͣ����ת�˽���

    function setPauseStatus(bool isPaused)public{

        assert(msg.sender==owner);

        isTransPaused=isPaused;

    }

    

	//�޸ĺ�Լ����

    function changeContractName(string memory _newName,string memory _newSymbol) public {

        assert(msg.sender==owner);

        name=_newName;

        symbol=_newSymbol;

    }

    

    

    function () external payable {

        revert();

		return;

    }

}