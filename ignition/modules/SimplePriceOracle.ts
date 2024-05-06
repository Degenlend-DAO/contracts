import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("SimplePriceOracle", (m) => {

    const SimplePriceOracle = m.contract("SimplePriceOracle");

    return { SimplePriceOracle }
})