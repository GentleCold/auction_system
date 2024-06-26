const NFT = artifacts.require("NFT");
const Auction = artifacts.require("Auction");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(NFT);
  const nft = await NFT.deployed();

  const accountA = accounts[1];
  for (let i = 0; i < 10; i++) {
    const tx = await nft.safeMint(accountA);
    const tokenId = tx.logs[0].args.tokenId;
    console.log(`NFT #${tokenId.toString()} minted and sent to ${accountA}`);
  }

  await deployer.deploy(Auction, nft.address);
};
