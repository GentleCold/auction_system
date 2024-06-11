<template>
  <div class="AuctionSystem">
    <el-container>
      <el-header>
        <h1>Auction System</h1>
      </el-header>
      <el-main>
        <create-auction @auctionCreated="fetchAuctions" />
        <el-divider></el-divider>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-select v-model="filterState" placeholder="Filter by state">
              <el-option label="All" value=""></el-option>
              <el-option label="In Progress" value="0"></el-option>
              <el-option label="Awaiting Delivery" value="1"></el-option>
              <el-option label="Awaiting Received" value="2"></el-option>
              <el-option label="Completed" value="3"></el-option>
            </el-select>
            <el-button @click="sortByPrice">Sort by Price</el-button>
            <el-button @click="sortByParticipants">Sort by Participants</el-button>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <el-row :gutter="20">
          <el-col v-for="item in filteredItems" :key="item.id" :span="8">
            <auction-item :item="item" @bidPlaced="fetchAuctions" @itemShipped="fetchAuctions" @itemReceived="fetchAuctions" />
          </el-col>
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
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
    items = items.sort((a, b) => b.startPrice - a.startPrice);
  } else if (sortType.value === 'participants') {
    items = items.sort((a, b) => b.participants - a.participants);
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
</style>
