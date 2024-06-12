const MyNFT = artifacts.require("MyNFT");
const Auction = artifacts.require("Auction");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(MyNFT);
  const nftContract = await MyNFT.deployed();

  const accountA = accounts[1];
  for (let i = 0; i < 10; i++) {
    const tx = await nftContract.safeMint(accountA);
    const tokenId = tx.logs[0].args.tokenId;
    console.log(`NFT #${tokenId.toString()} minted and sent to ${accountA}`);
  }

  await deployer.deploy(Auction, nftContract.address);
};
