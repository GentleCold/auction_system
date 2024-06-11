import Web3 from 'web3'
import AuctionArtifact from '../../../server/build/contracts/Auction.json'

let web3
let auctionContract

if (window.ethereum) {
  web3 = new Web3(window.ethereum)
  await window.ethereum.enable()
} else if (window.web3) {
  web3 = new Web3(window.web3.currentProvider)
} else {
  console.error('No Ethereum browser extension detected.')
}

const networkId = await web3.eth.net.getId()
const deployedNetwork = AuctionArtifact.networks[networkId]
auctionContract = new web3.eth.Contract(
  AuctionArtifact.abi,
  deployedNetwork && deployedNetwork.address
)

export { web3, auctionContract }
