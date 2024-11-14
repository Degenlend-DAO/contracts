import { HardhatUserConfig, task } from 'hardhat/config';
import '@nomiclabs/hardhat-ethers';
import '@nomicfoundation/hardhat-ignition';
import 'dotenv/config';


task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

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
