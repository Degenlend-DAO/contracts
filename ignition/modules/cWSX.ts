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
    const cWSX = m.contract("CErc20");
    m.call(cWSX, "initialize(address,address,address,uint256,string,string,uint8)", ["0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e", "0xd26cCEdaCb5E1166e3285ba5EF9817f45F6bfA76" , "0xcd24dCa1668d99ddE75AE75ecEdFf3CEEa09Fb29", 2, "Degen Wrapped SX", "cWSX", 8]);
    return { cWSX }
});