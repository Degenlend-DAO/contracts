import { expect } from "chai";
import { ethers } from "hardhat";

describe("Testing mint and withdraw for WSX & USDC tokens", () => {
  let degenWSX: any;
  let degenUSDC: any;

  before(async () => {
    // Fetch deployed contract instances
    degenWSX = await ethers.getContractAt(
      "CErc20Immutable",
      "0xD2F6594c692985850F85fd1b08d1F9DE0f719Cb5"
    );
    degenUSDC = await ethers.getContractAt(
      "CErc20Immutable",
      "0xE2e284aa000625719Ab4C27dA6E8c915aC0AEF04"
    );
  });

  it("should mint and withdraw WSX tokens", async () => {
    const [owner] = await ethers.getSigners();

    // Define mint and withdraw amounts
    const mintAmount = ethers.utils.parseUnits("1000", 18); // WSX uses 18 decimals
    const withdrawAmount = ethers.utils.parseUnits("500", 18);

    // Mint WSX tokens
    await degenWSX.mint(owner.address, mintAmount);

    // Validate minting
    const initialBalance = await degenWSX.balanceOf(owner.address);
    expect(initialBalance).to.equal(mintAmount);

    // Withdraw WSX tokens
    await degenWSX.withdraw(owner.address, withdrawAmount);

    // Validate withdrawal
    const finalBalance = await degenWSX.balanceOf(owner.address);
    expect(finalBalance).to.equal(mintAmount.sub(withdrawAmount));
  });

  it("should mint and withdraw USDC tokens", async () => {
    const [owner] = await ethers.getSigners();

    // Define mint and withdraw amounts
    const mintAmount = ethers.utils.parseUnits("1000", 6); // USDC uses 6 decimals
    const withdrawAmount = ethers.utils.parseUnits("500", 6);

    // Mint USDC tokens
    await degenUSDC.mint(owner.address, mintAmount);

    // Validate minting
    const initialBalance = await degenUSDC.balanceOf(owner.address);
    expect(initialBalance).to.equal(mintAmount);

    // Withdraw USDC tokens
    await degenUSDC.withdraw(owner.address, withdrawAmount);

    // Validate withdrawal
    const finalBalance = await degenUSDC.balanceOf(owner.address);
    expect(finalBalance).to.equal(mintAmount.sub(withdrawAmount));
  });
});
