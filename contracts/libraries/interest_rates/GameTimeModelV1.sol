// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "./BaseJumpRateModelV2.sol";
import "./InterestRateModel.sol";



/** 
 * @title DegenLend's GameTimeModel Contract for degenTokens
 * @author user2745
 * @notice This is based on Compound's JumpRateModelV2 contract, but focused on jumps in utility during game time.
 */

contract GameTimeModel is InterestRateModel, BaseJumpRateModelV2 {
    
    
    function getBorrowRate(
        uint cash,
        uint borrows,
        uint reserves
    ) external view virtual override returns (uint) {
        return getBorrowRateInternal(cash, borrows, reserves);
    }
    
    constructor(uint baseRatePerYear, uint multiplierPerYear, uint jumpMultiplierPerYear, uint kink_, address owner_)
    
    BaseJumpRateModelV2(baseRatePerYear,multiplierPerYear,jumpMultiplierPerYear,kink_,owner_) public {}
}