// The SX rate model is a jump rate model with the following parameters:
// * Base rate: 35%/yr
// * Multiplier: 15%/yr
// * Kink: 25%
// * Jump multiplier: 102%/yr

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("sxInterestRateModel", (m) => {
    const sxJumpModel = m.contract("JumpRateModelV2", [35, 15, 102, 25, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34"]);
    return { sxJumpModel }
});