/**
 *Submitted for verification at Etherscan.io on 2019-09-05
*/

// File: contracts/saga/interfaces/IModelDataSource.sol

pragma solidity 0.4.25;

/**
 * @title Model Data Source Interface.
 */
interface IModelDataSource {
    /**
     * @dev Get interval parameters.
     * @param _rowNum Interval row index.
     * @param _colNum Interval column index.
     * @return Interval minimum amount of SGA.
     * @return Interval maximum amount of SGA.
     * @return Interval minimum amount of SDR.
     * @return Interval maximum amount of SDR.
     * @return Interval alpha value (scaled up).
     * @return Interval beta  value (scaled up).
     */
    function getInterval(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);

    /**
     * @dev Get interval alpha and beta.
     * @param _rowNum Interval row index.
     * @param _colNum Interval column index.
     * @return Interval alpha value (scaled up).
     * @return Interval beta  value (scaled up).
     */
    function getIntervalCoefs(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256);

    /**
     * @dev Get the amount of SGA required for moving to the next minting-point.
     * @param _rowNum Interval row index.
     * @return Required amount of SGA.
     */
    function getRequiredMintAmount(uint256 _rowNum) external view returns (uint256);
}

// File: contracts/saga/interfaces/IMintingPointTimersManager.sol

pragma solidity 0.4.25;

/**
 * @title Minting Point Timers Manager Interface.
 */
interface IMintingPointTimersManager {
    /**
     * @dev Start a given timestamp.
     * @param _id The ID of the timestamp.
     * @notice When tested, this timestamp will be either 'running' or 'expired'.
     */
    function start(uint256 _id) external;

    /**
     * @dev Reset a given timestamp.
     * @param _id The ID of the timestamp.
     * @notice When tested, this timestamp will be neither 'running' nor 'expired'.
     */
    function reset(uint256 _id) external;

    /**
     * @dev Get an indication of whether or not a given timestamp is 'running'.
     * @param _id The ID of the timestamp.
     * @return An indication of whether or not a given timestamp is 'running'.
     * @notice Even if this timestamp is not 'running', it is not necessarily 'expired'.
     */
    function running(uint256 _id) external view returns (bool);

    /**
     * @dev Get an indication of whether or not a given timestamp is 'expired'.
     * @param _id The ID of the timestamp.
     * @return An indication of whether or not a given timestamp is 'expired'.
     * @notice Even if this timestamp is not 'expired', it is not necessarily 'running'.
     */
    function expired(uint256 _id) external view returns (bool);
}

// File: contracts/saga/interfaces/ISGAAuthorizationManager.sol

pragma solidity 0.4.25;

/**
 * @title SGA Authorization Manager Interface.
 */
interface ISGAAuthorizationManager {
    /**
     * @dev Determine whether or not a user is authorized to buy SGA.
     * @param _sender The address of the user.
     * @return Authorization status.
     */
    function isAuthorizedToBuy(address _sender) external view returns (bool);

    /**
     * @dev Determine whether or not a user is authorized to sell SGA.
     * @param _sender The address of the user.
     * @return Authorization status.
     */
    function isAuthorizedToSell(address _sender) external view returns (bool);

    /**
     * @dev Determine whether or not a user is authorized to transfer SGA to another user.
     * @param _sender The address of the source user.
     * @param _target The address of the target user.
     * @return Authorization status.
     */
    function isAuthorizedToTransfer(address _sender, address _target) external view returns (bool);

    /**
     * @dev Determine whether or not a user is authorized to transfer SGA from one user to another user.
     * @param _sender The address of the custodian user.
     * @param _source The address of the source user.
     * @param _target The address of the target user.
     * @return Authorization status.
     */
    function isAuthorizedToTransferFrom(address _sender, address _source, address _target) external view returns (bool);

    /**
     * @dev Determine whether or not a user is authorized for public operation.
     * @param _sender The address of the user.
     * @return Authorization status.
     */
    function isAuthorizedForPublicOperation(address _sender) external view returns (bool);
}

// File: contracts/saga/interfaces/IMintListener.sol

pragma solidity 0.4.25;

/**
 * @title Mint Listener Interface.
 */
interface IMintListener {
    /**
     * @dev Mint SGA for SGN holders.
     * @param _value The amount of SGA to mint.
     */
    function mintSgaForSgnHolders(uint256 _value) external;
}

// File: contracts/saga-genesis/interfaces/IMintHandler.sol

pragma solidity 0.4.25;

/**
 * @title Mint Handler Interface.
 */
interface IMintHandler {
    /**
     * @dev Upon minting of SGN vested in delay.
     * @param _index The minting-point index.
     */
    function mintSgnVestedInDelay(uint256 _index) external;
}

// File: contracts/saga-genesis/interfaces/IMintManager.sol

pragma solidity 0.4.25;

/**
 * @title Mint Manager Interface.
 */
interface IMintManager {
    /**
     * @dev Return the current minting-point index.
     */
    function getIndex() external view returns (uint256);
}

// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol

pragma solidity 0.4.25;

/**
 * @title Contract Address Locator Interface.
 */
interface IContractAddressLocator {
    /**
     * @dev Get the contract address mapped to a given identifier.
     * @param _identifier The identifier.
     * @return The contract address.
     */
    function getContractAddress(bytes32 _identifier) external view returns (address);

