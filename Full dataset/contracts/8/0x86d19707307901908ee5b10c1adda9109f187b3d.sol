/**
 *Submitted for verification at Etherscan.io on 2019-09-01
*/

pragma solidity ^0.5.10;


interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

interface IERC1400 {

    
    function getDocument(bytes32 name) external view returns (string memory, bytes32); 
    function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external; 
    event Document(bytes32 indexed name, string uri, bytes32 documentHash);

    
    function isControllable() external view returns (bool); 

    
    function isIssuable() external view returns (bool); 
    function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data) external; 
    event IssuedByPartition(bytes32 indexed partition, address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);

    
    function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data) external; 
    function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData) external; 
    event RedeemedByPartition(bytes32 indexed partition, address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);

    
    function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external view returns (byte, bytes32, bytes32); 
    function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external view returns (byte, bytes32, bytes32); 

}

interface IERC1400Partition {

    
    function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256); 
    function partitionsOf(address tokenHolder) external view returns (bytes32[] memory); 

    
    function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external returns (bytes32); 
    function operatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external returns (bytes32); 

    
    function getDefaultPartitions() external view returns (bytes32[] memory); 
    function setDefaultPartitions(bytes32[] calldata partitions) external; 

    
    function controllersByPartition(bytes32 partition) external view returns (address[] memory); 
    function authorizeOperatorByPartition(bytes32 partition, address operator) external; 
    function revokeOperatorByPartition(bytes32 partition, address operator) external; 
    function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool); 

    
    event TransferByPartition(
        bytes32 indexed fromPartition,
        address operator,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );

    event ChangedPartition(
        bytes32 indexed fromPartition,
        bytes32 indexed toPartition,
        uint256 value
    );

    
    event AuthorizedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
    event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);

}

library SafeMath {
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        
        require(b > 0);
        uint256 c = a / b;
        

        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    
    function owner() public view returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ReentrancyGuard {
    
    uint256 private _guardCounter;

    constructor () internal {
        
        
        _guardCounter = 1;
    }

    
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

contract ERC1820Registry {
    function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
    function setManager(address _addr, address _newManager) external;
    function getManager(address _addr) public view returns (address);
}

contract ERC1820Client {
    ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        ERC1820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
    }

    function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
    }

    function delegateManagement(address _newManager) internal {
        ERC1820REGISTRY.setManager(address(this), _newManager);
    }
}

contract CertificateControllerMock {

  
  mapping(address => bool) internal _certificateSigners;

  
  mapping(address => uint256) internal _checkCount;

  event Checked(address sender);

  constructor(address _certificateSigner) public {
    _setCertificateSigner(_certificateSigner, true);
  }

  
  modifier isValidCertificate(bytes memory data) {

    require(_certificateSigners[msg.sender] || _checkCertificate(data, 0, 0x00000000), "A3"); 

    _checkCount[msg.sender] += 1; 

    emit Checked(msg.sender);
    _;
  }

  
  function checkCount(address sender) external view returns (uint256) {
    return _checkCount[sender];
  }

  
  function certificateSigners(address operator) external view returns (bool) {
    return _certificateSigners[operator];
  }

  
  function _setCertificateSigner(address operator, bool authorized) internal {
    require(operator != address(0)); 
    _certificateSigners[operator] = authorized;
  }

  
   function _checkCertificate(bytes memory data, uint256 , bytes4 ) internal pure returns(bool) { 
     if(data.length > 0 && (data[0] == hex"10" || data[0] == hex"11" || data[0] == hex"22")) {
       return true;
     } else {
       return false;
     }
   }
}

contract CertificateController is CertificateControllerMock {

  constructor(address _certificateSigner) public CertificateControllerMock(_certificateSigner) {}

}

interface IERC1400Raw {

  function name() external view returns (string memory); 
  function symbol() external view returns (string memory); 
  function totalSupply() external view returns (uint256); 
  function balanceOf(address owner) external view returns (uint256); 
  function granularity() external view returns (uint256); 

  function controllers() external view returns (address[] memory); 
  function authorizeOperator(address operator) external; 
  function revokeOperator(address operator) external; 
  function isOperator(address operator, address tokenHolder) external view returns (bool); 

