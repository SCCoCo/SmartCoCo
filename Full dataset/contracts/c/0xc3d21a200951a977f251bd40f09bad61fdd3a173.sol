/**
 *Submitted for verification at Etherscan.io on 2021-04-08
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

// A modification of OpenZeppelin ERC20
// Original can be found here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol

// Very slow erc20 implementation. Limits release of the funds with emission rate in _beforeTokenTransfer().
// Even if there will be a vulnerability in upgradeable contracts defined in _beforeTokenTransfer(), it won't be devastating.
// Developers can't simply rug.
// Allowances are booleans now instead of uints and uni v2 router is hardcoded, so it achieves -7100 gas per trade on uni v2 post-Berlin
// _mint() and _burn() functions are removed.
// Token name and symbol can be changed.
// Bulk transfer allows to transact in bulk cheaper by making up to three times less store writes in comparison to regular erc-20 transfers

contract VSRERC20 {
	event Transfer(address indexed from, address indexed to, uint value);
	event Approval(address indexed owner, address indexed spender, uint value);
	event BulkTransfer(address indexed from, address[] indexed recipients, uint[] amounts);
	event BulkTransferFrom(address[] indexed senders, uint[] amounts, address indexed recipient);
	event NameSymbolChangedTo(string name, string symbol);

	mapping (address => mapping (address => bool)) private _allowances;
	mapping (address => uint) private _balances;

	string private _name;
	string private _symbol;
	address private _governance;
//	uint88 private _nextBulkBlock;
	uint8 private _governanceSet;
// live it will be set as hardcoded addresses in next logic
	address private _registry;
	address private _founding;
	bool private _init;
	bool private _contractsDefined;

	function init() public {
		require(_init == false);_init = true;_name = "RAID";_symbol = "RAID";_governance = msg.sender;_balances[msg.sender] = 1e27;emit NameSymbolChangedTo("RAID","RAID");
	}

	function defineContracts(address c, address t) public onlyGovernance {require(_contractsDefined == false);_contractsDefined = true; _founding = c; _registry = t;}
	modifier onlyGovernance() {require(msg.sender == _governance);_;}
	function withdrawn() public view returns(uint wthdrwn) {uint withd =  999e24 - _balances[_registry]; return withd;}
	function name() public view returns (string memory) {return _name;}
	function symbol() public view returns (string memory) {return _symbol;}
	function totalSupply() public view returns (uint) {uint supply = (block.number - 12640000)*42e16+1e24;if (supply > 1e27) {supply = 1e27;}return supply;}
	function decimals() public pure returns (uint) {return 18;}
	function balanceOf(address a) public view returns (uint) {return _balances[a];}
	function transfer(address recipient, uint amount) public returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
	function disallow(address spender) public returns (bool) {delete _allowances[msg.sender][spender];emit Approval(msg.sender, spender, 0);return true;}
	function setNameSymbol(string memory n_, string memory s_) public onlyGovernance {_name = n_;_symbol = s_;emit NameSymbolChangedTo(n_,s_);}
	function setGovernance(address a) public onlyGovernance {require(_governanceSet < 3);_governanceSet += 1;_governance = a;}
	function _isContract(address a) internal view returns(bool) {uint s_;assembly {s_ := extcodesize(a)}return s_ > 0;}

	function approve(address spender, uint amount) public returns (bool) { // hardcoded mainnet uniswapv2 router 02, transfer helper library
		if (spender == 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D) {emit Approval(msg.sender, spender, 2**256 - 1);return true;}
		else {_allowances[msg.sender][spender] = true;emit Approval(msg.sender, spender, 2**256 - 1);return true;}
	}

	function allowance(address owner, address spender) public returns (uint) { // hardcoded mainnet uniswapv2 router 02, transfer helper library
		if (spender == 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D||_allowances[owner][spender] == true) {return 2**256 - 1;} else {return 0;}
	}

	function transferFrom(address sender, address recipient, uint amount) public returns (bool) { // hardcoded mainnet uniswapv2 router 02, transfer helper library
		require(msg.sender == 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D||_allowances[sender][msg.sender] == true);_transfer(sender, recipient, amount);return true;
	}

	function _transfer(address sender, address recipient, uint amount) internal {
		require(sender != address(0) && recipient != address(0));
		_beforeTokenTransfer(sender, recipient, amount);
		uint senderBalance = _balances[sender];
		require(senderBalance >= amount);
		_balances[sender] = senderBalance - amount;
		_balances[recipient] += amount;
		emit Transfer(sender, recipient, amount);
	}

/*	function bulkTransfer(address[] memory recipients, uint[] memory amounts) public returns (bool) { // will be used by the contract, or anybody who wants to use it
		require(recipients.length == amounts.length && amounts.length < 100,"human error");
		require(block.number >= _nextBulkBlock);
		_nextBulkBlock = uint88(block.number + 20);
		uint senderBalance = _balances[msg.sender];
		uint total;
		for(uint i = 0;i<amounts.length;i++) {if (recipients[i] != address(0) && amounts[i] > 0) {total += amounts[i];_balances[recipients[i]] += amounts[i];}else{revert();}}
		require(senderBalance >= total);
		if (msg.sender == _registry) {_beforeTokenTransfer(msg.sender, total);}
		if (senderBalance == total) {delete _balances[msg.sender];} else {_balances[msg.sender] = senderBalance - total;}
		emit BulkTransfer(msg.sender, recipients, amounts);
		return true;
	}

	function bulkTransferFrom(address[] memory senders, address recipient, uint[] memory amounts) public returns (bool) {
		require(senders.length == amounts.length && amounts.length < 100,"human error");
		require(block.number >= _nextBulkBlock);
		_nextBulkBlock = uint88(block.number + 20);
		uint total;
		uint senderBalance;
		for (uint i = 0;i<amounts.length;i++) {
			senderBalance = _balances[senders[i]];
			if (amounts[i] > 0 && senderBalance >= amounts[i] && _allowances[senders[i]][msg.sender]== true){
				total+= amounts[i];	_balances[senders[i]] = senderBalance - total;//does not delete if empty, since it could be just trading
			} else {revert();}
		}
		_balances[msg.sender] += total;
		emit BulkTransferFrom(senders, amounts, recipient);
		return true;
	}*/

	function _beforeTokenTransfer(address from, address to, uint amount) internal {
		if(block.number < 12640000) {require(from == _founding || from == _governance);}
		else {
			if (from == _registry) {// hardcoded address
				require(block.number > 12640000);
				uint registry = _balances[_registry];
				uint withd =  999e24 - registry;
				uint allowed = (block.number - 12640000)*42e16 - withd;
				require(amount <= allowed && amount <= registry);
			}
		}
	}
}