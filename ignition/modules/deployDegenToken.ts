import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("Degen", (m) => {
    const destinationAdress: string = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";
    const degenContract = m.contract("Degen", [destinationAdress]);

    return {  }
});