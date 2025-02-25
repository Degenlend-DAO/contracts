pragma solidity 0.8.10;

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";
import {Comptroller} from "../contracts/libraries/comptroller/Comptroller.sol";

contract ComptrollerTest is Test {
    uint256 testNumber;
    Comptroller comptroller;

    // Invoked every test run
    function setUp() public {
        testNumber = 42;
        comptroller = new Comptroller();
    }

    function test_EnterMarkets() public view {
        // Add test logic here
    }

    function test_NumberIs42() public view {
        assertEq(testNumber, 42);
    }

    function test_CannotSubtract43() public {
        // Use vm.expectRevert() to assert that the next call reverts
        vm.expectRevert();
        // Perform the operation that should revert
        testNumber -= 43;
    }
}