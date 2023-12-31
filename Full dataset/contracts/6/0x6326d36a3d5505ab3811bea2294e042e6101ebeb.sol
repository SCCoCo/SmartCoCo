/**
 *Submitted for verification at Etherscan.io on 2020-07-22
*/

pragma solidity ^0.5.12;
pragma experimental ABIEncoderV2;

interface IConversionRate {

    function getStepFunctionData(address token, uint command, uint param) external view returns(int);
    function getListedTokens() external view returns(address[] memory);
}



contract KyberHelper {
    
    // bps - basic rate steps. one step is 1 / 10000 of the rate.
    struct StepFunction {
        int[] x; // quantity for each step. Quantity of each step includes previous steps.
        int[] y; // rate change per quantity step  in bps.
    }

    struct TokenData {
        address token;
        StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
        StepFunction sellRateQtyStepFunction;// in bps. higher the qua
        StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
        StepFunction sellRateImbalanceStepFunction;
    }
    
    function loadStepFunctionData(address conversionRateContract) external view returns (TokenData[] memory data) {
        address[] memory tokens = IConversionRate(conversionRateContract).getListedTokens();
        
        data = new TokenData[](tokens.length);
        
        for (uint i = 0; i < tokens.length; i++) {
            
            data[i].token = tokens[i];
            
            uint[8] memory stepFunctionLenList = [
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 0, 0)),  // buyRateQtyStepFunctionXLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 2, 0)),  // buyRateQtyStepFunctionYLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 4, 0)),  // sellRateQtyStepFunctionXLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 6, 0)),  // sellRateQtyStepFunctionYLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 8, 0)),  // buyRateImbalanceStepFunctionXLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 10, 0)), // buyRateImbalanceStepFunctionYLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 12, 0)), // sellRateImbalanceStepFunctionXLen
                uint(IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 14, 0))  // sellRateImbalanceStepFunctionYLen
            ]; 
            
            data[i].buyRateQtyStepFunction = initStepFunction(stepFunctionLenList[0], stepFunctionLenList[1]);
            data[i].sellRateQtyStepFunction = initStepFunction(stepFunctionLenList[2], stepFunctionLenList[3]);
            data[i].buyRateImbalanceStepFunction = initStepFunction(stepFunctionLenList[4], stepFunctionLenList[5]);
            data[i].sellRateImbalanceStepFunction = initStepFunction(stepFunctionLenList[6], stepFunctionLenList[7]);

            for (uint j = 0; j < getMaxValue(stepFunctionLenList); j++) {
              if (j < stepFunctionLenList[0]) {
                data[i].buyRateQtyStepFunction.x[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 1, uint(j));
              }
              if (j < stepFunctionLenList[1]) {
                data[i].buyRateQtyStepFunction.y[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 3, uint(j));
              }
              if (j < stepFunctionLenList[2]) {
                data[i].sellRateQtyStepFunction.x[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 5, uint(j));
              }
              if (j < stepFunctionLenList[3]) {
                data[i].sellRateQtyStepFunction.y[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 7, uint(j));
              }
              if (j < stepFunctionLenList[4]) {
                data[i].buyRateImbalanceStepFunction.x[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 9, uint(j));
              }
              if (j < stepFunctionLenList[5]) {
                data[i].buyRateImbalanceStepFunction.y[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 11, uint(j));
              }
              if (j < stepFunctionLenList[6]) {
                data[i].sellRateImbalanceStepFunction.x[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 13, uint(j));
              }
              if (j < stepFunctionLenList[7]) {
                data[i].sellRateImbalanceStepFunction.y[j] = IConversionRate(conversionRateContract).getStepFunctionData(tokens[i], 15, uint(j));
              }  
            }
        }
    }
    
    function getMaxValue(uint[8] memory values) private pure returns (uint) {
        uint max; 
        for(uint i = 0; i < values.length; i++) {
            if(values[i] > max) {
                max = values[i]; 
            } 
        }
        return max;
    }
    
    function initStepFunction(uint xLen, uint yLen) private pure returns (StepFunction memory stepFunc) {
        stepFunc.x = new int[](xLen);
        stepFunc.y = new int[](yLen);
    }
    
}