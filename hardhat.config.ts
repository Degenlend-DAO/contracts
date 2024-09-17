import { HardhatUserConfig } from 'hardhat/config';
import '@nomiclabs/hardhat-ethers';
import '@nomicfoundation/hardhat-ignition';
import 'dotenv/config';

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 2000, // Increase the number of optimizer runs
      },
    },
  },
  networks: {
    sx_testnet: {
      url: 'https://rpc.toronto.sx.technology',
      accounts: [process.env.PRIVATE_KEY!],
      chainId: 647,
    },
  },
};

export default config;
