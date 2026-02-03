**🔐 Decentralized Freelance Escrow Smart Contract**

A production-oriented Ethereum-based escrow system designed to securely manage freelance payments using smart contracts. This project eliminates trust issues between clients and freelancers by enforcing transparent, deterministic settlement rules directly on-chain.

Built with Solidity + Hardhat, the system supports manual fund release, automatic deadline-based settlement, optional token swaps, and is fully covered by unit tests.

**🚀 Project Overview**

In traditional freelance platforms, payments rely on centralized intermediaries, introducing risks such as delayed payouts, disputes, or platform bias.
This project demonstrates how blockchain technology can replace intermediaries with smart contract logic that guarantees fair outcomes for both parties.

Funds are locked in an escrow smart contract and can only be released according to predefined rules — either by client approval or automatically when deadlines are reached.

🏗️** System Architecture**
Client ──┐
         │  (ETH Deposit)
         ▼
   Escrow Smart Contract
         │
         ├── Reputation Module
         ├── Swap Interface (DEX-ready)
         │
         ▼
   Freelancer (Payout)


**Core Components:**

Client: Initiates escrow and funds the contract

Freelancer: Receives funds upon successful completion

Escrow Contract: Holds funds and enforces settlement rules

Swap Interface: Enables ETH → stable token conversion

Reputation Module: Tracks participant behavior post-transaction

🔁** Escrow Workflow**
1. Escrow Created (Client deposits ETH)
2. Funds locked inside smart contract
3. Settlement Path:
   - Manual release by client
   - OR automatic release after deadline
4. Optional ETH → Stable Token swap
5. Funds transferred & escrow finalized


This ensures trust-minimized, predictable outcomes with no centralized control.

🧪** Testing & Reliability**

Comprehensive unit tests written using Mocha + Chai

Covers:

Authorized vs unauthorized fund release

Deadline-based auto settlement

Token swap execution

All tests pass on a local Hardhat network

🛠️ **Tech Stack
**
Solidity (0.8.x)

Hardhat

Ethers.js

Mocha / Chai

Node.js

📦 Installation & Usage
npm install
npx hardhat compile
npx hardhat test

🎯 **Why This Project Matters**

Demonstrates real-world escrow logic used in DeFi & Web3 platforms

Shows strong understanding of smart contract security patterns

Clean separation of concerns for extensibility

Fully tested and production-aligned structure

**👨‍💻 Author | Pranith R **

Built as a hands-on blockchain engineering project to showcase secure smart contract design, testing discipline, and real-world decentralized application architecture.
