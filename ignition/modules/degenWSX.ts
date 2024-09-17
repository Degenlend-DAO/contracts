// The degenWSX market has these key params
// * address: 
// * comptroller:
// * interest rate model: 
// * initialExchangeRateMantissa_
// * name
// * symbol 
// * decimals
// * admin
// * feeReciever
// * mintFee

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("degenWSX", (m) => {
    const cWSX = m.contract("CErc20Immutable", [
        "0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e", // Underlying WSX address
        "0xB078459124e55Eb9F2937c86c0Ec893ff4FF082b", // Unitroller address (proxy)
        "0x353e7839870604Edf9D766bEFb7929c95c215e00", // WSX interest rate model
        "200000000000000000000000000", // Initial exchange rate (200 * 1e18)
        "Degen Wrapped SX", // Name
        "degenWSX", // Symbol
        18, // Decimals (WSX has 18 decimals)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34", // Fee Receiver address
        250, // Minting fee (2.5% in basis points)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34" // Admin address
    ]);

    return { cWSX };
});
