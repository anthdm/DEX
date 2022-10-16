// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BondingCurve {
    using SafeMath for uint256;
    using SafeMath for uint32;

    function calculateBuyReturn(
        uint256 totalSupply,
        uint256 depositAmount,
        uint32 slope
    ) public pure returns (uint256) {
        uint256 price = calculatePrice(totalSupply, slope);

        return (depositAmount * (10**8)) / price;
    }

    function calculatePrice(uint256 totalSupply, uint32 slope)
        public
        pure
        returns (uint256)
    {
        // uint256 temp = totalSupply.mul(totalSupply);
        return slope.mul(totalSupply);
    }
}
