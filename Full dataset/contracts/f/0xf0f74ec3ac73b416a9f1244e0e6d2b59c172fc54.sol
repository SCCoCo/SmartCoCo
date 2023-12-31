/**
 *Submitted for verification at Etherscan.io on 2021-04-06
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;


contract Adder {
	event Add(uint256 a, uint256 b, uint256 c);
	event AddWithValue(uint256 a, uint256 b, uint256 c);

	function add(uint256 a, uint256 b) external returns (uint256 c) {
		c = a + b;
		emit Add(a, b, c);
	}

	function addWithValue(uint256 a) external payable returns (uint256 c) {
		c = a + msg.value;
		emit AddWithValue(a, msg.value, c);
		payable(msg.sender).transfer(msg.value);
	}
}