  function transferWithData(address to, uint256 value, bytes calldata data) external; 
  function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external; 

  function redeem(uint256 value, bytes calldata data) external; 
  function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData) external; 

  event TransferWithData(
    address indexed operator,
    address indexed from,
    address indexed to,
    uint256 value,
    bytes data,
    bytes operatorData
  );
  event Issued(address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
  event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);
  event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
  event RevokedOperator(address indexed operator, address indexed tokenHolder);

}

interface IERC1400TokensSender {

  function canTransfer(
    bytes32 partition,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external view returns(bool);

  function tokensToTransfer(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external;

}

interface IERC1400TokensRecipient {

  function canReceive(
    bytes32 partition,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external view returns(bool);

  function tokensReceived(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external;

}

contract ERC1400Raw is IERC1400Raw, Ownable, ERC1820Client, CertificateController, ReentrancyGuard {
  using SafeMath for uint256;

  string internal _name;
  string internal _symbol;
  uint256 internal _granularity;
  uint256 internal _totalSupply;

  
  bool internal _isControllable;

  
  mapping(address => uint256) internal _balances;

  
  
  mapping(address => mapping(address => bool)) internal _authorizedOperator;

  
  address[] internal _controllers;

  
  mapping(address => bool) internal _isController;
  

  
  constructor(
    string memory name,
    string memory symbol,
    uint256 granularity,
    address[] memory controllers,
    address certificateSigner
  )
    public
    CertificateController(certificateSigner)
  {
    _name = name;
    _symbol = symbol;
    _totalSupply = 0;
    require(granularity >= 1); 
    _granularity = granularity;

    _setControllers(controllers);
  }

  

  
  function name() external view returns(string memory) {
    return _name;
  }

  
  function symbol() external view returns(string memory) {
    return _symbol;
  }

  
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  
  function balanceOf(address tokenHolder) external view returns (uint256) {
    return _balances[tokenHolder];
  }

  
  function granularity() external view returns(uint256) {
    return _granularity;
  }

  
  function controllers() external view returns (address[] memory) {
    return _controllers;
  }

  
  function authorizeOperator(address operator) external {
    require(operator != msg.sender);
    _authorizedOperator[operator][msg.sender] = true;
    emit AuthorizedOperator(operator, msg.sender);
  }

  
  function revokeOperator(address operator) external {
    require(operator != msg.sender);
    _authorizedOperator[operator][msg.sender] = false;
    emit RevokedOperator(operator, msg.sender);
  }

  
  function isOperator(address operator, address tokenHolder) external view returns (bool) {
    return _isOperator(operator, tokenHolder);
  }

  
  function transferWithData(address to, uint256 value, bytes calldata data)
    external
    isValidCertificate(data)
  {
    _transferWithData("", msg.sender, msg.sender, to, value, data, "", true);
  }

  
  function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    isValidCertificate(operatorData)
  {
    require(_isOperator(msg.sender, from), "A7"); 

    _transferWithData("", msg.sender, from, to, value, data, operatorData, true);
  }

  
  function redeem(uint256 value, bytes calldata data)
    external
    isValidCertificate(data)
  {
    _redeem("", msg.sender, msg.sender, value, data, "");
  }

  
  function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    isValidCertificate(operatorData)
  {
    require(_isOperator(msg.sender, from), "A7"); 

    _redeem("", msg.sender, from, value, data, operatorData);
  }

  

  
  function _isMultiple(uint256 value) internal view returns(bool) {
    return(value.div(_granularity).mul(_granularity) == value);
  }

  
  function _isRegularAddress(address addr) internal view returns(bool) {
    if (addr == address(0)) { return false; }
    uint size;
    assembly { size := extcodesize(addr) } 
    return size == 0;
  }

  
  function _isOperator(address operator, address tokenHolder) internal view returns (bool) {
    return (operator == tokenHolder
      || _authorizedOperator[operator][tokenHolder]
      || (_isControllable && _isController[operator])
    );
  }

   
  function _transferWithData(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData,
    bool preventLocking
  )
    internal
    nonReentrant
  {
    require(_isMultiple(value), "A9"); 
    require(to != address(0), "A6"); 
    require(_balances[from] >= value, "A4"); 

    _callSender(partition, operator, from, to, value, data, operatorData);

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);

    _callRecipient(partition, operator, from, to, value, data, operatorData, preventLocking);

    emit TransferWithData(operator, from, to, value, data, operatorData);
  }

  
  function _redeem(bytes32 partition, address operator, address from, uint256 value, bytes memory data, bytes memory operatorData)
    internal
    nonReentrant
  {
    require(_isMultiple(value), "A9"); 
    require(from != address(0), "A5"); 
    require(_balances[from] >= value, "A4"); 

    _callSender(partition, operator, from, address(0), value, data, operatorData);

    _balances[from] = _balances[from].sub(value);
    _totalSupply = _totalSupply.sub(value);

    emit Redeemed(operator, from, value, data, operatorData);
  }

  
  function _callSender(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData
  )
    internal
  {
    address senderImplementation;
    senderImplementation = interfaceAddr(from, "ERC1400TokensSender");

    if (senderImplementation != address(0)) {
      IERC1400TokensSender(senderImplementation).tokensToTransfer(partition, operator, from, to, value, data, operatorData);
    }
  }

  
  function _callRecipient(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData,
    bool preventLocking
  )
    internal
  {
    address recipientImplementation;
    recipientImplementation = interfaceAddr(to, "ERC1400TokensRecipient");

    if (recipientImplementation != address(0)) {
      IERC1400TokensRecipient(recipientImplementation).tokensReceived(partition, operator, from, to, value, data, operatorData);
    } else if (preventLocking) {
      require(_isRegularAddress(to), "A6"); 
    }
  }

  
  function _issue(bytes32 partition, address operator, address to, uint256 value, bytes memory data, bytes memory operatorData) internal nonReentrant {
    require(_isMultiple(value), "A9"); 
    require(to != address(0), "A6"); 

    _totalSupply = _totalSupply.add(value);
    _balances[to] = _balances[to].add(value);

    _callRecipient(partition, operator, address(0), to, value, data, operatorData, true);

    emit Issued(operator, to, value, data, operatorData);
  }

  

  
  function _setControllers(address[] memory operators) internal {
    for (uint i = 0; i<_controllers.length; i++){
      _isController[_controllers[i]] = false;
    }
    for (uint j = 0; j<operators.length; j++){
      _isController[operators[j]] = true;
    }
    _controllers = operators;
  }

}

contract ERC1400Partition is IERC1400Partition, ERC1400Raw {

  
  
  bytes32[] internal _totalPartitions;

  
  mapping (bytes32 => uint256) internal _indexOfTotalPartitions;

  
  mapping (bytes32 => uint256) internal _totalSupplyByPartition;

  
  mapping (address => bytes32[]) internal _partitionsOf;

  
  mapping (address => mapping (bytes32 => uint256)) internal _indexOfPartitionsOf;

  
  mapping (address => mapping (bytes32 => uint256)) internal _balanceOfByPartition;

  
  bytes32[] internal _defaultPartitions;
  

  
  
  mapping (address => mapping (bytes32 => mapping (address => bool))) internal _authorizedOperatorByPartition;

  
  mapping (bytes32 => address[]) internal _controllersByPartition;

  
  mapping (bytes32 => mapping (address => bool)) internal _isControllerByPartition;
  

  
  constructor(
    string memory name,
    string memory symbol,
    uint256 granularity,
    address[] memory controllers,
    address certificateSigner,
    bytes32[] memory defaultPartitions
  )
    public
    ERC1400Raw(name, symbol, granularity, controllers, certificateSigner)
  {
    _defaultPartitions = defaultPartitions;
  }

  

  
  function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256) {
    return _balanceOfByPartition[tokenHolder][partition];
  }

  
  function partitionsOf(address tokenHolder) external view returns (bytes32[] memory) {
    return _partitionsOf[tokenHolder];
  }

  
  function transferByPartition(
    bytes32 partition,
    address to,
    uint256 value,
    bytes calldata data
  )
    external
    isValidCertificate(data)
    returns (bytes32)
  {
    return _transferByPartition(partition, msg.sender, msg.sender, to, value, data, "", true);
  }

  
  function operatorTransferByPartition(
    bytes32 partition,
    address from,
    address to,
    uint256 value,
    bytes calldata data,
    bytes calldata operatorData
  )
    external
    isValidCertificate(operatorData)
    returns (bytes32)
  {
    require(_isOperatorForPartition(partition, msg.sender, from), "A7"); 

    return _transferByPartition(partition, msg.sender, from, to, value, data, operatorData, true);
  }

  
  function getDefaultPartitions() external view returns (bytes32[] memory) {
    return _defaultPartitions;
  }

  
  function setDefaultPartitions(bytes32[] calldata partitions) external onlyOwner {
    _defaultPartitions = partitions;
  }

  
  function controllersByPartition(bytes32 partition) external view returns (address[] memory) {
    return _controllersByPartition[partition];
  }

  
  function authorizeOperatorByPartition(bytes32 partition, address operator) external {
    _authorizedOperatorByPartition[msg.sender][partition][operator] = true;
    emit AuthorizedOperatorByPartition(partition, operator, msg.sender);
  }

  
  function revokeOperatorByPartition(bytes32 partition, address operator) external {
    _authorizedOperatorByPartition[msg.sender][partition][operator] = false;
    emit RevokedOperatorByPartition(partition, operator, msg.sender);
  }

  
  function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool) {
    return _isOperatorForPartition(partition, operator, tokenHolder);
  }

  

  
   function _isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) internal view returns (bool) {
     return (_isOperator(operator, tokenHolder)
       || _authorizedOperatorByPartition[tokenHolder][partition][operator]
       || (_isControllable && _isControllerByPartition[partition][operator])
     );
   }

  
  function _transferByPartition(
    bytes32 fromPartition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData,
    bool preventLocking
  )
    internal
    returns (bytes32)
  {
    require(_balanceOfByPartition[from][fromPartition] >= value, "A4"); 

    bytes32 toPartition = fromPartition;

    if(operatorData.length != 0 && data.length >= 64) {
      toPartition = _getDestinationPartition(fromPartition, data);
    }

    _removeTokenFromPartition(from, fromPartition, value);
    _transferWithData(fromPartition, operator, from, to, value, data, operatorData, preventLocking);
    _addTokenToPartition(to, toPartition, value);

    emit TransferByPartition(fromPartition, operator, from, to, value, data, operatorData);

    if(toPartition != fromPartition) {
      emit ChangedPartition(fromPartition, toPartition, value);
    }

    return toPartition;
  }

  
  function _removeTokenFromPartition(address from, bytes32 partition, uint256 value) internal {
    _balanceOfByPartition[from][partition] = _balanceOfByPartition[from][partition].sub(value);
    _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].sub(value);

    
    if(_totalSupplyByPartition[partition] == 0) {
      uint256 index1 = _indexOfTotalPartitions[partition];
      require(index1 > 0, "A8"); 

      
      bytes32 lastValue = _totalPartitions[_totalPartitions.length - 1];
      _totalPartitions[index1 - 1] = lastValue; 
      _indexOfTotalPartitions[lastValue] = index1;

      _totalPartitions.length -= 1;
      _indexOfTotalPartitions[partition] = 0;
    }

    
    if(_balanceOfByPartition[from][partition] == 0) {
      uint256 index2 = _indexOfPartitionsOf[from][partition];
      require(index2 > 0, "A8"); 

      
      bytes32 lastValue = _partitionsOf[from][_partitionsOf[from].length - 1];
      _partitionsOf[from][index2 - 1] = lastValue;  
      _indexOfPartitionsOf[from][lastValue] = index2;

      _partitionsOf[from].length -= 1;
      _indexOfPartitionsOf[from][partition] = 0;
    }

  }

  
  function _addTokenToPartition(address to, bytes32 partition, uint256 value) internal {
    if(value != 0) {
      if (_indexOfPartitionsOf[to][partition] == 0) {
        _partitionsOf[to].push(partition);
        _indexOfPartitionsOf[to][partition] = _partitionsOf[to].length;
      }
      _balanceOfByPartition[to][partition] = _balanceOfByPartition[to][partition].add(value);

      if (_indexOfTotalPartitions[partition] == 0) {
        _totalPartitions.push(partition);
        _indexOfTotalPartitions[partition] = _totalPartitions.length;
      }
      _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].add(value);
    }
  }

  
  function _getDestinationPartition(bytes32 fromPartition, bytes memory data) internal pure returns(bytes32 toPartition) {
    bytes32 changePartitionFlag = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    bytes32 flag;
    assembly {
      flag := mload(add(data, 32))
    }
    if(flag == changePartitionFlag) {
      assembly {
        toPartition := mload(add(data, 64))
      }
    } else {
      toPartition = fromPartition;
    }
  }

  

  
  function totalPartitions() external view returns (bytes32[] memory) {
    return _totalPartitions;
  }

  
   function _setPartitionControllers(bytes32 partition, address[] memory operators) internal {
     for (uint i = 0; i<_controllersByPartition[partition].length; i++){
       _isControllerByPartition[partition][_controllersByPartition[partition][i]] = false;
     }
     for (uint j = 0; j<operators.length; j++){
       _isControllerByPartition[partition][operators[j]] = true;
     }
     _controllersByPartition[partition] = operators;
   }

  

  
  function transferWithData(address to, uint256 value, bytes calldata data)
    external
    isValidCertificate(data)
  {
    _transferByDefaultPartitions(msg.sender, msg.sender, to, value, data, "", true);
  }

  
  function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    isValidCertificate(operatorData)
  {
    require(_isOperator(msg.sender, from), "A7"); 

    _transferByDefaultPartitions(msg.sender, from, to, value, data, operatorData, true);
  }

  
  function redeem(uint256 , bytes calldata ) external { 
    revert("A8: Transfer Blocked - Token restriction");
  }

  
  function redeemFrom(address , uint256 , bytes calldata , bytes calldata ) external { 
    revert("A8: Transfer Blocked - Token restriction");
  }

  
  function _transferByDefaultPartitions(
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData,
    bool preventLocking
  )
    internal
  {
    require(_defaultPartitions.length != 0, "A8"); 

    uint256 _remainingValue = value;
    uint256 _localBalance;

    for (uint i = 0; i < _defaultPartitions.length; i++) {
      _localBalance = _balanceOfByPartition[from][_defaultPartitions[i]];
      if(_remainingValue <= _localBalance) {
        _transferByPartition(_defaultPartitions[i], operator, from, to, _remainingValue, data, operatorData, preventLocking);
        _remainingValue = 0;
        break;
      } else if (_localBalance != 0) {
        _transferByPartition(_defaultPartitions[i], operator, from, to, _localBalance, data, operatorData, preventLocking);
        _remainingValue = _remainingValue - _localBalance;
      }
    }

    require(_remainingValue == 0, "A8"); 
  }
}

