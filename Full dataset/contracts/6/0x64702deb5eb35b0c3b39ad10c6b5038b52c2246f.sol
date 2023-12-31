/**
 *Submitted for verification at Etherscan.io on 2021-04-21
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;



// Part: Context

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// Part: IERC20

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Part: IWeedVault

interface IWeedVault {
    function balanceOf(address account) external view returns (uint256);
    function addTaxFee(uint256 amount) external returns (bool);
}

// Part: SafeMath

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// Part: Ownable

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: WeedToken.sol

/**
 * 'WEED' token contract
 *
 * Name        : W33D.FINANCE
 * Symbol      : WEED
 * Total supply: 420,069 (420 thousand and 69)
 * Decimals    : 18
 *
 * ERC20 Token, with the Burnable, Pausable and Ownable from OpenZeppelin
 */
contract WeedToken is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint16 public _taxFee;
    address public _vault;
    address private _vaultTokenOwner;
    address private _uniswapTokenOwner;
    address private _presaleTokenOwner;
    address private _uniswapV2Router;


    modifier onlyVault() {
        require(
            _vault == _msgSender(),
            "Ownable: caller is not vault"
        );
        _;
    }

    event ChangedTaxFee(address indexed owner, uint16 fee);
    event ChangedVault(address indexed owner, address indexed oldAddress, address indexed newAddress);
    event ChangedInitialMaxTransfers(address indexed owner, uint8 count);

    IWeedVault weedVault;
    constructor(address uniswapTokenOwner, address presaleTokenOwner, address vaultTokenOwner) public {
        _name = "W33D.FINANCE";
        _symbol = "WEED";
        _decimals = 18;

        _uniswapTokenOwner = uniswapTokenOwner;
        _presaleTokenOwner = presaleTokenOwner;
        _vaultTokenOwner = vaultTokenOwner;
        _uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

        // set initial tax fee(transfer) fee as 4.20%
        // It is allow 2 digits under point
        _taxFee = 420;

        // 420,069

        // Uniswap pool 100
        _mint(_uniswapTokenOwner, 2000E18);
        // Farming 9900
        _mint(_vaultTokenOwner, 376000E18);
        // presale 1000
        _mint(_presaleTokenOwner, 42069E18);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if (_checkWithoutFee()) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint256 taxAmount = amount.mul(uint256(_taxFee)).div(10000);
            uint256 leftAmount = amount.sub(taxAmount);
            _transfer(_msgSender(), _vault, taxAmount);
            _transfer(_msgSender(), recipient, leftAmount);

            weedVault.addTaxFee(taxAmount);
        }

        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        if (_checkWithoutFee()) {
            _transfer(sender, recipient, amount);
        } else {
            uint256 feeAmount = amount.mul(uint256(_taxFee)).div(10000);
            uint256 leftAmount = amount.sub(feeAmount);

            _transfer(sender, _vault, feeAmount);
            _transfer(sender, recipient, leftAmount);
            weedVault.addTaxFee(feeAmount);
        }
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function setTaxFee(uint16 fee) external onlyOwner {
        _taxFee = fee;
        emit ChangedTaxFee(_msgSender(), fee);
    }

    function setVault(address vault) external onlyOwner {
        require(vault != address(0), "Invalid vault contract address");
        address oldAddress = _vault;
        _vault = vault;
        weedVault = IWeedVault(_vault);
        emit ChangedVault(_msgSender(), oldAddress, _vault);
    }


    function burnFromVault(uint256 amount) external onlyVault returns (bool) {
        _burn(_vault, amount);
        return true;
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _checkWithoutFee() internal view returns (bool) {
        if (_msgSender() == _vault || _msgSender() == _presaleTokenOwner ||
            _msgSender() == _uniswapTokenOwner || _msgSender() == _vaultTokenOwner || _msgSender() == _uniswapV2Router) {
            return true;
        } else {
            return false;
        }
    }
}