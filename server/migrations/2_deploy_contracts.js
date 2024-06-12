const Auction = artifacts.require("Auction");
const MyNFT = artifacts.require("MyNFT");

module.exports = function (deployer) {
  deployer.deploy(Auction);
  deployer.deploy(MyNFT);
};
