<template>
  <div class="AuctionSystem">
    <el-container>
      <el-header>
        <h1>拍卖系统</h1>
      </el-header>
      <el-main>
        <create-auction @auctionCreated="fetchAuctions" />
        <el-divider></el-divider>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-select v-model="filterState" placeholder="过滤拍卖状态">
              <el-option label="所有" value=""></el-option>
              <el-option label="竞价中" value="0"></el-option>
              <el-option label="等待发货" value="1"></el-option>
              <el-option label="等待收货" value="2"></el-option>
              <el-option label="拍卖完成" value="3"></el-option>
            </el-select>
            <el-button @click="sortByPrice">根据价格降序</el-button>
            <el-button @click="sortByParticipants">根据参与人数降序</el-button>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <el-row :gutter="20">
          <el-col v-for="item in filteredItems" :key="item.id" :span="8">
            <auction-item :item="item" @bidPlaced="fetchAuctions" @itemShipped="fetchAuctions" @itemReceived="fetchAuctions" @auctionEnded="fetchAuctions"/>
          </el-col>
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { web3, auctionContract } from '../utils/web3';
import CreateAuction from '../components/CreateAuction.vue';
import AuctionItem from '../components/AuctionItem.vue';

const auctions = ref([]);
const filterState = ref('');
const sortType = ref('');

const fetchAuctions = async () => {
  const itemCount = await auctionContract.methods.itemCount().call();
  auctions.value = [];

  for (let i = 1; i <= itemCount; i++) {
    const item = await auctionContract.methods.items(i).call();
    auctions.value.push(item);
  }
};

const filteredItems = computed(() => {
  let items = auctions.value;

  if (filterState.value !== '') {
    items = items.filter(item => item.state === filterState.value);
  }

  if (sortType.value === 'price') {
    items = items.sort((a, b) => b.highestBid - a.highestBid);
  } else if (sortType.value === 'participants') {
    items = items.sort((a, b) => a.participants - b.participants);
  }

  return items;
});

const sortByPrice = () => {
  sortType.value = 'price';
};

const sortByParticipants = () => {
  sortType.value = 'participants';
};

onMounted(fetchAuctions);
</script>

<style>
.el-header {
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
