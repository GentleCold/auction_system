<template>
  <el-dialog title="买家收货" v-model="visible" @close="handleClose">
    <p>请确认您已收到货物</p>
    <div class="right-btn">
      <el-button type="primary" @click="receiveItem">确认</el-button>
    </div>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'itemReceived']);
const visible = ref(true);

const receiveItem = async () => {
  await auctionContract.methods.receiveItem(props.item.id).send({ from: web3.currentProvider.selectedAddress });
  
  emit('itemReceived');
  emit('close');
};

const handleClose = () => {
  emit('close');
};

</script>
