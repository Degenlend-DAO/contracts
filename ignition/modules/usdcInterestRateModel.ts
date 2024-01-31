// The USDC rate model is a jump rate model with the following parameters:
// * Base rate: 0%/yr
// * Multiplier: 5%/yr
// * Kink: 80%
// * Jump multiplier: 109%/yr
// The USDC market also has a reserve factor of 7%. Reserve factor is 0% if the protocol fee switch is off.

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("usdcInterestRateModel", (m) => {
    const usdcJumpModel = m.contract("JumpRateModelV2", [0, 5, 109, 80, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34"]);

    return { usdcJumpModel }
});