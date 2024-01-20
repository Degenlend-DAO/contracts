/** @type import('hardhat/config').HardhatUserConfig */
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-ignition-ethers";

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const solcVersion = "0.8.19"

const config: HardhatUserConfig = {
  networks: {
    hardhat: {},
    sx_testnet: {
      url: "https://rpc.sx.technology/",
      accounts: [ `${process.env.C4ACCOUNT}` ],
      chainId: 617
    },
    sx_mainnet: {
      url: "",
      accounts: [ `${process.env.C4ACCOUNT}` ]
    }
  },
  solidity: {
    version: solcVersion,
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
        details: {
          yul: false,
        },
      },
    },
  },
}

export default config
