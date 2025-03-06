pragma solidity 0.8.10;

import { Test } from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import { ERC20 } from "../contracts/ERC20.sol";

import { SimplePriceOracle } from "../contracts/SimplePriceOracle.sol";
import { CToken } from "../contracts/libraries/money_markets/CToken.sol";
import { CErc20Immutable } from "../contracts/libraries/money_markets/CErc20Immutable.sol";
import { Comptroller } from "../contracts/libraries/comptroller/Comptroller.sol";
import { JumpRateModelV2 } from "../contracts/libraries/interest_rates/JumpRateModelV2.sol";

// TODO: Fork it to the sx blockchain to actuall test it.
// TODO: fix any missing bugs, and we will be done with this phase.

    contract MoneyMarketTests is Test {
        uint256 sxNetworkFork;
        Comptroller comptroller;
        CErc20Immutable degenWSX;
        CErc20Immutable degenUSDC;
        JumpRateModelV2 usdcInterestRate;
        JumpRateModelV2 wsxInterestRate; 
        ERC20 wsx;
        ERC20 usdc;
        SimplePriceOracle oracle;
        address feeReceiver = 0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34;
        address admin = 0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34;

        address constant WSX_ADDRESS = 0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e;
        address constant USDC_ADDRESS = 0x5147891461a7C81075950f8eE6384e019e39ab98;
        address constant COMPTROLLER_ADDRESS = 0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b;
        address constant USDC_RATE_MODEL = 0xeE1bFEE55C42048735c04A9bE7133EB62417F131;
        address constant WSX_RATE_MODEL = 0x353e7839870604Edf9D766bEFb7929c95c215e00;

        // Deployed contract addresses
        address constant DEGEN_USDC_ADDRESS = 0x05d225eA760bc4E974b0691bFb0Cf026A7D33279;
        address constant DEGEN_WSX_ADDRESS = 0xD2F6594c692985850F85fd1b08d1F9DE0f719Cb5;

        address me = vm.addr(vm.envUint("PRIVATE_KEY"));

        event Transfer(address indexed from, address indexed to, uint256 value);
   
        event Approval(
            address indexed owner, address indexed spender, uint256 value
        );

        function setUp() public {

            // Fork SX Testnet
            sxNetworkFork = vm.createFork('sxTestnet');
            vm.selectFork(sxNetworkFork); // deploy on sx network

            wsx = ERC20(WSX_ADDRESS);
            usdc = ERC20(USDC_ADDRESS);
            comptroller = Comptroller(COMPTROLLER_ADDRESS);
            usdcInterestRate = JumpRateModelV2(USDC_RATE_MODEL);
            wsxInterestRate = JumpRateModelV2(WSX_RATE_MODEL);
            feeReceiver = 0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34;

            oracle = new SimplePriceOracle();
            vm.prank(me);
            comptroller._setPriceOracle(SimplePriceOracle(address(oracle)));
            
            // Deploy tokens locally
            degenUSDC = CErc20Immutable(DEGEN_USDC_ADDRESS);

            degenWSX = CErc20Immutable(DEGEN_WSX_ADDRESS);


            vm.startPrank(me);
            comptroller._supportMarket((CToken(address(degenUSDC))));
            comptroller._supportMarket(CToken(address(degenWSX)));
            oracle.setUnderlyingPrice(CToken(address(degenUSDC)), 1e18); // 1 USD = 1e18
            oracle.setUnderlyingPrice(CToken(address(degenWSX)), 1e18); // Placeholder price
            comptroller._setCollateralFactor(CToken(address(degenUSDC)), 0.5e18);
            comptroller._setCollateralFactor(CToken(address(degenWSX)), 0.5e18);

            console.log("USDC balance of me:", usdc.balanceOf(me) / 10**6, "USDC");
            console.log("WSX balance of me:", wsx.balanceOf(me) / 10**18, "WSX");
            vm.stopPrank();

        }

        function test_Approvals() public {
            vm.startPrank(me);
            uint256 amountUSDC = 100 * 10**6; // 100 USDC
            uint256 amountWSX = 100 * 10**18; // 100 WSX
            
            // Expect Approval event with test contract as owner.
            vm.expectEmit(true, true, false, true);
            emit Approval(me, address(degenUSDC), amountUSDC);
            usdc.approve(address(degenUSDC), amountUSDC); 

            vm.expectEmit(true, true, false, true);
            emit Approval(me, address(degenWSX), amountWSX);
            wsx.approve(address(degenWSX), amountWSX);
            vm.stopPrank();
        }

        function test_EnteringAMarket() public {

            CToken[] memory assetsIn = comptroller.getAssetsIn(address(this));

            {
                address[] memory marketsUSDC = new address[](1);
                marketsUSDC[0] = address(degenUSDC);
                comptroller.enterMarkets(marketsUSDC);
            }
            {
                address[] memory marketsWSX = new address[](1);
                marketsWSX[0] = address(degenWSX);
                comptroller.enterMarkets(marketsWSX);
            }
        }

        function test_ExitMarkets() public {
            comptroller.exitMarket(address(degenWSX));
            comptroller.exitMarket(address(degenUSDC));
        }


        function test_IamAbleToDepositUSDSavings() public {

            uint256 amount = 1000 * 10**6; //Let's mess around with 1,000 tokens
            address[] memory marketsUSDC = new address[](1);
            marketsUSDC[0] = address(degenUSDC);

            vm.startPrank(me);
            require(usdc.balanceOf(me) >= amount, "Insufficient USDC Balance");
            usdc.approve(address(degenUSDC), amount);
            comptroller.enterMarkets(marketsUSDC);
            degenUSDC.mint(amount);
            vm.stopPrank();
        
        }

        function test_IamAbleToDepositWSXSavings() public {
            uint amount = 1000 * 10**18;
            address[] memory marketsWSX = new address[](1);
            marketsWSX[0] = address(degenWSX);

            vm.startPrank(me);
            require(wsx.balanceOf(me) >= amount, "Insufficient WSX Balance");
            wsx.approve(address(degenWSX), amount); // Approve CErc20
            comptroller.enterMarkets(marketsWSX);
            degenWSX.mint(amount);
            vm.stopPrank();
        }

        function test_IfThereIsUSDSavingsICanWithdraw() public {
            uint256 amount = 1000 * 10**6;

            vm.startPrank(me);
            usdc.approve(address(degenUSDC), amount);
            address[] memory markets = new address[](1);
            markets[0] = address(degenUSDC);
            vm.startPrank(me);
            comptroller.enterMarkets(markets);
            degenUSDC.mint(amount); // Deposit funds
            degenUSDC.redeemUnderlying(amount); // Should succeed
            vm.stopPrank();
        }

        function test_IfThereIsWSXSavingsICanWithdraw() public {
            uint256 amount = 1000 * 10**18;
            wsx.approve(address(degenWSX), amount);
            address[] memory markets = new address[](1);
            markets[0] = address(degenWSX);
            vm.startPrank(me);
            comptroller.enterMarkets(markets);
            degenWSX.mint(amount); // Deposit funds
            degenWSX.redeemUnderlying(amount); // Should succeed
            vm.stopPrank();
        }

        function test_IfThereIsUSDSavingsICanBorrow() public {
            uint256 depositAmount = 1000 * 10**6;
            uint256 borrowAmount = 100 * 10**6;
            address[] memory markets = new address[](1);
            markets[0] = address(degenUSDC);

            vm.startPrank(me);
            require(usdc.balanceOf(me) >= depositAmount, 'insufficient USDC Balance');
            usdc.approve(address(degenUSDC), depositAmount);
            comptroller.enterMarkets(markets);
            degenUSDC.mint(depositAmount); // Deposit funds
            // comptroller._setCollateralFactor(CToken(address(degenUSDC)), 0.5e6); // Set collateral factor
            degenUSDC.borrow(borrowAmount); // Should succeed now
            vm.stopPrank();
        }

        function test_IfThereIsWSXSavingsICanBorrow() public {
            uint256 depositAmount = 1000 * 10**18;
            uint256 borrowAmount = 100 * 10**18;
            wsx.approve(address(degenWSX), depositAmount);
            address[] memory markets = new address[](1);
            markets[0] = address(degenWSX);

            vm.startPrank(me);
            comptroller.enterMarkets(markets);
            degenWSX.mint(depositAmount); // Deposit funds
            // comptroller._setCollateralFactor(CToken(address(degenWSX)), 0.5e18); // Set collateral factor
            degenWSX.borrow(borrowAmount); // Should succeed now
            vm.stopPrank();
        }

    }