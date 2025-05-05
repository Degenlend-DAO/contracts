// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

interface ICERC20 {
    function mint(uint mintAmount) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function underlying() external view returns (address);
    function underlying() external view returns (address);
}

contract DegenLendRelayer is EIP712 {
contract DegenLendRelayer is EIP712 {
    using ECDSA for bytes32;

    bytes32 public constant MINT_TYPEHASH = 
        keccak256("MintIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");
    bytes32 public constant REDEEM_TYPEHASH = 
        keccak256("RedeemIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");
    bytes32 public constant BORROW_TYPEHASH = 
        keccak256("BorrowIntent(address user, address cToken,uint256 amount, uint256 nonce,uint256 deadline)");
    bytes32 public constant REPAY_TYPEHASH = 
        keccak256("RepayIntent(address user, address cToken, uint256 amount, uint256 nonce, uint256 deadline)");

    mapping(address => uint256) public nonces;

    constructor() EIP712("DegenLendRelayer", "1") {}

    // ================== MINT/REDEEM ================== //

    function mintWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, MINT_TYPEHASH);
        
        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transferFrom(user, address(this), amount);  // Pull underlying from user
        IERC20(underlying).approve(cToken, amount);                  // Approve cToken to spend
        
        require(ICERC20(cToken).mint(amount) == 0, "Mint failed");    // Mint cTokens
        IERC20(cToken).transfer(user, IERC20(cToken).balanceOf(address(this))); // Send cTokens to user
    }

    function redeemUnderlyingWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, REDEEM_TYPEHASH);
        
        IERC20(cToken).transferFrom(user, address(this), amount);     // Pull cTokens from user
        require(ICERC20(cToken).redeemUnderlying(amount) == 0, "Redeem failed"); // Redeem for underlying
        
        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transfer(user, IERC20(underlying).balanceOf(address(this))); // Send underlying to user
    }

    // ================== BORROW/REPAY ================== //

    function borrowWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, BORROW_TYPEHASH);
        
        // 1. Execute borrow (funds go to relayer)
        require(ICERC20(cToken).borrow(amount) == 0, "Borrow failed");
        
        // 2. Forward borrowed tokens to user
        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transfer(user, amount);
        
        emit BorrowExecuted(user, cToken, amount, nonces[user] - 1);
    }

    function repayBorrowWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, REPAY_TYPEHASH);
        
        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transferFrom(user, address(this), amount);  // Pull underlying from user
        IERC20(underlying).approve(cToken, amount);                   // Approve cToken to spend
        
        require(ICERC20(cToken).repayBorrow(amount) == 0, "Repay failed"); // Repay borrow
    }

    // ================== SHARED VERIFICATION ================== //

    function _verifyIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature,
        bytes32 typeHash
    ) internal {
        require(block.timestamp <= deadline, "Intent expired");
        
        uint256 currentNonce = nonces[user]++;
        bytes32 structHash = keccak256(abi.encode(
            typeHash,
            user,
            cToken,
            amount,
            currentNonce,
            deadline
        ));

        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = digest.recover(signature);
        require(signer == user, "Invalid signature");
    }
}