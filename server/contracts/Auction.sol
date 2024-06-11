// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Auction {
    struct Item {
        uint id;
        string description;
        uint startPrice;
        address payable seller;
        address payable highestBidder;
        uint highestBid;
        uint endTime;
        AuctionState state;
    }

    enum AuctionState {
        InProgress,
        AwaitingDelivery,
        AwaitingReceived,
        Completed
    }

    uint public itemCount;
    mapping(uint => Item) public items;
    mapping(address => uint) public pendingReturns;

    event AuctionCreated(
        uint id,
        string description,
        uint startPrice,
        uint endTime
    );
    event HighestBidIncreased(uint id, address bidder, uint amount);
    event AuctionEnded(uint id, address winner, uint amount);
    event ItemShipped(uint id);
    event ItemReceived(uint id);

    function createAuction(
        string memory description,
        uint startPrice,
        uint duration
    ) public {
        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            description: description,
            startPrice: startPrice,
            seller: payable(msg.sender),
            highestBidder: payable(address(0)),
            highestBid: 0,
            endTime: block.timestamp + duration,
            state: AuctionState.InProgress
        });

        emit AuctionCreated(
            itemCount,
            description,
            startPrice,
            items[itemCount].endTime
        );
    }

    function bid(uint itemId) public payable {
        Item storage item = items[itemId];
        require(block.timestamp < item.endTime, "Auction already ended.");
        require(msg.value > item.highestBid, "There already is a higher bid.");
        require(
            msg.value >= item.startPrice,
            "Bid must be at least the start price."
        );

        if (item.highestBidder != address(0)) {
            pendingReturns[item.highestBidder] += item.highestBid;
        }

        item.highestBidder = payable(msg.sender);
        item.highestBid = msg.value;

        emit HighestBidIncreased(itemId, msg.sender, msg.value);
    }

    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw.");

        pendingReturns[msg.sender] = 0;

        if (!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount;
        }
    }

    function endAuction(uint itemId) public {
        Item storage item = items[itemId];
        require(block.timestamp >= item.endTime, "Auction has not ended yet.");
        require(
            item.state == AuctionState.InProgress,
            "Auction already completed."
        );

        item.state = AuctionState.AwaitingDelivery;

        emit AuctionEnded(itemId, item.highestBidder, item.highestBid);
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

        emit ItemShipped(itemId);
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

        payable(item.seller).transfer(item.highestBid);

        emit ItemReceived(itemId);
    }
}
