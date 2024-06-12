import Web3 from 'web3'
import AuctionArtifact from '../../../server/build/contracts/Auction.json'
import NFTArtifact from '../../../server/build/contracts/MyNFT.json'

let web3
let auctionContract
let nftContract

if (window.ethereum) {
  web3 = new Web3(window.ethereum)
  await window.ethereum.enable()
} else if (window.web3) {
  web3 = new Web3(window.web3.currentProvider)
} else {
  console.error('No Ethereum browser extension detected.')
}

const networkId = await web3.eth.net.getId()

const deployedNetwork2 = NFTArtifact.networks[networkId]
nftContract = new web3.eth.Contract(NFTArtifact.abi, deployedNetwork2 && deployedNetwork2.address)

const deployedNetwork = AuctionArtifact.networks[networkId]
auctionContract = new web3.eth.Contract(
  AuctionArtifact.abi,
  deployedNetwork && deployedNetwork.address
)

export { web3, auctionContract, nftContract }
