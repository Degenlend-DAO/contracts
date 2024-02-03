// The cUSDC market hasthese key params
// * address: 
// * comptroller:
// * interest rate model: 
// * initialExchangeRateMantissa_
// * name
// * symbol 
// * decimals

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("cUSDC", (m) => {
    const cUSDC = m.contract("CErc20Immutable", ["0x5147891461a7C81075950f8eE6384e019e39ab98", "0xd26cCEdaCb5E1166e3285ba5EF9817f45F6bfA76", "0x2CB576EcD7F0b9DEa43294E2e22E05EDc8BF2B90", 2.0e18, "Degen USDC", "cUSDC", 8, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34"]);
    // m.call(cUSDC, "initialize(address,address,address,uint256,string,string,uint8)", ["0x5147891461a7C81075950f8eE6384e019e39ab98", "0xd26cCEdaCb5E1166e3285ba5EF9817f45F6bfA76", "0x2CB576EcD7F0b9DEa43294E2e22E05EDc8BF2B90", 2.0e18, "Degen USDC", "cUSDC", 8])
    return { cUSDC }
});