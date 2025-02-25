pragma solidity 0.8.10;

import { Test } from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";
import { ERC20 } from "../contracts/ERC20.sol";
import { CErc20Immutable } from "../contracts/libraries/money_markets/CErc20Immutable.sol";
import { Comptroller } from "../contracts/libraries/comptroller/Comptroller.sol";
import { JumpRateModelV2 } from "../contracts/libraries/interest_rates/JumpRateModelV2.sol";

    contract MoneyMarketTests is Test {
        Comptroller comptroller;
        CErc20Immutable degenWSX;
        CErc20Immutable degenUSDC;
        JumpRateModelV2 usdcInterestRate;
        JumpRateModelV2 wsxInterestRate; 
        ERC20 wSX;
        ERC20 usdc;

        function setUp() public {

            wSX = new ERC20("Wrapped SX", "WSX", 18);
            usdc = new ERC20("USD Coin", "USDC", 6);

            comptroller = new Comptroller();

            usdcInterestRate = new JumpRateModelV2(0, 50000000000000000, 1090000000000000000, 800000000000000000, address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)); //0xeE1bFEE55C42048735c04A9bE7133EB62417F131
            wsxInterestRate = new JumpRateModelV2(350000000000000000, 150000000000000000, 1020000000000000000, 250000000000000000, address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)); //0x353e7839870604Edf9D766bEFb7929c95c215e00

            degenUSDC = new CErc20Immutable(address(0x5147891461a7C81075950f8eE6384e019e39ab98), // Underlying USDC address
                Comptroller(0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b), // Unitroller address (proxy)
                usdcInterestRate, // USDC interest rate model
                20000000000000000, // Initial exchange rate (0.02 * 1e18)
                "Degen USDC", // Name
                "degenUSDC", // Symbol
                6, // Decimals (USDC has 6 decimals)
                payable(address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)), // Fee Receiver address
                250, // Minting fee (2.5% in basis points)
                payable(address(0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34)) // Admin address
            );

            degenWSX = new CErc20Immutable(
                payable(address(0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e)), // Underlying WSX address
                Comptroller(0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b), // Unitroller address (proxy)
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
            // Step one: Approve the underlying tokens FIRST
            vm.expectEmit(true, true, true, true);
            wSX.approve(0x26B94ffdc8FeEA3cd1DB88F5D8FD1C5A08f52Fa8, 2000);

            vm.expectEmit(true, true, true, true);
            usdc.approve(0x26B94ffdc8FeEA3cd1DB88F5D8FD1C5A08f52Fa8, 2000);

        }

        function test_InterestRatesModels() public {

        }

        function test_ComptrollerEngagements() public {

            // comptroller.enterMarkets([]);

        }

        function test_SupplyMarketActivities() public {
            // Step two: use the Comptroller to Enter, exit, then enter markets again.

            // Testing VIEWS
            // View: APY, Balance, Collateral & Price



            // Testing ACTIONS
            // Action: Supply, Withdraw, 


        }


        function test_BorrowMarketActivities() public {
            // Step three, borrow / repay from the money markets

        }


        function test_FeeCollection() public {

            // Create a test to collect fees

        }

        function test_AntiDonationGuard() public {

            // Testing out the complex anti-donation guard scenario
        }

        function test_ComptrollerDisengagements() public {

            // comptroller.exitMarkets();

        }
    }