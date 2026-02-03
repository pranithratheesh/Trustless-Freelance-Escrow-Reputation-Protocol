// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReputationRegistry {
    mapping(address => uint256) public completedJobs;
    mapping(address => uint256) public totalScore;

    address public escrow;

    modifier onlyEscrow() {
        require(msg.sender == escrow, "Only escrow");
        _;
    }

    constructor(address _escrow) {
        escrow = _escrow;
    }

    function updateReputation(address freelancer, uint256 score) external onlyEscrow {
    require(score <= 5, "Max 5");

    completedJobs[freelancer] += 1;
    totalScore[freelancer] += score;
}

    function getAverageScore(address freelancer) external view returns (uint256) {
        if (completedJobs[freelancer] == 0) return 0;
        return totalScore[freelancer] / completedJobs[freelancer];
    }
}