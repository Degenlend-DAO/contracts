import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("Comptroller", (m) => {
    const contract = m.contract("Comptroller");

    return { contract }
});