contract ERC1400 is IERC1400, ERC1400Partition, MinterRole {

  struct Doc {
    string docURI;
    bytes32 docHash;
  }

  
  mapping(bytes32 => Doc) internal _documents;

  
  bool internal _isIssuable;

  
  modifier issuableToken() {
    require(_isIssuable, "A8"); 
    _;
  }

  
  constructor(
    string memory name,
    string memory symbol,
    uint256 granularity,
    address[] memory controllers,
    address certificateSigner,
    bytes32[] memory defaultPartitions
  )
    public
    ERC1400Partition(name, symbol, granularity, controllers, certificateSigner, defaultPartitions)
  {
    setInterfaceImplementation("ERC1400Token", address(this));
    _isControllable = true;
    _isIssuable = true;
  }

  

  
  function getDocument(bytes32 name) external view returns (string memory, bytes32) {
    require(bytes(_documents[name].docURI).length != 0); 
    return (
      _documents[name].docURI,
      _documents[name].docHash
    );
  }

  
  function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external {
    require(_isController[msg.sender]);
    _documents[name] = Doc({
      docURI: uri,
      docHash: documentHash
    });
    emit Document(name, uri, documentHash);
  }

  
  function isControllable() external view returns (bool) {
    return _isControllable;
  }

  
  function isIssuable() external view returns (bool) {
    return _isIssuable;
  }

  
  function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data)
    external
    onlyMinter
    issuableToken
    isValidCertificate(data)
  {
    _issueByPartition(partition, msg.sender, tokenHolder, value, data, "");
  }

  
  function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data)
    external
    isValidCertificate(data)
  {
    _redeemByPartition(partition, msg.sender, msg.sender, value, data, "");
  }

  
  function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    isValidCertificate(operatorData)
  {
    require(_isOperatorForPartition(partition, msg.sender, tokenHolder), "A7"); 

    _redeemByPartition(partition, msg.sender, tokenHolder, value, data, operatorData);
  }

  
  function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data)
    external
    view
    returns (byte, bytes32, bytes32)
  {
    if(!_checkCertificate(data, 0, this.transferByPartition.selector)) { 
      return(hex"A3", "", partition); 
    } else {
      return _canTransfer(partition, msg.sender, msg.sender, to, value, data, "");
    }
  }

  
  function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    view
    returns (byte, bytes32, bytes32)
  {
    if(!_checkCertificate(operatorData, 0, this.operatorTransferByPartition.selector)) { 
      return(hex"A3", "", partition); 
    } else {
      return _canTransfer(partition, msg.sender, from, to, value, data, operatorData);
    }
  }

  

  
   function _canTransfer(bytes32 partition, address operator, address from, address to, uint256 value, bytes memory data, bytes memory operatorData)
     internal
     view
     returns (byte, bytes32, bytes32)
   {
     if(!_isOperatorForPartition(partition, operator, from))
       return(hex"A7", "", partition); 

     if((_balances[from] < value) || (_balanceOfByPartition[from][partition] < value))
       return(hex"A4", "", partition); 

     if(to == address(0))
       return(hex"A6", "", partition); 

     address senderImplementation;
     address recipientImplementation;
     senderImplementation = interfaceAddr(from, "ERC1400TokensSender");
     recipientImplementation = interfaceAddr(to, "ERC1400TokensRecipient");

     if((senderImplementation != address(0))
       && !IERC1400TokensSender(senderImplementation).canTransfer(partition, from, to, value, data, operatorData))
       return(hex"A5", "", partition); 

     if((recipientImplementation != address(0))
       && !IERC1400TokensRecipient(recipientImplementation).canReceive(partition, from, to, value, data, operatorData))
       return(hex"A6", "", partition); 

     if(!_isMultiple(value))
       return(hex"A9", "", partition); 

     return(hex"A2", "", partition);  
   }

  
  function _issueByPartition(
    bytes32 toPartition,
    address operator,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData
  )
    internal
  {
    _issue(toPartition, operator, to, value, data, operatorData);
    _addTokenToPartition(to, toPartition, value);

    emit IssuedByPartition(toPartition, operator, to, value, data, operatorData);
  }

  
  function _redeemByPartition(
    bytes32 fromPartition,
    address operator,
    address from,
    uint256 value,
    bytes memory data,
    bytes memory operatorData
  )
    internal
  {
    require(_balanceOfByPartition[from][fromPartition] >= value, "A4"); 

    _removeTokenFromPartition(from, fromPartition, value);
    _redeem(fromPartition, operator, from, value, data, operatorData);

    emit RedeemedByPartition(fromPartition, operator, from, value, data, operatorData);
  }

  

  
  function renounceControl() external onlyOwner {
    _isControllable = false;
  }

  
  function renounceIssuance() external onlyOwner {
    _isIssuable = false;
  }

  
  function setControllers(address[] calldata operators) external onlyOwner {
    _setControllers(operators);
  }

  
   function setPartitionControllers(bytes32 partition, address[] calldata operators) external onlyOwner {
     _setPartitionControllers(partition, operators);
   }

   
  function setCertificateSigner(address operator, bool authorized) external onlyOwner {
    _setCertificateSigner(operator, authorized);
  }

  


  
  function redeem(uint256 value, bytes calldata data)
    external
    isValidCertificate(data)
  {
    _redeemByDefaultPartitions(msg.sender, msg.sender, value, data, "");
  }

  
  function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
    external
    isValidCertificate(operatorData)
  {
    require(_isOperator(msg.sender, from), "A7"); 

    _redeemByDefaultPartitions(msg.sender, from, value, data, operatorData);
  }

  
  function _redeemByDefaultPartitions(
    address operator,
    address from,
    uint256 value,
    bytes memory data,
    bytes memory operatorData
  )
    internal
  {
    require(_defaultPartitions.length != 0, "A8"); 

    uint256 _remainingValue = value;
    uint256 _localBalance;

    for (uint i = 0; i < _defaultPartitions.length; i++) {
      _localBalance = _balanceOfByPartition[from][_defaultPartitions[i]];
      if(_remainingValue <= _localBalance) {
        _redeemByPartition(_defaultPartitions[i], operator, from, _remainingValue, data, operatorData);
        _remainingValue = 0;
        break;
      } else {
        _redeemByPartition(_defaultPartitions[i], operator, from, _localBalance, data, operatorData);
        _remainingValue = _remainingValue - _localBalance;
      }
    }

    require(_remainingValue == 0, "A8"); 
  }

}

