<template>
  <el-dialog title="Receive Item" :visible.sync="visible">
    <p>Are you sure you have received this item?</p>
    <el-button type="primary" @click="receiveItem">Confirm</el-button>
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
  const accounts = await web3.eth.getAccounts();
  
  await auctionContract.methods.receiveItem(props.item.id).send({ from: accounts[0] });
  
  emit('itemReceived');
  emit('close');
};
</script>
