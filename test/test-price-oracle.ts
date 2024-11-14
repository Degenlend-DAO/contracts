import { expect } from "chai";
import { ethers } from "hardhat";


describe("Price Oracle", () => {
    it("should deploy the Price Oracle", async () => {
        let priceOracle: any;
        const PriceOracle = await ethers.getContractFactory("PriceOracle");
        priceOracle = await PriceOracle.deploy();

        expect(priceOracle.address).to.match(/^0x[0-9A-Fa-f]{40}$/);
    });
});