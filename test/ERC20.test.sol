pragma solidity 0.8.10;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../contracts/ERC20.sol";

contract ERC20Test is Test {

    event Transfer(address indexed from, address indexed to, uint256 value);
   
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );

    ERC20 token;
    address alice = address(0x123);
    address bob = address(0x456);

    function setUp() public {
        token = new ERC20("Test Token", "TT", 18);
    }

    function test_TransferEvent() public {
        token.mint(alice, 1000);

        vm.expectEmit(true, true, true, true);
        emit Transfer(alice, bob, 500);

        vm.prank(alice);
        token.transfer(bob, 500);
    }

    function test_ApprovalEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Approval(address(this), bob, 1000);

        token.approve(bob, 1000);
    }

    function test_TransferFromEvent() public {
        token.mint(alice, 1000);

        // Approve Bob to spend Alice's tokens
        vm.prank(alice);
        token.approve(bob, 1000);

        // Expect Transfer event
        vm.expectEmit(true, true, true, true);
        emit Transfer(alice, address(this), 500);

        // Perform transferFrom
        vm.prank(bob);
        token.transferFrom(alice, address(this), 500);
    }
}