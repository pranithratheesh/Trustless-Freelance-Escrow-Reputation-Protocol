// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockReputation {
    event ReputationUpdated(address indexed freelancer, uint256 score);

    function updateReputation(address freelancer, uint256 score) external {
        emit ReputationUpdated(freelancer, score);
    }
}