// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/* Interfaces */

interface IReputation {
    function updateReputation(address freelancer, uint256 score) external;
}

interface AutomationCompatibleInterface {
    function checkUpkeep(bytes calldata) external returns (bool, bytes memory);
    function performUpkeep(bytes calldata) external;
}

interface IUniswap {
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
}

/* Escrow Contract */

contract Escrow is AutomationCompatibleInterface {
    address public immutable client;
    address public immutable freelancer;

    uint256 public immutable amount;
    uint256 public immutable deadline;

    bool public released;

    IReputation public immutable reputation;
    IUniswap public immutable uniswap;
    address public immutable stableToken;

    /* NonReentrant Modifier */
    bool private locked;

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyClient() {
        require(msg.sender == client, "Not client");
        _;
    }

    constructor(
        address _freelancer,
        uint256 _deadline,
        address _reputation,
        address _uniswap,
        address _stableToken
    ) payable {
        require(msg.value > 0, "No funds");

        client = msg.sender;
        freelancer = _freelancer;
        amount = msg.value;
        deadline = _deadline;

        reputation = IReputation(_reputation);
        uniswap = IUniswap(_uniswap);
        stableToken = _stableToken;
    }

    /* Manual Release */
    function release(uint256 score) external onlyClient nonReentrant {
        require(!released, "Already released");

       released = true;
       reputation.updateReputation(freelancer, score);
       (bool success, ) = freelancer.call{value: amount}("");
       require(success);
    }

    /* Chainlink Automation */
    function checkUpkeep(bytes calldata)
    external
    view
    override
    returns (bool upkeepNeeded, bytes memory performData)
{
    upkeepNeeded = (!released && block.timestamp >= deadline);
    performData = ""; // just return empty bytes
}

    function performUpkeep(bytes calldata) external override nonReentrant {
        require(!released, "Already released");
        require(block.timestamp >= deadline, "Too early");

        released = true;
        (bool success, ) = freelancer.call{value: amount}("");
        require(success, "ETH transfer failed");
    }

    /* Uniswap Swap */
    function swapToStable(uint256 minOut) external onlyClient nonReentrant() {
    address[] memory path = new address[](2);
    path[0] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // Confirm for your chain
    path[1] = stableToken;
    require(!released, "Already released");
    uniswap.swapExactETHForTokens{value: amount}(
        minOut,
        path,
        address(this),
        block.timestamp
    );
}

}
