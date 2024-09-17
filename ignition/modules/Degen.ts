import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("Degen", (m) => {
    const destinationAdress: string = "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34";
    const degenContract = m.contract("Degen", [destinationAdress]);

    return { degenContract }
});