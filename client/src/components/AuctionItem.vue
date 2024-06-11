<template>
  <el-card>
    <h3>{{ props.item.description }}</h3>
    <p>Start Price: {{ web3.utils.fromWei(props.item.startPrice, 'ether') }} ETH</p>
    <p>Highest Bid: {{ web3.utils.fromWei(props.item.highestBid, 'ether') }} ETH</p>
    <p>End Time: {{ new Date(props.item.endTime * 1000).toLocaleString() }}</p>
    <p>State: {{ stateLabel }}</p>
    <el-button v-if="props.item.state === '0'" type="primary" @click="openBidModal">Bid</el-button>
    <el-button v-if="props.item.state === '1'" type="primary" @click="shipItem">Ship Item</el-button>
    <el-button v-if="props.item.state === '2'" type="primary" @click="receiveItem">Receive Item</el-button>
    <bid-modal v-if="showBidModal" :item="props.item" @close="showBidModal = false" @bidPlaced="handleBidPlaced" />
  </el-card>
</template>

<script setup>
import { ref, computed } from 'vue';
import { web3, auctionContract } from '../utils/web3';
import BidModal from './BidModal.vue';

const props = defineProps({
  item: Object
});

const showBidModal = ref(false);

const stateLabel = computed(() => {
  switch (props.item.state) {
    case '0': return 'In Progress';
    case '1': return 'Awaiting Delivery';
    case '2': return 'Awaiting Received';
    case '3': return 'Completed';
  }
});

const openBidModal = () => {
  showBidModal.value = true;
};

const shipItem = async () => {
  const auctionContract = await getAuctionContract(web3);
  await auctionContract.methods.shipItem(props.item.id).send({ from: accounts[0] });
  $emit('itemShipped');
};

const receiveItem = async () => {
  const auctionContract = await getAuctionContract(web3);
  await auctionContract.methods.receiveItem(props.item.id).send({ from: accounts[0] });
  $emit('itemReceived');
};

const handleBidPlaced = () => {
  showBidModal.value = false;
  $emit('bidPlaced');
};
</script>
