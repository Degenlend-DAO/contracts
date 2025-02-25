pragma solidity ^0.8.10;
import "../contracts/SimplePriceOracle.sol";
import { Test } from "forge-std/Test.sol";
import "forge-std/console.sol";


    contract PriceOracleTest is Test {
        SimplePriceOracle priceOracle;

        event PricePosted(address asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);

        function setUp() public {
            priceOracle = new SimplePriceOracle();
        }
    }