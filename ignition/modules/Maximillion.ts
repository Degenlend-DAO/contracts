import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("Maximillion", (m) => {
    const maximillion = m.contract("Maximillion");
    
    return { maximillion }
})