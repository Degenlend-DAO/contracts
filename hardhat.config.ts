/** @type import('hardhat/config').HardhatUserConfig */
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ignition-ethers";

const config: HardhatUserConfig = {
  networks: {
    hardhat: {},
    sx_testnet: {
      url: "https://rpc.sx.technology/",
      accounts: [ `${process.env.C4ACCOUNT}` ]
    },
    sx_mainnet: {
      url: "",
      accounts: [ `${process.env.C4ACCOUNT}` ]
    }
  },
  solidity: {
    version: "0.8.19",
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
