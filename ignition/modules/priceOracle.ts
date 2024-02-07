/// The Price oracle proxy contract 

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("", (m) => {
    const priceOracle = m.contract("SimplePriceOracle")

    return { priceOracle }
});