import { expect } from "chai";
import { ethers } from "hardhat";


describe("Price Oracle", () => {
    it("should retrieve the Simple Price Oracle", async () => {
        let priceOracle: any;

    before(async () => {
        const SimplePriceOracle = await ethers.getContractAt(
            "SimplePriceOracle",
            "0x1f98431c8ad98523631ae4a59f267346ea31f984"    
        );
        expect(SimplePriceOracle.address).to.equal("0x1f98431c8ad98523631ae4a59f267346ea31f984");
    });
});

it("should list all the prices on the Price Oracle", async () => {
    const SimplePriceOracle = await ethers.getContractAt(
        "SimplePriceOracle",
        "0x1f98431c8ad98523631ae4a59f267346ea31f984"
    );
    const prices = await SimplePriceOracle.getPrices();
    expect(prices.length).to.be.at.least(1);
});

it("should retrive the correct price of USDC token", async () => {
    const SimplePriceOracle = await ethers.getContractAt(
        "SimplePriceOracle",
        "0x1f98431c8ad98523631ae4a59f267346ea31f984"
    );
    const price = await SimplePriceOracle.getPrice("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48");
    console.log(price);
});

});