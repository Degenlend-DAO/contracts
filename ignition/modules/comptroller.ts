import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("comptrollerDeployment", (m) => {
    const comptroller = m.contract("Comptroller", []); // Deploy the Comptroller logic
    return { comptroller };
});