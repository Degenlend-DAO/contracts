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
    const cUSDC = m.contract("CErc20Immutable", ["0x5147891461a7C81075950f8eE6384e019e39ab98", "0x8D1230e6Ae4C1Bc573697D93103349C3FDefC944", "0x2CB576EcD7F0b9DEa43294E2e22E05EDc8BF2B90", 2000000000000000, "Degen USDC", "degenUSDC", 18, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34"]);
    return { cUSDC }
});