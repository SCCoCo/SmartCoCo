/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

pragma solidity ^0.6.0;


/**
 * 
 * UniPower's Liquidity Vault
 * 
 * Simple smart contract to decentralize the uniswap liquidity, providing proof of liquidity indefinitely.
 * For more info visit: https://unipower.network 
 * 
 */
contract LiquidityVault {
    
    ERC20 constant kgwToken = ERC20(0x55Eb5288c9b65037a4cd2289637f38A4F9DB3a6B);
    ERC20 constant liquidityToken = ERC20(0x7d3bA7C3188cAb8a02a68b369dbddC3F405B5Bf5);
    
    address blobby = msg.sender;
    uint256 public lastTradingFeeDistribution;
    uint256 public migrationLock;
    address public migrationRecipient;
    
    
 
    function distributeWeekly(address recipient) external {
        uint256 liquidityBalance = liquidityToken.balanceOf(address(this));
        require(lastTradingFeeDistribution + 7 days < now); // Max once a day
        require(msg.sender == blobby);
        liquidityToken.transfer(recipient, (liquidityBalance / 100));
        lastTradingFeeDistribution = now;
    } 
    
    
    function startLiquidityMigration(address recipient) external {
        require(msg.sender == blobby);
        migrationLock = now + 177 days;
        migrationRecipient = recipient;
    }
    
    
    function processMigration() external {
        require(msg.sender == blobby);
        require(migrationRecipient != address(0));
        require(now > migrationLock);
        
        uint256 liquidityBalance = liquidityToken.balanceOf(address(this));
        liquidityToken.transfer(migrationRecipient, liquidityBalance);
    }
    
    
    
    function getBlobby() public view returns (address){
        return blobby;
    }
    function getLiquidityBalance() public view returns (uint256){
        return liquidityToken.balanceOf(address(this));
    }
    
}

interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}