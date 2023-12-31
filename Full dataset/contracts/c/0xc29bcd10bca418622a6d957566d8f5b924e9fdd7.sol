/**
 *Submitted for verification at Etherscan.io on 2021-02-06
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

contract ContractGuard {
    mapping(uint256 => mapping(address => bool)) private _status;

    function checkSameOriginReentranted() internal view returns (bool) {
        return _status[block.number][tx.origin];
    }

    function checkSameSenderReentranted() internal view returns (bool) {
        return _status[block.number][msg.sender];
    }

    modifier onlyOneBlock() {
        require(!checkSameOriginReentranted(), "ContractGuard: one block, one function");
        require(!checkSameSenderReentranted(), "ContractGuard: one block, one function");

        _;

        _status[block.number][tx.origin] = true;
        _status[block.number][msg.sender] = true;
    }
}

interface IBondMarket {
    function bondSupply() external view returns (uint256);

    function isDebtPhase() external view returns (bool);

    function epoch() external view returns (uint256);

    function nextEpochPoint() external view returns (uint256);

    function nextEpochLength() external view returns (uint256);

    function issueNewBond(uint256 _issuedBond) external;

    function buyCoupons(uint256 _amount, uint256 _targetPrice) external;

    function redeemCoupons(
        uint256 _epoch,
        uint256 _amount,
        uint256 _targetPrice
    ) external;
}

interface IEpochController {
    function epoch() external view returns (uint256);

    function nextEpochPoint() external view returns (uint256);

    function nextEpochLength() external view returns (uint256);

    function nextEpochAllocatedReward(address _pool) external view returns (uint256);
}

interface ITreasury is IEpochController {
    function dollarPriceOne() external view returns (uint256);

    function dollarPriceCeiling() external view returns (uint256);
}

interface IDollar {
    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

    function mint(address account, uint256 amount) external returns (bool);
}

interface IOracle {
    function epoch() external view returns (uint256);

    function nextEpochPoint() external view returns (uint256);

    function updateCumulative() external;

    function update() external;

    function consult(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);

    function consultDollarPrice(address _sideToken, uint256 _amountIn) external view returns (uint256 _dollarPrice);

    function twap(uint256 _amountIn) external view returns (uint144 _amountOut);

    function twapDollarPrice(address _sideToken, uint256 _amountIn) external view returns (uint256 _amountOut);
}

contract BondMarket is ContractGuard, IBondMarket {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    /* ========== STATE VARIABLES ========== */

    // governance
    address public operator;

    // flags
    bool public initialized = false;

    // core components
    address public dollar = address(0x3479B0ACF875405D7853f44142FE06470a40f6CC);
    address public treasury = address(0x71535ad4C7C5925382CdEadC806371cc89A5085D);

    // oracle
    address public dollarOracle = address(0xa2D385185Bbd96f4794AE3504aeaa7825827A297);
    uint256 public constant dollarPriceOne = 1e18;
    address public sideToken = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // WETH

    // coupon info
    uint256 public couponSupply;
    uint256 public couponIssued;
    uint256 public couponClaimed;

    // coupon purchase & redeem
    uint256 public discountPercent; // when purchasing coupon
    uint256 public maxDiscountRate;
    uint256 public premiumPercent; // when redeeming coupon
    uint256 public maxPremiumRate;
    uint256 public maxRedeemableCouponPercentPerEpoch;
    mapping(address => mapping(uint256 => uint256)) public purchasedCoupons; // user -> epoch -> purchased coupons
    mapping(address => uint256[]) public purchasedEpochs; // user -> array of purchasing epochs
    mapping(uint256 => uint256) public redemptedCoupons; // epoch -> redempted coupons

    /* =================== Added variables (need to keep orders for proxy to work) =================== */
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    uint256 public lpPoolIncentiveRate;
    uint256 public expiredCouponEpochs;

    /* =================== Events =================== */

    event Initialized(address indexed executor, uint256 at);
    event IssueNewCoupon(uint256 timestamp, uint256 amount);
    event BoughtCoupons(address indexed from, uint256 epoch, uint256 dollarAmount, uint256 bondAmount);
    event RedeemedCoupons(address indexed from, uint256 epoch, uint256 redeemedEpoch, uint256 dollarAmount, uint256 bondAmount);

    /* =================== Modifier =================== */

    modifier onlyOperator() {
        require(operator == msg.sender, "CouponMarket: caller is not the operator");
        _;
    }

    modifier onlyTreasury() {
        require(treasury == msg.sender || operator == msg.sender, "CouponMarket: caller is not a treasury nor operator");
        _;
    }

    modifier notInitialized {
        require(!initialized, "CouponMarket: already initialized");
        _;
    }

    /* ========== VIEW FUNCTIONS ========== */

    // flags
    function isInitialized() public view returns (bool) {
        return initialized;
    }

    // epoch
    function epoch() public view override returns (uint256) {
        return ITreasury(treasury).epoch();
    }

    function nextEpochPoint() public view override returns (uint256) {
        return ITreasury(treasury).nextEpochPoint();
    }

    function nextEpochLength() public view override returns (uint256) {
        return ITreasury(treasury).nextEpochLength();
    }

    // oracle
    function getDollarPrice() public view returns (uint256 _dollarPrice) {
        try IOracle(dollarOracle).consultDollarPrice(sideToken, 1e18) returns (uint256 price) {
            return price;
        } catch {
            revert("CouponMarket: failed to consult dollar price from the oracle");
        }
    }

    function getDollarUpdatedPrice() public view returns (uint256 _dollarPrice) {
        try IOracle(dollarOracle).twapDollarPrice(sideToken, 1e18) returns (uint256 price) {
            return price;
        } catch {
            revert("CouponMarket: failed to get TWAP dollar price from the oracle");
        }
    }

    function isDebtPhase() public view override returns (bool) {
        return getDollarUpdatedPrice() < dollarPriceOne;
    }

    function bondSupply() public view override returns (uint256) {
        return couponSupply;
    }

    function getCouponDiscountRate() public view returns (uint256 _rate) {
        uint256 _dollarPrice = getDollarUpdatedPrice();
        if (_dollarPrice < dollarPriceOne) {
            if (discountPercent == 0) {
                // no discount
                _rate = dollarPriceOne;
            } else {
                uint256 _couponAmount = dollarPriceOne.mul(1e18).div(_dollarPrice); // to burn 1 dollar
                uint256 _discountAmount = _couponAmount.sub(dollarPriceOne).mul(discountPercent).div(10000);
                _rate = dollarPriceOne.add(_discountAmount);
                uint256 _maxDiscountRate = maxDiscountRate;
                if (_maxDiscountRate > 0 && _rate > _maxDiscountRate) {
                    _rate = _maxDiscountRate;
                }
            }
        }
    }

    function getCouponPremiumRate() public view returns (uint256 _rate) {
        uint256 _dollarPrice = getDollarUpdatedPrice();
        if (_dollarPrice >= dollarPriceOne) {
            if (premiumPercent == 0) {
                // no premium bonus
                _rate = dollarPriceOne;
            } else {
                uint256 _premiumAmount = _dollarPrice.sub(dollarPriceOne).mul(premiumPercent).div(10000);
                _rate = dollarPriceOne.add(_premiumAmount);
                uint256 _maxPremiumRate = maxPremiumRate;
                if (_maxPremiumRate > 0 && _rate > _maxPremiumRate) {
                    _rate = _maxPremiumRate;
                }
            }
        }
    }

    function getBurnableDollarLeft() public view returns (uint256 _burnableDollarLeft) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice < dollarPriceOne) {
            _burnableDollarLeft = couponSupply.mul(1e18).div(getCouponDiscountRate());
        }
    }

    function getRedeemableCoupons() public view returns (uint256 _redeemableCoupons) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice >= dollarPriceOne) {
            uint256 _epoch = epoch();
            uint256 _maxRedeemableCoupons = IERC20(dollar).totalSupply().mul(maxRedeemableCouponPercentPerEpoch).div(10000);
            uint256 _redemptedCoupons = redemptedCoupons[_epoch];
            _redeemableCoupons = (_maxRedeemableCoupons <= _redemptedCoupons) ? 0 : _maxRedeemableCoupons.sub(_redemptedCoupons);
        }
    }

    function getPurchasedCouponHistory(address _account)
        external
        view
        returns (
            uint256 _length,
            uint256[] memory _epochs,
            uint256[] memory _amounts
        )
    {
        uint256 _purchasedEpochLength = purchasedEpochs[_account].length;
        _epochs = new uint256[](_purchasedEpochLength);
        _amounts = new uint256[](_purchasedEpochLength);
        for (uint256 _index = 0; _index < _purchasedEpochLength; _index++) {
            uint256 _ep = purchasedEpochs[_account][_index];
            uint256 _amt = purchasedCoupons[_account][_ep];
            if (_amt > 0) {
                _epochs[_length] = _ep;
                _amounts[_length] = _amt;
                ++_length;
            }
        }
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _account) external view returns (uint256) {
        return _balances[_account];
    }

    /* ========== GOVERNANCE ========== */

    function initialize(
        address _dollar,
        address _treasury,
        address _dollarOracle
    ) public notInitialized {
        dollar = _dollar;
        treasury = _treasury;
        dollarOracle = _dollarOracle;

        sideToken = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

        couponSupply = 0;
        couponIssued = 0;
        couponClaimed = 0;

        maxDiscountRate = 130e16; // upto 130%
        maxPremiumRate = 130e16; // upto 130%

        discountPercent = 3000; // 30%
        premiumPercent = 3000; // 30%

        maxRedeemableCouponPercentPerEpoch = 300; // 3% redeemable each epoch

        initialized = true;
        operator = msg.sender;

        emit Initialized(msg.sender, block.number);
    }

    function setOperator(address _operator) external onlyOperator {
        operator = _operator;
    }

    function setDollarOracle(address _dollarOracle) external onlyOperator {
        dollarOracle = _dollarOracle;
    }

    function setSideToken(address _sideToken) external onlyOperator {
        sideToken = _sideToken;
    }

    function setMaxDiscountRate(uint256 _maxDiscountRate) external onlyOperator {
        maxDiscountRate = _maxDiscountRate;
    }

    function setMaxPremiumRate(uint256 _maxPremiumRate) external onlyOperator {
        maxPremiumRate = _maxPremiumRate;
    }

    function setDiscountPercent(uint256 _discountPercent) external onlyOperator {
        require(_discountPercent <= 20000, "over 200%");
        discountPercent = _discountPercent;
    }

    function setPremiumPercent(uint256 _premiumPercent) external onlyOperator {
        require(_premiumPercent <= 20000, "over 200%");
        premiumPercent = _premiumPercent;
    }

    function setMaxRedeemableCouponPercentPerEpoch(uint256 _maxRedeemableCouponPercentPerEpoch) external onlyOperator {
        require(_maxRedeemableCouponPercentPerEpoch <= 10000, "over 100%");
        maxRedeemableCouponPercentPerEpoch = _maxRedeemableCouponPercentPerEpoch;
    }

    function setLpPoolIncentiveRate(uint256 _lpPoolIncentiveRate) external onlyOperator {
        require(_lpPoolIncentiveRate <= 2000, "over 20%");
        lpPoolIncentiveRate = _lpPoolIncentiveRate;
    }

    function setExpiredCouponEpochs(uint256 _expiredCouponEpochs) external onlyOperator {
        require(_expiredCouponEpochs >= 180, "too short"); // >= 180 epochs
        expiredCouponEpochs = _expiredCouponEpochs;
    }

    // Manual add balances for display only
    function manuallyBalanceAdd(address _account, uint256 _amount) external onlyOperator {
        _balances[_account] = _balances[_account].add(_amount);
        _totalSupply = _totalSupply.add(_amount);
    }

    function governanceRecoverUnsupported(
        IERC20 _token,
        uint256 _amount,
        address _to
    ) external onlyOperator {
        _token.safeTransfer(_to, _amount);
    }

    /* ========== MUTABLE FUNCTIONS ========== */

    function _updateDollarPrice() internal {
        try IOracle(dollarOracle).update() {} catch {}
    }

    function _updateDollarPriceCumulative() internal {
        try IOracle(dollarOracle).updateCumulative() {} catch {}
    }

    function issueNewBond(uint256 _issuedBond) external override onlyTreasury {
        couponSupply = couponSupply.add(_issuedBond);
    }

    function buyCoupons(uint256 _dollarAmount, uint256 _targetPrice) external override onlyOneBlock {
        require(_dollarAmount > 0, "BondMarket: cannot purchase coupons with zero amount");

        uint256 _dollarPrice = getDollarUpdatedPrice();
        require(_dollarPrice == _targetPrice, "BondMarket: dollar price moved");
        require(
            _dollarPrice < dollarPriceOne, // price < $1
            "BondMarket: dollarPrice not eligible for coupon purchase"
        );

        uint256 _burnableDollarLeft = getBurnableDollarLeft();
        require(_dollarAmount <= _burnableDollarLeft, "BondMarket: not enough coupon left to purchase");

        uint256 _rate = getCouponDiscountRate();
        require(_rate > 0, "BondMarket: invalid coupon rate");

        uint256 _couponAmount = _dollarAmount.mul(_rate).div(1e18);
        couponSupply = couponSupply.sub(_couponAmount);
        couponIssued = couponIssued.add(_couponAmount);

        uint256 _epoch = epoch();
        address _dollar = dollar;
        IDollar(_dollar).burnFrom(msg.sender, _dollarAmount);
        purchasedCoupons[msg.sender][_epoch] = purchasedCoupons[msg.sender][_epoch].add(_couponAmount);
        _balances[msg.sender] = _balances[msg.sender].add(_couponAmount);
        _totalSupply = _totalSupply.add(_couponAmount);

        if (lpPoolIncentiveRate > 0) {
            uint256 _lpPoolIncentive = (_dollarAmount * lpPoolIncentiveRate) / 10000;
            IDollar(_dollar).mint(treasury, _lpPoolIncentive);
        }

        uint256 _purchasedEpochLength = purchasedEpochs[msg.sender].length;
        if (_purchasedEpochLength == 0 || purchasedEpochs[msg.sender][_purchasedEpochLength - 1] < _epoch) {
            purchasedEpochs[msg.sender].push(_epoch);
        }

        _updateDollarPriceCumulative();

        emit BoughtCoupons(msg.sender, _epoch, _dollarAmount, purchasedCoupons[msg.sender][_epoch]);
    }

    function redeemCoupons(
        uint256 _epoch,
        uint256 _couponAmount,
        uint256 _targetPrice
    ) external override onlyOneBlock {
        require(_couponAmount > 0, "BondMarket: cannot redeem coupons with zero amount");

        uint256 _currentEpoch = epoch();
        uint256 _expiredCouponEpochs = expiredCouponEpochs;
        if (_expiredCouponEpochs > 0) {
            require(_epoch.add(_expiredCouponEpochs) >= _currentEpoch, "BondMarket: coupons expired");
        }

        uint256 _dollarPrice = getDollarUpdatedPrice();
        require(_dollarPrice == _targetPrice, "BondMarket: dollar price moved");
        require(
            _dollarPrice >= dollarPriceOne, // price >= $1
            "BondMarket: dollarPrice not eligible for coupon purchase"
        );

        uint256 _redeemableCoupons = getRedeemableCoupons();
        require(_couponAmount <= _redeemableCoupons, "BondMarket: not enough coupon available to redeem");

        uint256 _rate = getCouponPremiumRate();
        require(_rate > 0, "BondMarket: invalid coupon rate");

        uint256 _dollarAmount = _couponAmount.mul(_rate).div(1e18);
        IDollar(dollar).mint(msg.sender, _dollarAmount);
        purchasedCoupons[msg.sender][_epoch] = purchasedCoupons[msg.sender][_epoch].sub(_couponAmount, "over redeem");
        _balances[msg.sender] = _balances[msg.sender].sub(_couponAmount);
        _totalSupply = _totalSupply.sub(_couponAmount);
        couponClaimed = couponClaimed.add(_couponAmount);

        redemptedCoupons[_currentEpoch] = redemptedCoupons[_currentEpoch].add(_couponAmount);

        _updateDollarPriceCumulative();

        emit RedeemedCoupons(msg.sender, _currentEpoch, _epoch, _dollarAmount, _couponAmount);
    }
}