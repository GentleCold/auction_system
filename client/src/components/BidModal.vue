<template>
  <el-dialog title="发起竞价" v-model="visible" @close="handleClose">
    <el-form @submit.prevent="placeBid">
      <el-form-item label="竞价金额(ETH)">
        <el-input v-model.number="bidAmount" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="placeBid">发起竞价</el-button>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script setup>
import { ref, watch } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'bidPlaced']);
const bidAmount = ref(0);
const visible = ref(true);

watch(visible, (newValue) => {
  if (!newValue) {
    emit('close');
  }
});

const placeBid = async () => {
  await auctionContract.methods.bid(props.item.id).send({ from: web3.currentProvider.selectedAddress, value: web3.utils.toWei(String(bidAmount.value), 'ether') });

  emit('bidPlaced');
  visible.value = false;
};

const handleClose = () => {
  visible.value = false;
};
</script>
