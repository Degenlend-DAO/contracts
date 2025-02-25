pragma solidity 0.8.10;

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";
import {Comptroller} from "../contracts/libraries/comptroller/Comptroller.sol";

contract ComptrollerTest is Test {
    uint256 testNumber;
    Comptroller comptroller;
    // Invoked every test run
    function setUp() public {
        comptroller = new Comptroller();
    }

}