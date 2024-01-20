import "hardhat-deploy"
import { HardhatRuntimeEnvironment } from "hardhat/types";


const func = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts, getChainId } = hre;
    const { deploy } = deployments
    
}

module.exports = func;
func.tags = ["BaseJumpRateModelV2"];