contract ERC1400ERC20 is IERC20, ERC1400 {

  
  mapping (address => mapping (address => uint256)) internal _allowed;

  
  mapping (address => bool) internal _whitelisted;

  
  modifier areWhitelisted(address sender, address recipient) {
    require(_whitelisted[sender], "A5"); 
    require(_whitelisted[recipient], "A6"); 
    _;
  }

  
  constructor(
    string memory name,
    string memory symbol,
    uint256 granularity,
    address[] memory controllers,
    address certificateSigner,
    bytes32[] memory tokenDefaultPartitions
  )
    public
    ERC1400(name, symbol, granularity, controllers, certificateSigner, tokenDefaultPartitions)
  {
    setInterfaceImplementation("ERC20Token", address(this));
  }

  
  function _transferWithData(
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes memory data,
    bytes memory operatorData,
    bool preventLocking
  )
    internal
  {
    ERC1400Raw._transferWithData(partition, operator, from, to, value, data, operatorData, preventLocking);

    emit Transfer(from, to, value);
  }

  
  function _redeem(bytes32 partition, address operator, address from, uint256 value, bytes memory data, bytes memory operatorData) internal {
    ERC1400Raw._redeem(partition, operator, from, value, data, operatorData);

    emit Transfer(from, address(0), value);  
  }

  
  function _issue(bytes32 partition, address operator, address to, uint256 value, bytes memory data, bytes memory operatorData) internal {
    ERC1400Raw._issue(partition, operator, to, value, data, operatorData);

    emit Transfer(address(0), to, value); 
  }

  
  function decimals() external pure returns(uint8) {
    return uint8(18);
  }

  
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowed[owner][spender];
  }

  
  function approve(address spender, uint256 value) external returns (bool) {
    require(spender != address(0), "A5"); 
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  
  function transfer(address to, uint256 value) external areWhitelisted(msg.sender, to) returns (bool) {
    _transferByDefaultPartitions(msg.sender, msg.sender, to, value, "", "", false);
    return true;
  }

  
  function transferFrom(address from, address to, uint256 value) external areWhitelisted(from, to) returns (bool) {
    require( _isOperator(msg.sender, from)
      || (value <= _allowed[from][msg.sender]), "A7"); 

    if(_allowed[from][msg.sender] >= value) {
      _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    } else {
      _allowed[from][msg.sender] = 0;
    }

    _transferByDefaultPartitions(msg.sender, from, to, value, "", "", false);
    return true;
  }

  

  
  function whitelisted(address tokenHolder) external view returns (bool) {
    return _whitelisted[tokenHolder];
  }

  
  function setWhitelisted(address tokenHolder, bool authorized) external {
    require(_isController[msg.sender]);
    _setWhitelisted(tokenHolder, authorized);
  }

  
  function _setWhitelisted(address tokenHolder, bool authorized) internal {
    require(tokenHolder != address(0)); 
    _whitelisted[tokenHolder] = authorized;
  }

}