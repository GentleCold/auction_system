<template>
  <el-card>
    <h2>Create Auction</h2>
    <el-form @submit.prevent="createAuction">
      <el-form-item label="Description">
        <el-input v-model="description" />
      </el-form-item>
      <el-form-item label="Start Price (ETH)">
        <el-input v-model.number="startPrice" />
      </el-form-item>
      <el-form-item label="Duration (seconds)">
        <el-input v-model.number="duration" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="createAuction">Create Auction</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script setup>
import { ref } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const description = ref('');
const startPrice = ref(0);
const duration = ref(0);

const createAuction = async () => {
  const accounts = await web3.eth.getAccounts();
  
  await auctionContract.methods.createAuction(description.value, web3.utils.toWei(String(startPrice.value), 'ether'), duration.value).send({ from: accounts[0] });
  
  // Emit event to notify parent component
  $emit('auctionCreated');
};
</script>
