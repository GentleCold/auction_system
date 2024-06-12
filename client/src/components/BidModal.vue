<template>
  <el-dialog title="发起竞价" v-model="visible" @close="handleClose">
    <el-form @submit.prevent="placeBid">
      <el-form-item label="竞价金额(ETH)">
        <el-input v-model.number="bidAmount" />
      </el-form-item>
    <el-alert v-if="isSeller" title="作为卖家无法参与竞价" type="warning" show-icon />
      <div class="right-btn">
        <el-button type="primary" @click="placeBid" :disabled="bidAmount * 1e18 <= props.item.highestBid || isSeller">发起竞价</el-button>
      </div>
    </el-form>
  </el-dialog>
</template>

<script setup>
import { ref, computed } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'bidPlaced']);
const bidAmount = ref(0);
const visible = ref(true);

const isSeller = computed(() => {
  return props.item.seller.toLowerCase() === web3.currentProvider.selectedAddress.toLowerCase();
});

const placeBid = async () => {
  if (isSeller.value) {
    return;
  }

  await auctionContract.methods.bid(props.item.id).send({ from: web3.currentProvider.selectedAddress, value: web3.utils.toWei(String(bidAmount.value), 'ether') });

  emit('bidPlaced');
  emit('close');
};

const handleClose = () => {
  emit('close');
};
</script>
