// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "./CToken.sol";

interface CompLike {
    function delegate(address delegatee) external;
}

/**
 * @title Compound's CErc20 Contract
 * @notice CTokens which wrap an EIP-20 underlying
 * @author Compound
 */
contract CErc20 is CToken, CErc20Interface {
    address public feeTo; // Fee receiver
    uint public mintFeeBps; // Fee percentage in basis points (1 basis point = 0.01%)
    uint public collectedFees; // Internal accounting for batch fee distribution

    // Event for transparency
    event MintFeeCollected(
        address indexed underlying,
        address indexed minter,
        uint feeAmount
    );

    /**
     * @notice Initialize the new money market
     * @param underlying_ The address of the underlying asset
     * @param comptroller_ The address of the Comptroller
     * @param interestRateModel_ The address of the interest rate model
     * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
     * @param name_ ERC-20 name of this token
     * @param symbol_ ERC-20 symbol of this token
     * @param decimals_ ERC-20 decimal precision of this token
     */
    function initialize(
        address underlying_,
        ComptrollerInterface comptroller_,
        InterestRateModel interestRateModel_,
        uint initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address feeReceiver_, // Fee receiver address
        uint mintFee_
    ) public {
        // CToken initialize does the bulk of the work
        super.initialize(
            comptroller_,
            interestRateModel_,
            initialExchangeRateMantissa_,
            name_,
            symbol_,
            decimals_
        );

        // Set underlying and sanity check it
        underlying = underlying_;
        EIP20Interface(underlying).totalSupply();
                
        feeTo = feeReceiver_; // Initialize the fee receiver
        mintFeeBps = mintFee_; // Set the mint fee basis points
    }

    /*** User Interface ***/

    /**
     * @notice Sender supplies assets into the market and receives cTokens in exchange
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param mintAmount The amount of the underlying asset to supply
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function mint(uint mintAmount) external override returns (uint) {
        require(mintAmount > 0, "Mint amount must be greater than zero");
        mintInternal(mintAmount); // First make a deposit, then
        _mintFee(underlying, mintAmount); // Collect fee
        return NO_ERROR;
    }

    /**
     * @notice Sender redeems cTokens in exchange for the underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemTokens The number of cTokens to redeem into underlying
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeem(uint redeemTokens) external override returns (uint) {
        redeemInternal(redeemTokens);
        return NO_ERROR;
    }

    /**
     * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemAmount The amount of underlying to redeem
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeemUnderlying(
        uint redeemAmount
    ) external override returns (uint) {
        redeemUnderlyingInternal(redeemAmount);
        return NO_ERROR;
    }

    /**
     * @notice Sender borrows assets from the protocol to their own address
     * @param borrowAmount The amount of the underlying asset to borrow
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function borrow(uint borrowAmount) external override returns (uint) {
        borrowInternal(borrowAmount);
        return NO_ERROR;
    }

    /**
     * @notice Sender repays their own borrow
     * @param repayAmount The amount to repay, or -1 for the full outstanding amount
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrow(uint repayAmount) external override returns (uint) {
        repayBorrowInternal(repayAmount);
        return NO_ERROR;
    }

    /**
     * @notice Sender repays a borrow belonging to borrower
     * @param borrower the account with the debt being payed off
     * @param repayAmount The amount to repay, or -1 for the full outstanding amount
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrowBehalf(
        address borrower,
        uint repayAmount
    ) external override returns (uint) {
        repayBorrowBehalfInternal(borrower, repayAmount);
        return NO_ERROR;
    }

    /**
     * @notice The sender liquidates the borrowers collateral.
     *  The collateral seized is transferred to the liquidator.
     * @param borrower The borrower of this cToken to be liquidated
     * @param repayAmount The amount of the underlying borrowed asset to repay
     * @param cTokenCollateral The market in which to seize collateral from the borrower
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function liquidateBorrow(
        address borrower,
        uint repayAmount,
        CTokenInterface cTokenCollateral
    ) external override returns (uint) {
        liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
        return NO_ERROR;
    }

    /**
     * @notice A public function to sweep accidental ERC-20 transfers to this contract. Tokens are sent to admin (timelock)
     * @param sweepToken The address of the ERC-20 token to sweep
     */
    function sweepToken(EIP20NonStandardInterface sweepToken) external override {
        require(
            msg.sender == admin,
            "CErc20::sweepToken: only admin can sweep tokens"
        );
        require(
            address(sweepToken) != underlying,
            "CErc20::sweepToken: can not sweep underlying token"
        );
        uint256 balance = sweepToken.balanceOf(address(this));
        sweepToken.transfer(admin, balance);
    }

    /**
     * @notice The sender adds to reserves.
     * @param addAmount The amount fo underlying token to add as reserves
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function _addReserves(uint addAmount) external override returns (uint) {
        return _addReservesInternal(addAmount);
    }

    /**
     * @notice A function that collects a portion of the tokens deposited as a minting fee
     * @param underlying_ the address of the underlying asset
     * @param mintAmount The amount of tokens minted
     */
    function _mintFee(address underlying_, uint mintAmount) internal {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(
            underlying_
        );
        uint fee = (mintAmount * mintFeeBps) / 10000; // Calculate fee in basis points

        require(fee > 0 , "Fee paid is too small!" ); // Replacing small fee collection
        require(fee <= mintAmount, "Fee exceeds mint amount"); // Safety check
        require(
            address(token) == underlying,
            "CErc20 can only collect fees from underlying token!"
        );

        collectedFees += fee; // Accumulate fees internally for batch distribution later
        emit MintFeeCollected(underlying, msg.sender, fee); // Emit event for transparency
    }

    // Function to distribute the accumulated fees in batches to save gas
    function distributeFees() external {
        require(msg.sender == admin, "Only admin can distribute fees");
                address underlying_ = underlying;
        EIP20NonStandardInterface token = EIP20NonStandardInterface(
            underlying_
        );
        token.transfer(feeTo, collectedFees); // Transfer the accumulated fees to the fee receiver
        collectedFees = 0; // Reset the collected fees after distribution
    }

    // Admin function to set the fee receiver address
    function setFeeTo(address _feeTo) external {
        require(
            msg.sender == admin,
            "Only the Admin can set the fee receiver!"
        );
        feeTo = _feeTo;
    }

    // Admin function to set the mint fee in basis points
    function setMintFee(uint _mintFeeBps) external {
        require(msg.sender == admin, "Only the Admin can set the mint fee!");
        require(_mintFeeBps <= 1000, "Fee too high!"); // Limit to 10% for safety
        mintFeeBps = _mintFeeBps;
    }

    /*** Safe Token ***/

    /**
     * @notice Gets balance of this contract in terms of the underlying
     * @dev This excludes the value of the current message, if any
     * @return The quantity of underlying tokens owned by this contract
     */
    function getCashPrior() internal view virtual override returns (uint) {
        EIP20Interface underlyingToken = EIP20Interface(underlying);
        return underlyingToken.balanceOf(address(this));
    }

    /**
     * @dev Similar to EIP20 transfer, except it handles a False result from transferFrom and reverts in that case.
     *      This will revert due to insufficient balance or insufficient allowance.
     *      This function returns the actual amount received,
     *      which may be less than amount if there is a fee attached to the transfer.
     *
     *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
     *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
     */
    function doTransferIn(
        address from,
        uint amount
    ) internal virtual override returns (uint) {
        // Read from storage once
        address underlying_ = underlying;
        EIP20NonStandardInterface token = EIP20NonStandardInterface(
            underlying_
        );
        uint balanceBefore = EIP20Interface(underlying_).balanceOf(
            address(this)
        );
        token.transferFrom(from, address(this), amount);

        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                // This is a non-standard ERC-20
                success := not(0) // set success to true
            }
            case 32 {
                // This is a compliant ERC-20
                returndatacopy(0, 0, 32)
                success := mload(0) // Set success = returndata of override external call
            }
            default {
                // This is an excessively non-compliant ERC-20, revert.
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_IN_FAILED");

        // Calculate the amount that was *actually* transferred
        uint balanceAfter = EIP20Interface(underlying_).balanceOf(
            address(this)
        );
        return balanceAfter - balanceBefore; // underflow already checked above, just subtract
    }

    /**
     * @dev Similar to EIP20 transfer, except it handles a False success from transfer and returns an explanatory
     *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
     *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
     *      it is >= amount, this should not revert in normal conditions.
     *
     *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
     *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
     */
    function doTransferOut(
        address payable to,
        uint amount
    ) internal virtual override {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        token.transfer(to, amount);

        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                // This is a non-standard ERC-20
                success := not(0) // set success to true
            }
            case 32 {
                // This is a compliant ERC-20
                returndatacopy(0, 0, 32)
                success := mload(0) // Set success = returndata of override external call
            }
            default {
                // This is an excessively non-compliant ERC-20, revert.
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_OUT_FAILED");
    }

    /**
     * @notice Admin call to delegate the votes of the COMP-like underlying
     * @param compLikeDelegatee The address to delegate votes to
     * @dev CTokens whose underlying are not CompLike should revert here
     */
    function _delegateCompLikeTo(address compLikeDelegatee) external {
        require(
            msg.sender == admin,
            "only the admin may set the comp-like delegate"
        );
        CompLike(underlying).delegate(compLikeDelegatee);
    }
}
