import { expect } from "chai";
import { ethers } from "hardhat";
describe("Testing borrow, repay and liquidate for WSX & USDC tokens", () => {

    let degenWSX: any;
    let degenUSDC: any;

    before(async () => {
        // Fetch deployed contract instances ( on SX Testnet )
        degenWSX = await ethers.getContractAt(
            "CErc20Immutable",
            "0xD2F6594c692985850F85fd1b08d1F9DE0f719Cb5"
        );
        degenUSDC = await ethers.getContractAt(
            "CErc20Immutable",
            "0x05d225eA760bc4E974b0691bFb0Cf026A7D33279"
        );

    it("show borrow WSX and USDC tokens", async () => {})

    it("should repay WSX and USDC tokens", async () => {})

    it("should liquidate WSX and USDC tokens", async () => {})
    
    });

});