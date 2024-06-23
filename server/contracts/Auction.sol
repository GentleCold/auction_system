// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./MyNFT.sol";

contract Auction {
    MyNFT public nftContract;
    struct Item {
        uint id;
        uint256 nftTokenId;
        string description;
        uint startPrice;
        address payable seller;
        address payable highestBidder;
        uint highestBid;
        uint endTime;
        AuctionState state;
        uint participants;
    }

    enum AuctionState {
        InProgress,
        AwaitingDelivery,
        AwaitingReceived,
        Completed
    }

    constructor(address _nftContract) {
        nftContract = MyNFT(_nftContract);
    }

    uint public itemCount;
    mapping(uint => Item) public items;
    mapping(uint => mapping(address => bool)) public hasBid;

    function createAuction(
        uint256 _nftTokenId,
        string memory description,
        uint startPrice,
        uint duration
    ) public {
        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            nftTokenId: _nftTokenId,
            description: description,
            startPrice: startPrice,
            seller: payable(msg.sender),
            highestBidder: payable(address(0)),
            highestBid: 0,
            endTime: block.timestamp + duration,
            state: AuctionState.InProgress,
            participants: 0
        });

        // transfer the NFT to the contract
        nftContract.transferNFT(msg.sender, address(this), _nftTokenId);
    }

    function bid(uint itemId) public payable {
        Item storage item = items[itemId];
        require(block.timestamp < item.endTime, "Auction already ended.");
        require(msg.value > item.highestBid, "There already is a higher bid.");
        require(
            msg.value >= item.startPrice,
            "Bid must be at least the start price."
        );
        require(msg.sender != item.seller, "Cannot bid on your own item.");

        if (item.highestBidder != address(0)) {
            // return back money
            item.highestBidder.transfer(item.highestBid);
        }

        item.highestBidder = payable(msg.sender);
        item.highestBid = msg.value;

        if (!hasBid[itemId][msg.sender]) {
            item.participants++;
            hasBid[itemId][msg.sender] = true;
        }
    }

    function endAuction(uint itemId) public {
        Item storage item = items[itemId];
        require(block.timestamp >= item.endTime, "Auction has not ended yet.");
        require(
            item.state == AuctionState.InProgress,
            "Auction already completed."
        );

        if (item.highestBidder != address(0)) {
            item.state = AuctionState.AwaitingDelivery;
        } else {
            // transfer the NFT to the seller
            nftContract.transferNFT(
                address(this),
                item.seller,
                item.nftTokenId
            );
            item.state = AuctionState.Completed;
        }
    }

    function shipItem(uint itemId) public {
        Item storage item = items[itemId];
        require(
            msg.sender == item.seller,
            "Only the seller can call this function."
        );
        require(
            item.state == AuctionState.AwaitingDelivery,
            "The state should be AwaitingDelivery."
        );
        item.state = AuctionState.AwaitingReceived;
    }

    function receiveItem(uint itemId) public {
        Item storage item = items[itemId];
        require(
            msg.sender == item.highestBidder,
            "Only the buyer can call this function."
        );
        require(
            item.state == AuctionState.AwaitingReceived,
            "The state should be AwaitingReceived."
        );

        item.state = AuctionState.Completed;

        // transfer the nft
        nftContract.transferNFT(
            address(this),
            item.highestBidder,
            item.nftTokenId
        );

        // transfer the money
        payable(item.seller).transfer(item.highestBid);
    }
}
