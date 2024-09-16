// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "../contracts/libraries/interest_rates/JumpRateModelV2.sol";

contract DeployInterestRateModels {
    JumpRateModelV2 public usdcRateModel;
    JumpRateModelV2 public wsxRateModel;

    constructor(address owner) {
        // USDC Jump Rate Model
        uint baseRatePerYear = 0; // 0%
        uint multiplierPerYear = 5e16; // 5% per year (5 * 1e16)
        uint jumpMultiplierPerYear = 109e16; // 109% per year (109 * 1e16)
        uint kink = 8e17; // 80% kink (0.8 * 1e18)
        usdcRateModel = new JumpRateModelV2(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink, owner);

        // WSX Jump Rate Model
        uint baseRatePerYearWSX = 35e16; // 35% per year (35 * 1e16)
        uint multiplierPerYearWSX = 15e16; // 15% per year (15 * 1e16)
        uint jumpMultiplierPerYearWSX = 102e16; // 102% per year (102 * 1e16)
        uint kinkWSX = 25e16; // 25% kink (0.25 * 1e18)
        wsxRateModel = new JumpRateModelV2(baseRatePerYearWSX, multiplierPerYearWSX, jumpMultiplierPerYearWSX, kinkWSX, owner);
    }
}
