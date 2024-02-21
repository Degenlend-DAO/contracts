/// The Price oracle proxy contract 

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("priceOracle", (m) => {
    const priceOracle = m.contract("SimplePriceOracle")

    return { priceOracle }
});