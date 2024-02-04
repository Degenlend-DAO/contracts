import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
export default buildModule("Delegator", (m) => {
    const cDelegator = m.contract("CErc20Delegator", ["0x2D4e10Ee64CCF407C7F765B363348f7F62D2E06e", "0xd26cCEdaCb5E1166e3285ba5EF9817f45F6bfA76", "0xcd24dCa1668d99ddE75AE75ecEdFf3CEEa09Fb29", "200000000000000000", "Degen Wrapped SX", "cwSX", 8, "0x4869aF0Aed0a9948f724f809dC0DCcF9885cCe34", "0x0bd0DF8999b21C0140C62F859Cf8e36E867fFA3b", "0x"]);
    return { cDelegator }
});