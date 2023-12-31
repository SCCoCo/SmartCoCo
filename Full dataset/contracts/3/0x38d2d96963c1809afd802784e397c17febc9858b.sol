/**
 *Submitted for verification at Etherscan.io on 2021-08-01
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

interface erc20 { 
    function balanceOf(address) external view returns (uint);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

interface vault {
    function claimInsurance() external;
}

contract DummyController {
    
    address constant token = 0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84;
    address constant governance = 0x2D407dDb06311396fE14D4b49da5F0471447d45C;
    
    mapping(address => address) public vaults;
    mapping(address => address) public strategies;
    
    function withdraw(address _vault, uint amount) external {}
    function earn(address _vault, uint amount) external {}
    function want(address _vault) external view returns (address) {
        return 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    }
    function balanceOf(address _vault) external view returns (uint) {
        return 0;
    }
    function claimInsurance(address _vault) external {
        vault(_vault).claimInsurance();
        _safeTransfer(token, governance, erc20(token).balanceOf(address(this)));
    }
    function withdraw(address _token) external {
        _safeTransfer(_token, governance, erc20(_token).balanceOf(address(this)));
    }
    
    function _safeTransfer(
        address _token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            _token.call(abi.encodeWithSelector(erc20.transfer.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))));
    }
}