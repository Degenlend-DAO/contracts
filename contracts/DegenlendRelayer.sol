// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

interface ICERC20 {
    function mint(uint256 mintAmount) external returns (uint256);
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
    function borrow(uint256 borrowAmount) external returns (uint256);
    function repayBorrow(uint256 repayAmount) external returns (uint256);
    function underlying() external view returns (address);
}

contract DegenLendRelayer is EIP712 {
    using ECDSA for bytes32;

    /* -------------------------------------------------------------------------- */
    /*                                   Events                                   */
    /* -------------------------------------------------------------------------- */
    event MintExecuted(   address indexed user, address indexed cToken, uint256 amount, uint256 nonce);
    event RedeemExecuted( address indexed user, address indexed cToken, uint256 amount, uint256 nonce);
    event BorrowExecuted( address indexed user, address indexed cToken, uint256 amount, uint256 nonce);
    event RepayExecuted(  address indexed user, address indexed cToken, uint256 amount, uint256 nonce);

    /* -------------------------------------------------------------------------- */
    /*                                EIP‑712 Data                                */
    /* -------------------------------------------------------------------------- */
    bytes32 public constant MINT_TYPEHASH   = keccak256("MintIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");
    bytes32 public constant REDEEM_TYPEHASH = keccak256("RedeemIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");
    bytes32 public constant BORROW_TYPEHASH = keccak256("BorrowIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");
    bytes32 public constant REPAY_TYPEHASH  = keccak256("RepayIntent(address user,address cToken,uint256 amount,uint256 nonce,uint256 deadline)");

    mapping(address => uint256) public nonces;

    constructor() EIP712("DegenLendRelayer", "647") {}

    /* -------------------------------------------------------------------------- */
    /*                              MINT / REDEEM                                 */
    /* -------------------------------------------------------------------------- */

    function mintWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, MINT_TYPEHASH);
        
        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transferFrom(user, address(this), amount);
        IERC20(underlying).approve(cToken, amount);

        require(ICERC20(cToken).mint(amount) == 0, "Mint failed");
        IERC20(cToken).transfer(user, IERC20(cToken).balanceOf(address(this)));

        emit MintExecuted(user, cToken, amount, nonces[user] - 1);
    }

    function redeemUnderlyingWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, REDEEM_TYPEHASH);
        
        IERC20(cToken).transferFrom(user, address(this), amount);
        require(ICERC20(cToken).redeemUnderlying(amount) == 0, "Redeem failed");

        address underlying = ICERC20(cToken).underlying();
        IERC20(underlying).transfer(user, IERC20(underlying).balanceOf(address(this)));

        emit RedeemExecuted(user, cToken, amount, nonces[user] - 1);
    }

    /* -------------------------------------------------------------------------- */
    /*                              BORROW / REPAY                                */
    /* -------------------------------------------------------------------------- */

    function borrowWithIntent(
        address user,
        address cToken,
        uint256 amount,
        uint256 deadline,
        bytes calldata signature
    ) external {
        _verifyIntent(user, cToken, amount, deadline, signature, BORROW_TYPEHASH);
        
        require(ICERC20(cToken).borrow(amount) == 0, "Borrow failed");

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
        IERC20(underlying).transferFrom(user, address(this), amount);
        IERC20(underlying).approve(cToken, amount);

        require(ICERC20(cToken).repayBorrow(amount) == 0, "Repay failed");

        emit RepayExecuted(user, cToken, amount, nonces[user] - 1);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL HELPERS                               */
    /* -------------------------------------------------------------------------- */

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
        bytes32 structHash = keccak256(
            abi.encode(
                typeHash,
                user,
                cToken,
                amount,
                currentNonce,
                deadline
            )
        );

        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = digest.recover(signature);
        require(signer == user, "Invalid signature");
    }
}
