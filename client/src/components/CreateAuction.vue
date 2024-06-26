<template>
  <el-card>
    <h2>发起拍卖</h2>
    <el-form @submit.prevent="createAuction">
      <el-form-item label="NFT 选择">
        <el-select v-model="selectedNFT" placeholder="选择要拍卖的 NFT">
          <el-option v-for="nft in ownedNFTs" :key="nft.tokenId" :label="`Token ID: ${nft.tokenId}`" :value="nft.tokenId" ></el-option>
          <el-option v-if="ownedNFTs.length === 0" label="您没有任何 NFT" :value="null" disabled></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="描述">
        <el-input v-model="description" />
      </el-form-item>
      <el-form-item label="起价(ETH)">
        <el-input v-model.number="startPrice" />
      </el-form-item>
      <el-form-item label="竞价时间(秒)">
        <el-input v-model.number="duration" />
      </el-form-item>
      <div class="right-btn">
        <el-button type="primary" @click="createAuction" :disabled="selectedNFT === null">发起拍卖</el-button>
      </div>
    </el-form>
  </el-card>
</template>
<script setup>
import { ref, onMounted } from 'vue';
import { web3, auctionContract, nftContract } from '../utils/web3';
const selectedNFT = ref(null);
const description = ref('');
const startPrice = ref(0);
const duration = ref(0);
const ownedNFTs = ref([]);
const emit = defineEmits(['auctionCreated']);

onMounted(async () => {
  await loadOwnedNFTs();
});

const loadOwnedNFTs = async () => {
  const ownedTokens = await nftContract.methods.getAll(web3.currentProvider.selectedAddress).call();
  ownedNFTs.value = ownedTokens.map(tokenId => ({ tokenId }));
};

const createAuction = async () => {
  if (selectedNFT.value === null) {
    return;
  }

  await auctionContract.methods.create(
    selectedNFT.value,
    description.value,
    web3.utils.toWei(String(startPrice.value), 'ether'),
    duration.value
  ).send({ from: web3.currentProvider.selectedAddress });

  emit('auctionCreated');
  await loadOwnedNFTs();
  selectedNFT.value = null;
};
</script>
