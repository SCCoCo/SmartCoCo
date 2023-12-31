/**
 *Submitted for verification at Etherscan.io on 2021-07-03
*/

/**
 *Submitted for verification at Etherscan.io on 2021-07-02
*/

pragma solidity ^0.4.23;

/**
 * Static call proxy
 *
 * Use case: Obtain the result of a contract write method from a view method without actually writing state
 * Context: In EVM versions Byzantium or newer view methods utilize the `staticcall` opcode which enforces state to
 *          remain unmodified as part of EVM execution. This proxy contract was made to allow easier access to write method
 *          output from a view method without modifying state in newer versions of the EVM.
 *
 * Given a destination address and calldata:
 * - Forward request to an internal method (readInternal)
 * - Perform an eth_call to the destination address using calldata
 * - Perform a revert to roll back state
 * - Save the result of the call in a the revert message
 * - Throw out the revert and return the revert message as a successful response
 *
 * Usage: IStaticCallProxy(proxyAddress).read(destination, abi.encodeWithSignature("method(uint256)", arg));
 * 
 * Based on previous work from axic: https://gist.github.com/axic/fc61daf7775c56da02d21368865a9416
 */
 
interface IStaticCallProxy {
    function read(address _destination, bytes _calldata) external view returns (uint256);
}

contract StaticCallProxy {
    uint256 foo = 5; // test storage variable
    
    function readInternal(address _destination, bytes _calldata) public returns (bytes32) {
        uint256 _calldata_length = _calldata.length;
        assembly {
            pop(call(gas(), _destination, 0, add(_calldata, 0x20), _calldata_length, 0, 0))
            returndatacopy(0, 0, returndatasize())
            revert(0, 32)
        }
    }

    function read(address _destination, bytes memory _calldata) public returns (bytes32) {
        assembly {
            let _calldatasize := calldatasize()
            calldatacopy(0, 0, _calldatasize)

            // 0x9569bf28 = keccak256(readInternal(address,bytes))
            mstore8(0, 0x95)
            mstore8(add(0, 1), 0x69)
            mstore8(add(0, 2), 0xbf)
            mstore8(add(0, 3), 0x28)
            pop(call(gas(), address(), 0, 0, _calldatasize, 0, 0))
            returndatacopy(0, 0, returndatasize())
            return(0, 32)
        }
    }

    function currentState() public view returns (uint256) {
        return foo;
    }

    function updateState() public returns (uint256) {
        foo = 6;
        return foo;
    }
    
    function newState() public view returns (uint256) {
        return IStaticCallProxy(this).read(this, abi.encodeWithSignature("updateState()"));
    }
}