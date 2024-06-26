// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./NFT.sol";

contract Auction {
    NFT public nftContract;
    struct Item {
        uint id;
        uint nftId;
        string description;
        uint startPrice;
        address payable seller;
        address payable highestBidder;
        uint highestBid;
        uint endTime;
        State state;
        uint participantCount;
    }

    enum State {
        PROGRESS,
        SHIP,
        RECEIVE,
        COMPLETE
    }

    constructor(address instance) {
        nftContract = NFT(instance);
    }

    uint public count;
    mapping(uint => Item) public items;
    mapping(uint => mapping(address => bool)) public isBid;

    function create(
        uint nftId,
        string memory description,
        uint startPrice,
        uint duration
    ) public {
        count++;
        items[count] = Item({
            id: count,
            nftId: nftId,
            description: description,
            startPrice: startPrice,
            seller: payable(msg.sender),
            highestBidder: payable(address(0)),
            highestBid: 0,
            endTime: block.timestamp + duration,
            state: State.PROGRESS,
            participantCount: 0
        });

        // transfer the NFT to the contract
        nftContract.transferNFT(msg.sender, address(this), nftId);
    }

    function bid(uint id) public payable {
        Item storage item = items[id];
        require(
            block.timestamp < item.endTime &&
                msg.value > item.highestBid &&
                msg.value >= item.startPrice &&
                msg.sender != item.seller,
            "Logical error"
        );

        if (item.highestBidder != address(0)) {
            // return back money
            item.highestBidder.transfer(item.highestBid);
        }

        item.highestBidder = payable(msg.sender);
        item.highestBid = msg.value;

        if (!isBid[id][msg.sender]) {
            item.participantCount++;
            isBid[id][msg.sender] = true;
        }
    }

    function end(uint id) public {
        Item storage item = items[id];
        require(
            block.timestamp >= item.endTime && item.state == State.PROGRESS,
            "Logical error"
        );

        if (item.highestBidder != address(0)) {
            item.state = State.SHIP;
        } else {
            // transfer the NFT to the seller
            nftContract.transferNFT(address(this), item.seller, item.nftId);
            item.state = State.COMPLETE;
        }
    }

    function shipItem(uint id) public {
        Item storage item = items[id];
        require(
            msg.sender == item.seller && item.state == State.SHIP,
            "Logical error"
        );

        item.state = State.RECEIVE;
    }

    function receiveItem(uint id) public {
        Item storage item = items[id];
        require(
            msg.sender == item.highestBidder && item.state == State.RECEIVE,
            "Logical error!"
        );

        item.state = State.COMPLETE;

        // transfer the nft
        nftContract.transferNFT(address(this), item.highestBidder, item.nftId);

        // transfer the money
        payable(item.seller).transfer(item.highestBid);
    }
}
