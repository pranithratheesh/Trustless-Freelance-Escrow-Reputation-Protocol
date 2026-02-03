// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockUniswap {
    event SwapExecuted(uint256 amount, address to);

    function swapExactETHForTokens(
        uint, 
        address[] calldata, 
        address to, 
        uint
    ) external payable returns(uint[] memory amounts) {
        amounts = new uint[](1);
        amounts[0] = msg.value;
        emit SwapExecuted(msg.value, to);
        return amounts;
    }
}
