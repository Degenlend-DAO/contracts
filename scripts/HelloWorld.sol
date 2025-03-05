// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import { HelloWorld } from '../contracts/HelloWorld.sol';

contract HelloWorldTest is Test {
    HelloWorld hello;
    function setUp() public {
      hello = new HelloWorld("Foundry is fast!");
    }

    function test1() public {
        assertEq(
            hello.greet(),
            "Foundry is fast!"
        );
    }

    function test2() public {
        assertEq(hello.version(), 0);
        hello.updateGreeting("Hello World");
        assertEq(hello.version(), 1);
        assertEq(
            hello.greet(),
            "Hello World"
        );
    }
}