    /**
     * @dev Determine whether or not a contract address is relates to one of the given identifiers.
     * @param _contractAddress The contract address to look for.
     * @param _identifiers The identifiers.
     * @return Is the contract address relates to one of the identifiers.
     */
    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);
}

// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol

pragma solidity 0.4.25;


/**
 * @title Contract Address Locator Holder.
 * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.
 * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.
 * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.
 * @dev In addition to that, any function in any contract can be restricted to a specific caller.
 */
contract ContractAddressLocatorHolder {
    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";
    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;
    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;
    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;
    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;
    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;
    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;
    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;
    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;
    bytes32 internal constant _IMintListener_            = "IMintListener"           ;
    bytes32 internal constant _IMintManager_             = "IMintManager"            ;
    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;
    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;
    bytes32 internal constant _IRedButton_               = "IRedButton"              ;
    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;
    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;
    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;
    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;
    bytes32 internal constant _ISGAAuthorizationManager_ = "ISGAAuthorizationManager";
    bytes32 internal constant _ISGAToken_                = "ISGAToken"               ;
    bytes32 internal constant _ISGATokenManager_         = "ISGATokenManager"        ;
    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";
    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;
    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;
    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;
    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;
    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;
    bytes32 internal constant _IWalletsTradingDataSource_       = "IWalletsTradingDataSource"      ;
    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;
    bytes32 internal constant _WalletsTradingLimiter_SGATokenManager_          = "WalletsTLSGATokenManager"         ;
    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;
    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;
    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;
    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;

    IContractAddressLocator private contractAddressLocator;

    /**
     * @dev Create the contract.
     * @param _contractAddressLocator The contract address locator.
     */
    constructor(IContractAddressLocator _contractAddressLocator) internal {
        require(_contractAddressLocator != address(0), "locator is illegal");
        contractAddressLocator = _contractAddressLocator;
    }

    /**
     * @dev Get the contract address locator.
     * @return The contract address locator.
     */
    function getContractAddressLocator() external view returns (IContractAddressLocator) {
        return contractAddressLocator;
    }

    /**
     * @dev Get the contract address mapped to a given identifier.
     * @param _identifier The identifier.
     * @return The contract address.
     */
    function getContractAddress(bytes32 _identifier) internal view returns (address) {
        return contractAddressLocator.getContractAddress(_identifier);
    }



    /**
     * @dev Determine whether or not the sender is relates to one of the identifiers.
     * @param _identifiers The identifiers.
     * @return Is the sender relates to one of the identifiers.
     */
    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {
        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);
    }

    /**
     * @dev Verify that the caller is mapped to a given identifier.
     * @param _identifier The identifier.
     */
    modifier only(bytes32 _identifier) {
        require(msg.sender == getContractAddress(_identifier), "caller is illegal");
        _;
    }

}

// File: contracts/saga/MintManager.sol

pragma solidity 0.4.25;








/**
 * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
 */

/**
 * @title Mint Manager.
 */
contract MintManager is IMintManager, ContractAddressLocatorHolder {
    string public constant VERSION = "1.0.0";

    uint256 public index;

    /**
     * @dev Create the contract.
     * @param _contractAddressLocator The contract address locator.
     */
    constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}

    /**
     * @dev Return the contract which implements the IModelDataSource interface.
     */
    function getModelDataSource() public view returns (IModelDataSource) {
        return IModelDataSource(getContractAddress(_IModelDataSource_));
    }

    /**
     * @dev Return the contract which implements the IMintingPointTimersManager interface.
     */
    function getMintingPointTimersManager() public view returns (IMintingPointTimersManager) {
        return IMintingPointTimersManager(getContractAddress(_IMintingPointTimersManager_));
    }

    /**
     * @dev Return the contract which implements the ISGAAuthorizationManager interface.
     */
    function getSGAAuthorizationManager() public view returns (ISGAAuthorizationManager) {
        return ISGAAuthorizationManager(getContractAddress(_ISGAAuthorizationManager_));
    }

    /**
     * @dev Return the contract which implements the IMintHandler interface.
     */
    function getMintHandler() public view returns (IMintHandler) {
        return IMintHandler(getContractAddress(_IMintHandler_));
    }

    /**
     * @dev Return the contract which implements the IMintListener interface.
     */
    function getMintListener() public view returns (IMintListener) {
        return IMintListener(getContractAddress(_IMintListener_));
    }

    /**
     * @dev Return whether or not the minting-state should be updated.
     */
    function isMintingStateOutdated() public view returns (bool) {
        return getMintingPointTimersManager().expired(index + 1);
    }

    /**
     * @dev Update the minting-state if it is outdated.
     */
    function updateMintingState() external {
        require(getSGAAuthorizationManager().isAuthorizedForPublicOperation(msg.sender), "update minting state is not authorized");
        if (isMintingStateOutdated()) {
            uint256 amount = getModelDataSource().getRequiredMintAmount(index);
            getMintListener().mintSgaForSgnHolders(amount);
            getMintHandler().mintSgnVestedInDelay(index + 1);
            index += 1;
        }
    }

    /**
     * @dev Return the current minting-point index.
     */
    function getIndex() external view returns (uint256) {
        return index;
    }
}