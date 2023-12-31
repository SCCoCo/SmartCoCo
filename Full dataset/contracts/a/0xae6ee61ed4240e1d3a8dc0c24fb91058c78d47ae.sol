/**
 *Submitted for verification at Etherscan.io on 2021-09-25
*/

// Sources flattened with hardhat v2.4.1 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/[email protected]

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

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

// File contracts/interfaces/utils/IUtils.sol

pragma solidity ^0.8.0;

interface IUtils {
    function isContract(address addr) external view returns (bool);

    function isContracts(address[] calldata addrs) external view returns (bool[] memory);

    function getBalances(address token, address[] calldata addrs) external view returns (uint256[] memory);
}

// File contracts/utils/SNXAirDropHelper.sol

pragma solidity ^0.8.0;

interface IIssuer {
    function collateral(address addr) external view returns (uint256);
}

contract SNXAirDropHelper {
    IERC20 public snx;
    IUtils public utils;
    IIssuer public issuer;

    struct Info {
        uint256 snx;
        uint256 collateral;
    }

    constructor(
        IERC20 _snx,
        IUtils _utils,
        IIssuer _issuer
    ) {
        require(address(_snx) != address(0), "Invalid _snx");
        require(address(_utils) != address(0), "Invalid _utils");
        require(address(_issuer) != address(0), "Invalid _issuer");

        snx = _snx;
        utils = _utils;
        issuer = _issuer;
    }

    function getBalances(address[] calldata addrs) external view returns (Info[] memory) {
        Info[] memory results = new Info[](addrs.length);

        for (uint256 index = 0; index < addrs.length; index++) {
            address addr = addrs[index];
            if (!utils.isContract(addr)) {
                // EOA address

                results[index].snx = snx.balanceOf(addr);
                results[index].collateral = issuer.collateral(addr);
            }
        }

        return results;
    }
}