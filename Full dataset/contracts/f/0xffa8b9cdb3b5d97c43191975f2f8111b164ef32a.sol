/**
 *Submitted for verification at Etherscan.io on 2019-10-21
*/

//dapp GUI available at www.structuredeth.com

pragma solidity ^0.4.26;

contract fulcrumInterface {
    function mintWithEther(address receiver, uint256 maxPriceAllowed) external payable returns (uint256 mintAmount);
    function mint(address receiver, uint256 amount) external payable returns (uint256 mintAmount);
    function burnToEther(address receiver, uint256 burnAmount, uint256 minPriceAllowed)  returns (uint256 loanAmountPaid);
}

interface IKyberNetworkProxy {
    function maxGasPrice() external view returns(uint);
    function getUserCapInWei(address user) external view returns(uint);
    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
    function enabled() external view returns(bool);
    function info(bytes32 id) external view returns(uint);
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) external payable returns(uint);
    function swapEtherToToken(ERC20 token, uint minRate) external payable returns (uint);
    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns (uint);
}

interface CompoundERC20 {
  function approve ( address spender, uint256 amount ) external returns ( bool );
  function mint ( uint256 mintAmount ) external returns ( uint256 );
  function totalSupply() public view returns (uint supply);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
}

interface ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public view returns (string) {}
    function symbol() public view returns (string) {}
    function decimals() public view returns (uint8) {}
    function totalSupply() public view returns (uint256) {}
    function balanceOf(address _owner) public view returns (uint256) { _owner; }
    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

contract UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

    // ERC20 Token Smart Contract
    contract EightyTwentyPortfolio {

        using SafeMath for uint256;
        ERC20 dai = ERC20(0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359);
        ERC20 usdc = ERC20(0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48);
        ERC20 eth = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
        address kyberProxyAddress = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;

        // ITokens
        fulcrumInterface iusdc = fulcrumInterface(0xf013406a0b1d544238083df0b93ad0d2cbe0f65f);
        fulcrumInterface idai = fulcrumInterface(0x14094949152eddbfcd073717200da82fed8dc960);

        //CTokens
        CompoundERC20 cdai = CompoundERC20(0xf5dce57282a584d2746faf1593d3121fcac444dc);
        CompoundERC20 ceth = CompoundERC20(0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5);
        CompoundERC20 cusdc = CompoundERC20(0x39aa39c021dfbae8fac545936693ac917d5e7563);
        CompoundERC20 cwbtc = CompoundERC20(0xc11b1268c1a384e55c48c2391d8d480264a3a7f4);



        // Perpetual Longs ETH
        fulcrumInterface dLETH2x = fulcrumInterface(0x8129d9b2c3748791c430fea241207a4f9a0ac516);
 

        // Perpetual Longs WBTC
        fulcrumInterface dLWBTC2x = fulcrumInterface(0x9fe6854447bb39dc8b78960882831269f9e78408);


        UniswapExchangeInterface daiExchange = UniswapExchangeInterface(0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14);
        UniswapExchangeInterface usdcExchange = UniswapExchangeInterface(0x97deC872013f6B5fB443861090ad931542878126);
        uint256 maxMint = 100000000000000000000000000000;
        uint256 createdAmount = 0;
        uint256 createdAmount2 = 0;

        bytes PERM_HINT = "PERM";
        IKyberNetworkProxy kyberProxy = IKyberNetworkProxy(kyberProxyAddress);

        // Its a payable function works as a token factory.
        function () payable {
            buyPackage();
        }

        function buyPackage() payable returns (bool) {
          uint256 ethAmount1 = msg.value.mul(40).div(100);
          uint256 ethAmount2 = msg.value.mul(40).div(100);
          uint256 ethAmount3 = msg.value.mul(10).div(100);
          uint256 ethAmount4 = msg.value.mul(10).div(100);
          uint daiAmount = kyberProxy.tradeWithHint.value(ethAmount1)(eth, ethAmount1, dai, this, 8000000000000000000000000000000000000000000000000000000000000000, 0, 0x0000000000000000000000000000000000000004, PERM_HINT);
          uint usdcAmount = kyberProxy.tradeWithHint.value(ethAmount2)(eth, ethAmount2, usdc, this, 8000000000000000000000000000000000000000000000000000000000000000, 0, 0x0000000000000000000000000000000000000004, PERM_HINT);

        
            dai.approve(address(cdai), 8000000000000000000000000000000000000000000000000000000);
            usdc.approve(address(cusdc), 800000000000000000000000000000000000000000000000000000);
          
           cusdc.mint(usdcAmount);
        cdai.mint(daiAmount);
         
          uint256 usdcMinted = cusdc.balanceOf(this);
          uint256 cDaiMinted = cdai.balanceOf(this);
          
          cdai.transfer(msg.sender, cDaiMinted);
          cusdc.transfer(msg.sender, usdcMinted);
          
          dLWBTC2x.mintWithEther.value(ethAmount3)(msg.sender, maxMint);
          dLETH2x.mintWithEther.value(ethAmount4)(msg.sender, maxMint);
          return true;
        }
    }