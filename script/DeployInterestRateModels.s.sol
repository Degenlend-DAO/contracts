// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "./DeployInterestRateModels.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Get deployer's address from the private key
        address deployerAddress = vm.addr(deployerPrivateKey);

        // Start broadcast of transaction using deployer’s private key
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the interest rate models with the deployer address as the owner
        DeployInterestRateModels deployer = new DeployInterestRateModels(deployerAddress);

        // Print the addresses of the deployed rate models
        console.log("USDC Rate Model deployed at:", address(deployer.usdcRateModel()));
        console.log("WSX Rate Model deployed at:", address(deployer.wsxRateModel()));

        // End broadcast
        vm.stopBroadcast();
    }
}
