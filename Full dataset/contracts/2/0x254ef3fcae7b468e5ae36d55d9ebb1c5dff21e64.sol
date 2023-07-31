/**

 *Submitted for verification at Etherscan.io on 2019-03-18

*/



pragma solidity ^0.4.16;



interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }



/**

 * ��׼ ERC-20-2 ��Լ

 */

contract ERC_20_2 {

    //- Token ����

    string public name; 

    //- Token ����

    string public symbol;

    //- Token С��λ

    uint8 public decimals;

    //- Token �ܷ�����

    uint256 public totalSupply;

    //- ��Լ����״̬

    bool public lockAll = false;

    //- ��Լ������

    address public creator;

    //- ��Լ������

    address public owner;

    //- ��Լ��������

    address internal newOwner = 0x0;



    //- ��ַӳ���ϵ

    mapping (address => uint256) public balanceOf;

    //- ��ַ��Ӧ Token

    mapping (address => mapping (address => uint256)) public allowance;

    //- �����б�

    mapping (address => bool) public frozens;



    //- Token ����֪ͨ�¼�

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    //- Token ������չ֪ͨ�¼�

    event TransferExtra(address indexed _from, address indexed _to, uint256 _value, bytes _extraData);

    //- Token ��׼֪ͨ�¼�

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    //- Token ����֪ͨ�¼�

    event Burn(address indexed _from, uint256 _value);

    //- Token ����֪ͨ�¼�

    event Offer(uint256 _supplyTM);

    //- ��Լ�����߱��֪ͨ

    event OwnerChanged(address _oldOwner, address _newOwner);

    //- ��ַ����֪ͨ

    event FreezeAddress(address indexed _target, bool _frozen);



    /**

     * ���캯��

     *

     * ��ʼ��һ����Լ

     * @param initialSupplyHM ��ʼ��������λ�ڣ�

     * @param tokenName Token ����

     * @param tokenSymbol Token ����

     * @param tokenDecimals Token С��λ

     */

    constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {

        name = tokenName;

        symbol = tokenSymbol;

        decimals = tokenDecimals;

        totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);

        

        balanceOf[msg.sender] = totalSupply;

        owner = msg.sender;

        creator = msg.sender;

    }



    /**

     * ���������η�

     */

    modifier onlyOwner {

        require(msg.sender == owner, "�Ƿ���Լִ����");

        _;

    }

	

    /**

     * ���ӷ�����

     * @param _supplyTM ��������λǧ��

     */

    function offer(uint256 _supplyTM) onlyOwner public returns (bool success){

        //- �Ǹ�����֤

        require(_supplyTM > 0, "��Ч����");

		uint256 tm = _supplyTM * 1000 * 10000 * 10 ** uint256(decimals);

        totalSupply += tm;

        balanceOf[msg.sender] += tm;

        emit Offer(_supplyTM);

        return true;

    }



    /**

     * ת�ƺ�Լ������

     * @param _newOwner �º�Լ�����ߵ�ַ

     */

    function transferOwnership(address _newOwner) onlyOwner public returns (bool success){

        require(owner != _newOwner, "��Ч��Լ��������");

        newOwner = _newOwner;

        return true;

    }

    

    /**

     * ���ܲ���Ϊ�µĺ�Լ������

     */

    function acceptOwnership() public returns (bool success){

        require(msg.sender == newOwner && newOwner != 0x0, "��Ч��Լ��������");

        address oldOwner = owner;

        owner = newOwner;

        newOwner = 0x0;

        emit OwnerChanged(oldOwner, owner);

        return true;

    }



    /**

     * �趨��Լ����״̬

     * @param _lockAll ״̬

     */

    function setLockAll(bool _lockAll) onlyOwner public returns (bool success){

        lockAll = _lockAll;

        return true;

    }



    /**

     * �趨�˻�����״̬

     * @param _target ����Ŀ��

     * @param _freeze ����״̬

     */

    function setFreezeAddress(address _target, bool _freeze) onlyOwner public returns (bool success){

        frozens[_target] = _freeze;

        emit FreezeAddress(_target, _freeze);

        return true;

    }



    /**

     * �ӳ��з�ת��ָ�������� Token �����շ�

     * @param _from ���з�

     * @param _to ���շ�

     * @param _value ����

     */

    function _transfer(address _from, address _to, uint256 _value) internal {

        //- ����У��

        require(!lockAll, "��Լ��������״̬");

        //- ��ַ��Ч��֤

        require(_to != 0x0, "��Ч���յ�ַ");

        //- �Ǹ�����֤

        require(_value > 0, "��Ч����");

        //- �����֤

        require(balanceOf[_from] >= _value, "���з�ת����������");

        //- ���з�����У��

        require(!frozens[_from], "���з����ڶ���״̬"); 

        //- ���շ�����У��

        //require(!frozenAccount[_to]); 



        //- ����ԤУ������

        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];

        //- ���з����ٴ���

        balanceOf[_from] -= _value;

        //- ���շ����Ӵ���

        balanceOf[_to] += _value;

        //- ����ת���¼�

		emit Transfer(_from, _to, _value);



        //- ȷ�����׹��󣬳��з��ͽ��շ�������������

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

    }



    /**

     * ת��תָ�������� Token �����շ�

     *

     * @param _to ���շ���ַ

     * @param _value ����

     */

    function transfer(address _to, uint256 _value) public returns (bool success) {

        _transfer(msg.sender, _to, _value);

        return true;

    }

	

    /**

     * ת��תָ�������� Token �����շ�����������չ���ݣ��÷������ᴥ�������¼���

     *

     * @param _to ���շ���ַ

     * @param _value ����

     * @param _extraData ��չ����

     */

    function transferExtra(address _to, uint256 _value, bytes _extraData) public returns (bool success) {

        _transfer(msg.sender, _to, _value);

		emit TransferExtra(msg.sender, _to, _value, _extraData);

        return true;

    }



    /**

     * �ӳ��з�ת��ָ�������� Token �����շ�

     *

     * @param _from ���з�

     * @param _to ���շ�

     * @param _value ����

     */

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        //- ��Ȩ���У��

        require(_value <= allowance[_from][msg.sender], "��Ȩ��Ȳ���");



        allowance[_from][msg.sender] -= _value;

        _transfer(_from, _to, _value);

        return true;

    }



    /**

     * ��Ȩָ����ַ��ת�ƶ��

     *

     * @param _spender ������

     * @param _value ��Ȩ���

     */

    function approve(address _spender, uint256 _value) public returns (bool success) {

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    /**

     * ��Ȩָ����ַ��ת�ƶ�ȣ���֪ͨ��������Լ

     *

     * @param _spender ������

     * @param _value ת����߶��

     * @param _extraData ��չ���ݣ����ݸ���������Լ��

     */

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {

        tokenRecipient spender = tokenRecipient(_spender);//- ��������Լ

        if (approve(_spender, _value)) {

            spender.receiveApproval(msg.sender, _value, this, _extraData);

            return true;

        }

    }



    function _burn(address _from, uint256 _value) internal {

        //- ����У��

        require(!lockAll, "��Լ��������״̬");

        //- �����֤

        require(balanceOf[_from] >= _value, "���з�����");

        //- ����У��

        require(!frozens[_from], "���з����ڶ���״̬"); 



        //- ���� Token

        balanceOf[_from] -= _value;

        //- �����µ�

        totalSupply -= _value;



        emit Burn(_from, _value);

    }



    /**

     * ����ָ�������� Token

     *

     * @param _value ��������

     */

    function burn(uint256 _value) public returns (bool success) {

        //- �Ǹ�����֤

        require(_value > 0, "��Ч����");



        _burn(msg.sender, _value);

        return true;

    }



    /**

     * ���ĳ��з���Ȩ�����ָ�������� Token

     *

     * @param _from ���з�

     * @param _value ��������

     */

    function burnFrom(address _from, uint256 _value) public returns (bool success) {

        //- ��Ȩ���У��

        require(_value <= allowance[_from][msg.sender], "��Ȩ��Ȳ���");

        //- �Ǹ�����֤

        require(_value > 0, "��Ч����");

      

        allowance[_from][msg.sender] -= _value;



        _burn(_from, _value);

        return true;

    }



    function() payable public{

    }

}