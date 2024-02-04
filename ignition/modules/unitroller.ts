import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("Unitroller", (m) => {
	//Comptroller Singleton -- Use the Unitroller address for deployed cTokens
	const Unitroller = m.contract("Unitroller");

	return { Unitroller }

});
