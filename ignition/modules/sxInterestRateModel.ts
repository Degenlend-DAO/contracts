// The SX rate model is a jump rate model with the following parameters:
// * Base rate: 35%/yr
// * Multiplier: 15%/yr
// * Kink: 25%
// * Jump multiplier: 102%/yr

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("sxInterestRateModel", (m) => {
    const sxJumpModel = m.contract("JumpRateModelV2", [
        "350000000000000000", // Base rate (35% -> 0.35 * 1e18)
        "150000000000000000", // Multiplier (15% -> 0.15 * 1e18)
        "1020000000000000000", // Jump multiplier (102% -> 1.02 * 1e18)
        "250000000000000000", // Kink (25% -> 0.25 * 1e18)
        "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34" // Admin address
    ]);
    return { sxJumpModel };
});
