<template>
  <el-dialog title="卖家发货" v-model="visible" @close="handleClose">
    <p>请确认您已发货</p>
    <div class="right-btn">
      <el-button type="primary" @click="shipItem">确认</el-button>
    </div>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'itemShipped']);
const visible = ref(true);

const shipItem = async () => {
  await auctionContract.methods.shipItem(props.item.id).send({ from: web3.currentProvider.selectedAddress });
  
  emit('itemShipped');
  emit('close');
};

const handleClose = () => {
  emit('close');
};

</script>
