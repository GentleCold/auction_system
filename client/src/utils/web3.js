import Web3 from 'web3'
import AuctionArtifact from '../../../server/build/contracts/Auction.json'
import NFTArtifact from '../../../server/build/contracts/NFT.json'

let web3
let auctionContract
let nftContract

web3 = new Web3(window.ethereum)
await window.ethereum.enable()

const networkId = await web3.eth.net.getId()

const deployedNetwork2 = NFTArtifact.networks[networkId]
nftContract = new web3.eth.Contract(NFTArtifact.abi, deployedNetwork2 && deployedNetwork2.address)

const deployedNetwork = AuctionArtifact.networks[networkId]
auctionContract = new web3.eth.Contract(
  AuctionArtifact.abi,
  deployedNetwork && deployedNetwork.address
)

export { web3, auctionContract, nftContract }
