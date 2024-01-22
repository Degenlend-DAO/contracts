import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CErc20", (m) => {
    const contract = m.contract("CErc20");

    return { contract }
});