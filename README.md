# NFT Auction System

[中文](./README-zh.md)

---

The frontend uses `Vue`+`Element UI`, the contract deployment uses `Truffle`, and the interaction between the frontend and the contract uses `web3`. The contract is written in `Solidity`, and `MetaMask` can be used for account connection.

The NFT auction system is a decentralized application that includes the following features:

- Initiate auction
- Bidding
- Shipment
- Receipt

Install dependencies:

`cd client && npm install`

`cd server && npm install`

Before enabling, make sure the local test chain (Ganache) is running.

- Deploy the contract: `sh build.sh`
- Start the service: `sh run.sh`

The NFT items need to be minted in advance, see `./server/migrations/2_deploy_contracts.js` for details.
