// The USDC rate model is a jump rate model with the following parameters:
// * Base rate: 0%/yr
// * Multiplier: 5%/yr
// * Kink: 80%
// * Jump multiplier: 109%/yr
// The USDC market also has a reserve factor of 7%. Reserve factor is 0% if the protocol fee switch is off.

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("usdcInterestRateModel", (m) => {
    // Correct the constructor values, scaling them properly to 18 decimals
    const usdcJumpModel = m.contract("JumpRateModelV2", [
        "0", // Base rate (0%)
        "50000000000000000", // Multiplier (5% -> 0.05 * 1e18)
        "1090000000000000000", // Jump multiplier (109% -> 1.09 * 1e18)
        "800000000000000000", // Kink (80% -> 0.80 * 1e18)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34" // Admin address (replace with correct admin address)
    ]);

    return { usdcJumpModel };
});