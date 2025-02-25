import { ethers } from 'hardhat';
import { expect } from "chai"

describe("Degen USDC Token", async () => {
    let degenUSDC: any;
    let USDC: any;

    const enableAmount = ethers.utils.parseUnits("1000", 6); // USDC uses 6 decimals
    const mintAmount = ethers.utils.parseUnits("1000", 6); // USDC uses 6 decimals
    const withdrawAmount = ethers.utils.parseUnits("500", 6); // USDC uses 6 decimals

    before(async () => {
        // Fetch deployed contract instances
        degenUSDC = await ethers.getContractAt(
            "CErc20Immutable",
            "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
        );

        USDC = await ethers.getContractAt("ERC20", "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174");
    });
});

