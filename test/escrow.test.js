const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Escrow Contract", function () {
  let escrow;
  let client;
  let freelancer;
  let stableToken;
  let reputation;
  let uniswap;

  const amount = ethers.parseEther("1");
  const deadlineOffset = 60;

  beforeEach(async function () {
    [client, freelancer, stableToken] = await ethers.getSigners();

    const ReputationFactory = await ethers.getContractFactory("MockReputation");
    reputation = await ReputationFactory.deploy();
    await reputation.waitForDeployment();

    const UniswapFactory = await ethers.getContractFactory("MockUniswap");
    uniswap = await UniswapFactory.deploy();
    await uniswap.waitForDeployment();

    const EscrowFactory = await ethers.getContractFactory("Escrow");
    escrow = await EscrowFactory.connect(client).deploy(
      freelancer.address,
      Math.floor(Date.now() / 1000) + deadlineOffset,
      await reputation.getAddress(),
      await uniswap.getAddress(),
      stableToken.address,
      { value: amount }
    );
    await escrow.waitForDeployment();
  });

  it("should allow client to manually release funds", async function () {
    await expect(escrow.connect(client).release(10))
      .to.emit(reputation, "ReputationUpdated")
      .withArgs(freelancer.address, 10);

    expect(await escrow.released()).to.equal(true);
  });

  it("should revert if non-client tries to release", async function () {
    await expect(
      escrow.connect(freelancer).release(5)
    ).to.be.revertedWith("Not client");
  });

  it("should auto-release after deadline", async function () {
    await ethers.provider.send("evm_increaseTime", [deadlineOffset + 1]);
    await ethers.provider.send("evm_mine", []);

    await escrow.performUpkeep("0x");
    expect(await escrow.released()).to.equal(true);
  });

  it("should allow client to swap ETH to stable token", async function () {
    await expect(escrow.connect(client).swapToStable(1))
      .to.emit(uniswap, "SwapExecuted")
      .withArgs(amount, await escrow.getAddress());
  });
});