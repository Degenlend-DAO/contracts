import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DegenLendRelayer", (m) => {
    const degenLendRelayer = m.contract("DegenLendRelayer");

    return { degenLendRelayer }
})