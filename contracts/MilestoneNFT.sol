// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MilestoneNFT is ERC1155, Ownable {
    uint256 public nextMilestoneId;

    constructor() ERC1155("") Ownable(msg.sender) {}

    function createMilestone(address client) external onlyOwner returns (uint256) {
        uint256 id = nextMilestoneId++;
        _mint(client, id, 1, "");
        return id;
    }

    function completeMilestone(address client, uint256 id) external onlyOwner {
        _burn(client, id, 1);
    }
}