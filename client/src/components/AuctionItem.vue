<template>
  <el-card>
    <template #header>
      <div class="card-header">
        <span class="title">{{ props.item.nftId }}</span>
      </div>
    </template>
    <div class="card-content">
      <p>描述: {{ props.item.description }}</p>
      <p>起价: {{ web3.utils.fromWei(props.item.startPrice, 'ether') }} ETH</p>
      <p>当前最高价格: {{ web3.utils.fromWei(props.item.highestBid, 'ether') }} ETH</p>
      <p>竞价结束时间: {{ new Date(props.item.endTime * 1000).toLocaleString() }}</p>
      <p>拍卖状态: {{ stateLabel }}</p>
      <p>参与人数: {{ props.item.participantCount }}</p>
    </div>
    <div class="right-btn">
      <el-button v-if="props.item.state === '0' && isExpired" type="danger" @click="endAuction" :disabled="!isSeller">停止竞价</el-button>
      <el-button v-if="props.item.state === '0' && !isExpired" type="primary" @click="openBidModal" :disabled="isSeller">竞价</el-button>
      <el-button v-if="props.item.state === '1'" type="primary" @click="openShipModal" :disabled="!isSeller">卖家发货</el-button>
      <el-button v-if="props.item.state === '2'" type="primary" @click="openReceiveModal" :disabled="!isBuyer">买家收货</el-button>
      <el-button v-if="props.item.state === '3'" type="primary">已完成</el-button>
    </div>
    <bid-modal v-if="showBidModal" :item="props.item" @close="showBidModal = false" @bidPlaced="handleBidPlaced" />
    <ship-modal v-if="showShipModal" :item="props.item" @close="showShipModal = false" @itemShipped="handleItemShipped" />
    <receive-modal v-if="showReceiveModal" :item="props.item" @close="showReceiveModal = false" @itemReceived="handleItemReceived" />
  </el-card>
</template>

<script setup>
import { ref, computed, defineEmits } from 'vue';
import { web3, auctionContract } from '../utils/web3';
import BidModal from './BidModal.vue';
import ShipModal from './ShipModal.vue';
import ReceiveModal from './ReceiveModal.vue';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['bidPlaced', 'itemShipped', 'itemReceived', 'auctionEnded']);

const showBidModal = ref(false);
const showShipModal = ref(false);
const showReceiveModal = ref(false);

const stateLabel = computed(() => {
  switch (props.item.state) {
    case '0': return '竞价中';
    case '1': return '等待发货';
    case '2': return '等待收货';
    case '3': return '拍卖完成';
  }
});

const isSeller = computed(() => {
  return props.item.seller.toLowerCase() === web3.currentProvider.selectedAddress.toLowerCase();
});

const isBuyer = computed(() => {
  return props.item.highestBidder.toLowerCase() === web3.currentProvider.selectedAddress.toLowerCase();
});

const isExpired = computed(() => {
  return props.item.endTime <= Math.floor(Date.now() / 1000);
});

const openBidModal = () => {
  showBidModal.value = true;
};

const openShipModal = () => {
  showShipModal.value = true;
};

const openReceiveModal = () => {
  showReceiveModal.value = true;
};

const endAuction = async () => {
  await auctionContract.methods.end(props.item.id).send({ from: web3.currentProvider.selectedAddress });
  emit('auctionEnded');
};

const handleBidPlaced = () => {
  showBidModal.value = false;
  emit('bidPlaced');
};

const handleItemShipped = () => {
  showShipModal.value = false;
  emit('itemShipped');
};

const handleItemReceived = () => {
  showReceiveModal.value = false;
  emit('itemReceived');
};

</script>
