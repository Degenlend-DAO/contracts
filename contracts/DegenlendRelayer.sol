// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICERC20 {
    function mint(uint mintAmount) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
}

contract DegenLendRelayer {
    using ECDSA for bytes32;

    bytes32 public immutable DOMAIN_SEPARATOR;
    address public immutable degenToken;
    mapping(address => uint256) public nonces;

    constructor(address _degenToken) {
        degenToken = _degenToken;
        DOMAIN_SEPARATOR = keccak256(x) // placeholder, needs to be filled in
    }

    function mintWithIntent(
        address user,
        uint amount,
        uint nonce,
        uint deadline,
        bytes calldata signature
    ) external {
        require(block.timestamp <= deadline, "Intent Expired");
        require(nonces[user]++ == nonce, "Invalid nonce");

        bytes32 structHash = keccack256(abi.encode(
            keccak256("MintIntent(address user,uint256 amount,uint256 nonce,uint256 deadline)"),
            user,
            amount,
            nonce,
            deadline
        ));

        byte32 digest = keccak256(x)
    }
}