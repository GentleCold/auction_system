详细描述需求，后端逻辑为，实现一个拍卖系统，维护一个拍卖列表，用户可以发起拍卖，然后竞拍，竞拍需要金额足够并且价格更高，需要在竞拍成功后就将金额转给部署合约的账户，如果有更高竞拍者就将原先金额返还，竞拍在一定时间后结束，需要有个计时系统确保时间到后立马结束，结束后卖家需要发货，买家需要收货，收货成功后部署合约的账户才将金额打给卖家。前端逻辑为，网站将展示各个拍卖品，有一个发起拍卖按钮，然后填写物品信息（唯一id、物品描述、起价），此时将拍卖品作为卡片展示，同时显示当前阶段为竞拍中，以及当前最高价、参与人数，此时有一个按钮为竞拍，点击即可参与竞拍，需要填写收获地址和竞拍金额，等拍卖结束后，会显示等待发货阶段，此时有一个按钮为发货，点击发货，需要确认为卖家，发货成功后为等待收货阶段，有一个按钮为已收货，需要确认为买家，最后为已完成阶段。对于所有拍卖品，可以根据价格、参与人数排序，根据阶段来筛选显示。通过web3和ganache、truffle等工具完成前端界面、合约编写、区块链部署，前端可使用vue框架完成。请帮我完成合约编写，以及配套的网页编写

给出以下合约：// SPDX-License-Identifier: MIT
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

现要求实现前端逻辑，网站主页大字展示为拍卖系统，大字下方将展示各个拍卖品，网页有个后台进程会定期更新拍卖品的状态，有一个发起拍卖按钮，然后填写物品信息（唯一id、物品描述、起价），此时将拍卖品作为卡片展示，同时显示当前阶段为竞拍中，以及当前最高价、参与人数，此时有一个按钮为竞拍，点击即可参与竞拍，需要填写收获地址和竞拍金额，单位为ETH，等拍卖结束后，会显示等待发货阶段，此时有一个按钮为发货，点击发货，需要确认为卖家，发货成功后为等待收货阶段，有一个按钮为已收货，需要确认为买家，最后为已完成阶段。对于所有拍卖品，可以根据价格、参与人数排序，根据阶段来筛选显示，使用vue框架编写，使用组合式，使用@truffle/contract做交互，使用element ui组件库，要求展示目录结构，并且给出js、vue文件的代码
