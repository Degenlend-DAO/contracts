// The cUSDC market hasthese key params
// * address: 
// * comptroller:
// * interest rate model: 
// * initialExchangeRateMantissa_
// * name
// * symbol 
// * decimals

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("cWSX", (m) => {
    const cWSX = m.contract("CErc20Immutable", ["0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e", "0x8D1230e6Ae4C1Bc573697D93103349C3FDefC944" , "0xcd24dCa1668d99ddE75AE75ecEdFf3CEEa09Fb29", 2000000000000000, "Degen Wrapped SX", "cWSX", 8, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34"]);
    return { cWSX }
});