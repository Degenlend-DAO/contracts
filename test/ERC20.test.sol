pragma solidity 0.8.10;

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";
import {ERC20} from "../contracts/ERC20.sol";

contract ECR20Test is Test {

    ERC20 testToken;

    function setUp() public {
        testToken = new ERC20("TestToken", "TTK", 18);
    }

    function test_names() public {
        assertEq(testToken.name(), "TestToken");
    }

    function test_approvals() public {
        // Call approve, and expect the blockchain to emit an 'Approval' Event
        // vm.expectEmit(true, 0x26B94ffdc8FeEA3cd1DB88F5D8FD1C5A08f52Fa8, 2000);
        vm.expectEmit(true, true, true, true);
         testToken.approve(0x26B94ffdc8FeEA3cd1DB88F5D8FD1C5A08f52Fa8, 2000);
    }
    
}