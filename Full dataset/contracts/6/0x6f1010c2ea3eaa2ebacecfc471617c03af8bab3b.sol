/**
 *Submitted for verification at Etherscan.io on 2021-09-03
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

interface ERC20 {
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

contract ADKSellV2 {
    
// VERSION 2.0       // NOTE DONT USE ANY OLDER ONES, THIS ONE INCLUDES A FEW BUGFIXES    
    
// Contract allowing purchase of Aidos Kuneen ADK for a fixed price
// Simply deposit ETH to this contract and it will exchange it at a fixed FX.
// Check the current wADK balance of this contract before depositing ETH, otherwise the transaction will fail and roll back
    
    address payable public FXContractOwner;
    address wADKContract = 0x888888881f8af02398DC3fee2A243B66356717F8; // wADK Contract
    
    
    uint256 public exchangeRate_WEI_PER_uwADK; // specifies the exchange rate in WEI per uwADK 
                                               // Info: 1 ETH = 10^18 WEI
                                               // Info: 1 wADK = 10^8 uwADK
    uint256 public exchangeRate_wADK_PER_ETH; // specifies the exchange rate: how many ADK you get for 1 ETH
    
    constructor(
       uint256 _exchangeRate_wADK_PER_ETH
    ) {
        FXContractOwner = payable(msg.sender);
        exchangeRate_wADK_PER_ETH  = _exchangeRate_wADK_PER_ETH;
        exchangeRate_WEI_PER_uwADK = 1e10 / _exchangeRate_wADK_PER_ETH; // 1e10 is the difference in decimal position between ETH and wADK
    }
    
    modifier onlyOwner {
        require(msg.sender == FXContractOwner);
        _;
    }

    event PurchasedADKEvent(address _to, uint256 _value);
    
    // Send ETH to this contract, and immediately receive wADK back, at the exchange rate specified in 
    // _exchangeRate_ADK_PER_ETH
    //
    // Info: the exchange rate is specified at contract creation and cannot be changed (to prevent front-running)
    //
    // Info: If there is not enough ADK in this Sale Contract to cover your ETH, the transaction will fail and roll back
    //
    // Info: If the ETH you send results in less than 1 ADK, the transaction will fail and roll back
    //
    // Info: Only send from Ethereum Addresses, that can receive ERC20 TOKEN as the ADK will be sent to the Address sending ETH to this Sale Contract
    //
    
    receive() external payable {
         uint256 uwADK_to_send = msg.value / exchangeRate_WEI_PER_uwADK; 
         require(msg.value != 0);
         require(ERC20(wADKContract).transfer(msg.sender, uwADK_to_send));
         emit PurchasedADKEvent(msg.sender, uwADK_to_send);
         
    }
    
    
    // Convenience Functions:
    
    // How much uwADK is available contract?  Remember 1 wADK = 10^8 uwADK
    function AvailableADKinContract() public view returns (uint256) {
        return ERC20(wADKContract).balanceOf(address(this));
    }
    
    // What is the maximum amount of WEI that can be sent to this contract?
    //  (Depends on wADK balance)
    function MaxWEIdepositable() public view returns (uint256) {  //Remember 1 WEI = 10^18 ETH
        uint256 uwADKBalance = ERC20(wADKContract).balanceOf(address(this));
        return uwADKBalance * exchangeRate_WEI_PER_uwADK; 
    }
    
    /////// For Contract Owner: Remove ETH
    function WithdrawETH() onlyOwner public {
        address payable _msg_sender = payable(msg.sender);
        _msg_sender.transfer(address(this).balance);
    }
    /////// For Contract Owner: Remove wADK
    function WithdrawADK() onlyOwner public {
        uint256 _adk_balance = ERC20(wADKContract).balanceOf(address(this));
        ERC20(wADKContract).transfer(msg.sender, _adk_balance);
    }

}