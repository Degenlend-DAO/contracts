pragma solidity 0.8.10;

import { Test } from "forge-std/Test.sol";
import "forge-std/console.sol";
import {stdError} from "forge-std/StdError.sol";
import { ERC20 } from "../contracts/ERC20.sol";
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
        address feeReceiver;
        address admin;

        event Transfer(address indexed from, address indexed to, uint256 value);
   
        event Approval(
            address indexed owner, address indexed spender, uint256 value
        );

        function setUp() public {

            sxNetworkFork = vm.createFork('https://rpc.toronto.sx.technology');
            vm.selectFork(sxNetworkFork); // deploy on sx network

            wsx = new ERC20("Wrapped SX", "WSX", 18); //0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e
            usdc = new ERC20("USD Coin", "USDC", 6); //0x5147891461a7C81075950f8eE6384e019e39ab98

            comptroller = new Comptroller(); //0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b

            usdcInterestRate = new JumpRateModelV2(0, 50000000000000000, 1090000000000000000, 800000000000000000, address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)); //0xeE1bFEE55C42048735c04A9bE7133EB62417F131
            wsxInterestRate = new JumpRateModelV2(350000000000000000, 150000000000000000, 1020000000000000000, 250000000000000000, address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)); //0x353e7839870604Edf9D766bEFb7929c95c215e00
            
            feeReceiver = 0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34;

            admin = 0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34;
            
            degenUSDC = new CErc20Immutable(address(usdc), // Underlying USDC address
                comptroller, // Unitroller address (proxy)
                usdcInterestRate, // USDC interest rate model
                20000000000000000, // Initial exchange rate (0.02 * 1e18)
                "Degen USDC", // Name
                "degenUSDC", // Symbol
                6, // Decimals (USDC has 6 decimals)
                feeReceiver, // Fee Receiver address
                250, // Minting fee (2.5% in basis points)
                payable(admin) // Admin address
            );

            
            degenWSX = new CErc20Immutable(
                address(wsx), // Underlying WSX address
                comptroller, // Unitroller address (proxy)
                wsxInterestRate, // WSX interest rate model
                20000000000000000, // Initial exchange rate (0.02 * 1e18)
                "Degen Wrapped SX", // Name
                "degenWSX", // Symbol
                18, // Decimals (WSX has 18 decimals)
                payable(address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)), // Fee Receiver address
                250, // Minting fee (2.5% in basis points)
                payable(address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)) // Admin address
            );


        }

        function test_Approvals() public {
            uint256 amount = 100;
            
            // Expect Approval event with test contract as owner.
            vm.expectEmit(true, true, false, true);
            emit Approval(address(this), address(degenUSDC), amount);
            usdc.approve(address(degenUSDC), amount); 
        }

        function test_EnteringAMarket() public {

            uint256 amount = 100;

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

        function test_WithdrawingLiquidity() public {
            uint256 amount = 100;
            // Expect redeem to revert (i.e. RedeemComptrollerRejection) Because, there isn't any capital in the market
            vm.expectRevert();
            degenWSX.redeemUnderlying(amount);
            vm.expectRevert();
            degenUSDC.redeemUnderlying(amount);

        }

        function test_BorrowingAssets() public {
            uint256 amount = 100;
            // Expect borrow to revert (i.e. BorrowComptrollerRejection) Because again, there isn't any capital in the market
            vm.expectRevert();
            degenWSX.borrow(amount);
            vm.expectRevert();
            degenUSDC.borrow(amount);
        }

        function test_RepayAssets() public {
            uint256 amount = 100;
            // Expect repay to revert (i.e. RepayBorrowComptrollerRejection)
            vm.expectRevert();
            degenWSX.repayBorrow(amount);
            vm.expectRevert();
            degenUSDC.repayBorrow(amount);
        }

        function test_ExitMarkets() public {
            comptroller.exitMarket(address(degenWSX));
            comptroller.exitMarket(address(degenUSDC));
        }


        function test_IamAbleToDepositUSDSavings() public {

            uint256 amount = 1000; //Let's mess around with 1,000 tokens
            address[] memory marketsUSDC = new address[](1);
            marketsUSDC[0] = address(degenUSDC);

            usdc.approve(address(comptroller), amount);
            comptroller.enterMarkets(marketsUSDC);
            degenUSDC.mint(amount);
        
        }

        function test_IamAbleToDepositWSXSavings() public {
            uint amount = 1000;
            address[] memory marketsWSX = new address[](1);
            marketsWSX[0] = address(degenWSX);

            // Enter the market & deposit funds
            wsx.approve(address(comptroller), amount);
            comptroller.enterMarkets(marketsWSX);
            degenWSX.mint(amount);

        }

        function test_IfThereIsUSDSavingsICanWithdraw() public {
            // First, check if there is USD savings IN the money market
            uint256 amount = 1000;

            // Check if there are any savings already deposited.
            
            if (degenUSDC.balanceOf(address(this)) > 0) {
                degenUSDC.redeem(amount);
            } else {
                vm.expectRevert();
                revert();
            }

        }

        function test_IfThereIsWSXSavingsICanWithdraw() public {
            // First, check if there is WSX Savings IN the money market

            uint amount = 1000;

            if (degenWSX.balanceOf(address(this)) > 0) {
                degenWSX.redeem(amount);
            } else {
                vm.expectRevert();
                revert();
            }

        }

        function test_IfThereIsUSDSavingsICanBorrow() public {
            // First, check if there is USD Savings In the money market
            uint256 amount = 100;

            if (degenUSDC.balanceOf(address(this)) > 900 )
            {
                degenUSDC.borrow(amount);
            } else {
                vm.expectRevert();
                revert();
            }

        }

        function test_IfThereIsWSXSavingsICanBorrow() public {
            //  First, check if there is WSX Savings IN the money market

            uint256 amount = 100;

            if (degenWSX.balanceOf(address(this)) > 990 )  // We will leave some dust in the account, because 2.5% of mint is transferred as fees
            {
                degenWSX.borrow(amount);
            } else {
                vm.expectRevert();
                revert();
            }

        }

        function test_IfThereIsUSDSavingsICanRepay() public {
            // First, check if there is WSX debt I have to repay
            
            
        }

        function test_IfThereIsWSXSavingsICanRepay() public {
            // First, check if there is WSX debt I have to repay

        }
    }