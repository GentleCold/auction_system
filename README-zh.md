# NFT拍卖系统

[English](./README.md)

---

前端使用Vue+Element UI，合约部署使用truffle，利用web3进行前端与合约交互，使用solidity进行合约编写，可以使用MetaMask进行账户连接。

NFT拍卖系统为一种去中心化应用，包含功能：

- 发起拍卖
- 竞价
- 发货
- 收货

安装依赖环境：

`cd client && npm install`

`cd server && npm install`

启用前确保开启了本地测试链（Ganache）

- 部署合约：`sh build.sh`
- 启动服务：`sh run.sh`

NFT商品需要提前铸造，详情见`./server/migrations/2_deploy_contracts.js`
