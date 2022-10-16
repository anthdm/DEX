// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./BondingCurve.sol";
import "hardhat/console.sol";

contract Dex is BondingCurve {
    struct Pair {
        ERC20 base;
        ERC20 quote;
        uint32 slope;
    }

    mapping(string => Pair) public tradingPairs;
    mapping(address => mapping(ERC20 => uint256)) public poolTokenBalances;
    mapping(ERC20 => uint256) public poolTokenSupplies;

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

        console.log("buying =>", pair.base.symbol());
        console.log("selling =>", pair.quote.symbol());

        deposit(pair.quote, amount);

        uint256 baseTokenPoolSupply = poolTokenSupplies[pair.base];

        uint256 baseTokensToReturn = calculateBuyReturn(
            baseTokenPoolSupply,
            amount,
            pair.slope
        );

        withdraw(pair.base, baseTokensToReturn);
    }

    function deposit(ERC20 token, uint256 amount) public {
        console.log("depositing to the contract pool => ", token.symbol());

        token.transferFrom(msg.sender, address(this), amount);

        poolTokenBalances[msg.sender][token] += amount;
        poolTokenSupplies[token] += amount;
    }

    function withdraw(ERC20 token, uint256 amount) public {
        console.log("withdrawing from the contract pool => ", token.symbol());

        token.approve(address(this), amount);
        token.transferFrom(address(this), msg.sender, amount);
        poolTokenSupplies[token] -= amount;
    }
}
