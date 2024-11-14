import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";


describe("Comptroller", () => {
    it("should deploy the Comptroller", async () => {
        let comptroller: Contract;
        const Comptroller = await ethers.deployContract("Comptroller");

        expect(Comptroller.address).to.match(/^0x[0-9A-Fa-f]{40}$/);

    });
})