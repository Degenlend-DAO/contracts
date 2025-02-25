import { ethers } from "hardhat";
import { expect } from "chai"

describe("Degen WSX Token", async () => {

    let degenWSX: any;
    let WSX: any;

    const enableAmount = ethers.utils.parseUnits("1000", 18); // USDC uses 6 decimals
    const mintAmount = ethers.utils.parseUnits("1000", 18); // WSX uses 18 decimals
    const withdrawAmount = ethers.utils.parseUnits("500", 18); // WSX uses 18 decimals

    before(async () => {
        // Fetch deployed contract instances
        degenWSX = await ethers.getContractAt(
            "CErc20Immutable",
            "0xD2F6594c692985850F85fd1b08d1F9DE0f719Cb5"
        );
    });

    it("should display the WSX Token name and symbol", async () => {
        const name = await degenWSX.name();
        const symbol = await degenWSX.symbol();

        expect(name).to.equal("Degen Wrapped SX");
        expect(symbol).to.equal("degenWSX");
    });

    // it("should mint WSX tokens", async () => {
    //     const [owner] = await ethers.getSigners();
    //     // Mint WSX tokens
    //     await degenWSX.mint(owner.address, mintAmount);
    //     // Validate minting
    //     const initialBalance = await degenWSX.balanceOf(owner.address);
    //     expect(initialBalance).to.equal(mintAmount);
    // });

    // it("should withdraw WSX tokens", async () => {
    //     const [owner] = await ethers.getSigners();
    //     // Withdraw WSX tokens
    //     await degenWSX.withdraw(owner.address, withdrawAmount);
    //     // Validate withdrawal
    //     const finalBalance = await degenWSX.balanceOf(owner.address);
    //     expect(finalBalance).to.equal(mintAmount.sub(withdrawAmount));
    // });

    // it("shows the balance of the owner", async () => {
    //     const [owner] = await ethers.getSigners();
    //     const initialBalance = await degenWSX.balanceOf(owner.address);
    //     const parsedInitialBalance = parseUnits(initialBalance.toString(), 18) as unknown as Number;
    //     expect(Number(parsedInitialBalance)).to.be.at.least(0);
    // });
    // it("should borrow and repay WSX tokens", async () => {
    //     const [owner] = await ethers.getSigners();
    //     const borrowAmount = ethers.utils.parseUnits("100", 18); // WSX uses 18 decimals
    //     const repayAmount = ethers.utils.parseUnits("50", 18); // WSX uses 18 decimals
    //     // Borrow WSX tokens
    //     const borrowTx = await degenWSX.borrow(borrowAmount);
    //     await borrowTx.wait();
    //     // Validate borrowing
    //     const initialBorrowBalance = await degenWSX.borrowBalanceCurrent(owner.address);
    //     expect(initialBorrowBalance).to.equal(borrowAmount);
    //     // Repay WSX tokens
    //     const repayTx = await degenWSX.repayBorrow(repayAmount);
    //     await repayTx.wait();
    //     // Validate repayment
    //     const finalBorrowBalance = await degenWSX.borrowBalanceCurrent(owner.address);
    //     expect(finalBorrowBalance).to.equal(borrowAmount.sub(repayAmount));
    // });
    // it("should redeem WSX tokens", async () => {
    //     const [owner] = await ethers.getSigners();
    //     const redeemAmount = ethers.utils.parseUnits("100", 18); // WSX uses 18 decimals
    //     // Redeem WSX tokens
    //     const redeemTx = await degenWSX.redeem(redeemAmount);
    //     await redeemTx.wait();
    //     // Validate redemption
    //     const finalBalance = await degenWSX.balanceOf(owner.address);
    //     expect(finalBalance).to.equal(mintAmount.sub(withdrawAmount).sub(redeemAmount));
    // });
} );