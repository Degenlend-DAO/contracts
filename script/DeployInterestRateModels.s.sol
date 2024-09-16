// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "./DeployInterestRateModels.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcast of transaction using deployer’s private key
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        DeployInterestRateModels deployer = new DeployInterestRateModels();

        // Print the addresses of the deployed rate models
        console.log("USDC Rate Model deployed at:", address(deployer.usdcRateModel()));
        console.log("WSX Rate Model deployed at:", address(deployer.wsxRateModel()));

        // End broadcast
        vm.stopBroadcast();
    }
}
