const MyNFT = artifacts.require("MyNFT");

async function mint() {
  console.log("abab");
  const accounts = await web3.eth.getAccounts();
  const deployer = accounts[0];
  const recipient = accounts[1];

  console.log("Deployer address:", deployer);
  console.log("Recipient address:", recipient);

  const myNFT = await MyNFT.deployed();
  console.log("MyNFT contract address:", myNFT.address);

  for (let i = 0; i < 10; i++) {
    const tx = await myNFT.methods.safeMint(recipient).send({ from: deployer });
    const tokenId = tx.events.Transfer.returnValues.tokenId;
    console.log(`NFT #${tokenId.toString()} minted and sent to ${recipient}`);
  }
}

mint()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
