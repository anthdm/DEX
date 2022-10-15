// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./BondingCurve.sol";

contract Dex is BondingCurve {
    struct Pair {
        ERC20 base;
        ERC20 quote;
        uint32 slope;
    }

    mapping(string => Pair) public tradingPairs;
    mapping(address => mapping(ERC20 => uint256)) public poolBalances;
    mapping(ERC20 => uint256) public poolSupplies;

    function registerTradingPair(
        ERC20 base,
        ERC20 quote,
        uint32 slope
    ) public {
        string memory baseTicker = base.symbol();
        string memory quoteTicker = quote.symbol();
        string memory pairName = string.concat(baseTicker, quoteTicker);

        tradingPairs[pairName] = Pair({base: base, quote: quote, slope: slope});
    }

    function buy(string calldata pairName, uint256 amount) public {
        Pair memory pair = tradingPairs[pairName];

        deposit(pair.base, amount);

        // uint256 buyReturn = calculateBuyReturn(totalSupply, amount, pair.slope);

        // TODO calculate the amount the withdraw based on the AMM (bonding curve).
        // pair.quote.transferFrom(address(this), msg.sender, amount);
    }

    function deposit(ERC20 token, uint256 amount) public {
        token.transferFrom(msg.sender, address(this), amount);

        poolBalances[msg.sender][token] += amount;
    }
}
