/**
 *Submitted for verification at Etherscan.io on 2019-08-02
*/

pragma solidity 0.4.25;

/**
 * @title A contract with an owner.
 * @notice Contract ownership can be transferred by first nominating the new owner,
 * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
 */
contract Owned {
    address public owner;
    address public nominatedOwner;

    /**
     * @dev Owned Constructor
     */
    constructor(address _owner)
        public
    {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    /**
     * @notice Nominate a new owner of this contract.
     * @dev Only the current owner may nominate a new owner.
     */
    function nominateNewOwner(address _owner)
        external
        onlyOwner
    {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    /**
     * @notice Accept the nomination to be owner.
     */
    function acceptOwnership()
        external
    {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner
    {
        require(msg.sender == owner, "Only the contract owner may perform this action");
        _;
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}


contract ISynthetixState {
    // A struct for handing values associated with an individual user's debt position
    struct IssuanceData {
        // Percentage of the total debt owned at the time
        // of issuance. This number is modified by the global debt
        // delta array. You can figure out a user's exit price and
        // collateralisation ratio using a combination of their initial
        // debt and the slice of global debt delta which applies to them.
        uint initialDebtOwnership;
        // This lets us know when (in relative terms) the user entered
        // the debt pool so we can calculate their exit price and
        // collateralistion ratio
        uint debtEntryIndex;
    }

    uint[] public debtLedger;
    uint public issuanceRatio;
    mapping(address => IssuanceData) public issuanceData;

    function debtLedgerLength() external view returns (uint);
    function hasIssued(address account) external view returns (bool);
    function incrementTotalIssuerCount() external;
    function decrementTotalIssuerCount() external;
    function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
    function lastDebtLedgerEntry() external view returns (uint);
    function appendDebtLedgerValue(uint value) external;
    function clearIssuanceData(address account) external;
}


interface ISynth {
  function burn(address account, uint amount) external;
  function issue(address account, uint amount) external;
  function transfer(address to, uint value) public returns (bool);
  function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount) external;
  function transferFrom(address from, address to, uint value) public returns (bool);
}


/**
 * @title SynthetixEscrow interface
 */
interface ISynthetixEscrow {
    function balanceOf(address account) public view returns (uint);
    function appendVestingEntry(address account, uint quantity) public;
}


contract IFeePool {
    address public FEE_ADDRESS;
    uint public exchangeFeeRate;
    function amountReceivedFromExchange(uint value) external view returns (uint);
    function amountReceivedFromTransfer(uint value) external view returns (uint);
    function feePaid(bytes4 currencyKey, uint amount) external;
    function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
    function rewardsMinted(uint amount) external;
    function transferFeeIncurred(uint value) public view returns (uint);
}


/**
 * @title ExchangeRates interface
 */
interface IExchangeRates {
    function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey) public view returns (uint);

    function rateForCurrency(bytes4 currencyKey) public view returns (uint);

    function anyRateIsStale(bytes4[] currencyKeys) external view returns (bool);

    function rateIsStale(bytes4 currencyKey) external view returns (bool);
}


/**
 * @title Synthetix interface contract
 * @dev pseudo interface, actually declared as contract to hold the public getters 
 */


contract ISynthetix {

    // ========== PUBLIC STATE VARIABLES ==========

    IFeePool public feePool;
    ISynthetixEscrow public escrow;
    ISynthetixEscrow public rewardEscrow;
    ISynthetixState public synthetixState;
    IExchangeRates public exchangeRates;

    // ========== PUBLIC FUNCTIONS ==========

    function balanceOf(address account) public view returns (uint);
    function transfer(address to, uint value) public returns (bool);
    function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey) public view returns (uint);

    function synthInitiatedFeePayment(address from, bytes4 sourceCurrencyKey, uint sourceAmount) external returns (bool);
    function synthInitiatedExchange(
        address from,
        bytes4 sourceCurrencyKey,
        uint sourceAmount,
        bytes4 destinationCurrencyKey,
        address destinationAddress) external returns (bool);
    function exchange(
        bytes4 sourceCurrencyKey,
        uint sourceAmount,
        bytes4 destinationCurrencyKey,
        address destinationAddress) external returns (bool);
    function collateralisationRatio(address issuer) public view returns (uint);
    function totalIssuedSynths(bytes4 currencyKey)
        public
        view
        returns (uint);
    function getSynth(bytes4 currencyKey) public view returns (ISynth);
    function debtBalanceOf(address issuer, bytes4 currencyKey) public view returns (uint);
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract IERC20 {
    function totalSupply() public view returns (uint);

    function balanceOf(address owner) public view returns (uint);

    function allowance(address owner, address spender) public view returns (uint);

    function transfer(address to, uint value) public returns (bool);

    function approve(address spender, uint value) public returns (bool);

    function transferFrom(address from, address to, uint value) public returns (bool);

    // ERC20 Optional
    function name() public view returns (string);
    function symbol() public view returns (string);
    function decimals() public view returns (uint8);

    event Transfer(
      address indexed from,
      address indexed to,
      uint value
    );

    event Approval(
      address indexed owner,
      address indexed spender,
      uint value
    );
}


/* TokenExchanger.sol: Used for testing contract to contract calls on chain 
 * with Synthetix for testing ERC20 compatability
 */


contract TokenExchanger is Owned {

    address public integrationProxy;
    address public synthetix;

    constructor(address _owner, address _integrationProxy)
        Owned(_owner)
        public
    {
        integrationProxy = _integrationProxy;
    }

    function setSynthetixProxy(address _integrationProxy)
        external
        onlyOwner
    {
        integrationProxy = _integrationProxy;
    }

    function setSynthetix(address _synthetix)
        external
        onlyOwner
    {
        synthetix = _synthetix;
    }

    function checkBalance(address account)
        public
        view
        synthetixProxyIsSet
        returns (uint)
    {
        return IERC20(integrationProxy).balanceOf(account);
    }

    function checkAllowance(address tokenOwner, address spender)
        public
        view
        synthetixProxyIsSet
        returns (uint)
    {
        return IERC20(integrationProxy).allowance(tokenOwner, spender);
    }

    function checkBalanceSNXDirect(address account)
        public
        view
        synthetixProxyIsSet
        returns (uint)
    {
        return IERC20(synthetix).balanceOf(account);
    }

    function getDecimals(address tokenAddress)
        public
        view
        returns (uint)
    {
        return IERC20(tokenAddress).decimals();
    }

    function doTokenSpend(address fromAccount, address toAccount, uint amount)
        public
        synthetixProxyIsSet
        returns (bool)
    {
        // Call Immutable static call #1
        require(checkBalance(fromAccount) > amount, "fromAccount does not have the required balance to spend");

        // Call Immutable static call #2
        require(checkAllowance(fromAccount, address(this)) > amount, "I TokenExchanger, do not have approval to spend this guys tokens");

        // Call Mutable call
        return IERC20(integrationProxy).transferFrom(fromAccount, toAccount, amount);
    }

    modifier synthetixProxyIsSet {
        require(integrationProxy != address(0), "Synthetix Integration proxy address not set");
        _;
    }

    event LogString(string name, string value);
    event LogInt(string name, uint value);
    event LogAddress(string name, address value);
    event LogBytes(string name, bytes4 value);
}