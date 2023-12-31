/**
 *Submitted for verification at Etherscan.io on 2021-06-29
*/

pragma solidity ^0.4.23;

/*
 * STATICCALL Proxy
 * original author: Alex Beregszaszi (@axic) - https://gist.github.com/axic/fc61daf7775c56da02d21368865a9416
 *
 * It expects the input:
 * 256 bit - destination address
 * n   bit - calldata to be proxied
 * 
 * And returns the output:
 * 8 bit - original CALL result
 * n bit - result data
 *
 */
contract StaticCallProxy {
    function() payable external {
        assembly {
            let _dst := calldataload(0)
            let _len : = sub(calldatasize, 32)
            calldatacopy(0, 32, _len)
            let ret := call(gas(), _dst, 0, 0, _len, 0, 0)
            let result_len := returndatasize()
            mstore8(0, ret)
            returndatacopy(1, 0, result_len)
            revert(0, add(result_len, 1))
        }
    }
}