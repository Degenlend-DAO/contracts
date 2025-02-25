pragma solidity 0.8.10;

import { Test } from "forge-std/Test.sol";
import "forge-std/console.sol";
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
        address feeReceiver;
        address admin;

        event Transfer(address indexed from, address indexed to, uint256 value);
   
        event Approval(
            address indexed owner, address indexed spender, uint256 value
        );

        function setUp() public {

            wSX = new ERC20("Wrapped SX", "WSX", 18); //0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e
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
                address(wSX), // Underlying WSX address
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

        function test_EnteringAMarket() public {
            //  Let This contract have the ability to move degenWSX tokens.

            //  Check if a project is collateral


            // Enter / mint assets

        }
    }