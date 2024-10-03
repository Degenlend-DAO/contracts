// The degenUSDC market has these key params
// * underlying address: 
// * comptroller:
// * interest rate model: 
// * initialExchangeRateMantissa_
// * name
// * symbol 
// * decimals
// * admin

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("degenUSDC", (m) => {
    const cUSDC = m.contract("CErc20Immutable", [
        "0x5147891461a7C81075950f8eE6384e019e39ab98", // Underlying USDC address
        "0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b", // Unitroller address (proxy)
        "0xeE1bFEE55C42048735c04A9bE7133EB62417F131", // USDC interest rate model
        "20000000000000000", // Initial exchange rate (0.02 * 1e18)
        "Degen USDC", // Name
        "degenUSDC", // Symbol
        6, // Decimals (USDC has 6 decimals)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34", // Fee Receiver address
        250, // Minting fee (2.5% in basis points)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34" // Admin address
    ]);

    return { cUSDC };
});